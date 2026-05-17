<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.the_street.the_street.dao.UserDAO" %>
<%
    UserDAO dao = new UserDAO();
    int totalUsers   = dao.countUsers();
    int pendingUsers = dao.countPendingUsers();
    int activeUsers  = dao.countActiveUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – Sahayog Sathi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        /* ── Stat cards ── */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: #FFFFFF;
            border-radius: 14px;
            padding: 22px 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 18px;
            text-decoration: none;
            cursor: pointer;
            transition: box-shadow 0.15s, transform 0.15s;
        }

        .stat-card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.10);
            transform: translateY(-2px);
        }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .stat-icon svg {
            width: 24px;
            height: 24px;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            fill: none;
        }

        .stat-icon.green  { background: #D1FAE5; }
        .stat-icon.green svg { stroke: #065F46; }

        .stat-icon.amber  { background: #FEF3C7; }
        .stat-icon.amber svg { stroke: #92400E; }

        .stat-icon.blue   { background: #DBEAFE; }
        .stat-icon.blue svg { stroke: #1E40AF; }

        .stat-icon.rose   { background: #FFE4E6; }
        .stat-icon.rose svg { stroke: #9F1239; }

        .stat-info p {
            font-size: 13px;
            color: #6B7280;
            margin-bottom: 4px;
            font-weight: 500;
        }

        .stat-info h2 {
            font-size: 28px;
            font-weight: 700;
            color: #1E1E1E;
            line-height: 1;
        }
        /* ── Section heading ── */
        .section-title {
            font-size: 15px;
            font-weight: 700;
            color: #1E1E1E;
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F3F4F6;
        }

        /* ── Quick actions grid ── */
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }

        .action-card {
            background: #FFFFFF;
            border-radius: 14px;
            padding: 22px 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            display: flex;
            flex-direction: column;
            gap: 14px;
            border-top: 3px solid transparent;
            transition: box-shadow 0.15s, transform 0.15s;
        }

        .action-card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.10);
            transform: translateY(-2px);
        }

        .action-card.border-green  { border-top-color: #1F7A5C; }
        .action-card.border-blue   { border-top-color: #2563EB; }
        .action-card.border-amber  { border-top-color: #D97706; }
        .action-card.border-red    { border-top-color: #DC2626; }
        .action-card.border-teal   { border-top-color: #0891B2; }
        .action-card.border-rose   { border-top-color: #E11D48; }

        .action-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .action-card-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .action-card-icon svg {
            width: 20px;
            height: 20px;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            fill: none;
        }

        .action-card-icon.green { background: #D1FAE5; }
        .action-card-icon.green svg { stroke: #065F46; }

        .action-card-icon.blue  { background: #DBEAFE; }
        .action-card-icon.blue svg  { stroke: #1E40AF; }

        .action-card-icon.amber { background: #FEF3C7; }
        .action-card-icon.amber svg { stroke: #92400E; }

        .action-card-icon.red   { background: #FFE4E6; }
        .action-card-icon.red svg   { stroke: #9F1239; }

        .action-card-icon.teal  { background: #CFFAFE; }
        .action-card-icon.teal svg  { stroke: #155E75; }

        .action-card-icon.rose  { background: #FFE4E6; }
        .action-card-icon.rose svg  { stroke: #BE123C; }

        .action-card h3 {
            font-size: 15px;
            font-weight: 700;
            color: #1E1E1E;
            margin: 0;
        }

        .action-card p {
            font-size: 13px;
            color: #6B7280;
            margin: 0;
            line-height: 1.5;
            min-height: 38px;
        }

        /* Action card input+button rows */
        .action-card form {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .action-card form input {
            flex: 1;
            padding: 9px 12px;
            margin: 0;
            border: 1.5px solid #E5E7EB;
            border-radius: 8px;
            font-size: 14px;
            color: #1E1E1E;
            background: #F9FAFB;
            transition: border-color 0.2s;
            min-width: 0;
        }

        .action-card form input:focus {
            outline: none;
            border-color: #1F7A5C;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(31,122,92,0.10);
        }

        .action-card form button {
            padding: 9px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            flex-shrink: 0;
        }

        /* Inline action row (non-form) */
        .action-row {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .action-row input {
            flex: 1;
            padding: 9px 12px;
            margin: 0;
            border: 1.5px solid #E5E7EB;
            border-radius: 8px;
            font-size: 14px;
            color: #1E1E1E;
            background: #F9FAFB;
            transition: border-color 0.2s;
            min-width: 0;
        }

        .action-row input:focus {
            outline: none;
            border-color: #1F7A5C;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(31,122,92,0.10);
        }

        .action-row button {
            padding: 9px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            white-space: nowrap;
            flex-shrink: 0;
            border: none;
            cursor: pointer;
            color: #E8F5F0;
            transition: opacity 0.15s, transform 0.1s;
        }

        .action-row button:hover { opacity: 0.85; transform: translateY(-1px); }
        .action-row button:active { transform: translateY(0); }

        .btn-blue   { background: #2563EB; }
        .btn-green  { background: #059669; }
        .btn-amber  { background: #D97706; }
        .btn-red    { background: #DC2626; }
        .btn-rose   { background: #E11D48; }

        .action-card .action-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #1F7A5C;
            color: #E8F5F0;
            padding: 9px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.15s, transform 0.1s;
            width: fit-content;
        }

        .action-link:hover        { background: #145A42; transform: translateY(-1px); }
        .action-link.amber        { background: #D97706; }
        .action-link.amber:hover  { background: #B45309; transform: translateY(-1px); }
        .action-link.teal         { background: #0891B2; }
        .action-link.teal:hover   { background: #0E7490; transform: translateY(-1px); }

        .action-link svg {
            width: 15px;
            height: 15px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2.5;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        /* ── Topbar greeting ── */
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .topbar-avatar { width: 38px; height: 38px; border-radius: 50%; background: #1F7A5C; color: #E8F5F0; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 15px; flex-shrink: 0; }
        .topbar-greeting { display: flex; flex-direction: column; align-items: flex-end; }
        .topbar-greeting span:first-child { font-size: 14px; font-weight: 600; color: #1E1E1E; }
        .topbar-greeting span:last-child { font-size: 12px; color: #6B7280; }

        /* ── Result Modal ── */
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 1000; background: rgba(0,0,0,0.55); backdrop-filter: blur(5px); -webkit-backdrop-filter: blur(5px); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: rgba(15,40,30,0.80); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid rgba(255,255,255,0.18); border-radius: 20px; box-shadow: 0 24px 64px rgba(0,0,0,0.50); width: 100%; max-width: 460px; animation: modalIn 0.2s ease; }
        @keyframes modalIn { from { opacity:0; transform:scale(0.95) translateY(12px); } to { opacity:1; transform:scale(1) translateY(0); } }
        .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px 16px; border-bottom: 1px solid rgba(255,255,255,0.12); }
        .modal-header-left { display: flex; align-items: center; gap: 12px; }
        .modal-icon { width: 40px; height: 40px; border-radius: 11px; display: flex; align-items: center; justify-content: center; }
        .modal-icon svg { width: 19px; height: 19px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
        .modal-icon.green { background: rgba(5,150,105,0.25); color: #6EE7B7; }
        .modal-icon.red   { background: rgba(220,38,38,0.25);  color: #FCA5A5; }
        .modal-icon.amber { background: rgba(217,119,6,0.25);  color: #FCD34D; }
        .modal-icon.blue  { background: rgba(37,99,235,0.25);  color: #93C5FD; }
        .modal-icon.rose  { background: rgba(225,29,72,0.25);  color: #FDA4AF; }
        .modal-title { font-size: 16px; font-weight: 700; color: #E8F5F0; }
        .modal-subtitle { font-size: 12px; color: rgba(200,230,218,0.60); margin-top: 2px; }
        .modal-close { background: none; border: none; cursor: pointer; font-size: 22px; font-weight: 300; color: #ffffff; line-height: 1; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; margin-left: auto; border-radius: 8px; transition: background 0.15s; margin-top: -24px; margin-right: -16px; padding: 0; }
        .modal-close:hover { background: rgba(255,255,255,0.15); }
        .modal-body { padding: 20px 24px; }
        .modal-footer { padding: 14px 24px 20px; display: flex; gap: 10px; justify-content: flex-end; border-top: 1px solid rgba(255,255,255,0.10); }
        .modal-btn { padding: 10px 22px; border-radius: 9px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; transition: opacity 0.15s; }
        .modal-btn:hover { opacity: 0.88; }
        .modal-btn-cancel { background: rgba(255,255,255,0.12); color: rgba(220,245,235,0.80); }
        .modal-btn-green  { background: #059669; color: #E8F5F0; }
        .modal-btn-red    { background: #DC2626; color: #E8F5F0; }
        .modal-btn-amber  { background: #D97706; color: #E8F5F0; }
        .modal-btn-rose   { background: #E11D48; color: #E8F5F0; }
        .modal-btn-blue   { background: #2563EB; color: #E8F5F0; }

        /* Result body */
        .result-body { text-align: center; padding: 8px 0; }
        .result-icon { width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; }
        .result-icon svg { width: 26px; height: 26px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
        .result-icon.green { background: rgba(5,150,105,0.22); color: #6EE7B7; }
        .result-icon.red   { background: rgba(220,38,38,0.22);  color: #FCA5A5; }
        .result-icon.amber { background: rgba(217,119,6,0.22);  color: #FCD34D; }
        .result-icon.rose  { background: rgba(225,29,72,0.22);  color: #FDA4AF; }
        .result-title { font-size: 17px; font-weight: 700; color: #E8F5F0; margin-bottom: 8px; }
        .result-desc  { font-size: 14px; color: rgba(220,245,235,0.65); line-height: 1.6; }

        /* User info grid in search result */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 4px; }
        .info-item label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: rgba(200,230,218,0.55); margin-bottom: 3px; }
        .info-item span  { font-size: 14px; font-weight: 500; color: #E8F5F0; }
        .info-item.full  { grid-column: 1 / -1; }
        .info-avatar-row { display: flex; align-items: center; gap: 14px; margin-bottom: 18px; padding-bottom: 16px; border-bottom: 1px solid rgba(255,255,255,0.10); }
        .info-avatar-ph  { width: 52px; height: 52px; border-radius: 50%; background: #1F7A5C; color: #E8F5F0; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 20px; flex-shrink: 0; }
        .info-avatar-name { font-size: 16px; font-weight: 700; color: #E8F5F0; }
        .info-avatar-id   { font-size: 12px; color: rgba(200,230,218,0.55); margin-top: 2px; }

        /* Toast */
        .toast { position: fixed; bottom: 28px; right: 28px; z-index: 2000; background: rgba(20,90,66,0.95); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.15); border-radius: 12px; padding: 13px 18px; display: flex; align-items: center; gap: 10px; color: #E8F5F0; font-size: 14px; font-weight: 500; box-shadow: 0 8px 30px rgba(0,0,0,0.30); transform: translateY(80px); opacity: 0; transition: transform 0.3s ease, opacity 0.3s ease; min-width: 240px; }
        .toast.show  { transform: translateY(0); opacity: 1; }
        .toast.error { background: rgba(185,28,28,0.95); }
        .toast svg   { width: 17px; height: 17px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; flex-shrink: 0; }
    </style>
</head>
<body>

<div class="dashboard">

    <!-- Sidebar -->
    <% request.setAttribute("activePage","dashboard"); %>
    <jsp:include page="/admin/includes/sidebar.jsp"/>

    <!-- Main -->
    <main class="main">
        <% request.setAttribute("pageTitle","Dashboard");
           request.setAttribute("pageSubtitle","Welcome back, here's what's happening today."); %>
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <!-- Stat cards -->
        <div class="stat-grid">
            <a class="stat-card" href="<%= request.getContextPath() %>/view-users">
                <div class="stat-icon green">
                    <svg viewBox="0 0 24 24">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                </div>
                <div class="stat-info">
                    <p>Total Users</p>
                    <h2><%= totalUsers %></h2>
                </div>
            </a>

            <a class="stat-card" href="<%= request.getContextPath() %>/view-users?filter=PENDING">
                <div class="stat-icon amber">
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                </div>
                <div class="stat-info">
                    <p>Pending Approval</p>
                    <h2><%= pendingUsers %></h2>
                </div>
            </a>

            <a class="stat-card" href="<%= request.getContextPath() %>/view-users?filter=ACTIVE">
                <div class="stat-icon blue">
                    <svg viewBox="0 0 24 24">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                </div>
                <div class="stat-info">
                    <p>Active Users</p>
                    <h2><%= activeUsers %></h2>
                </div>
            </a>
        </div>

        <!-- Quick Actions -->
        <p class="section-title">Quick Actions</p>

        <div class="action-grid">

            <!-- Manage Users -->
            <div class="action-card border-green">
                <div class="action-card-header">
                    <div class="action-card-icon green">
                        <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                    <h3>Manage Users</h3>
                </div>
                <p>View, edit and manage all registered users.</p>
                <a class="action-link" href="<%= request.getContextPath() %>/view-users">
                    View All Users
                    <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>
            </div>

            <!-- Manage Donations -->
            <div class="action-card border-green">
                <div class="action-card-header">
                    <div class="action-card-icon green">
                        <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
                    </div>
                    <h3>Manage Donations</h3>
                </div>
                <p>Monitor and remove donation posts.</p>
                <a class="action-link" href="<%= request.getContextPath() %>/admin/manage-donations.jsp">
                    View Donations
                    <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>
            </div>

            <!-- Manage Requests -->
            <div class="action-card border-amber">
                <div class="action-card-header">
                    <div class="action-card-icon amber">
                        <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                    </div>
                    <h3>Manage Requests</h3>
                </div>
                <p>Monitor and remove receiver requests.</p>
                <a class="action-link amber" href="<%= request.getContextPath() %>/admin/manage-requests.jsp">
                    View Requests
                    <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>
            </div>

            <!-- Create User -->
            <div class="action-card border-teal">
                <div class="action-card-header">
                    <div class="action-card-icon teal">
                        <svg viewBox="0 0 24 24">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="8.5" cy="7" r="4"/>
                            <line x1="20" y1="8" x2="20" y2="14"/>
                            <line x1="23" y1="11" x2="17" y2="11"/>
                        </svg>
                    </div>
                    <h3>Create User</h3>
                </div>
                <p>Add a new user account with any role and status.</p>
                <a class="action-link teal" href="<%= request.getContextPath() %>/admin-create-user">
                    Create New User
                    <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </a>
            </div>

            <div class="action-card border-blue">
                <div class="action-card-header">
                    <div class="action-card-icon blue">
                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    </div>
                    <h3>Search User</h3>
                </div>
                <p>Find a user by their ID.</p>
                <div class="action-row">
                    <input type="number" id="searchId" placeholder="Enter User ID" min="1">
                    <button onclick="doSearch()" class="btn-blue">Search</button>
                </div>
            </div>

            <!-- Approve User -->
            <div class="action-card border-green">
                <div class="action-card-header">
                    <div class="action-card-icon green">
                        <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                    </div>
                    <h3>Approve User</h3>
                </div>
                <p>Approve a pending user account.</p>
                <div class="action-row">
                    <input type="number" id="approveId" placeholder="User ID" min="1">
                    <button onclick="doAction('approve','approveId')" class="btn-green">Approve</button>
                </div>
            </div>

            <!-- Reject User -->
            <div class="action-card border-amber">
                <div class="action-card-header">
                    <div class="action-card-icon amber">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    </div>
                    <h3>Reject User</h3>
                </div>
                <p>Reject a user's registration request.</p>
                <div class="action-row">
                    <input type="number" id="rejectId" placeholder="User ID" min="1">
                    <button onclick="doAction('reject','rejectId')" class="btn-amber">Reject</button>
                </div>
            </div>

            <!-- Block User -->
            <div class="action-card border-red">
                <div class="action-card-header">
                    <div class="action-card-icon red">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
                    </div>
                    <h3>Block User</h3>
                </div>
                <p>Block a user from accessing the platform.</p>
                <div class="action-row">
                    <input type="number" id="blockId" placeholder="User ID" min="1">
                    <button onclick="doAction('block','blockId')" class="btn-red">Block</button>
                </div>
            </div>

            <!-- Delete User -->
            <div class="action-card border-rose">
                <div class="action-card-header">
                    <div class="action-card-icon rose">
                        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                    </div>
                    <h3>Delete User</h3>
                </div>
                <p>Permanently remove a user from the system.</p>
                <div class="action-row">
                    <input type="number" id="deleteId" placeholder="User ID" min="1">
                    <button onclick="doAction('delete','deleteId')" class="btn-rose">Delete</button>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- ══ RESULT MODAL ══ -->
<div class="modal-overlay" id="resultModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-icon" id="modalIcon"></div>
                <div><div class="modal-title" id="modalTitle"></div><div class="modal-subtitle" id="modalSubtitle"></div></div>
            </div>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        <div class="modal-body" id="modalBody"></div>
        <div class="modal-footer">
            <button class="modal-btn modal-btn-cancel" onclick="closeModal()">Close</button>
            <a id="modalViewBtn" href="#" class="modal-btn modal-btn-blue" style="display:none;text-decoration:none;">View in Manage Users</a>
        </div>
    </div>
</div>

<!-- Toast -->
<div class="toast" id="toast">
    <svg id="toastIcon" viewBox="0 0 24 24"></svg>
    <span id="toastMsg"></span>
</div>

<script>
    const CTX = '<%= request.getContextPath() %>';

    function closeModal() {
        document.getElementById('resultModal').classList.remove('open');
    }

    document.getElementById('resultModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    function showToast(msg, isError) {
        const t = document.getElementById('toast');
        t.classList.toggle('error', !!isError);
        document.getElementById('toastIcon').innerHTML = isError
            ? '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>'
            : '<polyline points="20 6 9 17 4 12"/>';
        document.getElementById('toastMsg').textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 3200);
    }

    function showResultModal(cfg) {
        document.getElementById('modalIcon').className = 'modal-icon ' + cfg.iconClass;
        document.getElementById('modalIcon').innerHTML = '<svg viewBox="0 0 24 24">' + cfg.iconSvg + '</svg>';
        document.getElementById('modalTitle').textContent    = cfg.title;
        document.getElementById('modalSubtitle').textContent = cfg.subtitle || '';
        document.getElementById('modalBody').innerHTML       = cfg.body;
        const viewBtn = document.getElementById('modalViewBtn');
        if (cfg.userId) {
            viewBtn.style.display = 'inline-flex';
            viewBtn.href = CTX + '/view-users';
        } else {
            viewBtn.style.display = 'none';
        }
        document.getElementById('resultModal').classList.add('open');
    }

    /* ── Search ── */
    function doSearch() {
        const id = document.getElementById('searchId').value.trim();
        if (!id) { showToast('Please enter a User ID.', true); return; }

        fetch(CTX + '/user-json?userId=' + id)
            .then(r => {
                if (r.status === 404) throw new Error('User not found.');
                if (!r.ok) throw new Error('Error fetching user.');
                return r.json();
            })
            .then(u => {
                const initial = u.fullName ? u.fullName.charAt(0).toUpperCase() : '?';
                const statusColors = { ACTIVE:'#059669', PENDING:'#D97706', BLOCKED:'#DC2626', REJECTED:'#6B7280' };
                const roleColors   = { ADMIN:'#5B21B6', DONOR:'#1E40AF', RECEIVER:'#92400E', VOLUNTEER:'#065F46' };
                const sc = statusColors[u.status] || '#6B7280';
                const rc = roleColors[u.role]     || '#374151';
                const body =
                    '<div class="info-avatar-row">' +
                        '<div class="info-avatar-ph">' + initial + '</div>' +
                        '<div><div class="info-avatar-name">' + u.fullName + '</div><div class="info-avatar-id">ID: ' + u.userId + '</div></div>' +
                    '</div>' +
                    '<div class="info-grid">' +
                        '<div class="info-item full"><label>Email</label><span>' + u.email + '</span></div>' +
                        '<div class="info-item"><label>Phone</label><span>' + u.phone + '</span></div>' +
                        '<div class="info-item"><label>Role</label><span style="color:' + rc + ';font-weight:700;">' + u.role + '</span></div>' +
                        '<div class="info-item"><label>Status</label><span style="color:' + sc + ';font-weight:700;">' + u.status + '</span></div>' +
                        '<div class="info-item full"><label>Address</label><span>' + (u.address || '—') + '</span></div>' +
                    '</div>';
                showResultModal({
                    iconClass: 'blue',
                    iconSvg: '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>',
                    title: 'User Found',
                    subtitle: '#' + u.userId,
                    userId: u.userId,
                    body: body
                });
                document.getElementById('searchId').value = '';
            })
            .catch(err => showToast(err.message, true));
    }

    /* ── Action (approve / reject / block / delete) ── */
    const actionConfig = {
        approve: { endpoint:'/approve-user', iconClass:'green', iconSvg:'<polyline points="20 6 9 17 4 12"/>', title:'User Approved',  desc:'The user account has been activated.' },
        reject:  { endpoint:'/reject-user',  iconClass:'amber', iconSvg:'<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>', title:'User Rejected', desc:'The registration has been rejected.' },
        block:   { endpoint:'/block-user',   iconClass:'red',   iconSvg:'<circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>', title:'User Blocked', desc:'The user has been blocked from the platform.' },
        delete:  { endpoint:'/delete-user',  iconClass:'rose',  iconSvg:'<polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>', title:'User Deleted', desc:'The user has been permanently removed.' }
    };

    function doAction(action, inputId) {
        const id = document.getElementById(inputId).value.trim();
        if (!id) { showToast('Please enter a User ID.', true); return; }

        const cfg = actionConfig[action];
        const payload = new URLSearchParams({ userId: id });

        fetch(CTX + cfg.endpoint, { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: payload })
            .then(r => {
                if (r.ok || r.redirected) {
                    showResultModal({
                        iconClass: cfg.iconClass,
                        iconSvg:   cfg.iconSvg,
                        title:     cfg.title,
                        subtitle:  'User ID: ' + id,
                        userId:    id,
                        body: '<div class="result-body">' +
                                  '<div class="result-icon ' + cfg.iconClass + '"><svg viewBox="0 0 24 24">' + cfg.iconSvg + '</svg></div>' +
                                  '<div class="result-title">' + cfg.title + '</div>' +
                                  '<div class="result-desc">' + cfg.desc + '<br><br>User ID: <strong style="color:#A7F3D0;">' + id + '</strong></div>' +
                              '</div>'
                    });
                    document.getElementById(inputId).value = '';
                    // Refresh stat counts after a short delay
                    setTimeout(() => location.reload(), 2000);
                } else {
                    showToast('Action failed. Check the User ID and try again.', true);
                }
            })
            .catch(() => showToast('Network error. Please try again.', true));
    }

    // Allow Enter key on search input
    document.getElementById('searchId').addEventListener('keydown', e => { if (e.key === 'Enter') doSearch(); });
</script>
</body>
</html>
