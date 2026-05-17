<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/17/2026
  Time: 4:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="the_street.sahayog_sathi_donor.model.User" %>
<%
    User donor = (User) session.getAttribute("loggedInUser");
    if (donor == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String firstName = donor.getFullName().contains(" ")
            ? donor.getFullName().split(" ")[0]
            : donor.getFullName();

    int total     = (request.getAttribute("totalDonations")     != null) ? (int) request.getAttribute("totalDonations")     : 0;
    int available = (request.getAttribute("availableDonations") != null) ? (int) request.getAttribute("availableDonations") : 0;
    int claimed   = (request.getAttribute("claimedDonations")   != null) ? (int) request.getAttribute("claimedDonations")   : 0;
    int delivered = (request.getAttribute("deliveredDonations") != null) ? (int) request.getAttribute("deliveredDonations") : 0;

    request.setAttribute("pageTitle",    "Dashboard");
    request.setAttribute("pageSubtitle", "Welcome back, " + firstName + ". Here's what's happening today.");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Sahayog Sathi</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #F5F7F6; color: #1E1E1E; }

        .page-body { padding: 28px 30px; }

        /* Stats cards */
        .stats-row {
            display: flex;
            gap: 18px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .stat-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px 22px;
            flex: 1;
            min-width: 160px;
            border-top: 3px solid #1F7A5C;
        }
        .stat-card .num {
            font-size: 2rem;
            font-weight: 700;
            color: #1F7A5C;
            line-height: 1;
        }
        .stat-card .lbl {
            font-size: 0.8rem;
            color: #6B7280;
            margin-top: 5px;
        }
        .stat-card.blue  { border-top-color: #1d4ed8; }
        .stat-card.blue  .num { color: #1d4ed8; }
        .stat-card.yellow { border-top-color: #b45309; }
        .stat-card.yellow .num { color: #b45309; }
        .stat-card.purple { border-top-color: #7c3aed; }
        .stat-card.purple .num { color: #7c3aed; }

        /* Section heading */
        .section-title {
            font-size: 1rem;
            font-weight: 700;
            color: #1E1E1E;
            margin-bottom: 14px;
        }

        /* Quick action cards */
        .actions-row {
            display: flex;
            gap: 18px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .action-card {
            background: #fff;
            border-radius: 10px;
            padding: 22px 20px;
            flex: 1;
            min-width: 200px;
            text-decoration: none;
            color: #1E1E1E;
            border-left: 4px solid #1F7A5C;
            transition: box-shadow 0.15s;
        }
        .action-card:hover { box-shadow: 0 4px 14px rgba(0,0,0,0.09); }
        .action-card h3 { font-size: 0.95rem; font-weight: 700; margin-bottom: 6px; }
        .action-card p  { font-size: 0.8rem; color: #6B7280; }

        /* Info box */
        .info-box {
            background: #fff;
            border-radius: 10px;
            padding: 22px 24px;
        }
        .info-box p { font-size: 0.9rem; color: #6B7280; line-height: 1.7; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>
<%@ include file="topbar.jsp" %>

<div class="page-body">

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="num"><%= total %></div>
            <div class="lbl">Total Donations</div>
        </div>
        <div class="stat-card blue">
            <div class="num"><%= available %></div>
            <div class="lbl">Available</div>
        </div>
        <div class="stat-card yellow">
            <div class="num"><%= claimed %></div>
            <div class="lbl">In Progress</div>
        </div>
        <div class="stat-card purple">
            <div class="num"><%= delivered %></div>
            <div class="lbl">Delivered</div>
        </div>
    </div>

    <!-- Quick Actions -->
    <p class="section-title">Quick Actions</p>
    <div class="actions-row">
        <a href="<%= request.getContextPath() %>/donor/createDonation" class="action-card">
            <h3>+ New Donation</h3>
            <p>Post a new donation with category, location and description.</p>
        </a>
        <a href="<%= request.getContextPath() %>/donor/myDonations" class="action-card">
            <h3>My Donations</h3>
            <p>View and manage all your donation history.</p>
        </a>
        <a href="<%= request.getContextPath() %>/donor/myDonations?filter=DELIVERED" class="action-card">
            <h3>Track Deliveries</h3>
            <p>Check the delivery status of your donations.</p>
        </a>
    </div>

    <!-- Impact -->
    <div class="info-box">
        <p class="section-title" style="margin-bottom:10px;">Your Impact</p>
        <p>
            Thank you for being part of <strong>Sahayog Sathi</strong>!
            You have made <strong><%= total %></strong> donation(s) so far,
            and <strong><%= delivered %></strong> of them have already reached their recipients.
            Keep up the great work!
        </p>
    </div>

</div>

</body>
</html>

