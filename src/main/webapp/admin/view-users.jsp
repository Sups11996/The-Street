<%@ page import="java.util.List" %>
<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Sahayog Sathi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        html, body { height: 100%; overflow: hidden; }
        .dashboard { height: 100vh; overflow: hidden; }
        .main { padding: 28px; display: flex; flex-direction: column; height: 100vh; overflow: hidden; box-sizing: border-box; }
        .topbar { flex-shrink: 0; margin-bottom: 20px; }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .topbar-avatar { width: 38px; height: 38px; border-radius: 50%; background: #1F7A5C; color: #E8F5F0; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 15px; flex-shrink: 0; }
        .topbar-greeting { display: flex; flex-direction: column; align-items: flex-end; }
        .topbar-greeting span:first-child { font-size: 14px; font-weight: 600; color: #1E1E1E; }
        .topbar-greeting span:last-child { font-size: 12px; color: #6B7280; }
        .table-card { flex: 1; display: flex; flex-direction: column; overflow: hidden; min-height: 0; background: #FFFFFF; border-radius: 14px; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
        .table-scroll { flex: 1; overflow-x: auto; overflow-y: hidden; display: flex; flex-direction: column; }
        .users-table { width: 100%; border-collapse: collapse; table-layout: fixed; flex: 1; }
        .users-table tbody tr.filler-row { height: 100%; }
        .filler-row td { border-bottom: none !important; background: transparent; }

        /* ── Pagination ── */
        .pagination-bar { display: flex; align-items: center; justify-content: space-between; padding: 12px 20px; border-top: 1px solid #F3F4F6; background: #FFFFFF; flex-shrink: 0; border-radius: 0 0 14px 14px; }
        .pagination-info { font-size: 13px; color: #6B7280; }
        .pagination-btns { display: flex; align-items: center; gap: 4px; }
        .pg-btn { min-width: 32px; height: 32px; padding: 0 8px; border: 1.5px solid #E5E7EB; background: #fff; border-radius: 7px; font-size: 13px; font-weight: 600; color: #374151; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
        .pg-btn:hover:not(:disabled) { border-color: #1F7A5C; color: #1F7A5C; background: #F0FAF6; }
        .pg-btn.active { background: #1F7A5C; border-color: #1F7A5C; color: #fff; }
        .pg-btn:disabled { opacity: 0.35; cursor: not-allowed; }
        .pg-btn svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
        .toolbar { background: #FFFFFF; border-radius: 12px; padding: 16px 20px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); flex-wrap: wrap; }
        .search-box { display: flex; align-items: center; gap: 8px; flex: 1; min-width: 200px; background: #F9FAFB; border: 1.5px solid #E5E7EB; border-radius: 8px; padding: 9px 14px; }
        .search-box:focus-within { border-color: #1F7A5C; box-shadow: 0 0 0 3px rgba(31,122,92,0.10); }
        .search-box svg { width: 16px; height: 16px; stroke: #6B7280; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; flex-shrink: 0; }
        .search-box input { border: none; background: none; outline: none; box-shadow: none; font-size: 14px; color: #1E1E1E; width: 100%; padding: 0; margin: 0; border-radius: 4px; }
        .search-box input[type="search"]::-webkit-search-cancel-button { cursor: pointer; -webkit-appearance: auto; }
        .search-box input::placeholder { color: #9CA3AF; }
        .filter-select { padding: 9px 14px; border: 1.5px solid #E5E7EB; border-radius: 8px; font-size: 14px; color: #1E1E1E; background: #F9FAFB; cursor: pointer; margin: 0; width: auto; min-width: 140px; }
        .filter-select:focus { outline: none; border-color: #1F7A5C; }
        .toolbar-count { font-size: 13px; color: #6B7280; white-space: nowrap; }
        .users-table th:nth-child(1) { width: 18%; }
        .users-table th:nth-child(2) { width: 18%; }
        .users-table th:nth-child(3) { width: 12%; }
        .users-table th:nth-child(4) { width: 10%; }
        .users-table th:nth-child(5) { width: 10%; }
        .users-table th:nth-child(6) { width: 32%; text-align: left; padding-left: 16px; }
        .users-table td:nth-child(6) { text-align: left; padding-left: 16px; padding-right: 16px; }
        .users-table thead tr { background: #F9FAFB; border-bottom: 2px solid #E5E7EB; }
        .users-table th, .users-table td { padding: 13px 16px; text-align: left; vertical-align: middle; }
        .users-table th { background: #F9FAFB; color: #6B7280; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; white-space: nowrap; }
        .users-table td { border-bottom: 1px solid #F3F4F6; font-size: 14px; color: #1E1E1E; }
        .users-table tbody tr:last-child td { border-bottom: none; }
        .users-table tbody tr { transition: background 0.12s; }
        .users-table tbody tr:hover { background: #F0FAF6; }
        .user-cell { display: flex; align-items: center; gap: 12px; }
        .profile-img { width: 38px; height: 38px; border-radius: 50%; object-fit: cover; border: 2px solid #D1FAE5; flex-shrink: 0; }
        .profile-placeholder { width: 38px; height: 38px; border-radius: 50%; background: #1F7A5C; color: #E8F5F0; display: inline-flex; align-items: center; justify-content: center; font-weight: 700; font-size: 15px; flex-shrink: 0; }
        .user-name { font-weight: 600; color: #1E1E1E; font-size: 14px; }
        .user-id { font-size: 12px; color: #9CA3AF; }
        .role-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .role-admin { background: #EDE9FE; color: #5B21B6; }
        .role-donor { background: #DBEAFE; color: #1E40AF; }
        .role-receiver { background: #FEF3C7; color: #92400E; }
        .role-volunteer { background: #D1FAE5; color: #065F46; }
        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .status-badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; flex-shrink: 0; }
        .status-active { background: #D1FAE5; color: #065F46; } .status-active::before { background: #059669; }
        .status-pending { background: #FEF3C7; color: #92400E; } .status-pending::before { background: #D97706; }
        .status-blocked { background: #FEE2E2; color: #991B1B; } .status-blocked::before { background: #DC2626; }
        .status-rejected { background: #F3F4F6; color: #374151; } .status-rejected::before { background: #9CA3AF; }
        .actions-cell { padding-left: 16px !important; padding-right: 16px !important; }
        .actions-inner { display: flex; align-items: center; width: 100%; gap: 4px; }
        .actions-inner .btn-action { flex: 1; justify-content: center; margin-right: 0; }
        .actions-inner form { flex: 1; display: flex; }
        .actions-inner form .btn-action { width: 100%; }
        .btn-action { display: inline-flex; align-items: center; gap: 4px; padding: 6px 8px; font-size: 12px; font-weight: 600; border-radius: 6px; text-decoration: none; color: #E8F5F0; border: none; cursor: pointer; transition: opacity 0.15s, transform 0.1s; white-space: nowrap; }
        .btn-action:hover { opacity: 0.85; transform: translateY(-1px); }
        .btn-action svg { width: 11px; height: 11px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
        .btn-view { background: #2563EB; } .btn-edit { background: #0891B2; }
        .btn-success { background: #059669; } .btn-warning { background: #D97706; }
        .btn-danger { background: #DC2626; } .btn-rose { background: #E11D48; }
        .empty-state { text-align: center; padding: 60px 20px; color: #6B7280; }
        .empty-state svg { width: 48px; height: 48px; stroke: #D1D5DB; fill: none; stroke-width: 1.5; margin-bottom: 16px; }

        /* ── MODAL OVERLAY ── */
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 1000; background: rgba(0,0,0,0.55); backdrop-filter: blur(5px); -webkit-backdrop-filter: blur(5px); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: rgba(15,40,30,0.75); backdrop-filter: blur(24px); -webkit-backdrop-filter: blur(24px); border: 1px solid rgba(255,255,255,0.18); border-radius: 20px; box-shadow: 0 24px 64px rgba(0,0,0,0.50); width: 100%; max-width: 500px; animation: modalIn 0.2s ease; }
        @keyframes modalIn { from { opacity:0; transform:scale(0.95) translateY(12px); } to { opacity:1; transform:scale(1) translateY(0); } }
        .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px 16px; border-bottom: 1px solid rgba(255,255,255,0.12); }
        .modal-header-left { display: flex; align-items: center; gap: 12px; }
        .modal-icon { width: 40px; height: 40px; border-radius: 11px; display: flex; align-items: center; justify-content: center; }
        .modal-icon svg { width: 19px; height: 19px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
        .modal-icon.blue  { background: rgba(37,99,235,0.25);  color: #93C5FD; }
        .modal-icon.teal  { background: rgba(8,145,178,0.25);  color: #67E8F9; }
        .modal-icon.green { background: rgba(5,150,105,0.25);  color: #6EE7B7; }
        .modal-icon.amber { background: rgba(217,119,6,0.25);  color: #FCD34D; }
        .modal-icon.red   { background: rgba(220,38,38,0.25);  color: #FCA5A5; }
        .modal-icon.rose  { background: rgba(225,29,72,0.25);  color: #FDA4AF; }
        .modal-title { font-size: 16px; font-weight: 700; color: #E8F5F0; }
        .modal-subtitle { font-size: 12px; color: rgba(200,230,218,0.60); margin-top: 2px; }
        .modal-close { background: none; border: none; cursor: pointer; font-size: 22px; font-weight: 300; color: #ffffff; line-height: 1; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; margin-left: auto; border-radius: 8px; transition: background 0.15s; margin-top: -24px; margin-right: -16px; padding: 0; }
        .modal-close:hover { background: rgba(255,255,255,0.15); }
        .modal-body { padding: 20px 24px; }
        .modal-footer { padding: 14px 24px 20px; display: flex; gap: 10px; justify-content: flex-end; border-top: 1px solid rgba(255,255,255,0.10); }
        .modal-btn { padding: 10px 22px; border-radius: 9px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; transition: opacity 0.15s, transform 0.1s; }
        .modal-btn:hover { opacity: 0.88; transform: translateY(-1px); }
        .modal-btn-cancel { background: rgba(255,255,255,0.12); color: rgba(220,245,235,0.80); }
        .modal-btn-cancel:hover { background: rgba(255,255,255,0.20); opacity: 1; }
        .modal-btn-blue  { background: #2563EB; color: #E8F5F0; }
        .modal-btn-green { background: #059669; color: #E8F5F0; }
        .modal-btn-amber { background: #D97706; color: #E8F5F0; }
        .modal-btn-red   { background: #DC2626; color: #E8F5F0; }
        .modal-btn-rose  { background: #E11D48; color: #E8F5F0; }
        .modal-btn-teal  { background: #0891B2; color: #E8F5F0; }

        /* View info grid */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .info-item label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: rgba(200,230,218,0.55); margin-bottom: 4px; }
        .info-item span { font-size: 14px; font-weight: 500; color: #E8F5F0; }
        .info-item.full { grid-column: 1 / -1; }
        .info-avatar { display: flex; align-items: center; gap: 14px; margin-bottom: 20px; padding-bottom: 18px; border-bottom: 1px solid rgba(255,255,255,0.10); }
        .info-avatar-img { width: 56px; height: 56px; border-radius: 50%; object-fit: cover; border: 2px solid rgba(255,255,255,0.20); }
        .info-avatar-placeholder { width: 56px; height: 56px; border-radius: 50%; background: #1F7A5C; color: #E8F5F0; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 22px; flex-shrink: 0; }
        .info-avatar-name { font-size: 17px; font-weight: 700; color: #E8F5F0; }
        .info-avatar-id { font-size: 12px; color: rgba(200,230,218,0.55); margin-top: 2px; }

        /* Edit form fields */
        .modal-form-group { margin-bottom: 13px; }
        .modal-form-group label { display: block; font-size: 11px; font-weight: 700; color: rgba(200,230,218,0.70); margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.4px; }
        .modal-form-group input, .modal-form-group select { width: 100%; padding: 10px 12px; background: rgba(255,255,255,0.10); border: 1px solid rgba(255,255,255,0.18); border-radius: 8px; font-size: 14px; color: #E8F5F0; margin: 0; transition: border-color 0.2s; }
        .modal-form-group input::placeholder { color: rgba(200,230,218,0.35); }
        .modal-form-group input:focus, .modal-form-group select:focus { outline: none; border-color: #1F7A5C; box-shadow: 0 0 0 3px rgba(31,122,92,0.25); background: rgba(255,255,255,0.14); }
        .modal-form-group select option { background: #1a3a2a; color: #E8F5F0; }
        .modal-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 0 14px; }

        /* Confirm */
        .confirm-body { text-align: center; padding: 8px 0 4px; }
        .confirm-icon { width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; }
        .confirm-icon svg { width: 26px; height: 26px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
        .confirm-icon.red   { background: rgba(220,38,38,0.22);  color: #FCA5A5; }
        .confirm-icon.amber { background: rgba(217,119,6,0.22);  color: #FCD34D; }
        .confirm-icon.green { background: rgba(5,150,105,0.22);  color: #6EE7B7; }
        .confirm-icon.rose  { background: rgba(225,29,72,0.22);  color: #FDA4AF; }
        .confirm-title { font-size: 17px; font-weight: 700; color: #E8F5F0; margin-bottom: 8px; }
        .confirm-desc { font-size: 14px; color: rgba(220,245,235,0.65); line-height: 1.6; }
        .confirm-name { font-weight: 700; color: #A7F3D0; }

        /* Toast */
        .toast { position: fixed; bottom: 28px; right: 28px; z-index: 2000; background: rgba(20,90,66,0.95); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.15); border-radius: 12px; padding: 13px 18px; display: flex; align-items: center; gap: 10px; color: #E8F5F0; font-size: 14px; font-weight: 500; box-shadow: 0 8px 30px rgba(0,0,0,0.30); transform: translateY(80px); opacity: 0; transition: transform 0.3s ease, opacity 0.3s ease; min-width: 240px; }
        .toast.show { transform: translateY(0); opacity: 1; }
        .toast.error { background: rgba(185,28,28,0.95); }
        .toast svg { width: 17px; height: 17px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; flex-shrink: 0; }
    </style>
</head>
<body>

<div class="dashboard">
    <% request.setAttribute("activePage","users"); %>
    <jsp:include page="/admin/includes/sidebar.jsp"/>

    <main class="main">
        <% request.setAttribute("pageTitle","Manage Users");
           request.setAttribute("pageSubtitle","View and manage all registered users."); %>
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <%
            List<User> users = (List<User>) request.getAttribute("users");
            int userCount = (users != null) ? users.size() : 0;
        %>

        <div class="toolbar" autocomplete="off">
            <!-- Hidden dummy fields to prevent browser autofill on the search box -->
            <input type="text" style="display:none;" aria-hidden="true">
            <input type="password" style="display:none;" aria-hidden="true">
            <div class="search-box">
                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="search" id="searchInput" placeholder="Search by name, email or phone..."
                       oninput="filterTable()" autocomplete="off" autocorrect="off"
                       autocapitalize="off" spellcheck="false" name="search_q">
            </div>
            <select class="filter-select" id="roleFilter" onchange="filterTable()">
                <option value="">All Roles</option>
                <option value="ADMIN">Admin</option>
                <option value="DONOR">Donor</option>
                <option value="RECEIVER">Receiver</option>
                <option value="VOLUNTEER">Volunteer</option>
            </select>
            <select class="filter-select" id="statusFilter" onchange="filterTable()">
                <option value="">All Status</option>
                <option value="ACTIVE">Active</option>
                <option value="PENDING">Pending</option>
                <option value="BLOCKED">Blocked</option>
                <option value="REJECTED">Rejected</option>
            </select>
            <a href="<%= request.getContextPath() %>/admin-create-user"
               style="display:inline-flex;align-items:center;gap:6px;background:#1F7A5C;color:#E8F5F0;padding:9px 16px;border-radius:8px;text-decoration:none;font-size:14px;font-weight:600;white-space:nowrap;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                New User
            </a>
            <span class="toolbar-count" id="rowCount"><%= userCount %> users</span>
        </div>

        <div class="table-card">
            <div class="table-scroll">
                <table class="users-table" id="usersTable">
                    <thead>
                        <tr>
                            <th>User</th><th>Email</th><th>Phone</th><th>Role</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (users != null && !users.isEmpty()) {
                            for (User u : users) {
                                String status = u.getStatus();
                                String statusClass = "ACTIVE".equalsIgnoreCase(status) ? "status-active" :
                                                     "PENDING".equalsIgnoreCase(status) ? "status-pending" :
                                                     "BLOCKED".equalsIgnoreCase(status) ? "status-blocked" : "status-rejected";
                                String role = u.getRole();
                                String roleClass = "ADMIN".equalsIgnoreCase(role) ? "role-admin" :
                                                   "DONOR".equalsIgnoreCase(role) ? "role-donor" :
                                                   "RECEIVER".equalsIgnoreCase(role) ? "role-receiver" : "role-volunteer";
                                String profileImage = u.getProfileImage();
                                boolean hasImage = (profileImage != null && !profileImage.trim().isEmpty());
                                String addr = u.getAddress() != null ? u.getAddress() : "";
                    %>
                    <tr>
                        <td>
                            <div class="user-cell">
                                <% if (hasImage) { %>
                                <img src="<%= request.getContextPath() %>/<%= profileImage %>" alt="<%= u.getFullName() %>" class="profile-img" onerror="this.style.display='none';this.nextElementSibling.style.display='inline-flex';">
                                <div class="profile-placeholder" style="display:none;"><%= u.getFullName().substring(0,1).toUpperCase() %></div>
                                <% } else { %>
                                <div class="profile-placeholder"><%= u.getFullName().substring(0,1).toUpperCase() %></div>
                                <% } %>
                                <div><div class="user-name"><%= u.getFullName() %></div><div class="user-id">#<%= u.getUserId() %></div></div>
                            </div>
                        </td>
                        <td style="color:#6B7280;"><%= u.getEmail() %></td>
                        <td style="color:#6B7280;"><%= u.getPhone() %></td>
                        <td><span class="role-badge <%= roleClass %>"><%= u.getRole() %></span></td>
                        <td><span class="status-badge <%= statusClass %>"><%= u.getStatus() %></span></td>
                        <td class="actions-cell">
                            <div class="actions-inner">
                                <button class="btn-action btn-view"    onclick="openView(<%= u.getUserId() %>,'<%= u.getFullName().replace("'","\\'") %>','<%= u.getEmail() %>','<%= u.getPhone() %>','<%= u.getRole() %>','<%= status %>','<%= addr.replace("'","\\'") %>','<%= hasImage ? request.getContextPath()+"/"+profileImage : "" %>')">
                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>View
                                </button>
                                <button class="btn-action btn-edit"    onclick="openEdit(<%= u.getUserId() %>,'<%= u.getFullName().replace("'","\\'") %>','<%= u.getEmail() %>','<%= u.getPhone() %>','<%= u.getRole() %>','<%= status %>','<%= addr.replace("'","\\'") %>')">
                                    <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>Edit
                                </button>
                                <button class="btn-action btn-success" onclick="openConfirm('approve',<%= u.getUserId() %>,'<%= u.getFullName().replace("'","\\'") %>')">
                                    <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>Approve
                                </button>
                                <button class="btn-action btn-warning" onclick="openConfirm('block',<%= u.getUserId() %>,'<%= u.getFullName().replace("'","\\'") %>')">
                                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>Block
                                </button>
                                <button class="btn-action btn-danger"  onclick="openConfirm('reject',<%= u.getUserId() %>,'<%= u.getFullName().replace("'","\\'") %>')">
                                    <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>Reject
                                </button>
                                <button class="btn-action btn-rose"    onclick="openConfirm('delete',<%= u.getUserId() %>,'<%= u.getFullName().replace("'","\\'") %>')">
                                    <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>Delete
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6"><div class="empty-state"><svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg><p>No users found.</p></div></td></tr>
                    <% } %>
                    <tr class="filler-row"><td colspan="6"></td></tr>
                    </tbody>
                </table>
            </div>
            <!-- Pagination bar -->
            <div class="pagination-bar">
                <span class="pagination-info" id="pgInfo"></span>
                <div class="pagination-btns" id="pgBtns"></div>
            </div>
        </div>
    </main>
</div>

<!-- ══ VIEW MODAL ══ -->
<div class="modal-overlay" id="viewModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-icon blue"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></div>
                <div><div class="modal-title">User Details</div><div class="modal-subtitle" id="viewSubtitle"></div></div>
            </div>
            <button class="modal-close" onclick="closeModal('viewModal')">&times;</button>
        </div>
        <div class="modal-body">
            <div class="info-avatar">
                <img id="viewAvatar" class="info-avatar-img" src="" alt="" style="display:none;">
                <div id="viewAvatarPlaceholder" class="info-avatar-placeholder"></div>
                <div><div class="info-avatar-name" id="viewName"></div><div class="info-avatar-id" id="viewIdLabel"></div></div>
            </div>
            <div class="info-grid">
                <div class="info-item full"><label>Email</label><span id="viewEmail"></span></div>
                <div class="info-item"><label>Phone</label><span id="viewPhone"></span></div>
                <div class="info-item"><label>Role</label><span id="viewRole"></span></div>
                <div class="info-item"><label>Status</label><span id="viewStatus"></span></div>
                <div class="info-item full"><label>Address</label><span id="viewAddress"></span></div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-btn modal-btn-cancel" onclick="closeModal('viewModal')">Close</button>
            <button class="modal-btn modal-btn-teal" id="viewEditBtn">Edit User</button>
        </div>
    </div>
</div>

<!-- ══ EDIT MODAL ══ -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-icon teal"><svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></div>
                <div><div class="modal-title">Edit User</div><div class="modal-subtitle" id="editSubtitle"></div></div>
            </div>
            <button class="modal-close" onclick="closeModal('editModal')">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editUserId">
            <div class="modal-grid-2">
                <div class="modal-form-group"><label>Full Name</label><input type="text" id="editFullName" placeholder="Full name"></div>
                <div class="modal-form-group"><label>Phone</label><input type="text" id="editPhone" placeholder="Phone number"></div>
            </div>
            <div class="modal-form-group"><label>Email</label><input type="email" id="editEmail" placeholder="Email address"></div>
            <div class="modal-form-group"><label>Address</label><input type="text" id="editAddress" placeholder="Address"></div>
            <div class="modal-grid-2">
                <div class="modal-form-group"><label>Role</label>
                    <select id="editRole">
                        <option value="ADMIN">Admin</option><option value="DONOR">Donor</option>
                        <option value="RECEIVER">Receiver</option><option value="VOLUNTEER">Volunteer</option>
                    </select>
                </div>
                <div class="modal-form-group"><label>Status</label>
                    <select id="editStatus">
                        <option value="ACTIVE">Active</option><option value="PENDING">Pending</option>
                        <option value="BLOCKED">Blocked</option><option value="REJECTED">Rejected</option>
                    </select>
                </div>
            </div>
            <div class="modal-form-group" style="margin-top:8px;padding-top:14px;border-top:1px solid rgba(255,255,255,0.10);">
                <label>New Password <span style="font-weight:400;text-transform:none;font-size:11px;color:rgba(200,230,218,0.45);">(leave blank to keep current)</span></label>
                <div style="position:relative;">
                    <input type="password" id="editNewPassword" placeholder="Min. 6 characters" style="padding-right:44px;">
                    <button type="button" onclick="toggleEditPw()" style="position:absolute;right:0;top:0;bottom:0;width:42px;background:none;border:none;cursor:pointer;color:rgba(200,230,218,0.70);display:flex;align-items:center;justify-content:center;" id="editPwToggle">
                        <svg id="editEyeShow" viewBox="0 0 24 24" style="width:18px;height:18px;stroke:rgba(200,230,218,0.70);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;pointer-events:none;">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                        <svg id="editEyeHide" viewBox="0 0 24 24" style="width:18px;height:18px;stroke:rgba(200,230,218,0.70);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;pointer-events:none;display:none;">
                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
                            <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
                            <line x1="1" y1="1" x2="23" y2="23"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-btn modal-btn-cancel" onclick="closeModal('editModal')">Cancel</button>
            <button class="modal-btn modal-btn-teal" onclick="submitEdit()">Save Changes</button>
        </div>
    </div>
</div>

<!-- ══ CONFIRM MODAL ══ -->
<div class="modal-overlay" id="confirmModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-icon" id="confirmIcon"></div>
                <div><div class="modal-title" id="confirmTitle"></div><div class="modal-subtitle" id="confirmSubtitle"></div></div>
            </div>
            <button class="modal-close" onclick="closeModal('confirmModal')">&times;</button>
        </div>
        <div class="modal-body">
            <div class="confirm-body">
                <div class="confirm-icon" id="confirmBodyIcon"></div>
                <div class="confirm-title" id="confirmBodyTitle"></div>
                <div class="confirm-desc" id="confirmBodyDesc"></div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-btn modal-btn-cancel" onclick="closeModal('confirmModal')">Cancel</button>
            <button class="modal-btn" id="confirmActionBtn" onclick="submitConfirm()">Confirm</button>
        </div>
    </div>
</div>

<!-- ══ TOAST ══ -->
<div class="toast" id="toast">
    <svg id="toastIcon" viewBox="0 0 24 24"></svg>
    <span id="toastMsg"></span>
</div>

<script>
    const CTX = '<%= request.getContextPath() %>';
    let currentAction = null;
    let currentUserId = null;

    function toggleEditPw() {
        const input = document.getElementById('editNewPassword');
        const show  = document.getElementById('editEyeShow');
        const hide  = document.getElementById('editEyeHide');
        if (input.type === 'password') {
            input.type = 'text';
            show.style.display = 'none';
            hide.style.display = 'block';
        } else {
            input.type = 'password';
            show.style.display = 'block';
            hide.style.display = 'none';
        }
    }

    /* ── Pagination + Filter ── */
    const ROWS_PER_PAGE = 9;
    let currentPage = 1;
    let filteredRows = [];

    function filterTable() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const role   = document.getElementById('roleFilter').value.toUpperCase();
        const status = document.getElementById('statusFilter').value.toUpperCase();
        const allRows = Array.from(document.querySelectorAll('#usersTable tbody tr:not(.filler-row):not(.empty-state-row)'));

        filteredRows = allRows.filter(row => {
            const text   = row.textContent.toLowerCase();
            const rCell  = row.querySelector('.role-badge')   ? row.querySelector('.role-badge').textContent.trim().toUpperCase()   : '';
            const sCell  = row.querySelector('.status-badge') ? row.querySelector('.status-badge').textContent.trim().toUpperCase() : '';
            return (!search || text.includes(search)) && (!role || rCell.includes(role)) && (!status || sCell.includes(status));
        });

        currentPage = 1;
        renderPage();
    }

    function renderPage() {
        const allRows = Array.from(document.querySelectorAll('#usersTable tbody tr:not(.filler-row):not(.empty-state-row)'));
        // Hide all first
        allRows.forEach(r => r.style.display = 'none');

        const total = filteredRows.length;
        const totalPages = Math.max(1, Math.ceil(total / ROWS_PER_PAGE));
        currentPage = Math.min(currentPage, totalPages);

        const start = (currentPage - 1) * ROWS_PER_PAGE;
        const end   = Math.min(start + ROWS_PER_PAGE, total);

        filteredRows.forEach((row, i) => {
            row.style.display = (i >= start && i < end) ? '' : 'none';
        });

        // Update info
        document.getElementById('rowCount').textContent = total + ' user' + (total !== 1 ? 's' : '');
        document.getElementById('pgInfo').textContent   = total === 0
            ? 'No results'
            : 'Showing ' + (start + 1) + '–' + end + ' of ' + total + ' users  •  Page ' + currentPage + ' of ' + totalPages;

        // Build page buttons
        const btns = document.getElementById('pgBtns');
        btns.innerHTML = '';

        // Prev
        const prev = document.createElement('button');
        prev.className = 'pg-btn';
        prev.innerHTML = '<svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>';
        prev.disabled = currentPage === 1;
        prev.onclick = () => { currentPage--; renderPage(); };
        btns.appendChild(prev);

        // Page numbers
        let pages = [];
        if (totalPages <= 5) {
            for (let i = 1; i <= totalPages; i++) pages.push(i);
        } else {
            pages = [1];
            if (currentPage > 3) pages.push('...');
            for (let i = Math.max(2, currentPage - 1); i <= Math.min(totalPages - 1, currentPage + 1); i++) pages.push(i);
            if (currentPage < totalPages - 2) pages.push('...');
            pages.push(totalPages);
        }

        pages.forEach(p => {
            const btn = document.createElement('button');
            if (p === '...') {
                btn.className = 'pg-btn'; btn.textContent = '…'; btn.disabled = true;
            } else {
                btn.className = 'pg-btn' + (p === currentPage ? ' active' : '');
                btn.textContent = p;
                btn.onclick = () => { currentPage = p; renderPage(); };
            }
            btns.appendChild(btn);
        });

        // Next
        const next = document.createElement('button');
        next.className = 'pg-btn';
        next.innerHTML = '<svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>';
        next.disabled = currentPage === totalPages;
        next.onclick = () => { currentPage++; renderPage(); };
        btns.appendChild(next);
    }

    // Init on load
    document.addEventListener('DOMContentLoaded', () => {
        // Clear search to prevent browser autofill from persisting
        const searchInput = document.getElementById('searchInput');
        searchInput.value = '';
        // Also clear after a short delay — some browsers autofill after DOMContentLoaded
        setTimeout(() => { searchInput.value = ''; filterTable(); }, 100);

        filteredRows = Array.from(document.querySelectorAll('#usersTable tbody tr:not(.filler-row):not(.empty-state-row)'));

        // Auto-apply filter from URL param (e.g. ?filter=PENDING)
        const urlParams = new URLSearchParams(window.location.search);
        const filterParam = urlParams.get('filter');
        if (filterParam) {
            const statusSelect = document.getElementById('statusFilter');
            statusSelect.value = filterParam;
        }

        filterTable();
    });

    /* ── Modal helpers ── */
    function openModal(id)  { document.getElementById(id).classList.add('open');    document.body.style.overflow = 'hidden'; }
    function closeModal(id) { document.getElementById(id).classList.remove('open'); document.body.style.overflow = ''; }

    document.querySelectorAll('.modal-overlay').forEach(o => {
        o.addEventListener('click', e => { if (e.target === o) closeModal(o.id); });
    });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') document.querySelectorAll('.modal-overlay.open').forEach(o => closeModal(o.id)); });

    /* ── Toast ── */
    function showToast(msg, isError) {
        const t = document.getElementById('toast');
        const icon = document.getElementById('toastIcon');
        t.classList.toggle('error', !!isError);
        icon.innerHTML = isError
            ? '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>'
            : '<polyline points="20 6 9 17 4 12"/>';
        document.getElementById('toastMsg').textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 3200);
    }

    /* ── VIEW modal ── */
    function openView(id, name, email, phone, role, status, address, imgSrc) {
        document.getElementById('viewSubtitle').textContent = '#' + id;
        document.getElementById('viewName').textContent     = name;
        document.getElementById('viewIdLabel').textContent  = 'User ID: ' + id;
        document.getElementById('viewEmail').textContent    = email;
        document.getElementById('viewPhone').textContent    = phone;
        document.getElementById('viewRole').textContent     = role;
        document.getElementById('viewStatus').textContent   = status;
        document.getElementById('viewAddress').textContent  = address || '—';
        const img = document.getElementById('viewAvatar');
        const ph  = document.getElementById('viewAvatarPlaceholder');
        ph.textContent = name.charAt(0).toUpperCase();
        if (imgSrc) {
            img.src = imgSrc; img.style.display = 'block'; ph.style.display = 'none';
            img.onerror = () => { img.style.display = 'none'; ph.style.display = 'flex'; };
        } else { img.style.display = 'none'; ph.style.display = 'flex'; }
        document.getElementById('viewEditBtn').onclick = () => { closeModal('viewModal'); openEdit(id, name, email, phone, role, status, address); };
        openModal('viewModal');
    }

    /* ── EDIT modal ── */
    function openEdit(id, name, email, phone, role, status, address) {
        document.getElementById('editSubtitle').textContent = '#' + id;
        document.getElementById('editUserId').value    = id;
        document.getElementById('editFullName').value  = name;
        document.getElementById('editEmail').value     = email;
        document.getElementById('editPhone').value     = phone;
        document.getElementById('editAddress').value   = address || '';
        document.getElementById('editRole').value      = role;
        document.getElementById('editStatus').value    = status;
        document.getElementById('editNewPassword').value = '';
        document.getElementById('editNewPassword').type   = 'password';
        openModal('editModal');
    }

    function submitEdit() {
        const id      = document.getElementById('editUserId').value;
        const payload = new URLSearchParams({
            userId:      id,
            fullName:    document.getElementById('editFullName').value.trim(),
            email:       document.getElementById('editEmail').value.trim(),
            phone:       document.getElementById('editPhone').value.trim(),
            address:     document.getElementById('editAddress').value.trim(),
            role:        document.getElementById('editRole').value,
            status:      document.getElementById('editStatus').value,
            newPassword: document.getElementById('editNewPassword').value
        });
        fetch(CTX + '/update-user', { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: payload })
            .then(r => {
                closeModal('editModal');
                if (r.ok || r.redirected) { showToast('User updated successfully.'); setTimeout(() => location.reload(), 1200); }
                else showToast('Update failed. Please try again.', true);
            })
            .catch(() => { closeModal('editModal'); showToast('Network error.', true); });
    }

    /* ── CONFIRM modal ── */
    const confirmConfig = {
        approve: { title:'Approve User', subtitle:'Grant account access', iconClass:'green', btnClass:'modal-btn-green', btnText:'Approve',
                   bodyIcon:'<polyline points="20 6 9 17 4 12"/>', desc:'This will activate the account and allow the user to log in.' },
        block:   { title:'Block User',   subtitle:'Restrict account access', iconClass:'amber', btnClass:'modal-btn-amber', btnText:'Block',
                   bodyIcon:'<circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>', desc:'The user will be blocked and unable to log in.' },
        reject:  { title:'Reject User',  subtitle:'Decline registration', iconClass:'red', btnClass:'modal-btn-red', btnText:'Reject',
                   bodyIcon:'<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>', desc:'The registration request will be rejected.' },
        delete:  { title:'Delete User',  subtitle:'Permanent action', iconClass:'rose', btnClass:'modal-btn-rose', btnText:'Delete',
                   bodyIcon:'<polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>', desc:'This will permanently remove the user. This cannot be undone.' }
    };

    function openConfirm(action, id, name) {
        currentAction = action; currentUserId = id;
        const cfg = confirmConfig[action];
        document.getElementById('confirmTitle').textContent    = cfg.title;
        document.getElementById('confirmSubtitle').textContent = cfg.subtitle;
        document.getElementById('confirmIcon').className       = 'modal-icon ' + cfg.iconClass;
        document.getElementById('confirmIcon').innerHTML       = '<svg viewBox="0 0 24 24">' + cfg.bodyIcon + '</svg>';
        document.getElementById('confirmBodyIcon').className   = 'confirm-icon ' + cfg.iconClass;
        document.getElementById('confirmBodyIcon').innerHTML   = '<svg viewBox="0 0 24 24">' + cfg.bodyIcon + '</svg>';
        document.getElementById('confirmBodyTitle').textContent = cfg.title + '?';
        document.getElementById('confirmBodyDesc').innerHTML   = cfg.desc + '<br><br>User: <span class="confirm-name">' + name + '</span>';
        const btn = document.getElementById('confirmActionBtn');
        btn.className = 'modal-btn ' + cfg.btnClass;
        btn.textContent = cfg.btnText;
        openModal('confirmModal');
    }

    function submitConfirm() {
        const endpoints = { approve: '/approve-user', block: '/block-user', reject: '/reject-user', delete: '/delete-user' };
        const payload = new URLSearchParams({ userId: currentUserId });
        fetch(CTX + endpoints[currentAction], { method: 'POST', headers: {'Content-Type':'application/x-www-form-urlencoded'}, body: payload })
            .then(r => {
                closeModal('confirmModal');
                if (r.ok || r.redirected) {
                    const msgs = { approve:'User approved.', block:'User blocked.', reject:'User rejected.', delete:'User deleted.' };
                    showToast(msgs[currentAction]);
                    setTimeout(() => location.reload(), 1200);
                } else showToast('Action failed. Please try again.', true);
            })
            .catch(() => { closeModal('confirmModal'); showToast('Network error.', true); });
    }
</script>
</body>
</html>
