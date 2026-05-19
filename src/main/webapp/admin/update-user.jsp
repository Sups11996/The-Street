<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User u = (User) request.getAttribute("user");
    request.setAttribute("activePage", "users");
    request.setAttribute("pageTitle", "Update User");
    request.setAttribute("pageSubtitle", "Edit user account details.");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update User – Sahayog Sathi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>
<body>
<div class="dashboard">
    <jsp:include page="/admin/includes/sidebar.jsp"/>
    <main class="main">
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <% if (u != null) { %>
        <div class="form-box">
            <form action="<%= request.getContextPath() %>/update-user" method="post">
                <input type="hidden" name="userId" value="<%= u.getUserId() %>">

                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= u.getFullName() %>" required>

                <label>Email</label>
                <input type="email" name="email" value="<%= u.getEmail() %>" required>

                <label>Phone</label>
                <input type="text" name="phone" value="<%= u.getPhone() %>" required>

                <label>Address</label>
                <input type="text" name="address" value="<%= u.getAddress() != null ? u.getAddress() : "" %>">

                <label>Role</label>
                <select name="role" required>
                    <option value="ADMIN"      <%= "ADMIN".equals(u.getRole())      ? "selected" : "" %>>Admin</option>
                    <option value="DONOR"      <%= "DONOR".equals(u.getRole())      ? "selected" : "" %>>Donor</option>
                    <option value="RECEIVER"   <%= "RECEIVER".equals(u.getRole())   ? "selected" : "" %>>Receiver</option>
                    <option value="VOLUNTEER"  <%= "VOLUNTEER".equals(u.getRole())  ? "selected" : "" %>>Volunteer</option>
                </select>

                <label>Status</label>
                <select name="status" required>
                    <option value="ACTIVE"   <%= "ACTIVE".equals(u.getStatus())   ? "selected" : "" %>>Active</option>
                    <option value="PENDING"  <%= "PENDING".equals(u.getStatus())  ? "selected" : "" %>>Pending</option>
                    <option value="BLOCKED"  <%= "BLOCKED".equals(u.getStatus())  ? "selected" : "" %>>Blocked</option>
                    <option value="REJECTED" <%= "REJECTED".equals(u.getStatus()) ? "selected" : "" %>>Rejected</option>
                </select>

                <button type="submit">Update User</button>
            </form>
        </div>
        <% } else { %>
        <div class="alert error">User not found.</div>
        <% } %>
    </main>
</div>
</body>
</html>
