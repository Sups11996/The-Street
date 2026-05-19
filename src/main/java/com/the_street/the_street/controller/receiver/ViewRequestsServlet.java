package com.the_street.the_street.controller.receiver;

import com.the_street.the_street.dao.RequestDAO;
import com.the_street.the_street.dao.RequestInterface;
import com.the_street.the_street.model.Request;
import com.the_street.the_street.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Shows the receiver's "My Requests" page with all their requests.
 * URL: /receiver/my-requests
 */
@WebServlet("/receiver/my-requests")
public class ViewRequestsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ViewRequestsServlet.class.getName());
    private final RequestInterface requestDAO = new RequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Guard: only logged-in receivers
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (!"RECEIVER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            int receiverId = user.getUserId();

            // Fetch all requests
            ArrayList<Request> requests = requestDAO.getRequestsByReceiverId(receiverId);

            // Dashboard counts
            int totalRequests    = requestDAO.countRequestsByReceiverId(receiverId);
            int pendingCount     = requestDAO.countRequestsByStatus(receiverId, "PENDING");
            int acceptedCount    = requestDAO.countRequestsByStatus(receiverId, "ACCEPTED");
            int fulfilledCount   = requestDAO.countRequestsByStatus(receiverId, "FULFILLED");

            request.setAttribute("requests",       requests);
            request.setAttribute("totalRequests",  totalRequests);
            request.setAttribute("pendingCount",   pendingCount);
            request.setAttribute("acceptedCount",  acceptedCount);
            request.setAttribute("fulfilledCount", fulfilledCount);

            // Flash messages from session
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage   = (String) session.getAttribute("errorMessage");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }

            request.getRequestDispatcher("/receiver/my-requests.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading receiver requests.", e);
            request.setAttribute("errorMessage", "Could not load requests.");
            request.getRequestDispatcher("/receiver/my-requests.jsp").forward(request, response);
        }
    }
}
