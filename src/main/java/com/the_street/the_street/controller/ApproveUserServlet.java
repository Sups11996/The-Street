package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.dao.UserInterface;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/approve-user")
public class ApproveUserServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ApproveUserServlet.class.getName());

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

            boolean result = userInterface.approveUser(userId);

            if (result) {
                request.getSession().setAttribute("successMessage", "User approved successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "User approval failed.");
            }

            response.sendRedirect("view-users");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid user ID format while approving user.", e);
            request.getSession().setAttribute("errorMessage", "Invalid user ID format.");
            response.sendRedirect("view-users");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error occurred while approving user.", e);
            request.getSession().setAttribute("errorMessage", "Something went wrong while approving user.");
            response.sendRedirect("view-users");
        }
    }
}