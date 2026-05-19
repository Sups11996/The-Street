package com.the_street.the_street.controller.donor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.the_street.the_street.model.User;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.the_street.the_street.dao.DonationDAO;
import com.the_street.the_street.dao.DonationInterface;
import com.the_street.the_street.model.Donation;

@WebServlet("/donor/createDonation")
public class CreateDonationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CreateDonationServlet.class.getName());
    private final DonationInterface donationDAO = new DonationDAO();

    // GET - show blank form
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/donor/createDonation.jsp").forward(req, res);
    }

    // POST - validate and save
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            User donor = (User) session.getAttribute("loggedInUser");

            String title       = req.getParameter("title");
            String category    = req.getParameter("category");
            String quantityStr = req.getParameter("quantity");
            String description = req.getParameter("description");
            String location    = req.getParameter("location");

            // Validation
            if (isBlank(title) || isBlank(category) || isBlank(quantityStr)
                    || isBlank(description) || isBlank(location)) {
                req.setAttribute("errorMessage", "All fields are required.");
                req.getRequestDispatcher("/donor/createDonation.jsp").forward(req, res);
                return;
            }

            int quantity;
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                if (quantity <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                req.setAttribute("errorMessage", "Quantity must be a positive number.");
                req.getRequestDispatcher("/donor/createDonation.jsp").forward(req, res);
                return;
            }

            String[] validCategories = {"FOOD", "CLOTHING", "ESSENTIALS", "OTHER"};
            boolean validCat = false;
            for (String c : validCategories) {
                if (c.equalsIgnoreCase(category.trim())) { validCat = true; break; }
            }
            if (!validCat) {
                req.setAttribute("errorMessage", "Please select a valid category.");
                req.getRequestDispatcher("/donor/createDonation.jsp").forward(req, res);
                return;
            }

            // Build and save
            Donation donation = new Donation();
            donation.setDonorId(donor.getUserId());
            donation.setTitle(title.trim());
            donation.setCategory(category.trim().toUpperCase());
            donation.setQuantity(quantity);
            donation.setDescription(description.trim());
            donation.setLocation(location.trim());
            donation.setStatus("AVAILABLE");

            if (donationDAO.insertDonation(donation)) {
                req.getSession().setAttribute("successMessage", "Donation posted successfully!");
                res.sendRedirect(req.getContextPath() + "/donor/myDonations");
            } else {
                req.setAttribute("errorMessage", "Failed to save donation. Please try again.");
                req.getRequestDispatcher("/donor/createDonation.jsp").forward(req, res);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating donation.", e);
            req.setAttribute("errorMessage", "Something went wrong. Please try again.");
            req.getRequestDispatcher("/donor/createDonation.jsp").forward(req, res);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
