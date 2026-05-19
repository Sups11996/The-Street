<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    com.sahayogsathi.model.User loggedUser =
            (com.sahayogsathi.model.User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"RECEIVER".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Request – Sahayog Sathi</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f0f4f8; color: #1a2332; }
        .navbar { background: #1a6b4a; padding: 0 36px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 12px rgba(26,107,74,0.3); }
        .navbar .brand { font-size: 1.25rem; font-weight: 800; color: white; letter-spacing: -0.3px; display: flex; align-items: center; gap: 10px; }
        .brand-dot { width: 8px; height: 8px; background: #4ade80; border-radius: 50%; }
        .nav-links { display: flex; align-items: center; gap: 4px; }
        .nav-links a { color: rgba(255,255,255,0.85); text-decoration: none; padding: 8px 16px; border-radius: 8px; font-size: 0.88rem; font-weight: 500; transition: all 0.2s; }
        .nav-links a:hover { background: rgba(255,255,255,0.15); color: white; }
        .container { max-width: 680px; margin: 40px auto; padding: 0 20px; }
        .page-header { margin-bottom: 24px; }
        .back-link { display: inline-flex; align-items: center; gap: 6px; color: #64748b; text-decoration: none; font-size: 0.85rem; font-weight: 500; margin-bottom: 16px; transition: color 0.2s; }
        .back-link:hover { color: #1a6b4a; }
        .back-link svg { width: 15px; height: 15px; stroke: currentColor; }
        .page-header h1 { font-size: 1.6rem; font-weight: 800; letter-spacing: -0.4px; }
        .page-header p { color: #64748b; margin-top: 6px; font-size: 0.9rem; }
        .card { background: white; border-radius: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.06), 0 4px 16px rgba(0,0,0,0.04); padding: 36px; }
        .notice { display: flex; align-items: flex-start; gap: 10px; background: #fffbeb; border: 1px solid #fcd34d; border-radius: 10px; padding: 12px 16px; margin-bottom: 24px; font-size: 0.87rem; color: #92400e; }
        .notice svg { width: 16px; height: 16px; stroke: #d97706; flex-shrink: 0; margin-top: 1px; }
        .alert { padding: 12px 16px; border-radius: 10px; margin-bottom: 24px; font-size: 0.88rem; display: flex; align-items: center; gap: 10px; }
        .alert-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; flex-shrink: 0; }
        .form-group { margin-bottom: 22px; }
        label { display: block; font-size: 0.85rem; font-weight: 600; color: #374151; margin-bottom: 7px; }
        .input-wrap { position: relative; }
        .input-wrap svg { position: absolute; left: 13px; top: 50%; transform: translateY(-50%); width: 16px; height: 16px; stroke: #9ca3af; pointer-events: none; }
        input[type="text"], select, textarea { width: 100%; padding: 11px 14px; border: 1.5px solid #e5e7eb; border-radius: 10px; font-size: 0.9rem; font-family: inherit; transition: border-color 0.2s, box-shadow 0.2s; color: #1a2332; }
        .has-icon input[type="text"], .has-icon select { padding-left: 40px; }
        input[type="text"]:focus, select:focus, textarea:focus { outline: none; border-color: #1a6b4a; box-shadow: 0 0 0 3px rgba(26,107,74,0.1); }
        textarea { resize: vertical; min-height: 110px; }
        select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%239ca3af' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 14px center; }
        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .urgency-group { display: flex; gap: 10px; }
        .urgency-option { flex: 1; }
        .urgency-option input[type="radio"] { display: none; }
        .urgency-option label { display: flex; align-items: center; justify-content: center; gap: 7px; padding: 10px; border: 1.5px solid #e5e7eb; border-radius: 10px; cursor: pointer; font-weight: 600; font-size: 0.84rem; transition: all 0.2s; color: #64748b; }
        .urgency-option label svg { width: 14px; height: 14px; }
        .urgency-option.low   input:checked + label { border-color: #16a34a; background: #dcfce7; color: #166534; }
        .urgency-option.medium input:checked + label { border-color: #d97706; background: #fef3c7; color: #92400e; }
        .urgency-option.high  input:checked + label { border-color: #dc2626; background: #fee2e2; color: #991b1b; }
        .divider { border: none; border-top: 1px solid #f1f5f9; margin: 8px 0 24px; }
        .form-actions { display: flex; gap: 12px; }
        .btn-submit { flex: 1; background: #d97706; color: white; padding: 13px; border: none; border-radius: 10px; font-size: 0.95rem; font-weight: 700; cursor: pointer; font-family: inherit; transition: background 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .btn-submit:hover { background: #b45309; }
        .btn-submit svg { width: 17px; height: 17px; stroke: white; }
        .btn-back { background: #f8fafc; color: #374151; padding: 13px 22px; border: 1.5px solid #e5e7eb; border-radius: 10px; text-decoration: none; font-size: 0.9rem; font-weight: 600; display: flex; align-items: center; gap: 7px; transition: all 0.2s; }
        .btn-back:hover { background: #f1f5f9; }
        .btn-back svg { width: 16px; height: 16px; stroke: currentColor; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="brand"><div class="brand-dot"></div>Sahayog Sathi</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/receiver/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/receiver/my-requests">My Requests</a>
        <a href="${pageContext.request.contextPath}/auth/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <a href="${pageContext.request.contextPath}/receiver/my-requests" class="back-link">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
            Back to My Requests
        </a>
        <h1>Edit Request</h1>
        <p>Update your request details below.</p>
    </div>

    <div class="card">
        <div class="notice">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            You can only edit requests that are still <strong>&nbsp;PENDING</strong>.
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/receiver/edit-request" method="post">
            <input type="hidden" name="request_id" value="${existingRequest.requestId}">

            <div class="form-group">
                <label for="title">Item / Need Title</label>
                <div class="input-wrap has-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                    <input type="text" id="title" name="title" value="${existingRequest.title}" maxlength="100" required>
                </div>
            </div>

            <div class="row-2">
                <div class="form-group">
                    <label for="category">Category</label>
                    <div class="input-wrap has-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>
                        <select id="category" name="category" required>
                            <c:forEach var="cat" items="${['FOOD','CLOTHES','ESSENTIALS','OTHER']}">
                                <option value="${cat}" ${existingRequest.category == cat ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="quantity">Quantity</label>
                    <div class="input-wrap has-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                        <input type="text" id="quantity" name="quantity" value="${existingRequest.quantity}" maxlength="50" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Urgency Level</label>
                <div class="urgency-group">
                    <div class="urgency-option low">
                        <input type="radio" id="urgency-LOW" name="urgency" value="LOW" ${existingRequest.urgency == 'LOW' ? 'checked' : ''}>
                        <label for="urgency-LOW">
                            <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" stroke="#16a34a"><polyline points="18 15 12 9 6 15"/></svg>
                            Low
                        </label>
                    </div>
                    <div class="urgency-option medium">
                        <input type="radio" id="urgency-MEDIUM" name="urgency" value="MEDIUM" ${existingRequest.urgency == 'MEDIUM' ? 'checked' : ''}>
                        <label for="urgency-MEDIUM">
                            <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" stroke="#d97706"><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Medium
                        </label>
                    </div>
                    <div class="urgency-option high">
                        <input type="radio" id="urgency-HIGH" name="urgency" value="HIGH" ${existingRequest.urgency == 'HIGH' ? 'checked' : ''}>
                        <label for="urgency-HIGH">
                            <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" stroke="#dc2626"><polyline points="6 9 12 15 18 9"/></svg>
                            High
                        </label>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label for="location">Delivery Location</label>
                <div class="input-wrap has-icon">
                    <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    <input type="text" id="location" name="location" value="${existingRequest.location}" maxlength="255" required>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description">${existingRequest.description}</textarea>
            </div>

            <hr class="divider">

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/receiver/my-requests" class="btn-back">
                    <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                    Back
                </a>
                <button type="submit" class="btn-submit">
                    <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13"/><polyline points="7 3 7 8 15 8"/></svg>
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>