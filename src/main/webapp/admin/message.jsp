<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.the_street.the_street.model.User" %>
<%
    // --- Resolve message and type ---
    String message = (String) request.getAttribute("message");
    String msgType = (String) request.getAttribute("messageType");

    // Get user details if available
    User user = (User) request.getAttribute("user");
    String previousStatus = (String) request.getAttribute("previousStatus");
    String newStatus = (String) request.getAttribute("newStatus");

    // Fallback to session attributes (set before a redirect)
    if (message == null) {
        message = (String) session.getAttribute("successMessage");
        if (message != null) {
            msgType = "success";
            session.removeAttribute("successMessage");
        }
    }
    if (message == null) {
        message = (String) session.getAttribute("errorMessage");
        if (message != null) {
            msgType = "error";
            session.removeAttribute("errorMessage");
        }
    }

    // Final fallback
    if (message == null) {
        message = "Operation completed.";
    }

    // Auto-detect type from message text if not explicitly set
    if (msgType == null) {
        String lower = message.toLowerCase();
        if (lower.contains("error") || lower.contains("fail") || lower.contains("invalid")
                || lower.contains("wrong") || lower.contains("not found") || lower.contains("denied")) {
            msgType = "error";
        } else if (lower.contains("block")) {
            msgType = "warning";
        } else if (lower.contains("delete") || lower.contains("reject")) {
            msgType = "error";
        } else {
            msgType = "success";
        }
    }

    // Normalize "danger" to "error" for standardization
    if ("danger".equals(msgType)) {
        msgType = "error";
    }

    // Determine icon SVG and CSS class
    String icon;
    String cssClass;

    if ("success".equals(msgType)) {
        icon = "<svg viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round' style='width:32px;height:32px;'><polyline points='20 6 9 17 4 12'/></svg>";
        cssClass = "msg-success";
    } else if ("warning".equals(msgType)) {
        icon = "<svg viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round' style='width:32px;height:32px;'><path d='M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z'/><line x1='12' y1='9' x2='12' y2='13'/><line x1='12' y1='17' x2='12.01' y2='17'/></svg>";
        cssClass = "msg-warning";
    } else {
        icon = "<svg viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round' style='width:32px;height:32px;'><line x1='18' y1='6' x2='6' y2='18'/><line x1='6' y1='6' x2='18' y2='18'/></svg>";
        cssClass = "msg-error";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message - Sahayog Sathi</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #F5F7F6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .msg-page {
            width: 100%;
            padding: 20px;
            display: flex;
            justify-content: center;
        }

        .msg-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 40px 36px;
            max-width: 400px;
            width: 100%;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.10);
        }

        /* Icon circle */
        .msg-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 22px;
        }

        /* Success variant - GREEN */
        .msg-success .msg-icon {
            background: #D1FAE5;
            color: #065F46;
        }

        .msg-success .msg-text {
            color: #065F46;
        }

        /* Warning variant - ORANGE */
        .msg-warning .msg-icon {
            background: #FEF3C7;
            color: #92400E;
        }

        .msg-warning .msg-text {
            color: #92400E;
        }

        /* Danger/Error variant - RED */
        .msg-danger .msg-icon,
        .msg-error .msg-icon {
            background: #FEE2E2;
            color: #991B1B;
        }

        .msg-danger .msg-text,
        .msg-error .msg-text {
            color: #991B1B;
        }

        /* Message text */
        .msg-text {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 30px;
            line-height: 1.4;
        }

        /* User details card */
        .user-details {
            background: #F9FAFB;
            border: 1px solid #E5E7EB;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }

        .user-details h3 {
            color: #1F7A5C;
            margin-bottom: 15px;
            font-size: 18px;
            border-bottom: 2px solid #D1FAE5;
            padding-bottom: 8px;
        }

        .user-details table {
            width: 100%;
            border-collapse: collapse;
        }

        .user-details td {
            padding: 8px 0;
            border-bottom: 1px solid #F3F4F6;
        }

        .user-details td:first-child {
            font-weight: bold;
            color: #6B7280;
            width: 40%;
        }

        .user-details td:last-child {
            color: #1E1E1E;
        }

        .user-details tr:last-child td {
            border-bottom: none;
        }

        .status-change {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-badge-small {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active   { background: #D1FAE5; color: #065F46; }
        .status-pending  { background: #FEF3C7; color: #92400E; }
        .status-blocked  { background: #FEE2E2; color: #991B1B; }
        .status-rejected { background: #F3F4F6; color: #374151; }
        .status-deleted  { background: #F3F4F6; color: #374151; }

        /* Button row */
        .msg-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-primary {
            display: inline-block;
            background: #1F7A5C;
            color: #ffffff;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            margin: 4px;
            transition: background 0.2s;
            cursor: pointer;
        }

        .btn-primary:hover {
            background: #145A42;
        }

        /* Dark button — View Users */
        .btn-dark {
            display: inline-block;
            background: #374151;
            color: #ffffff;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            margin: 4px;
            transition: background 0.2s;
            cursor: pointer;
        }

        .btn-dark:hover {
            background: #1F2937;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .msg-card {
                padding: 30px 24px;
            }

            .msg-text {
                font-size: 20px;
            }

            .msg-actions {
                flex-direction: column;
            }

            .btn-primary,
            .btn-dark {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="msg-page">
    <div class="msg-card <%= cssClass %>">

        <!-- Icon -->
        <div class="msg-icon">
            <%= icon %>
        </div>

        <!-- Message text -->
        <p class="msg-text"><%= message %></p>

        <!-- User details (if available) -->
        <% if (user != null) { %>
        <div class="user-details">
            <h3>User Details</h3>
            <table>
                <tr>
                    <td>User ID:</td>
                    <td><%= user.getUserId() %></td>
                </tr>
                <tr>
                    <td>Full Name:</td>
                    <td><%= user.getFullName() %></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><%= user.getEmail() %></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><%= user.getPhone() %></td>
                </tr>
                <tr>
                    <td>Role:</td>
                    <td><%= user.getRole() %></td>
                </tr>
                <% if (previousStatus != null) { %>
                <tr>
                    <td>Previous Status:</td>
                    <td>
                        <span class="status-badge-small status-<%= previousStatus.toLowerCase() %>">
                            <%= previousStatus %>
                        </span>
                    </td>
                </tr>
                <% } %>
                <% if (newStatus != null) { %>
                <tr>
                    <td>New Status:</td>
                    <td>
                        <span class="status-badge-small status-<%= newStatus.toLowerCase() %>">
                            <%= newStatus %>
                        </span>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <% } %>

        <!-- Action buttons -->
        <div class="msg-actions">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn-primary">
                Back to Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/view-users" class="btn-dark">
                Manage Users
            </a>
        </div>

    </div>
</div>

</body>
</html>
