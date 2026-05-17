<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/17/2026
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="the_street.sahayog_sathi_donor.model.User" %>
<%
    User _u = (User) session.getAttribute("loggedInUser");
    String _name = (_u != null) ? _u.getFullName() : "Donor";
    String _uri  = request.getRequestURI();
%>

<style>
    .navbar {
        background: #145A42;
        padding: 0 30px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 58px;
        font-family: Arial, sans-serif;
    }
    .navbar-brand {
        color: #fff;
        font-size: 1.15rem;
        font-weight: 700;
        text-decoration: none;
    }
    .navbar-brand span {
        font-size: 0.72rem;
        color: rgba(255,255,255,0.55);
        display: block;
        font-weight: 400;
        margin-top: -3px;
    }
    .navbar-links {
        display: flex;
        align-items: center;
        gap: 4px;
        list-style: none;
        margin: 0;
        padding: 0;
    }
    .navbar-links a {
        color: rgba(255,255,255,0.78);
        text-decoration: none;
        padding: 8px 14px;
        border-radius: 6px;
        font-size: 0.88rem;
        transition: background 0.15s;
    }
    .navbar-links a:hover,
    .navbar-links a.active {
        background: rgba(255,255,255,0.15);
        color: #fff;
    }
    .navbar-user {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .navbar-user .avatar {
        width: 32px; height: 32px;
        border-radius: 50%;
        background: #1F7A5C;
        color: #fff;
        font-weight: 700;
        font-size: 0.85rem;
        display: flex; align-items: center; justify-content: center;
        border: 2px solid rgba(255,255,255,0.3);
    }
    .navbar-user .uname {
        color: #fff;
        font-size: 0.85rem;
    }
    .navbar-user .urole {
        background: #1F7A5C;
        color: #d1fae5;
        font-size: 0.68rem;
        padding: 1px 7px;
        border-radius: 20px;
        font-weight: 700;
    }
    .logout-form button {
        background: rgba(255,255,255,0.12);
        color: rgba(255,255,255,0.85);
        border: 1px solid rgba(255,255,255,0.2);
        padding: 5px 12px;
        border-radius: 6px;
        font-size: 0.82rem;
        cursor: pointer;
        font-family: Arial, sans-serif;
    }
    .logout-form button:hover {
        background: rgba(255,255,255,0.22);
        color: #fff;
    }
</style>

<nav class="navbar">
    <a href="<%= request.getContextPath() %>/donor/dashboard" class="navbar-brand">
        Sahayog Sathi
        <span>Donor Panel</span>
    </a>

    <ul class="navbar-links">
        <li>
            <a href="<%= request.getContextPath() %>/donor/dashboard"
               class="<%= _uri.contains("dashboard") ? "active" : "" %>">
                Dashboard
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/donor/createDonation"
               class="<%= _uri.contains("createDonation") ? "active" : "" %>">
                + New Donation
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/donor/myDonations"
               class="<%= (_uri.contains("myDonations") || _uri.contains("editDonation")) ? "active" : "" %>">
                My Donations
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/donor/myDonations?filter=DELIVERED"
               class="<%= request.getQueryString() != null && request.getQueryString().contains("DELIVERED") ? "active" : "" %>">
                Delivered
            </a>
        </li>
    </ul>

    <div class="navbar-user">
        <div class="avatar"><%= _name.charAt(0) %></div>
        <div>
            <div class="uname"><%= _name %></div>
            <span class="urole">DONOR</span>
        </div>
        <form action="<%= request.getContextPath() %>/logout" method="post" class="logout-form">
            <button type="submit">Logout</button>
        </form>
    </div>
</nav>
