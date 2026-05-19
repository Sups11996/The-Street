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
 * Receiver confirms they received the donated item → sets status to FULFILLED.
 * URL: /receiver/confirm-receipt?request_id=X
 */
@WebServlet("/receiver/confirm-receipt")
public class ConfirmReceiptServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ConfirmReceiptServlet.class.getName());
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

            // Security: only owner can confirm, only if ACCEPTED
            if (req == null || req.getReceiverId() != user.getUserId()) {
                session.setAttribute("errorMessage", "Unauthorized action.");
            } else if (!"ACCEPTED".equals(req.getStatus())) {
                session.setAttribute("errorMessage", "You can only confirm receipt for ACCEPTED requests.");
            } else {
                boolean success = requestDAO.confirmReceipt(requestId);
                if (success) {
                    session.setAttribute("successMessage", "Receipt confirmed! Thank you.");
                } else {
                    session.setAttribute("errorMessage", "Could not confirm receipt.");
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid request ID for confirm receipt.", e);
            session.setAttribute("errorMessage", "Invalid request ID.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error confirming receipt.", e);
            session.setAttribute("errorMessage", "Something went wrong.");
        }

        response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
    }
}
