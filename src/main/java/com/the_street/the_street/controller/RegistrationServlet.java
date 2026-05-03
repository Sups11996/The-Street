package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.PasswordUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/register")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class RegistrationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegistrationServlet.class.getName());

    private final UserInterface userInterface = new UserDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");
            String role = request.getParameter("role");
            String address = request.getParameter("address");

            Part filePart = request.getPart("profile_image");
            String savedFilePath = "";

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                String contentType = filePart.getContentType();

                if (!contentType.equals("image/jpeg")
                        && !contentType.equals("image/png")
                        && !contentType.equals("image/jpg")) {

                    request.setAttribute("errorMessage", "Only JPG, JPEG, and PNG files are allowed.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                if (filePart.getSize() > 1024 * 1024 * 5) {
                    request.setAttribute("errorMessage", "File size must be less than 5MB.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }

                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);

                savedFilePath = "uploads/" + uniqueFileName;
            }

            if (fullName == null || fullName.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()
                    || role == null || role.trim().isEmpty()) {

                request.setAttribute("errorMessage", "All required fields must be filled.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            role = role.trim();

            if ("ADMIN".equals(role)) {
                request.setAttribute("errorMessage", "Admin registration is not allowed.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (!role.equals("DONOR") && !role.equals("RECEIVER") && !role.equals("VOLUNTEER")) {
                request.setAttribute("errorMessage", "Invalid role selected.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (!fullName.matches("^[A-Za-z ]+$")) {
                request.setAttribute("errorMessage", "Full name must contain only letters.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                request.setAttribute("errorMessage", "Please enter a valid email address.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (!phone.matches("^[0-9]{10}$")) {
                request.setAttribute("errorMessage", "Phone number must be 10 digits.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (password.length() < 6) {
                request.setAttribute("errorMessage", "Password must be at least 6 characters.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User existingUser = userInterface.getUserByEmail(email.trim());

            if (existingUser != null) {
                request.setAttribute("errorMessage", "Email already exists. Please use another email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User existingPhone = userInterface.getUserByPhone(phone.trim());

            if (existingPhone != null) {
                request.setAttribute("errorMessage", "Phone number already exists. Please use another phone number.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            String hashedPassword = PasswordUtils.hashPassword(password);

            String status;
            if ("RECEIVER".equals(role)) {
                status = "PENDING";
            } else {
                status = "ACTIVE";
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone(phone.trim());
            user.setPassword(hashedPassword);
            user.setRole(role.trim());
            user.setAddress(address == null ? "" : address.trim());
            user.setStatus(status);
            user.setProfileImage(savedFilePath);

            boolean result = userInterface.insertUser(user);

            if (result) {
                request.setAttribute("successMessage", "Registration successful. Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred during user registration.", e);

            request.setAttribute("errorMessage", "Something went wrong during registration. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}