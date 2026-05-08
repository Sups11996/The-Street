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

@WebServlet("/update-user")
public class UpdateUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateUserServlet.class.getName());

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
            // Get user ID
            String userIdParam = request.getParameter("userId");

            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Update user attempt with missing user ID.");
                request.setAttribute("message", "Invalid user ID.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            // Get existing user
            User existingUser = userInterface.getUserById(userId);

            if (existingUser == null) {
                LOGGER.log(Level.WARNING, "Update user attempt for non-existent user. User ID: {0}", userId);
                request.setAttribute("message", "User not found.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            // Get form parameters
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String address = request.getParameter("address");
            String status = request.getParameter("status");

            // Validate required fields - prevent empty values
            if (fullName == null || fullName.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Update user attempt with empty full name. User ID: {0}", userId);
                request.setAttribute("message", "Full name cannot be empty.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Update user attempt with empty email. User ID: {0}", userId);
                request.setAttribute("message", "Email cannot be empty.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            if (phone == null || phone.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Update user attempt with empty phone. User ID: {0}", userId);
                request.setAttribute("message", "Phone number cannot be empty.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            // Use existing values for optional fields if empty
            if (role == null || role.trim().isEmpty()) {
                role = existingUser.getRole();
            }

            if (address == null || address.trim().isEmpty()) {
                address = existingUser.getAddress();
            }

            if (status == null || status.trim().isEmpty()) {
                status = existingUser.getStatus();
            }

            // Trim values
            fullName = fullName.trim();
            email = email.trim();
            phone = phone.trim();
            role = role.trim();
            address = address.trim();
            status = status.trim();

            // Check if email already exists for another user
            if (userInterface.isEmailExistsForOtherUser(email, userId)) {
                LOGGER.log(Level.WARNING, "Update user attempt with duplicate email. User ID: {0}, Email: {1}",
                        new Object[]{userId, email});
                request.setAttribute("message", "Update failed: Email already exists.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            // Check if phone already exists for another user
            if (userInterface.isPhoneExistsForOtherUser(phone, userId)) {
                LOGGER.log(Level.WARNING, "Update user attempt with duplicate phone. User ID: {0}, Phone: {1}",
                        new Object[]{userId, phone});
                request.setAttribute("message", "Update failed: Phone number already exists.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
                return;
            }

            // Create updated user object
            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setAddress(address);
            user.setStatus(status);

            // Attempt to update user
            boolean result = userInterface.updateUser(user);

            if (result) {
                LOGGER.log(Level.INFO, "User updated successfully. User ID: {0}", userId);
                request.setAttribute("message", "User updated successfully.");
                request.setAttribute("messageType", "success");
            } else {
                LOGGER.log(Level.WARNING, "User update failed. User ID: {0}", userId);
                request.setAttribute("message", "Update failed. No changes were made.");
                request.setAttribute("messageType", "error");
            }

            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format while updating user.", e);
            request.setAttribute("message", "Invalid user ID format.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred while updating user.", e);
            request.setAttribute("message", "Something went wrong while updating user.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/admin/message.jsp").forward(request, response);
        }
    }
}