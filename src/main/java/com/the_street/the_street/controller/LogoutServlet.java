package com.the_street.the_street.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);

            if (session != null) {
                session.invalidate();
            }

            Cookie rememberCookie = new Cookie("rememberEmail", "");
            rememberCookie.setMaxAge(0);
            rememberCookie.setPath("/");
            response.addCookie(rememberCookie);

            response.sendRedirect("auth/login.jsp");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred during logout process.", e);

            // Even if error happens, still try to redirect user safely
            response.sendRedirect("auth/login.jsp");
        }
    }
}