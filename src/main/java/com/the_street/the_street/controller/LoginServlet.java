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
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            User user = userInterface.getUserByEmail(email.trim());

            if (user == null) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            boolean isValidPassword = PasswordUtils.checkPassword(password, user.getPassword());

            if (!isValidPassword) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (!"ACTIVE".equals(user.getStatus())) {
                request.setAttribute("errorMessage", "Your account is " + user.getStatus() + ".");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());

            session.setMaxInactiveInterval(30 * 60);

            String remember = request.getParameter("remember");

            if (remember != null) {
                Cookie cookie = new Cookie("rememberEmail", user.getEmail());
                cookie.setMaxAge(7 * 24 * 60 * 60);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin-dashboard.jsp");
            } else if ("DONOR".equals(user.getRole())) {
                response.sendRedirect("donor-dashboard.jsp");
            } else if ("RECEIVER".equals(user.getRole())) {
                response.sendRedirect("receiver-dashboard.jsp");
            } else if ("VOLUNTEER".equals(user.getRole())) {
                response.sendRedirect("volunteer-dashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Invalid user role.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Login error", e);

            request.setAttribute("errorMessage", "Something went wrong. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}