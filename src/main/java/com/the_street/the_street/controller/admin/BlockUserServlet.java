package com.the_street.the_street.controller.admin;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.ServletUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/block-user")
public class BlockUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BlockUserServlet.class.getName());
    private final UserInterface userInterface = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!ServletUtils.requireAdmin(req, res)) return;
        try {
            int userId = ServletUtils.parseUserId(req.getParameter("userId"), req, res);
            if (userId == -1) return;

            User user = userInterface.getUserById(userId);
            if (user == null) { ServletUtils.forwardMessage(req, res, "User not found.", "error"); return; }

            String prev = user.getStatus();
            boolean ok  = userInterface.blockUser(userId);
            LOGGER.log(ok ? Level.INFO : Level.WARNING, "Block user {0}: {1}", new Object[]{userId, ok});

            req.setAttribute("user", user);
            req.setAttribute("previousStatus", prev);
            req.setAttribute("newStatus", "BLOCKED");
            ServletUtils.forwardMessage(req, res,
                ok ? "User blocked successfully." : "Failed to block user.",
                ok ? "warning" : "error");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error blocking user.", e);
            ServletUtils.forwardMessage(req, res, "Something went wrong.", "error");
        }
    }
}
