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
    request.setAttribute("pageTitle",    "Create Donation");
    request.setAttribute("pageSubtitle", "Fill in the details to post a new donation.");

    String errorMsg   = (String) request.getAttribute("errorMessage");
    String successMsg = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Donation – Sahayog Sathi</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #F5F7F6; color: #1E1E1E; }

        .page-body { padding: 28px 30px; }

        .form-card {
            background: #fff;
            border-radius: 10px;
            max-width: 680px;
            padding: 28px 30px;
        }
        .form-card h2 {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 22px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .back-link {
            font-size: 0.82rem;
            color: #1F7A5C;
            text-decoration: none;
            font-weight: 400;
        }
        .back-link:hover { text-decoration: underline; }

        /* Alerts */
        .alert {
            padding: 10px 14px;
            border-radius: 6px;
            margin-bottom: 18px;
            font-size: 0.85rem;
        }
        .alert-error   { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; }
        .alert-success { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }

        /* Form */
        .form-row {
            display: flex;
            gap: 16px;
            margin-bottom: 16px;
        }
        .form-group {
            flex: 1;
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: #6B7280;
            margin-bottom: 6px;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 9px 12px;
            border: 1.5px solid #e5e7eb;
            border-radius: 7px;
            font-size: 0.9rem;
            color: #1E1E1E;
            background: #fff;
            outline: none;
            font-family: Arial, sans-serif;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #1F7A5C;
        }
        .form-group textarea { min-height: 95px; resize: vertical; }

        .btn-row { display: flex; gap: 10px; margin-top: 6px; }
        .btn {
            padding: 9px 20px;
            border-radius: 7px;
            font-size: 0.88rem;
            font-weight: 700;
            border: none;
            cursor: pointer;
            font-family: Arial, sans-serif;
            text-decoration: none;
        }
        .btn-primary { background: #1F7A5C; color: #fff; }
        .btn-primary:hover { background: #145A42; }
        .btn-outline { background: #fff; color: #1F7A5C; border: 1.5px solid #1F7A5C; }
        .btn-outline:hover { background: #f0faf6; }
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

    <div class="form-card">
        <h2>
            Donation Details
            <a href="<%= request.getContextPath() %>/donor/myDonations" class="back-link">← Back to My Donations</a>
        </h2>

        <form action="<%= request.getContextPath() %>/donor/createDonation" method="post" id="donationForm">

            <div class="form-row">
                <div class="form-group">
                    <label for="title">Donation Title *</label>
                    <input type="text" id="title" name="title"
                           placeholder="e.g. Rice and Lentils – 10 kg" maxlength="120" required>
                </div>
                <div class="form-group">
                    <label for="category">Category *</label>
                    <select id="category" name="category" required>
                        <option value="" disabled selected>-- Select category --</option>
                        <option value="FOOD">Food</option>
                        <option value="CLOTHING">Clothing</option>
                        <option value="ESSENTIALS">Essentials</option>
                        <option value="OTHER">Other</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="quantity">Quantity *</label>
                    <input type="number" id="quantity" name="quantity"
                           placeholder="e.g. 5" min="1" max="9999" required>
                </div>
                <div class="form-group">
                    <label for="location">Pickup Location *</label>
                    <input type="text" id="location" name="location"
                           placeholder="e.g. Itahari, Sunsari" maxlength="200" required>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Description *</label>
                <textarea id="description" name="description"
                          placeholder="Describe the items, condition, any special instructions…"
                          maxlength="1000" required></textarea>
            </div>

            <div class="btn-row">
                <button type="submit" class="btn btn-primary">Submit Donation</button>
                <button type="reset"  class="btn btn-outline">Clear Form</button>
            </div>

        </form>
    </div>

</div>

<script>
    document.getElementById('donationForm').addEventListener('submit', function(e) {
        var qty = parseInt(document.getElementById('quantity').value, 10);
        if (isNaN(qty) || qty < 1) {
            e.preventDefault();
            alert('Quantity must be a positive number.');
        }
    });
</script>
</body>
</html>
