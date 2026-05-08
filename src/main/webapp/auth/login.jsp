<%--
  Created by IntelliJ IDEA.
  User: SayMyName
  Date: 5/3/2026
  Time: 3:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String rememberedEmail = "";
  Cookie[] cookies = request.getCookies();

  if (cookies != null) {
    for (Cookie cookie : cookies) {
      if ("rememberEmail".equals(cookie.getName())) {
        rememberedEmail = cookie.getValue();
      }
    }
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Login - Sahayog Sathi</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/auth/auth.css">
</head>
<body>

<div class="auth-container">
  <div class="auth-card">
    <h2>Welcome Back</h2>
    <p>Login to Sahayog Sathi</p>

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

    <form action="<%= request.getContextPath() %>/login" method="post">
      <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" value="<%= rememberedEmail %>" required>
      </div>

      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" required>
      </div>

      <div class="remember-row">
        <label>
          <input type="checkbox" name="rememberMe" value="yes">
          Remember me
        </label>
      </div>

      <button type="submit">Login</button>
    </form>

    <div class="auth-link">
      Don’t have an account?
      <a href="<%= request.getContextPath() %>/auth/register.jsp">Register</a>
    </div>
  </div>
</div>

</body>
</html>