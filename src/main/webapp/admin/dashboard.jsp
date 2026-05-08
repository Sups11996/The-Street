<%--
  Created by IntelliJ IDEA.
  User: SayMyName
  Date: 5/3/2026
  Time: 3:02 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Extract first name from fullName stored in session
    String fullName = (String) session.getAttribute("fullName");
    String firstName = "Admin";
    if (fullName != null && !fullName.trim().isEmpty()) {
        firstName = fullName.trim().split("\\s+")[0];
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>

<div class="dashboard">
    <aside class="sidebar">
        <h2>Sahayog Sathi</h2>
        <p>Admin Panel</p>

        <a class="active" href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
        <a href="<%= request.getContextPath() %>/view-users">Manage Users</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </aside>

    <main class="main">
        <div class="topbar">
            <h1>Admin Dashboard</h1>
            <span>Welcome, <%= firstName %></span>
        </div>

        <div class="cards">

            <!-- Manage Users -->
            <div class="card">
                <h3>Manage Users</h3>
                <p>View, update, block, approve, reject and delete users.</p>
                <a href="<%= request.getContextPath() %>/view-users">View Users</a>
            </div>

            <!-- Search User -->
            <div class="card">
                <h3>Search User</h3>
                <form action="<%= request.getContextPath() %>/view-user-by-id" method="get">
                    <input type="number" name="user_id" placeholder="Enter User ID" required>
                    <button type="submit">Search</button>
                </form>
            </div>

            <!-- Approve -->
            <div class="card">
                <h3>Approve User</h3>
                <form action="<%= request.getContextPath() %>/approve-user" method="post">
                    <input type="number" name="userId" required>
                    <button class="success" type="submit">Approve</button>
                </form>
            </div>

            <!-- Reject -->
            <div class="card">
                <h3>Reject User</h3>
                <form action="<%= request.getContextPath() %>/reject-user" method="post">
                    <input type="number" name="userId" required>
                    <button class="danger" type="submit">Reject</button>
                </form>
            </div>

            <!-- Block -->
            <div class="card">
                <h3>Block User</h3>
                <form action="<%= request.getContextPath() %>/block-user" method="post">
                    <input type="number" name="userId" required>
                    <button class="warning" type="submit">Block</button>
                </form>
            </div>

            <!-- Delete -->
            <div class="card">
                <h3>Delete User</h3>
                <form action="<%= request.getContextPath() %>/delete-user" method="post">
                    <input type="number" name="userId" required>
                    <button class="danger" type="submit">Delete</button>
                </form>
            </div>

        </div>
    </main>
</div>

</body>
</html>