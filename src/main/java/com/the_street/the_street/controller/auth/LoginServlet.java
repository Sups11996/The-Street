package com.the_street.the_street.controller.auth;

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
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String email    = req.getParameter("email");
            String password = req.getParameter("password");

            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Email and password are required.");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
                return;
            }

            User user = userInterface.getUserByEmail(email.trim());
            if (user == null || !PasswordUtils.checkPassword(password, user.getPassword())) {
                req.setAttribute("errorMessage", "Invalid email or password.");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
                return;
            }

            String status = user.getStatus();
            if (!"ACTIVE".equalsIgnoreCase(status)) {
                String msg = switch (status.toUpperCase()) {
                    case "BLOCKED"  -> "Your account has been blocked. Please contact admin.";
                    case "PENDING"  -> "Your account is pending admin approval.";
                    case "REJECTED" -> "Your account registration has been rejected.";
                    default         -> "Your account status is " + status + ". Please contact admin.";
                };
                LOGGER.log(Level.WARNING, "Login blocked. Email: {0}, Status: {1}", new Object[]{email, status});
                req.setAttribute("errorMessage", msg);
                req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
                return;
            }

            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId",   user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role",     user.getRole());
            session.setMaxInactiveInterval(30 * 60);

            if (req.getParameter("rememberMe") != null) {
                Cookie cookie = new Cookie("rememberEmail", user.getEmail());
                cookie.setMaxAge(7 * 24 * 60 * 60);
                cookie.setPath(req.getContextPath());
                res.addCookie(cookie);
            }

            String dest = switch (user.getRole().toUpperCase()) {
                case "ADMIN"     -> "/admin/dashboard.jsp";
                case "DONOR"     -> "/donor/dashboard.jsp";
                case "RECEIVER"  -> "/receiver/dashboard.jsp";
                case "VOLUNTEER" -> "/volunteer/dashboard.jsp";
                default          -> null;
            };

            if (dest != null) {
                res.sendRedirect(req.getContextPath() + dest);
            } else {
                req.setAttribute("errorMessage", "Invalid user role.");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Login error.", e);
            req.setAttribute("errorMessage", "Something went wrong. Please try again.");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
        }
    }
}
