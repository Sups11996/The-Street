<%-- Shared admin topbar. Set 'pageTitle' and 'pageSubtitle' before including. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String _fullName = (String) session.getAttribute("fullName");
    String _firstName = "Admin";
    if (_fullName != null && !_fullName.trim().isEmpty())
        _firstName = _fullName.trim().split("\\s+")[0];
    String _title    = (String) request.getAttribute("pageTitle");
    String _subtitle = (String) request.getAttribute("pageSubtitle");
    if (_title    == null) _title    = "Dashboard";
    if (_subtitle == null) _subtitle = "";
%>
<div class="topbar">
    <div>
        <h1 style="font-size:20px;font-weight:700;color:#1F7A5C;"><%= _title %></h1>
        <% if (!_subtitle.isEmpty()) { %>
        <p style="font-size:13px;color:#6B7280;margin-top:2px;"><%= _subtitle %></p>
        <% } %>
    </div>
    <div class="topbar-right">
        <div class="topbar-greeting">
            <span><%= _fullName != null ? _fullName : "Admin" %></span>
            <span>Administrator</span>
        </div>
        <div class="topbar-avatar"><%= _firstName.substring(0,1).toUpperCase() %></div>
    </div>
</div>
