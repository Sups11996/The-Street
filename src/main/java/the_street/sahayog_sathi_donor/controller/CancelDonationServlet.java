package the_street.sahayog_sathi_donor.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import the_street.sahayog_sathi_donor.dao.DonationDAO;
import the_street.sahayog_sathi_donor.dao.DonationInterface;
import the_street.sahayog_sathi_donor.model.User;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/donor/cancelDonation")
public class CancelDonationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CancelDonationServlet.class.getName());
    private final DonationInterface donationDAO = new DonationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String idParam = req.getParameter("donationId");

            if (idParam == null || idParam.trim().isEmpty()) {
                req.getSession().setAttribute("errorMessage", "Invalid donation ID.");
                res.sendRedirect(req.getContextPath() + "/donor/myDonations");
                return;
            }

            HttpSession session = req.getSession(false);
            User donor = (User) session.getAttribute("loggedInUser");

            int donationId = Integer.parseInt(idParam.trim());
            boolean cancelled = donationDAO.cancelDonation(donationId, donor.getUserId());

            if (cancelled) {
                session.setAttribute("successMessage", "Donation cancelled successfully.");
            } else {
                session.setAttribute("errorMessage", "Could not cancel. Donation may already be claimed or delivered.");
            }

            res.sendRedirect(req.getContextPath() + "/donor/myDonations");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error cancelling donation.", e);
            req.getSession().setAttribute("errorMessage", "Something went wrong. Please try again.");
            res.sendRedirect(req.getContextPath() + "/donor/myDonations");
        }
    }
}
