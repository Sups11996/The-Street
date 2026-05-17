<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/17/2026
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="the_street.sahayog_sathi_donor.model.User" %>
<%@ page import="the_street.sahayog_sathi_donor.model.Donation" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User donor = (User) session.getAttribute("loggedInUser");
    if (donor == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ArrayList<Donation> donations = (ArrayList<Donation>) request.getAttribute("donations");
    if (donations == null) donations = new ArrayList<>();

    String currentFilter = (String) request.getAttribute("currentFilter");
    if (currentFilter == null) currentFilter = "ALL";

    String errorMsg   = (String) request.getAttribute("errorMessage");
    String successMsg = (String) request.getAttribute("successMessage");

    request.setAttribute("pageTitle",    "My Donations");
    request.setAttribute("pageSubtitle", "View and manage all your donation posts.");

    SimpleDateFormat sdf = new SimpleDateFormat("MMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Donations – Sahayog Sathi</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #F5F7F6; color: #1E1E1E; }

        .page-body { padding: 28px 30px; }

        /* Alerts */
        .alert {
            padding: 10px 14px;
            border-radius: 6px;
            margin-bottom: 18px;
            font-size: 0.85rem;
        }
        .alert-error   { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; }
        .alert-success { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }

        /* Card wrapper */
        .card {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
        }
        .card-header {
            padding: 16px 22px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-header h2 { font-size: 1rem; font-weight: 700; }
        .btn-new {
            background: #1F7A5C;
            color: #fff;
            padding: 7px 16px;
            border-radius: 7px;
            font-size: 0.82rem;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }
        .btn-new:hover { background: #145A42; }

        /* Filter tabs */
        .filter-bar {
            padding: 14px 22px;
            display: flex;
            gap: 8px;
            border-bottom: 1px solid #f3f4f6;
            flex-wrap: wrap;
        }
        .filter-bar a {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            border: 1.5px solid #e5e7eb;
            background: #fff;
            color: #6B7280;
            text-decoration: none;
            transition: all 0.15s;
        }
        .filter-bar a:hover { border-color: #1F7A5C; color: #1F7A5C; }
        .filter-bar a.active { background: #1F7A5C; color: #fff; border-color: #1F7A5C; }

        /* Table */
        table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
        thead tr { background: #f9fafb; }
        thead th {
            padding: 10px 16px;
            text-align: left;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6B7280;
            border-bottom: 1.5px solid #e5e7eb;
        }
        tbody tr { border-bottom: 1px solid #f3f4f6; }
        tbody tr:hover { background: #f9fafb; }
        tbody td { padding: 12px 16px; vertical-align: middle; }

        /* Badges */
        .badge {
            display: inline-block;
            padding: 3px 9px;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-available  { background: #d1fae5; color: #065f46; }
        .badge-claimed    { background: #dbeafe; color: #1e40af; }
        .badge-delivered  { background: #ede9fe; color: #5b21b6; }
        .badge-cancelled  { background: #f3f4f6; color: #6B7280; }

        /* Action buttons */
        .btn-edit {
            background: #fff;
            color: #1F7A5C;
            border: 1.5px solid #1F7A5C;
            padding: 4px 11px;
            border-radius: 5px;
            font-size: 0.78rem;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            font-family: Arial, sans-serif;
            margin-right: 5px;
        }
        .btn-edit:hover { background: #f0faf6; }
        .btn-cancel {
            background: #fee2e2;
            color: #b91c1c;
            border: none;
            padding: 4px 11px;
            border-radius: 5px;
            font-size: 0.78rem;
            font-weight: 700;
            cursor: pointer;
            font-family: Arial, sans-serif;
        }
        .btn-cancel:hover { background: #fecaca; }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #6B7280;
        }
        .empty-state h3 { font-size: 1rem; margin-bottom: 8px; color: #1E1E1E; }
        .empty-state a  { color: #1F7A5C; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>
<%@ include file="topbar.jsp" %>

<div class="page-body">

    <% if (errorMsg != null) { %>
    <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>
    <% if (successMsg != null) { %>
    <div class="alert alert-success"><%= successMsg %></div>
    <% } %>

    <div class="card">
        <div class="card-header">
            <h2>All Donations (<%= donations.size() %>)</h2>
            <a href="<%= request.getContextPath() %>/donor/createDonation" class="btn-new">+ New Donation</a>
        </div>

        <!-- Filter tabs -->
        <div class="filter-bar">
            <a href="<%= request.getContextPath() %>/donor/myDonations"
               class="<%= currentFilter.equals("ALL") ? "active" : "" %>">All</a>
            <a href="<%= request.getContextPath() %>/donor/myDonations?filter=AVAILABLE"
               class="<%= currentFilter.equals("AVAILABLE") ? "active" : "" %>">Available</a>
            <a href="<%= request.getContextPath() %>/donor/myDonations?filter=CLAIMED"
               class="<%= currentFilter.equals("CLAIMED") ? "active" : "" %>">Claimed</a>
            <a href="<%= request.getContextPath() %>/donor/myDonations?filter=DELIVERED"
               class="<%= currentFilter.equals("DELIVERED") ? "active" : "" %>">Delivered</a>
            <a href="<%= request.getContextPath() %>/donor/myDonations?filter=CANCELLED"
               class="<%= currentFilter.equals("CANCELLED") ? "active" : "" %>">Cancelled</a>
        </div>

        <% if (donations.isEmpty()) { %>
        <div class="empty-state">
            <h3>No donations found</h3>
            <% if (!currentFilter.equals("ALL")) { %>
            <p>No donations with status "<%= currentFilter %>".
                <a href="<%= request.getContextPath() %>/donor/myDonations">View all</a></p>
            <% } else { %>
            <p>You haven't posted any donations yet.
                <a href="<%= request.getContextPath() %>/donor/createDonation">Create your first donation</a></p>
            <% } %>
        </div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Title</th>
                <th>Category</th>
                <th>Qty</th>
                <th>Location</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                int row = 1;
                for (Donation d : donations) {
                    String badgeClass = "badge-" + d.getStatus().toLowerCase();
                    String dateStr = (d.getCreatedAt() != null) ? sdf.format(d.getCreatedAt()) : "—";
            %>
            <tr>
                <td><%= row++ %></td>
                <td style="font-weight:600;max-width:170px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                    <%= d.getTitle() %>
                </td>
                <td><%= d.getCategory() %></td>
                <td><%= d.getQuantity() %></td>
                <td style="max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                    <%= d.getLocation() %>
                </td>
                <td><span class="badge <%= badgeClass %>"><%= d.getStatus() %></span></td>
                <td style="color:#6B7280;font-size:0.8rem;"><%= dateStr %></td>
                <td>
                    <% if ("AVAILABLE".equals(d.getStatus())) { %>
                    <a href="<%= request.getContextPath() %>/donor/editDonation?id=<%= d.getDonationId() %>"
                       class="btn-edit">Edit</a>
                    <form action="<%= request.getContextPath() %>/donor/cancelDonation"
                          method="post" style="display:inline"
                          onsubmit="return confirm('Cancel this donation?');">
                        <input type="hidden" name="donationId" value="<%= d.getDonationId() %>">
                        <button type="submit" class="btn-cancel">Cancel</button>
                    </form>
                    <% } else { %>
                    <span style="color:#6B7280;font-size:0.8rem;">—</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>
</body>
</html>

