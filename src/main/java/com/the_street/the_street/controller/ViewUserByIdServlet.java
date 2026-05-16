package com.the_street.the_street.controller;

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

@WebServlet("/view-user-by-id")
public class ViewUserByIdServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ViewUserByIdServlet.class.getName());
    private final UserInterface userInterface = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int userId = ServletUtils.parseUserId(req.getParameter("user_id"), req, res);
            if (userId == -1) return;

            User user = userInterface.getUserById(userId);
            if (user == null) {
                req.getSession().setAttribute("errorMessage", "User not found.");
                res.sendRedirect(req.getContextPath() + "/view-users");
                return;
            }

            req.setAttribute("user", user);
            String mode = req.getParameter("mode");
            req.getRequestDispatcher("edit".equalsIgnoreCase(mode)
                ? "/admin/update-user.jsp" : "/admin/view-user.jsp").forward(req, res);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading user details.", e);
            req.getSession().setAttribute("errorMessage", "Something went wrong.");
            res.sendRedirect(req.getContextPath() + "/view-users");
        }
    }
}
