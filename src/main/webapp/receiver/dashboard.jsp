<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    com.the_street.the_street.model.User loggedUser =
            (com.the_street.the_street.model.User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Sahayog Sathi</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f0f4f8; color: #1a2332; min-height: 100vh; }

        .navbar {
            background: #1a6b4a; padding: 0 36px; height: 64px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 2px 12px rgba(26,107,74,0.3);
        }
        .navbar .brand {
            font-size: 1.25rem; font-weight: 800; color: white; letter-spacing: -0.3px;
            display: flex; align-items: center; gap: 10px;
        }
        .brand-dot { width: 8px; height: 8px; background: #4ade80; border-radius: 50%; }
        .nav-links { display: flex; align-items: center; gap: 4px; }
        .nav-links a {
            color: rgba(255,255,255,0.85); text-decoration: none;
            padding: 8px 16px; border-radius: 8px; font-size: 0.88rem; font-weight: 500;
            transition: all 0.2s;
        }
        .nav-links a:hover { background: rgba(255,255,255,0.15); color: white; }
        .nav-links a.active { background: rgba(255,255,255,0.2); color: white; }

        .container { max-width: 1000px; margin: 0 auto; padding: 48px 24px; }

        .welcome-section { margin-bottom: 40px; }
        .welcome-tag {
            display: inline-flex; align-items: center; gap: 6px;
            background: #dcfce7; color: #166534; border-radius: 20px;
            padding: 4px 12px; font-size: 0.78rem; font-weight: 600;
            margin-bottom: 12px; letter-spacing: 0.3px;
        }
        .welcome-tag span { width: 6px; height: 6px; background: #16a34a; border-radius: 50%; display: inline-block; }
        .welcome-section h1 { font-size: 2rem; font-weight: 800; color: #0f1f14; letter-spacing: -0.5px; }
        .welcome-section p { color: #64748b; margin-top: 8px; font-size: 0.95rem; }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 36px; }
        .stat-card {
            background: white; border-radius: 14px; padding: 24px 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06), 0 4px 16px rgba(0,0,0,0.04);
        }
        .stat-label { font-size: 0.78rem; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .stat-value { font-size: 2rem; font-weight: 800; color: #0f1f14; }
        .stat-card.pending  .stat-value { color: #d97706; }
        .stat-card.fulfilled .stat-value { color: #16a34a; }
        .stat-card.cancelled .stat-value { color: #dc2626; }

        .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .card {
            background: white; border-radius: 16px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06), 0 4px 16px rgba(0,0,0,0.04);
            padding: 32px 28px; text-decoration: none; color: #1a2332;
            transition: transform 0.2s, box-shadow 0.2s;
            display: block; position: relative; overflow: hidden;
        }
        .card:hover { transform: translateY(-3px); box-shadow: 0 8px 32px rgba(0,0,0,0.10); }
        .card-icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center; margin-bottom: 20px;
        }
        .card-icon svg { width: 24px; height: 24px; }
        .card-icon.green  { background: #dcfce7; }
        .card-icon.blue   { background: #dbeafe; }
        .card-icon.orange { background: #fef3c7; }
        .card h3 { font-size: 1.05rem; font-weight: 700; margin-bottom: 6px; }
        .card p  { font-size: 0.85rem; color: #64748b; line-height: 1.5; }
        .card-arrow {
            position: absolute; bottom: 24px; right: 24px;
            width: 28px; height: 28px; background: #f0f4f8;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
        }
        .card-arrow svg { width: 14px; height: 14px; stroke: #64748b; }

        .section-title { font-size: 1.1rem; font-weight: 700; color: #0f1f14; margin-bottom: 20px; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="brand">
        <div class="brand-dot"></div>
        Sahayog Sathi
    </div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/receiver/dashboard" class="active">Dashboard</a>
        <a href="<%= request.getContextPath() %>/receiver/my-requests">My Requests</a>
        <a href="<%= request.getContextPath() %>/receiver/create-request">New Request</a>
        <a href="<%= request.getContextPath() %>/auth/logout">Logout</a>
    </div>
</nav>

<div class="container">

    <div class="welcome-section">
        <div class="welcome-tag"><span></span> Receiver Portal</div>
        <h1>Welcome back, <%= loggedUser != null ? loggedUser.getFullName() : "User" %>!</h1>
        <p>Here's a summary of your aid requests.</p>
    </div>

    <!-- Stats Row -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total Requests</div>
            <div class="stat-value">${totalRequests}</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-label">Pending</div>
            <div class="stat-value">${pendingCount}</div>
        </div>
        <div class="stat-card fulfilled">
            <div class="stat-label">Fulfilled</div>
            <div class="stat-value">${fulfilledCount}</div>
        </div>
        <div class="stat-card cancelled">
            <div class="stat-label">Cancelled</div>
            <div class="stat-value">${cancelledCount}</div>
        </div>
    </div>

    <!-- Action Cards -->
    <div class="section-title">Quick Actions</div>
    <div class="cards">

        <a href="<%= request.getContextPath() %>/receiver/create-request" class="card">
            <div class="card-icon green">
                <svg viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/>
                </svg>
            </div>
            <h3>Create New Request</h3>
            <p>Submit a new aid request for food, medicine, clothing, or other essentials.</p>
            <div class="card-arrow">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                </svg>
            </div>
        </a>

        <a href="<%= request.getContextPath() %>/receiver/my-requests" class="card">
            <div class="card-icon blue">
                <svg viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/>
                    <rect x="9" y="3" width="6" height="4" rx="1"/>
                    <line x1="9" y1="12" x2="15" y2="12"/><line x1="9" y1="16" x2="13" y2="16"/>
                </svg>
            </div>
            <h3>View My Requests</h3>
            <p>Track the status of all your submitted requests and confirm received items.</p>
            <div class="card-arrow">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                </svg>
            </div>
        </a>

        <a href="<%= request.getContextPath() %>/auth/logout" class="card">
            <div class="card-icon orange">
                <svg viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                    <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
                </svg>
            </div>
            <h3>Logout</h3>
            <p>Sign out of your account securely.</p>
            <div class="card-arrow">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                </svg>
            </div>
        </a>

    </div>
</div>

</body>
</html>