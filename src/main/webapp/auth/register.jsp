<%--
  Created by IntelliJ IDEA.
  User: SayMyName
  Date: 5/3/2026
  Time: 3:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
  <title>Register - Sahayog Sathi</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/auth/auth.css">
</head>
<body>

<div class="auth-container">
  <div class="auth-card register-card">
    <h2>Create Account</h2>
    <p>Join Sahayog Sathi as Donor, Receiver, or Volunteer</p>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="message error">
      <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="message success">
      <%= request.getAttribute("successMessage") %>
    </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/register" method="post" enctype="multipart/form-data">

      <div class="form-group">
        <label>Full Name</label>
        <input type="text" name="fullName" required>
      </div>

      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" required>
      </div>

      <div class="form-group">
        <label>Phone</label>
        <input type="text" name="phone" required>
      </div>

      <div class="form-group">
        <label>Address</label>
        <input type="text" name="address" required>
      </div>

      <div class="form-group">
        <label>Role</label>
        <select name="role" required>
          <option value="">-- Select Role --</option>
          <option value="DONOR">Donor</option>
          <option value="RECEIVER">Receiver</option>
          <option value="VOLUNTEER">Volunteer</option>
        </select>
      </div>

      <div class="form-group">
        <label>Profile Image</label>
        <input type="file" name="profileImage" accept="image/png, image/jpeg, image/jpg">
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" required>
      </div>

      <div class="form-group">
        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" required>
      </div>

      <button type="submit">Register</button>
    </form>

    <div class="auth-link">
      Already have an account?
      <a href="<%= request.getContextPath() %>/auth/login.jsp">Login</a>
    </div>
  </div>
</div>

</body>
</html>