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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Cancels a PENDING request.
 * URL: /receiver/cancel-request?request_id=X
 */
@WebServlet("/receiver/cancel-request")
public class CancelRequestServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CancelRequestServlet.class.getName());
    private final RequestInterface requestDAO = new RequestDAO();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        try {
            int requestId = Integer.parseInt(request.getParameter("request_id"));
            Request req = requestDAO.getRequestById(requestId);

            // Security: only owner can cancel, only if PENDING
            if (req == null || req.getReceiverId() != user.getUserId()) {
                session.setAttribute("errorMessage", "Unauthorized action.");
            } else if (!"PENDING".equals(req.getStatus())) {
                session.setAttribute("errorMessage", "Only PENDING requests can be cancelled.");
            } else {
                boolean success = requestDAO.cancelRequest(requestId);
                if (success) {
                    session.setAttribute("successMessage", "Request cancelled successfully.");
                } else {
                    session.setAttribute("errorMessage", "Could not cancel request.");
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid request ID for cancel.", e);
            session.setAttribute("errorMessage", "Invalid request ID.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error cancelling request.", e);
            session.setAttribute("errorMessage", "Something went wrong.");
        }

        response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
    }
}
