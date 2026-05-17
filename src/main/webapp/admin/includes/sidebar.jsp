<%-- Shared admin sidebar. Set 'activePage' attribute before including:
     request.setAttribute("activePage", "dashboard") or "users"
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "";
%>
<aside class="sidebar">
    <div style="margin-bottom:36px;"><h2>Sahayog Sathi</h2><p>Admin Panel</p></div>
    <nav>
        <a class="<%= "dashboard".equals(activePage) ? "active" : "" %>"
           href="<%= request.getContextPath() %>/admin/dashboard.jsp">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
                <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
            </svg>
            Dashboard
        </a>
        <a class="<%= "users".equals(activePage) ? "active" : "" %>"
           href="<%= request.getContextPath() %>/view-users">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
            Manage Users
        </a>
        <a class="<%= "donations".equals(activePage) ? "active" : "" %>"
           href="<%= request.getContextPath() %>/admin/manage-donations.jsp">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
            Manage Donations
        </a>
        <a class="<%= "requests".equals(activePage) ? "active" : "" %>"
           href="<%= request.getContextPath() %>/admin/manage-requests.jsp">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 11l3 3L22 4"/>
                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
            </svg>
            Manage Requests
        </a>
        <a class="<%= "profile".equals(activePage) ? "active" : "" %>"
           href="<%= request.getContextPath() %>/admin-profile">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
            </svg>
            Profile Settings
        </a>
    </nav>
    <div style="margin-top:auto;padding-top:20px;border-top:1px solid rgba(255,255,255,0.12);">
        <a href="<%= request.getContextPath() %>/logout" style="color:rgba(255,255,255,0.65);">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
            </svg>
            Logout
        </a>
    </div>
</aside>
