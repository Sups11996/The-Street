package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.PasswordUtils;
import com.the_street.the_street.utils.ServletUtils;
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!ServletUtils.requireAdmin(req, res)) return;
        try {
            int userId = ServletUtils.parseUserId(req.getParameter("userId"), req, res);
            if (userId == -1) return;

            User existing = userInterface.getUserById(userId);
            if (existing == null) { ServletUtils.forwardMessage(req, res, "User not found.", "error"); return; }

            String fullName = req.getParameter("fullName");
            String email    = req.getParameter("email");
            String phone    = req.getParameter("phone");
            String role     = req.getParameter("role");
            String address  = req.getParameter("address");
            String status   = req.getParameter("status");
            String newPw    = req.getParameter("newPassword");

            if (fullName == null || fullName.trim().isEmpty())
                { ServletUtils.forwardMessage(req, res, "Full name cannot be empty.", "error"); return; }
            if (email == null || email.trim().isEmpty())
                { ServletUtils.forwardMessage(req, res, "Email cannot be empty.", "error"); return; }
            if (phone == null || phone.trim().isEmpty())
                { ServletUtils.forwardMessage(req, res, "Phone number cannot be empty.", "error"); return; }

            fullName = fullName.trim();
            email    = email.trim();
            phone    = phone.trim();
            role     = (role    == null || role.trim().isEmpty())    ? existing.getRole()    : role.trim();
            address  = (address == null || address.trim().isEmpty()) ? existing.getAddress() : address.trim();
            status   = (status  == null || status.trim().isEmpty())  ? existing.getStatus()  : status.trim();

            if (userInterface.isEmailExistsForOtherUser(email, userId))
                { ServletUtils.forwardMessage(req, res, "Update failed: Email already exists.", "error"); return; }
            if (userInterface.isPhoneExistsForOtherUser(phone, userId))
                { ServletUtils.forwardMessage(req, res, "Update failed: Phone number already exists.", "error"); return; }

            if (newPw != null && !newPw.trim().isEmpty() && newPw.trim().length() < 6)
                { ServletUtils.forwardMessage(req, res, "New password must be at least 6 characters.", "error"); return; }

            User user = new User();
            user.setUserId(userId);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setAddress(address);
            user.setStatus(status);
            user.setPassword((newPw != null && !newPw.trim().isEmpty())
                ? PasswordUtils.hashPassword(newPw.trim())
                : existing.getPassword());
            user.setProfileImage(existing.getProfileImage());

            boolean ok = userInterface.updateUser(user);
            LOGGER.log(ok ? Level.INFO : Level.WARNING, "Update user {0}: {1}", new Object[]{userId, ok});
            ServletUtils.forwardMessage(req, res,
                ok ? "User updated successfully." : "Update failed. No changes were made.",
                ok ? "success" : "error");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user.", e);
            ServletUtils.forwardMessage(req, res, "Something went wrong.", "error");
        }
    }
}
