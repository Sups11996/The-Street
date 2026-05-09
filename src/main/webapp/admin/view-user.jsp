<%--
  Created by IntelliJ IDEA.
  User: SayMyName
  Date: 5/3/2026
  Time: 3:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
  <title>User Details</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>

<div class="dashboard">
  <aside class="sidebar">
    <h2>Sahayog Sathi</h2>
    <p>Admin Panel</p>

    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
    <a href="<%= request.getContextPath() %>/view-users">Manage Users</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
  </aside>

  <main class="main">
    <div class="topbar">
      <h1>User Details</h1>
      <a class="back-btn" href="<%= request.getContextPath() %>/view-users">Back</a>
    </div>

    <%
      User u = (User) request.getAttribute("user");

      if (u != null) {
        // Profile image
        String profileImage = u.getProfileImage();
        boolean hasImage = (profileImage != null && !profileImage.trim().isEmpty());

        // Status badge class
        String statusClass = "";
        String status = u.getStatus();
        if ("ACTIVE".equalsIgnoreCase(status)) {
          statusClass = "status-active";
        } else if ("PENDING".equalsIgnoreCase(status)) {
          statusClass = "status-pending";
        } else if ("BLOCKED".equalsIgnoreCase(status)) {
          statusClass = "status-blocked";
        } else if ("REJECTED".equalsIgnoreCase(status)) {
          statusClass = "status-rejected";
        }
    %>

    <div class="details-card">
      <!-- Profile Picture -->
      <div style="text-align: center; margin-bottom: 20px;">
        <% if (hasImage) { %>
        <img src="<%= request.getContextPath() %>/<%= profileImage %>"
             alt="Profile"
             style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #1F7A5C;">
        <% } else { %>
        <div style="width: 100px; height: 100px; border-radius: 50%; background: #1F7A5C; color: white; display: inline-flex; align-items: center; justify-content: center; font-weight: bold; font-size: 36px;">
          <%= u.getFullName().substring(0, 1).toUpperCase() %>
        </div>
        <% } %>
      </div>

      <p><strong>User ID:</strong> <%= u.getUserId() %></p>
      <p><strong>Full Name:</strong> <%= u.getFullName() %></p>
      <p><strong>Email:</strong> <%= u.getEmail() %></p>
      <p><strong>Phone:</strong> <%= u.getPhone() %></p>
      <p><strong>Role:</strong> <%= u.getRole() %></p>
      <p>
        <strong>Status:</strong>
        <span class="status-badge <%= statusClass %>">
          <%= u.getStatus() %>
        </span>
      </p>

      <!-- ✅ FIXED EDIT LINK -->
      <a href="<%= request.getContextPath() %>/view-user-by-id?user_id=<%= u.getUserId() %>&mode=edit">
        Edit User
      </a>
    </div>

    <%
    } else {
    %>

    <div class="alert error">User not found.</div>

    <%
      }
    %>
  </main>
</div>

</body>
</html>