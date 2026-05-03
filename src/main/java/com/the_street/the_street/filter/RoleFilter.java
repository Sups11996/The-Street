package com.the_street.the_street.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebFilter({
        "/view-users",
        "/view-user-by-id",
        "/update-user",
        "/delete-user",
        "/approve-user",
        "/reject-user",
        "/block-user",
        "/admin/*"
})
public class RoleFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(RoleFilter.class.getName());

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        try {
            HttpSession session = req.getSession(false);

            if (session == null || session.getAttribute("role") == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
                return;
            }

            chain.doFilter(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred in role-based authorization filter.", e);

            // Safe fallback
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}