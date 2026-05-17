package com.the_street.the_street.controller.auth;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.FileUploadUtils;
import com.the_street.the_street.utils.PasswordUtils;
import com.the_street.the_street.utils.UserValidationUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/register")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class RegistrationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegistrationServlet.class.getName());
    private final UserInterface userInterface = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String fullName       = req.getParameter("fullName");
            String email          = req.getParameter("email");
            String phone          = req.getParameter("phone");
            String password       = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String role           = req.getParameter("role");
            String address        = req.getParameter("address");

            // File upload
            String savedFilePath = "";
            try {
                Part filePart = req.getPart("profileImage");
                savedFilePath = FileUploadUtils.saveProfileImage(filePart, getServletContext());
            } catch (IllegalArgumentException e) {
                req.setAttribute("errorMessage", e.getMessage());
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }

            // Field validation
            String validationError = UserValidationUtils.validateUserFields(
                    fullName, email, phone, password, confirmPassword);
            if (validationError != null) {
                req.setAttribute("errorMessage", validationError);
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }

            role = role == null ? "" : role.trim();
            if ("ADMIN".equals(role)) {
                req.setAttribute("errorMessage", "Admin registration is not allowed.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }
            if (!role.equals("DONOR") && !role.equals("RECEIVER") && !role.equals("VOLUNTEER")) {
                req.setAttribute("errorMessage", "Invalid role selected.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }

            if (userInterface.getUserByEmail(email.trim()) != null) {
                req.setAttribute("errorMessage", "Email already exists. Please use another email.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }
            if (userInterface.getUserByPhone(phone.trim()) != null) {
                req.setAttribute("errorMessage", "Phone number already exists. Please use another phone number.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
                return;
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone(phone.trim());
            user.setPassword(PasswordUtils.hashPassword(password));
            user.setRole(role);
            user.setAddress(address == null ? "" : address.trim());
            user.setStatus("RECEIVER".equals(role) ? "PENDING" : "ACTIVE");
            user.setProfileImage(savedFilePath);

            if (userInterface.insertUser(user)) {
                req.setAttribute("successMessage", "Registration successful. Please login.");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, res);
            } else {
                req.setAttribute("errorMessage", "Registration failed. Please try again.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during registration.", e);
            req.setAttribute("errorMessage", "Something went wrong. Please try again.");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, res);
        }
    }
}
