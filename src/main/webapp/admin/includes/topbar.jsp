<%-- Shared admin topbar. Set 'pageTitle' and 'pageSubtitle' before including. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.the_street.the_street.model.User" %>
<%
    String _fullName = (String) session.getAttribute("fullName");
    String _firstName = "Admin";
    if (_fullName != null && !_fullName.trim().isEmpty())
        _firstName = _fullName.trim().split("\\s+")[0];

    // Build initials: first letter of first + last name
    String _initials = "A";
    if (_fullName != null && !_fullName.trim().isEmpty()) {
        String[] _parts = _fullName.trim().split("\\s+");
        if (_parts.length >= 2) {
            _initials = String.valueOf(_parts[0].charAt(0)).toUpperCase()
                      + String.valueOf(_parts[_parts.length - 1].charAt(0)).toUpperCase();
        } else {
            _initials = String.valueOf(_parts[0].charAt(0)).toUpperCase();
        }
    }

    // Get profile image from logged-in user object in session
    User _loggedInUser = (User) session.getAttribute("loggedInUser");
    String _profileImage = (_loggedInUser != null && _loggedInUser.getProfileImage() != null
                            && !_loggedInUser.getProfileImage().isEmpty())
                           ? _loggedInUser.getProfileImage() : null;

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
            <a href="<%= request.getContextPath() %>/admin-profile"
               style="font-size:14px;font-weight:600;color:#1E1E1E;text-decoration:none;"
               title="Profile Settings">
                <%= _fullName != null ? _fullName : "Admin" %>
            </a>
            <span>Administrator</span>
        </div>
        <a href="<%= request.getContextPath() %>/admin-profile"
           class="topbar-avatar"
           title="Profile Settings"
           style="overflow:hidden;padding:0;">
            <% if (_profileImage != null) { %>
            <img src="<%= request.getContextPath() %>/<%= _profileImage %>"
                 alt="Profile"
                 style="width:100%;height:100%;object-fit:cover;border-radius:50%;"
                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
            <span style="display:none;width:100%;height:100%;align-items:center;justify-content:center;font-weight:700;font-size:15px;"><%= _initials %></span>
            <% } else { %>
            <%= _initials %>
            <% } %>
        </a>
    </div>
</div>
