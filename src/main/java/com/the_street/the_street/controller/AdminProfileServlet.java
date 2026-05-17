package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.FileUploadUtils;
import com.the_street.the_street.utils.PasswordUtils;
import com.the_street.the_street.utils.ServletUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin-profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class AdminProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminProfileServlet.class.getName());
    private final UserInterface userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!ServletUtils.requireAdmin(req, res)) return;

        // Prevent caching so topbar always shows fresh profile image
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            ServletUtils.forwardMessage(req, res, "Session expired. Please log in again.", "error");
            return;
        }

        User user = userDAO.getUserById(userId);
        if (user == null) {
            ServletUtils.forwardMessage(req, res, "Could not load profile. User not found.", "error");
            return;
        }

        req.setAttribute("profileUser", user);
        req.getRequestDispatcher("/admin/profile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!ServletUtils.requireAdmin(req, res)) return;

        String action = req.getParameter("action");
        if ("updateProfile".equals(action)) {
            handleUpdateProfile(req, res);
        } else if ("updatePassword".equals(action)) {
            handleUpdatePassword(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin-profile");
        }
    }

    // ── Update personal info (+ optional photo) ──────────────────────────────

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String fullName = req.getParameter("fullName");
        String phone    = req.getParameter("phone");
        String address  = req.getParameter("address");

        // Validate full name: letters and spaces only
        if (fullName == null || fullName.trim().isEmpty()) {
            session.setAttribute("profileError", "Full name is required.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }
        if (!fullName.trim().matches("[a-zA-Z ]+")) {
            session.setAttribute("profileError", "Full name must contain letters only.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Validate phone: exactly 10 digits
        if (phone == null || phone.trim().isEmpty()) {
            session.setAttribute("profileError", "Phone number is required.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }
        if (!phone.trim().matches("\\d{10}")) {
            session.setAttribute("profileError", "Phone number must be exactly 10 digits.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Check phone uniqueness
        if (userDAO.isPhoneExistsForOtherUser(phone.trim(), userId)) {
            session.setAttribute("profileError", "Phone number is already in use by another account.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Handle optional profile image upload
        String newImagePath = "";
        try {
            Part filePart = req.getPart("profileImage");
            newImagePath = FileUploadUtils.saveProfileImage(filePart, getServletContext());
        } catch (IllegalArgumentException e) {
            session.setAttribute("profileError", e.getMessage());
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Load current user to preserve fields not being updated
        User existing = userDAO.getUserById(userId);
        if (existing == null) {
            session.setAttribute("profileError", "User not found.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        existing.setFullName(fullName.trim());
        existing.setPhone(phone.trim());
        existing.setAddress(address == null ? "" : address.trim());
        if (!newImagePath.isEmpty()) {
            existing.setProfileImage(newImagePath);
        }

        boolean ok = userDAO.updateUser(existing);
        LOGGER.log(ok ? Level.INFO : Level.WARNING,
                "Admin profile update for userId={0}: {1}", new Object[]{userId, ok});

        if (ok) {
            // Keep session fullName and loggedInUser in sync
            session.setAttribute("fullName", existing.getFullName());
            session.setAttribute("loggedInUser", existing);
            session.setAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            session.setAttribute("profileError", "Failed to update profile. Please try again.");
        }

        res.sendRedirect(req.getContextPath() + "/admin-profile");
    }

    // ── Update password ───────────────────────────────────────────────────────

    private void handleUpdatePassword(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String currentPassword  = req.getParameter("currentPassword");
        String newPassword      = req.getParameter("newPassword");
        String confirmPassword  = req.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.isEmpty()
                || newPassword == null || newPassword.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {
            session.setAttribute("pwError", "All password fields are required.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Verify current password
        User existing = userDAO.getUserById(userId);
        if (existing == null) {
            session.setAttribute("pwError", "User not found.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        if (!PasswordUtils.checkPassword(currentPassword, existing.getPassword())) {
            session.setAttribute("pwError", "Current password is incorrect.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Validate new password length
        if (newPassword.length() < 6) {
            session.setAttribute("pwError", "New password must be at least 6 characters.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        // Confirm match
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("pwError", "New passwords do not match.");
            res.sendRedirect(req.getContextPath() + "/admin-profile");
            return;
        }

        String hashed = PasswordUtils.hashPassword(newPassword);
        boolean ok = userDAO.updatePassword(userId, hashed);
        LOGGER.log(ok ? Level.INFO : Level.WARNING,
                "Admin password update for userId={0}: {1}", new Object[]{userId, ok});

        if (ok) {
            session.setAttribute("pwSuccess", "Password updated successfully.");
        } else {
            session.setAttribute("pwError", "Failed to update password. Please try again.");
        }

        res.sendRedirect(req.getContextPath() + "/admin-profile");
    }
}
