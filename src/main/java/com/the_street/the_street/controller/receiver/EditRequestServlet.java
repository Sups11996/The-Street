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
 * Edit an existing PENDING request.
 * GET  → /receiver/edit-request?request_id=X  (shows pre-filled form)
 * POST → /receiver/edit-request               (saves changes)
 */
@WebServlet("/receiver/edit-request")
public class EditRequestServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditRequestServlet.class.getName());
    private final RequestInterface requestDAO = new RequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        try {
            int requestId = Integer.parseInt(request.getParameter("request_id"));
            Request existingRequest = requestDAO.getRequestById(requestId);

            // Security: only the owner can edit, and only if PENDING
            if (existingRequest == null
                    || existingRequest.getReceiverId() != user.getUserId()
                    || !"PENDING".equals(existingRequest.getStatus())) {
                session.setAttribute("errorMessage", "Request cannot be edited.");
                response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
                return;
            }

            request.setAttribute("existingRequest", existingRequest);
            request.getRequestDispatcher("/receiver/edit-request.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid request ID for edit.", e);
            session.setAttribute("errorMessage", "Invalid request.");
            response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");

        try {
            int requestId = Integer.parseInt(request.getParameter("request_id"));
            Request existingRequest = requestDAO.getRequestById(requestId);

            // Security check again
            if (existingRequest == null || existingRequest.getReceiverId() != user.getUserId()) {
                session.setAttribute("errorMessage", "Unauthorized action.");
                response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
                return;
            }

            existingRequest.setTitle(request.getParameter("title").trim());
            existingRequest.setCategory(request.getParameter("category"));
            existingRequest.setQuantity(request.getParameter("quantity").trim());
            existingRequest.setUrgency(request.getParameter("urgency"));
            existingRequest.setDescription(request.getParameter("description").trim());
            existingRequest.setLocation(request.getParameter("location").trim());

            boolean success = requestDAO.updateRequest(existingRequest);

            if (success) {
                session.setAttribute("successMessage", "Request updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Update failed. Request may no longer be editable.");
            }
            response.sendRedirect(request.getContextPath() + "/receiver/my-requests");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating request.", e);
            session.setAttribute("errorMessage", "Something went wrong.");
            response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
        }
    }
}
