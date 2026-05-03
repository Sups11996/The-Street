package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/update-user")
public class UpdateUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateUserServlet.class.getName());

    private final UserInterface userInterface = new UserDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String userIdParam = request.getParameter("user_id");

            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Invalid user ID.");
                response.sendRedirect("view-users");
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            User existingUser = userInterface.getUserById(userId);

            if (existingUser == null) {
                request.getSession().setAttribute("errorMessage", "User not found.");
                response.sendRedirect("view-users");
                return;
            }

            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String address = request.getParameter("address");
            String status = request.getParameter("status");

            if (fullName == null || fullName.trim().isEmpty()) {
                fullName = existingUser.getFullName();
            }

            if (email == null || email.trim().isEmpty()) {
                email = existingUser.getEmail();
            }

            if (phone == null || phone.trim().isEmpty()) {
                phone = existingUser.getPhone();
            }

            if (role == null || role.trim().isEmpty()) {
                role = existingUser.getRole();
            }

            if (address == null || address.trim().isEmpty()) {
                address = existingUser.getAddress();
            }

            if (status == null || status.trim().isEmpty()) {
                status = existingUser.getStatus();
            }

            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone(phone.trim());
            user.setRole(role.trim());
            user.setAddress(address.trim());
            user.setStatus(status.trim());

            boolean result = userInterface.updateUser(user);

            if (result) {
                request.getSession().setAttribute("successMessage", "User updated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update user.");
            }

            response.sendRedirect("view-users");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format while updating user.", e);
            request.getSession().setAttribute("errorMessage", "Invalid user ID format.");
            response.sendRedirect("view-users");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred while updating user.", e);
            request.getSession().setAttribute("errorMessage", "Something went wrong while updating user.");
            response.sendRedirect("view-users");
        }
    }
}