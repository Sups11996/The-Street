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

    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            ArrayList<User> users = userInterface.getAllUsers();

            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/view-users.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred while retrieving user list.", e);

            request.getSession().setAttribute("errorMessage", "Unable to load users at the moment.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp"); // safe fallback
        }
    }
}