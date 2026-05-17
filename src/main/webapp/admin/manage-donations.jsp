<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("activePage", "donations");
    request.setAttribute("pageTitle", "Manage Donations");
    request.setAttribute("pageSubtitle", "View and manage all donation posts.");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Donations – Sahayog Sathi</title>
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
        .data-table { width: 100%; border-collapse: collapse; table-layout: fixed; flex: 1; }
        .data-table tbody tr.filler-row { height: 100%; }
        .filler-row td { border-bottom: none !important; background: transparent; }

        .pagination-bar { display: flex; align-items: center; justify-content: space-between; padding: 12px 20px; border-top: 1px solid #F3F4F6; background: #FFFFFF; flex-shrink: 0; border-radius: 0 0 14px 14px; }
        .pagination-info { font-size: 13px; color: #6B7280; }
        .pagination-btns { display: flex; align-items: center; gap: 4px; }
        .pg-btn { min-width: 32px; height: 32px; padding: 0 8px; border: 1.5px solid #E5E7EB; background: #fff; border-radius: 7px; font-size: 13px; font-weight: 600; color: #374151; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
        .pg-btn:hover:not(:disabled) { border-color: #1F7A5C; color: #1F7A5C; background: #F0FAF6; }
        .pg-btn.active { background: #1F7A5C; border-color: #1F7A5C; color: #fff; }
        .pg-btn:disabled { opacity: 0.35; cursor: not-allowed; }
        .pg-btn svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }

        .toolbar { background: #FFFFFF; border-radius: 12px; padding: 16px 20px; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); flex-wrap: wrap; flex-shrink: 0; }
        .search-box { display: flex; align-items: center; gap: 8px; flex: 1; min-width: 200px; background: #F9FAFB; border: 1.5px solid #E5E7EB; border-radius: 8px; padding: 9px 14px; }
        .search-box:focus-within { border-color: #1F7A5C; box-shadow: 0 0 0 3px rgba(31,122,92,0.10); }
        .search-box svg { width: 16px; height: 16px; stroke: #6B7280; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; flex-shrink: 0; }
        .search-box input { border: none; background: none; outline: none; box-shadow: none; font-size: 14px; color: #1E1E1E; width: 100%; padding: 0; margin: 0; border-radius: 4px; }
        .search-box input::placeholder { color: #9CA3AF; }
        .filter-select { padding: 9px 14px; border: 1.5px solid #E5E7EB; border-radius: 8px; font-size: 14px; color: #1E1E1E; background: #F9FAFB; cursor: pointer; margin: 0; width: auto; min-width: 140px; }
        .filter-select:focus { outline: none; border-color: #1F7A5C; }
        .toolbar-count { font-size: 13px; color: #6B7280; white-space: nowrap; }

        .data-table thead tr { background: #F9FAFB; border-bottom: 2px solid #E5E7EB; }
        .data-table th { background: #F9FAFB; color: #6B7280; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; white-space: nowrap; padding: 13px 16px; text-align: left; vertical-align: middle; }
        .data-table td { border-bottom: 1px solid #F3F4F6; font-size: 14px; color: #1E1E1E; padding: 13px 16px; text-align: left; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr { transition: background 0.12s; }
        .data-table tbody tr:hover { background: #F0FAF6; }

        /* Column widths */
        .data-table th:nth-child(1) { width: 5%; }
        .data-table th:nth-child(2) { width: 18%; }
        .data-table th:nth-child(3) { width: 10%; }
        .data-table th:nth-child(4) { width: 8%; }
        .data-table th:nth-child(5) { width: 14%; }
        .data-table th:nth-child(6) { width: 10%; }
        .data-table th:nth-child(7) { width: 10%; }
        .data-table th:nth-child(8) { width: 12%; }
        .data-table th:nth-child(9) { width: 13%; }

        .donor-cell { display: flex; align-items: center; gap: 10px; }
        .donor-avatar { width: 34px; height: 34px; border-radius: 50%; background: #1F7A5C; color: #E8F5F0; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 13px; flex-shrink: 0; }

        .category-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .cat-food       { background: #FEF3C7; color: #92400E; }
        .cat-clothes    { background: #DBEAFE; color: #1E40AF; }
        .cat-essentials { background: #D1FAE5; color: #065F46; }
        .cat-other      { background: #F3F4F6; color: #374151; }

        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .status-badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; flex-shrink: 0; }
        .status-available  { background: #D1FAE5; color: #065F46; } .status-available::before  { background: #059669; }
        .status-accepted   { background: #DBEAFE; color: #1E40AF; } .status-accepted::before   { background: #2563EB; }
        .status-picked_up  { background: #FEF3C7; color: #92400E; } .status-picked_up::before  { background: #D97706; }
        .status-delivered  { background: #EDE9FE; color: #5B21B6; } .status-delivered::before  { background: #7C3AED; }
        .status-cancelled  { background: #FEE2E2; color: #991B1B; } .status-cancelled::before  { background: #DC2626; }

        .btn-action { display: inline-flex; align-items: center; gap: 4px; padding: 6px 10px; font-size: 12px; font-weight: 600; border-radius: 6px; text-decoration: none; color: #E8F5F0; border: none; cursor: pointer; transition: opacity 0.15s; white-space: nowrap; }
        .btn-action:hover { opacity: 0.85; }
        .btn-action svg { width: 11px; height: 11px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }
        .btn-view  { background: #2563EB; }
        .btn-danger { background: #DC2626; }
        .data-table td:last-child { white-space: nowrap; }

        .empty-state { text-align: center; padding: 60px 20px; color: #6B7280; }
        .empty-state svg { width: 48px; height: 48px; stroke: #D1D5DB; fill: none; stroke-width: 1.5; margin-bottom: 16px; display: block; margin-left: auto; margin-right: auto; }

        /* Toast */
        .toast { position: fixed; bottom: 28px; right: 28px; z-index: 2000; background: rgba(20,90,66,0.95); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.15); border-radius: 12px; padding: 13px 18px; display: flex; align-items: center; gap: 10px; color: #E8F5F0; font-size: 14px; font-weight: 500; box-shadow: 0 8px 30px rgba(0,0,0,0.30); transform: translateY(80px); opacity: 0; transition: transform 0.3s ease, opacity 0.3s ease; min-width: 240px; }
        .toast.show { transform: translateY(0); opacity: 1; }
        .toast.error { background: rgba(185,28,28,0.95); }
        .toast svg { width: 17px; height: 17px; stroke: currentColor; fill: none; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; flex-shrink: 0; }

        /* Confirm Modal */
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 1000; background: rgba(0,0,0,0.55); backdrop-filter: blur(5px); align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal { background: rgba(15,40,30,0.80); backdrop-filter: blur(24px); border: 1px solid rgba(255,255,255,0.18); border-radius: 20px; box-shadow: 0 24px 64px rgba(0,0,0,0.50); width: 100%; max-width: 420px; animation: modalIn 0.2s ease; }
        @keyframes modalIn { from { opacity:0; transform:scale(0.95) translateY(12px); } to { opacity:1; transform:scale(1) translateY(0); } }
        .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px 16px; border-bottom: 1px solid rgba(255,255,255,0.12); }
        .modal-title { font-size: 16px; font-weight: 700; color: #E8F5F0; }
        .modal-close { background: none; border: none; cursor: pointer; font-size: 22px; color: #fff; width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border-radius: 8px; transition: background 0.15s; margin-top: -24px; margin-right: -16px; }
        .modal-close:hover { background: rgba(255,255,255,0.15); }
        .modal-body { padding: 20px 24px; text-align: center; }
        .modal-icon { width: 60px; height: 60px; border-radius: 50%; background: rgba(220,38,38,0.22); color: #FCA5A5; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; }
        .modal-icon svg { width: 26px; height: 26px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
        .modal-confirm-title { font-size: 17px; font-weight: 700; color: #E8F5F0; margin-bottom: 8px; }
        .modal-confirm-desc { font-size: 14px; color: rgba(220,245,235,0.65); line-height: 1.6; }
        .modal-footer { padding: 14px 24px 20px; display: flex; gap: 10px; justify-content: flex-end; border-top: 1px solid rgba(255,255,255,0.10); }
        .modal-btn { padding: 10px 22px; border-radius: 9px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; transition: opacity 0.15s; }
        .modal-btn-cancel { background: rgba(255,255,255,0.12); color: rgba(220,245,235,0.80); }
        .modal-btn-danger  { background: #DC2626; color: #E8F5F0; }
    </style>
</head>
<body>
<div class="dashboard">
    <% request.setAttribute("activePage","donations"); %>
    <jsp:include page="/admin/includes/sidebar.jsp"/>

    <main class="main">
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <div class="toolbar">
            <div class="search-box">
                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="search" id="searchInput" placeholder="Search by title, donor or location..." oninput="filterTable()" autocomplete="off">
            </div>
            <select class="filter-select" id="categoryFilter" onchange="filterTable()">
                <option value="">All Categories</option>
                <option value="FOOD">Food</option>
                <option value="CLOTHES">Clothes</option>
                <option value="ESSENTIALS">Essentials</option>
                <option value="OTHER">Other</option>
            </select>
            <select class="filter-select" id="statusFilter" onchange="filterTable()">
                <option value="">All Status</option>
                <option value="AVAILABLE">Available</option>
                <option value="ACCEPTED">Accepted</option>
                <option value="PICKED_UP">Picked Up</option>
                <option value="DELIVERED">Delivered</option>
                <option value="CANCELLED">Cancelled</option>
            </select>
            <span class="toolbar-count" id="rowCount">0 donations</span>
        </div>

        <div class="table-card">
            <div class="table-scroll">
                <table class="data-table" id="donationsTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Donor</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Location</th>
                            <th>Quantity</th>
                            <th>Status</th>
                            <th>Posted</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="donationsBody">
                        <!-- Placeholder rows — replace with real data when backend is ready -->
                        <tr>
                            <td>1</td>
                            <td><div class="donor-cell"><div class="donor-avatar">R</div><div><div style="font-weight:600;">Ram Bahadur</div><div style="font-size:12px;color:#9CA3AF;">ram@donor.com</div></div></div></td>
                            <td>Winter Clothes Bundle</td>
                            <td><span class="category-badge cat-clothes">Clothes</span></td>
                            <td style="color:#6B7280;">Kathmandu, Baneshwor</td>
                            <td style="color:#6B7280;">2 bags</td>
                            <td><span class="status-badge status-available">Available</span></td>
                            <td style="color:#6B7280;">May 10, 2026</td>
                            <td>
                                <button class="btn-action btn-view" onclick="viewDonation(1)">
                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>View
                                </button>
                                <button class="btn-action btn-danger" onclick="confirmDelete('donation', 1, 'Winter Clothes Bundle')" style="margin-left:4px;">
                                    <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>Delete
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><div class="donor-cell"><div class="donor-avatar">S</div><div><div style="font-weight:600;">Sita Kumari</div><div style="font-size:12px;color:#9CA3AF;">sita@donor.com</div></div></div></td>
                            <td>Rice and Dal (10kg)</td>
                            <td><span class="category-badge cat-food">Food</span></td>
                            <td style="color:#6B7280;">Lalitpur, Patan</td>
                            <td style="color:#6B7280;">10 kg</td>
                            <td><span class="status-badge status-accepted">Accepted</span></td>
                            <td style="color:#6B7280;">May 12, 2026</td>
                            <td>
                                <button class="btn-action btn-view" onclick="viewDonation(2)">
                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>View
                                </button>
                                <button class="btn-action btn-danger" onclick="confirmDelete('donation', 2, 'Rice and Dal (10kg)')" style="margin-left:4px;">
                                    <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>Delete
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td><div class="donor-cell"><div class="donor-avatar">A</div><div><div style="font-weight:600;">Anil Tamang</div><div style="font-size:12px;color:#9CA3AF;">anil@donor.com</div></div></div></td>
                            <td>Blankets and Bedsheets</td>
                            <td><span class="category-badge cat-essentials">Essentials</span></td>
                            <td style="color:#6B7280;">Bhaktapur</td>
                            <td style="color:#6B7280;">5 pieces</td>
                            <td><span class="status-badge status-delivered">Delivered</span></td>
                            <td style="color:#6B7280;">May 8, 2026</td>
                            <td>
                                <button class="btn-action btn-view" onclick="viewDonation(3)">
                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>View
                                </button>
                                <button class="btn-action btn-danger" onclick="confirmDelete('donation', 3, 'Blankets and Bedsheets')" style="margin-left:4px;">
                                    <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>Delete
                                </button>
                            </td>
                        </tr>
                        <tr class="filler-row"><td colspan="9"></td></tr>
                    </tbody>
                </table>
            </div>
            <div class="pagination-bar">
                <span class="pagination-info" id="pgInfo"></span>
                <div class="pagination-btns" id="pgBtns"></div>
            </div>
        </div>
    </main>
</div>

<!-- Delete Confirm Modal -->
<div class="modal-overlay" id="deleteModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-title">Delete Post</div>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="modal-icon"><svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg></div>
            <div class="modal-confirm-title">Delete this donation?</div>
            <div class="modal-confirm-desc" id="deleteDesc"></div>
        </div>
        <div class="modal-footer">
            <button class="modal-btn modal-btn-cancel" onclick="closeModal()">Cancel</button>
            <button class="modal-btn modal-btn-danger" id="confirmDeleteBtn">Delete</button>
        </div>
    </div>
</div>

<div class="toast" id="toast">
    <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
    <span id="toastMsg"></span>
</div>

<script>
    const ROWS_PER_PAGE = 9;
    let currentPage = 1;
    let filteredRows = [];

    function filterTable() {
        const search   = document.getElementById('searchInput').value.toLowerCase();
        const category = document.getElementById('categoryFilter').value.toUpperCase();
        const status   = document.getElementById('statusFilter').value.toUpperCase();
        const allRows  = Array.from(document.querySelectorAll('#donationsTable tbody tr:not(.filler-row)'));

        filteredRows = allRows.filter(row => {
            const text  = row.textContent.toLowerCase();
            const cCell = row.querySelector('.category-badge') ? row.querySelector('.category-badge').textContent.trim().toUpperCase() : '';
            const sCell = row.querySelector('.status-badge')   ? row.querySelector('.status-badge').textContent.trim().toUpperCase()   : '';
            return (!search || text.includes(search)) && (!category || cCell.includes(category)) && (!status || sCell.includes(status));
        });
        currentPage = 1;
        renderPage();
    }

    function renderPage() {
        const allRows   = Array.from(document.querySelectorAll('#donationsTable tbody tr:not(.filler-row)'));
        allRows.forEach(r => r.style.display = 'none');
        const total      = filteredRows.length;
        const totalPages = Math.max(1, Math.ceil(total / ROWS_PER_PAGE));
        currentPage      = Math.min(currentPage, totalPages);
        const start = (currentPage - 1) * ROWS_PER_PAGE;
        const end   = Math.min(start + ROWS_PER_PAGE, total);
        filteredRows.forEach((row, i) => { row.style.display = (i >= start && i < end) ? '' : 'none'; });

        document.getElementById('rowCount').textContent = total + ' donation' + (total !== 1 ? 's' : '');
        document.getElementById('pgInfo').textContent   = total === 0 ? 'No results' :
            'Showing ' + (start + 1) + '–' + end + ' of ' + total + '  •  Page ' + currentPage + ' of ' + totalPages;

        const btns = document.getElementById('pgBtns');
        btns.innerHTML = '';
        const prev = document.createElement('button');
        prev.className = 'pg-btn'; prev.innerHTML = '<svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>';
        prev.disabled = currentPage === 1; prev.onclick = () => { currentPage--; renderPage(); };
        btns.appendChild(prev);

        let pages = totalPages <= 5 ? Array.from({length: totalPages}, (_, i) => i + 1) : [1];
        if (totalPages > 5) {
            if (currentPage > 3) pages.push('...');
            for (let i = Math.max(2, currentPage - 1); i <= Math.min(totalPages - 1, currentPage + 1); i++) pages.push(i);
            if (currentPage < totalPages - 2) pages.push('...');
            pages.push(totalPages);
        }
        pages.forEach(p => {
            const btn = document.createElement('button');
            btn.className = 'pg-btn' + (p === currentPage ? ' active' : '');
            btn.textContent = p === '...' ? '…' : p;
            btn.disabled = p === '...';
            if (p !== '...') btn.onclick = () => { currentPage = p; renderPage(); };
            btns.appendChild(btn);
        });

        const next = document.createElement('button');
        next.className = 'pg-btn'; next.innerHTML = '<svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>';
        next.disabled = currentPage === totalPages; next.onclick = () => { currentPage++; renderPage(); };
        btns.appendChild(next);
    }

    function viewDonation(id) {
        showToast('View details — backend coming soon.');
    }

    function confirmDelete(type, id, title) {
        document.getElementById('deleteDesc').innerHTML = 'This will permanently remove <strong style="color:#A7F3D0;">' + title + '</strong>. This cannot be undone.';
        document.getElementById('confirmDeleteBtn').onclick = () => {
            closeModal();
            showToast('Delete — backend coming soon.');
        };
        document.getElementById('deleteModal').classList.add('open');
    }

    function closeModal() { document.getElementById('deleteModal').classList.remove('open'); }
    document.getElementById('deleteModal').addEventListener('click', e => { if (e.target.id === 'deleteModal') closeModal(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

    function showToast(msg, isError) {
        const t = document.getElementById('toast');
        t.classList.toggle('error', !!isError);
        document.getElementById('toastMsg').textContent = msg;
        t.classList.add('show');
        setTimeout(() => t.classList.remove('show'), 3000);
    }

    document.addEventListener('DOMContentLoaded', () => {
        filteredRows = Array.from(document.querySelectorAll('#donationsTable tbody tr:not(.filler-row)'));
        renderPage();
    });
</script>
</body>
</html>
