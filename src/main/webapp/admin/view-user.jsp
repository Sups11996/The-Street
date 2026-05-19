<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User u = (User) request.getAttribute("user");
    request.setAttribute("activePage", "users");
    request.setAttribute("pageTitle", "User Details");
    request.setAttribute("pageSubtitle", "View user account information.");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details – Sahayog Sathi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/admin/includes/sidebar.jsp"/>
    <main class="main">
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <% if (u != null) {
            String profileImage = u.getProfileImage();
            boolean hasImage = (profileImage != null && !profileImage.trim().isEmpty());
            String status = u.getStatus();
            String statusClass = "ACTIVE".equalsIgnoreCase(status) ? "status-active" :
                                 "PENDING".equalsIgnoreCase(status) ? "status-pending" :
                                 "BLOCKED".equalsIgnoreCase(status) ? "status-blocked" : "status-rejected";
        %>
        <div class="details-card">
            <div style="text-align:center;margin-bottom:20px;">
                <% if (hasImage) { %>
                <img src="<%= request.getContextPath() %>/<%= profileImage %>" alt="Profile"
                     style="width:100px;height:100px;border-radius:50%;object-fit:cover;border:3px solid #1F7A5C;">
                <% } else { %>
                <div style="width:100px;height:100px;border-radius:50%;background:#1F7A5C;color:#E8F5F0;display:inline-flex;align-items:center;justify-content:center;font-weight:700;font-size:36px;">
                    <%= u.getFullName().substring(0,1).toUpperCase() %>
                </div>
                <% } %>
            </div>
            <p><strong>User ID:</strong> <%= u.getUserId() %></p>
            <p><strong>Full Name:</strong> <%= u.getFullName() %></p>
            <p><strong>Email:</strong> <%= u.getEmail() %></p>
            <p><strong>Phone:</strong> <%= u.getPhone() %></p>
            <p><strong>Address:</strong> <%= u.getAddress() != null ? u.getAddress() : "—" %></p>
            <p><strong>Role:</strong> <%= u.getRole() %></p>
            <p><strong>Status:</strong> <span class="status-badge <%= statusClass %>"><%= u.getStatus() %></span></p>
            <a href="<%= request.getContextPath() %>/view-user-by-id?user_id=<%= u.getUserId() %>&mode=edit">Edit User</a>
        </div>
        <% } else { %>
        <div class="alert error">User not found.</div>
        <% } %>
    </main>
</div>
</body>
</html>
