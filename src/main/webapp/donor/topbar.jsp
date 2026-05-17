<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/17/2026
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%
    String _pageTitle    = (request.getAttribute("pageTitle")    != null) ? (String) request.getAttribute("pageTitle")    : "Dashboard";
    String _pageSubtitle = (request.getAttribute("pageSubtitle") != null) ? (String) request.getAttribute("pageSubtitle") : "";
%>

<style>
    .page-header {
        background: #fff;
        border-bottom: 1px solid #e5e7eb;
        padding: 18px 30px 14px;
        font-family: Arial, sans-serif;
    }
    .page-header h1 {
        font-size: 1.3rem;
        font-weight: 700;
        color: #1E1E1E;
        margin: 0 0 3px;
    }
    .page-header p {
        font-size: 0.82rem;
        color: #6B7280;
        margin: 0;
    }
</style>

<div class="page-header">
    <h1><%= _pageTitle %></h1>
    <% if (!_pageSubtitle.isEmpty()) { %>
    <p><%= _pageSubtitle %></p>
    <% } %>
</div>
