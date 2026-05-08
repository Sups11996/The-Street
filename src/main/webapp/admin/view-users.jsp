<%--
  Created by IntelliJ IDEA.
  User: SayMyName
  Date: 5/3/2026
  Time: 3:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>
<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>

<div class="dashboard manage-users-page">
    <aside class="sidebar">
        <h2>Sahayog Sathi</h2>
        <p>Admin Panel</p>

        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
        <a class="active" href="<%= request.getContextPath() %>/view-users">Manage Users</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </aside>

    <main class="main">
        <div class="topbar">
            <h1>Manage Users</h1>
            <a class="back-btn" href="<%= request.getContextPath() %>/admin/dashboard.jsp">Back</a>
        </div>

        <div class="table-box">
            <div class="table-container">
                <table class="users-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Profile</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>

                    <%
                        List<User> users = (List<User>) request.getAttribute("users");

                        if (users != null && !users.isEmpty()) {
                            for (User u : users) {
                                // Determine status badge class
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

                                // Profile image path
                                String profileImage = u.getProfileImage();
                                boolean hasImage = (profileImage != null && !profileImage.trim().isEmpty());
                    %>

                    <tr>
                        <td><%= u.getUserId() %></td>

                        <td>
                            <%
                                // Debug: Log the profile image path
                                String debugPath = (profileImage != null) ? profileImage : "NULL";
                                // System.out.println("User " + u.getUserId() + " - Profile Image: " + debugPath);
                            %>
                            <% if (hasImage) { %>
                            <img src="<%= request.getContextPath() %>/<%= profileImage %>"
                                 alt="<%= u.getFullName() %>"
                                 class="profile-img"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';">
                            <div class="profile-placeholder" style="display: none;">
                                <%= u.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                            <% } else { %>
                            <div class="profile-placeholder">
                                <%= u.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                            <% } %>
                        </td>

                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() %></td>
                        <td><%= u.getRole() %></td>

                        <td>
                        <span class="status-badge <%= statusClass %>">
                            <%= u.getStatus() %>
                        </span>
                        </td>

                        <td class="actions-cell">
                            <a href="<%= request.getContextPath() %>/view-user-by-id?user_id=<%= u.getUserId() %>" class="btn-action btn-view">View</a>

                            <a href="<%= request.getContextPath() %>/view-user-by-id?user_id=<%= u.getUserId() %>&mode=edit" class="btn-action btn-edit">Edit</a>

                            <form action="<%= request.getContextPath() %>/block-user" method="post" style="display: inline-block; margin: 0;">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <button class="btn-action btn-warning" type="submit">Block</button>
                            </form>

                            <form action="<%= request.getContextPath() %>/approve-user" method="post" style="display: inline-block; margin: 0;">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <button class="btn-action btn-success" type="submit">Approve</button>
                            </form>

                            <form action="<%= request.getContextPath() %>/reject-user" method="post" style="display: inline-block; margin: 0;">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <button class="btn-action btn-danger" type="submit">Reject</button>
                            </form>

                            <form action="<%= request.getContextPath() %>/delete-user" method="post" style="display: inline-block; margin: 0;" onsubmit="return confirm('Are you sure you want to delete this user? This action cannot be undone.');">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <button class="btn-action btn-danger" type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>

                    <%
                        }
                    } else {
                    %>

                    <tr>
                        <td colspan="8">No users found.</td>
                    </tr>

                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>