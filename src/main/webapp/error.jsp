<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/17/2026
  Time: 5:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error – Sahayog Sathi</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #F5F7F6; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .box { background: #fff; border-radius: 10px; padding: 40px 36px; text-align: center; max-width: 400px; width: 90%; }
        .box h2 { font-size: 1.2rem; color: #b91c1c; margin-bottom: 12px; }
        .box p  { font-size: 0.9rem; color: #6B7280; margin-bottom: 22px; line-height: 1.6; }
        .box a  { display: inline-block; padding: 9px 20px; background: #1F7A5C; color: #fff; border-radius: 7px; text-decoration: none; font-size: 0.88rem; font-weight: 700; }
        .box a:hover { background: #145A42; }
    </style>
</head>
<body>
<div class="box">
    <h2>Something went wrong</h2>
    <p>An unexpected error occurred. Please try again or go back to the dashboard.</p>
    <a href="<%= request.getContextPath() %>/donor/dashboard">Go to Dashboard</a>
</div>
</body>
</html>
