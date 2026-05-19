<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check if user is already logged in
    if (session.getAttribute("role") != null) {

        String role = (String) session.getAttribute("role");

        // Redirect based on role
        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");

        } else if ("DONOR".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/donor/dashboard.jsp");

        } else if ("RECEIVER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/receiver/dashboard.jsp");

        } else if ("VOLUNTEER".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/volunteer/dashboard.jsp");

        } else {
            // Unknown role → go to login
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        }

    } else {
        // Not logged in → go to login page
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    }
%>