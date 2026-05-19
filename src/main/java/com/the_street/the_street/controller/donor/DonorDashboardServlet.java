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

@WebServlet("/donor/dashboard")
public class DonorDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DonorDashboardServlet.class.getName());
    private final DonationInterface donationDAO = new DonationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            User donor = (User) session.getAttribute("loggedInUser");

            int donorId = donor.getUserId();

            int total     = donationDAO.countDonationsByDonor(donorId);
            int available = donationDAO.countDonationsByDonorAndStatus(donorId, "AVAILABLE");
            int claimed   = donationDAO.countDonationsByDonorAndStatus(donorId, "CLAIMED");
            int delivered = donationDAO.countDonationsByDonorAndStatus(donorId, "DELIVERED");

            req.setAttribute("totalDonations",     total);
            req.setAttribute("availableDonations", available);
            req.setAttribute("claimedDonations",   claimed);
            req.setAttribute("deliveredDonations", delivered);

            req.getRequestDispatcher("/donor/dashboard.jsp").forward(req, res);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading donor dashboard.", e);
            res.sendRedirect(req.getContextPath() + "/error.jsp");
        }
    }
}
