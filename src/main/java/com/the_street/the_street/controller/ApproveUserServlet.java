package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/approve-user")
public class ApproveUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ApproveUserServlet.class.getName());

    private final UserInterface userInterface = new UserDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !"ADMIN".equals(session.getAttribute("role"))) {
            request.setAttribute("message", "Access denied. Admin privileges required.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
            return;
        }

        try {
            String userIdParam = request.getParameter("userId");

            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Approve user attempt with missing user ID.");
                request.setAttribute("message", "Invalid user ID.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            // Fetch user before performing action
            User user = userInterface.getUserById(userId);

            if (user == null) {
                LOGGER.log(Level.WARNING, "Approve user attempt for non-existent user. User ID: {0}", userId);
                request.setAttribute("message", "User not found.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            // Store previous status
            String previousStatus = user.getStatus();

            // Perform approval
            boolean result = userInterface.approveUser(userId);

            if (result) {
                LOGGER.log(Level.INFO, "User approved successfully. User ID: {0}", userId);
                request.setAttribute("message", "User approved successfully.");
                request.setAttribute("messageType", "success");
                request.setAttribute("user", user);
                request.setAttribute("previousStatus", previousStatus);
                request.setAttribute("newStatus", "ACTIVE");
            } else {
                LOGGER.log(Level.WARNING, "User approval failed. User ID: {0}", userId);
                request.setAttribute("message", "Failed to approve user.");
                request.setAttribute("messageType", "error");
                request.setAttribute("user", user);
            }

            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format while approving user.", e);
            request.setAttribute("message", "Invalid user ID format.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred while approving user.", e);
            request.setAttribute("message", "Something went wrong while approving user.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
        }
    }
}
