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
 * Handles GET  → show the "Create Request" form
 *         POST → validate input and save the new request to DB
 *
 * URL: /receiver/create-request
 */
@WebServlet("/receiver/create-request")
public class CreateRequestServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CreateRequestServlet.class.getName());
    private final RequestInterface requestDAO = new RequestDAO();

    // ── GET: show the form ────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Guard: only logged-in receivers can access this page
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

        request.getRequestDispatcher("/receiver/create-request.jsp").forward(request, response);
    }

    // ── POST: validate and save ───────────────────────────────────────

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
            // Read form fields
            String title       = request.getParameter("title");
            String category    = request.getParameter("category");
            String quantity    = request.getParameter("quantity");
            String urgency     = request.getParameter("urgency");
            String description = request.getParameter("description");
            String location    = request.getParameter("location");

            // ── Server-side validation ────────────────────────────────
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Title is required.");
                request.getRequestDispatcher("/receiver/create-request.jsp").forward(request, response);
                return;
            }
            if (quantity == null || quantity.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Quantity is required.");
                request.getRequestDispatcher("/receiver/create-request.jsp").forward(request, response);
                return;
            }
            if (location == null || location.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Location is required.");
                request.getRequestDispatcher("/receiver/create-request.jsp").forward(request, response);
                return;
            }

            // ── Build and save the request object ─────────────────────
            Request newRequest = new Request();
            newRequest.setReceiverId(user.getUserId());
            newRequest.setTitle(title.trim());
            newRequest.setCategory(category);
            newRequest.setQuantity(quantity.trim());
            newRequest.setUrgency(urgency);
            newRequest.setDescription(description != null ? description.trim() : "");
            newRequest.setLocation(location.trim());

            boolean success = requestDAO.insertRequest(newRequest);

            if (success) {
                session.setAttribute("successMessage", "Request submitted successfully!");
                response.sendRedirect(request.getContextPath() + "/receiver/my-requests");
            } else {
                request.setAttribute("errorMessage", "Failed to submit request. Please try again.");
                request.getRequestDispatcher("/receiver/create-request.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating request.", e);
            request.setAttribute("errorMessage", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/receiver/create-request.jsp").forward(request, response);
        }
    }
}
