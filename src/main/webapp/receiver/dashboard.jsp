<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fullName = (String) session.getAttribute("fullName");
    String role     = (String) session.getAttribute("role");
    if (fullName == null || role == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    String firstName = fullName.trim().split("\\s+")[0];
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receiver Dashboard – Sahayog Sathi</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',Arial,sans-serif; background:#F5F7F6; color:#1E1E1E; min-height:100vh; display:flex; flex-direction:column; align-items:center; justify-content:center; padding:40px 20px; }
        .card { background:#FFFFFF; border-radius:20px; box-shadow:0 4px 24px rgba(0,0,0,0.08); padding:48px 44px; max-width:480px; width:100%; text-align:center; }
        .avatar { width:72px; height:72px; border-radius:50%; background:#D97706; color:#fff; font-size:28px; font-weight:700; display:flex; align-items:center; justify-content:center; margin:0 auto 20px; }
        .role-badge { display:inline-block; padding:4px 14px; border-radius:20px; font-size:12px; font-weight:700; text-transform:uppercase; background:#FEF3C7; color:#92400E; margin-bottom:16px; }
        h1 { font-size:24px; font-weight:700; margin-bottom:8px; }
        p  { font-size:15px; color:#6B7280; line-height:1.6; margin-bottom:32px; }
        .coming-soon { background:#F9FAFB; border:2px dashed #E5E7EB; border-radius:12px; padding:24px; margin-bottom:28px; }
        .coming-soon strong { display:block; font-size:16px; color:#374151; font-weight:700; margin-bottom:6px; }
        .coming-soon span { font-size:13px; color:#9CA3AF; font-weight:500; }
        .btn-logout { display:inline-flex; align-items:center; gap:8px; padding:11px 24px; background:#1F7A5C; color:#E8F5F0; border-radius:10px; text-decoration:none; font-size:14px; font-weight:600; }
        .btn-logout:hover { background:#145A42; }
    </style>
</head>
<body>
<div class="card">
    <div class="avatar"><%= firstName.substring(0,1).toUpperCase() %></div>
    <div class="role-badge">Receiver</div>
    <h1>Welcome, <%= firstName %>!</h1>
    <p>You're logged in as a <strong>Receiver</strong> on Sahayog Sathi.</p>
    <div class="coming-soon">
        <strong>Receiver dashboard coming soon</strong>
        <span>Request management features are being built.</span>
    </div>
    <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
</div>
</body>
</html>
