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

@WebServlet("/view-user-by-id")
public class ViewUserByIdServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ViewUserByIdServlet.class.getName());

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

            User user = userInterface.getUserById(userId);

            if (user == null) {
                request.getSession().setAttribute("errorMessage", "User not found.");
                response.sendRedirect("view-users");
                return;
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("admin/edit-user.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format while viewing user by ID.", e);
            request.getSession().setAttribute("errorMessage", "Invalid user ID format.");
            response.sendRedirect("view-users");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred while loading user details for editing.", e);
            request.getSession().setAttribute("errorMessage", "Something went wrong while loading user details.");
            response.sendRedirect("view-users");
        }
    }
}