<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // If already logged in, go to dashboard
  Object user = session.getAttribute("loggedInUser");
  if (user != null) {
    String role = (String) session.getAttribute("role");
    if ("DONOR".equalsIgnoreCase(role)) {
      response.sendRedirect(request.getContextPath() + "/donor/dashboard");
    }
    return;
  }
  // Otherwise redirect to login
  response.sendRedirect(request.getContextPath() + "/login.jsp");
%>
