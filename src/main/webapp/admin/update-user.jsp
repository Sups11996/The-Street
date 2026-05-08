<%--
  Created by IntelliJ IDEA.
  User: SayMyName
  Date: 5/3/2026
  Time: 3:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User u = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update User</title>
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
            <h1>Update User</h1>
            <a class="back-btn" href="<%= request.getContextPath() %>/view-users">Back</a>
        </div>

        <%
            if (u != null) {
        %>

        <div class="form-box">
            <form action="<%= request.getContextPath() %>/update-user" method="post">
                <input type="hidden" name="userId" value="<%= u.getUserId() %>">

                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= u.getFullName() %>" required>

                <label>Email</label>
                <input type="email" name="email" value="<%= u.getEmail() %>" required>

                <label>Phone</label>
                <input type="text" name="phone" value="<%= u.getPhone() %>" required>

                <label>Role</label>
                <select name="role" required>
                    <option value="ADMIN" <%= "ADMIN".equals(u.getRole()) ? "selected" : "" %>>ADMIN</option>
                    <option value="DONOR" <%= "DONOR".equals(u.getRole()) ? "selected" : "" %>>DONOR</option>
                    <option value="RECEIVER" <%= "RECEIVER".equals(u.getRole()) ? "selected" : "" %>>RECEIVER</option>
                    <option value="VOLUNTEER" <%= "VOLUNTEER".equals(u.getRole()) ? "selected" : "" %>>VOLUNTEER</option>
                </select>

                <label>Status</label>
                <select name="status" required>
                    <option value="ACTIVE" <%= "ACTIVE".equals(u.getStatus()) ? "selected" : "" %>>ACTIVE</option>
                    <option value="PENDING" <%= "PENDING".equals(u.getStatus()) ? "selected" : "" %>>PENDING</option>
                    <option value="REJECTED" <%= "REJECTED".equals(u.getStatus()) ? "selected" : "" %>>REJECTED</option>
                    <option value="BLOCKED" <%= "BLOCKED".equals(u.getStatus()) ? "selected" : "" %>>BLOCKED</option>
                </select>

                <button type="submit">Update User</button>
            </form>
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