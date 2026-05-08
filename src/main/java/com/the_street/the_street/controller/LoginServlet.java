package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    private final UserInterface userInterface = new UserDAO();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || email.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Email and password are required.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            User user = userInterface.getUserByEmail(email.trim());

            if (user == null) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // Check password
            boolean isValidPassword = PasswordUtils.checkPassword(password, user.getPassword());

            if (!isValidPassword) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // Check account status after password validation
            String status = user.getStatus();
            if (!"ACTIVE".equalsIgnoreCase(status)) {
                String errorMessage;
                if ("BLOCKED".equalsIgnoreCase(status)) {
                    errorMessage = "Your account has been blocked. Please contact admin.";
                } else if ("PENDING".equalsIgnoreCase(status)) {
                    errorMessage = "Your account is pending admin approval.";
                } else if ("REJECTED".equalsIgnoreCase(status)) {
                    errorMessage = "Your account registration has been rejected.";
                } else {
                    errorMessage = "Your account status is " + status + ". Please contact admin.";
                }

                LOGGER.log(Level.WARNING, "Login attempt with non-ACTIVE status. Email: {0}, Status: {1}",
                        new Object[]{email, status});
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // Create session only for ACTIVE users
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());

            session.setMaxInactiveInterval(30 * 60);

            // Set remember-me cookie only if login is successful
            String remember = request.getParameter("rememberMe");

            if (remember != null) {
                Cookie cookie = new Cookie("rememberEmail", user.getEmail());
                cookie.setMaxAge(7 * 24 * 60 * 60);
                cookie.setPath(request.getContextPath());
                response.addCookie(cookie);
            }

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else if ("DONOR".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/donor/dashboard.jsp");
            } else if ("RECEIVER".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/receiver/dashboard.jsp");
            } else if ("VOLUNTEER".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/volunteer/dashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid user role.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Login error", e);

            request.setAttribute("errorMessage", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }
}