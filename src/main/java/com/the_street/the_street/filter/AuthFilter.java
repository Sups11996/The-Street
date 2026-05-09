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
        "/admin/*",
        "/donor/*",
        "/receiver/*",
        "/volunteer/*",
        "/view-users",
        "/view-user-by-id",
        "/update-user",
        "/delete-user",
        "/approve-user",
        "/reject-user",
        "/block-user"
})
public class AuthFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(AuthFilter.class.getName());

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        try {
            HttpSession session = req.getSession(false);

            if (session == null || session.getAttribute("loggedInUser") == null) {
                res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }

            // Prevent back button after logout (cache control)
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);

            chain.doFilter(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred in authentication filter.", e);

            // Safe fallback redirect
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
        }
    }
}