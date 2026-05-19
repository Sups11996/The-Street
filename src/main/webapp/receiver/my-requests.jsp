<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    <title>My Requests – Sahayog Sathi</title>
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
        .nav-links a.active { background: rgba(255,255,255,0.2); color: white; }

        .container { max-width: 1100px; margin: 40px auto; padding: 0 24px; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 1.8rem; font-weight: 800; letter-spacing: -0.5px; }
        .page-header p { color: #64748b; margin-top: 6px; font-size: 0.9rem; }

        .alert { padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; font-size: 0.88rem; display: flex; align-items: center; gap: 10px; }
        .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; flex-shrink: 0; }

        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 28px; }
        .stat-card { background: white; border-radius: 12px; padding: 20px 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.06); display: flex; align-items: center; gap: 16px; }
        .stat-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .stat-icon svg { width: 22px; height: 22px; }
        .stat-icon.total  { background: #f1f5f9; } .stat-icon.total svg  { stroke: #475569; }
        .stat-icon.pending { background: #fef9c3; } .stat-icon.pending svg { stroke: #ca8a04; }
        .stat-icon.accepted { background: #dbeafe; } .stat-icon.accepted svg { stroke: #2563eb; }
        .stat-icon.fulfilled { background: #dcfce7; } .stat-icon.fulfilled svg { stroke: #16a34a; }
        .stat-info .number { font-size: 1.7rem; font-weight: 800; line-height: 1; }
        .stat-info .label { font-size: 0.78rem; color: #94a3b8; margin-top: 3px; font-weight: 500; }

        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .btn-new { display: inline-flex; align-items: center; gap: 7px; background: #1a6b4a; color: white; padding: 10px 20px; border-radius: 10px; text-decoration: none; font-weight: 700; font-size: 0.88rem; transition: background 0.2s; }
        .btn-new:hover { background: #145538; }
        .btn-new svg { width: 16px; height: 16px; stroke: white; }

        .table-wrap { background: white; border-radius: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.06), 0 4px 16px rgba(0,0,0,0.04); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #1a6b4a; color: white; padding: 13px 16px; text-align: left; font-size: 0.8rem; font-weight: 600; letter-spacing: 0.3px; text-transform: uppercase; }
        td { padding: 13px 16px; font-size: 0.875rem; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafbfc; }

        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .badge-HIGH     { background: #fee2e2; color: #991b1b; }
        .badge-MEDIUM   { background: #fef3c7; color: #92400e; }
        .badge-LOW      { background: #dcfce7; color: #166534; }
        .status-PENDING   { background: #fef9c3; color: #854d0e; }
        .status-ACCEPTED  { background: #dbeafe; color: #1e40af; }
        .status-FULFILLED { background: #dcfce7; color: #166534; }
        .status-CANCELLED { background: #fee2e2; color: #991b1b; }

        .btn-sm { padding: 5px 12px; border-radius: 7px; font-size: 0.78rem; font-weight: 600; border: none; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; margin: 2px; font-family: inherit; transition: all 0.2s; }
        .btn-sm svg { width: 12px; height: 12px; stroke: currentColor; }
        .btn-edit   { background: #fef3c7; color: #92400e; }
        .btn-edit:hover { background: #fde68a; }
        .btn-cancel { background: #fee2e2; color: #991b1b; }
        .btn-cancel:hover { background: #fecaca; }

        .btn-verify { display: inline-flex; align-items: center; gap: 6px; background: white; color: #1a6b4a; border: 1.5px solid #1a6b4a; border-radius: 7px; padding: 5px 12px; font-size: 0.78rem; font-weight: 600; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .btn-verify:hover { background: #1a6b4a; color: white; }
        .tick-circle { width: 16px; height: 16px; border-radius: 50%; border: 1.5px solid #1a6b4a; display: inline-flex; align-items: center; justify-content: center; font-size: 10px; transition: border-color 0.2s; }
        .btn-verify:hover .tick-circle { border-color: white; }

        .verified-badge { display: inline-flex; align-items: center; gap: 5px; background: #dcfce7; color: #166534; border-radius: 20px; padding: 4px 10px; font-size: 0.75rem; font-weight: 600; }
        .verified-badge svg { width: 12px; height: 12px; stroke: #16a34a; }

        .empty-state { text-align: center; padding: 60px 20px; color: #94a3b8; }
        .empty-icon { width: 60px; height: 60px; background: #f1f5f9; border-radius: 16px; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; }
        .empty-icon svg { width: 28px; height: 28px; stroke: #94a3b8; }
        .empty-state h3 { font-size: 1rem; font-weight: 600; color: #64748b; margin-bottom: 6px; }
        .empty-state p { font-size: 0.88rem; margin-bottom: 20px; }

        /* Modal */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 1000; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .modal { background: white; border-radius: 20px; padding: 40px 36px; max-width: 420px; width: 90%; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.2); animation: popIn 0.25s ease; }
        @keyframes popIn { from { transform: scale(0.85); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .check-circle { width: 76px; height: 76px; border-radius: 50%; background: #dcfce7; border: 3px solid #1a6b4a; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; animation: bounceIn 0.4s ease 0.1s both; }
        .check-circle svg { width: 36px; height: 36px; stroke: #1a6b4a; }
        @keyframes bounceIn { 0% { transform: scale(0); } 60% { transform: scale(1.15); } 100% { transform: scale(1); } }
        .modal h2 { font-size: 1.3rem; font-weight: 800; color: #0f1f14; margin-bottom: 8px; }
        .modal p { color: #64748b; font-size: 0.9rem; line-height: 1.6; margin-bottom: 6px; }
        .modal .item-name { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 16px; margin: 14px 0; font-weight: 700; color: #1a2332; font-size: 0.92rem; }
        .modal-actions { display: flex; gap: 12px; margin-top: 24px; }
        .modal-actions a, .modal-actions button { flex: 1; padding: 12px; border-radius: 10px; font-size: 0.92rem; font-weight: 700; cursor: pointer; border: none; text-decoration: none; text-align: center; font-family: inherit; }
        .btn-modal-confirm { background: #1a6b4a; color: white; display: flex; align-items: center; justify-content: center; gap: 7px; }
        .btn-modal-confirm:hover { background: #145538; }
        .btn-modal-confirm svg { width: 16px; height: 16px; stroke: white; }
        .btn-modal-no { background: #f1f5f9; color: #64748b; }
        .btn-modal-no:hover { background: #e2e8f0; }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="brand"><div class="brand-dot"></div>Sahayog Sathi</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/receiver/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/receiver/my-requests" class="active">My Requests</a>
        <a href="${pageContext.request.contextPath}/auth/logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <h1>My Requests</h1>
        <p>Manage your assistance requests and track their status.</p>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                ${successMessage}
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                ${errorMessage}
        </div>
    </c:if>

    <div class="stats">
        <div class="stat-card">
            <div class="stat-icon total">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="2"/></svg>
            </div>
            <div class="stat-info"><div class="number">${totalRequests}</div><div class="label">Total</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon pending">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            </div>
            <div class="stat-info"><div class="number">${pendingCount}</div><div class="label">Pending</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon accepted">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            </div>
            <div class="stat-info"><div class="number">${acceptedCount}</div><div class="label">Accepted</div></div>
        </div>
        <div class="stat-card">
            <div class="stat-icon fulfilled">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
            </div>
            <div class="stat-info"><div class="number">${fulfilledCount}</div><div class="label">Fulfilled</div></div>
        </div>
    </div>

    <div class="toolbar">
        <div></div>
        <a href="${pageContext.request.contextPath}/receiver/create-request" class="btn-new">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            New Request
        </a>
    </div>

    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty requests}">
                <div class="empty-state">
                    <div class="empty-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="2"/></svg>
                    </div>
                    <h3>No requests yet</h3>
                    <p>You have not submitted any requests yet.</p>
                    <a href="${pageContext.request.contextPath}/receiver/create-request" class="btn-new">
                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        Submit Your First Request
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Quantity</th>
                        <th>Urgency</th>
                        <th>Location</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="req" items="${requests}" varStatus="loop">
                        <tr>
                            <td style="color:#94a3b8; font-weight:600;">${loop.count}</td>
                            <td style="font-weight:600;">${req.title}</td>
                            <td>${req.category}</td>
                            <td>${req.quantity}</td>
                            <td><span class="badge badge-${req.urgency}">${req.urgency}</span></td>
                            <td>${req.location}</td>
                            <td><span class="badge status-${req.status}">${req.status}</span></td>
                            <td style="color:#64748b;"><fmt:formatDate value="${req.createdAt}" pattern="dd MMM yyyy"/></td>
                            <td>
                                <c:if test="${req.status == 'PENDING'}">
                                    <a href="${pageContext.request.contextPath}/receiver/edit-request?request_id=${req.requestId}" class="btn-sm btn-edit">
                                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                        Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/receiver/cancel-request?request_id=${req.requestId}" class="btn-sm btn-cancel" onclick="return confirm('Cancel this request?')">
                                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                        Cancel
                                    </a>
                                </c:if>
                                <c:if test="${req.status == 'ACCEPTED'}">
                                    <button class="btn-verify" onclick="openModal('${req.requestId}', '${req.title}')">
                                        <span class="tick-circle">&#10003;</span>
                                        Mark as Received
                                    </button>
                                </c:if>
                                <c:if test="${req.status == 'FULFILLED'}">
                                    <span class="verified-badge">
                                        <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                                        Received & Verified
                                    </span>
                                </c:if>
                                <c:if test="${req.status == 'CANCELLED'}">
                                    <span style="color:#cbd5e1; font-size:0.8rem;">—</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal -->
<div class="modal-overlay" id="verifyModal">
    <div class="modal">
        <div class="check-circle">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
        </div>
        <h2>Confirm Receipt</h2>
        <p>Are you confirming that you have physically received the goods for:</p>
        <div class="item-name" id="modalItemName"></div>
        <p>This will mark the request as <strong>Fulfilled</strong> and cannot be undone.</p>
        <div class="modal-actions">
            <button class="btn-modal-no" onclick="closeModal()">Not Yet</button>
            <a id="modalConfirmLink" href="#" class="btn-modal-confirm">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                Yes, I Received It
            </a>
        </div>
    </div>
</div>

<script>
    function openModal(requestId, itemName) {
        document.getElementById('modalItemName').textContent = itemName;
        document.getElementById('modalConfirmLink').href =
            '${pageContext.request.contextPath}/receiver/confirm-receipt?request_id=' + requestId;
        document.getElementById('verifyModal').classList.add('active');
    }
    function closeModal() {
        document.getElementById('verifyModal').classList.remove('active');
    }
    document.getElementById('verifyModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>

</body>
</html>