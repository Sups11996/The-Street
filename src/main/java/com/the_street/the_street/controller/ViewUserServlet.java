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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/view-users")
public class ViewUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ViewUserServlet.class.getName());
    private final UserInterface userInterface = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            ArrayList<User> users = userInterface.getAllUsers();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/admin/view-users.jsp").forward(req, res);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user list.", e);
            req.getSession().setAttribute("errorMessage", "Unable to load users.");
            res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
        }
    }
}
