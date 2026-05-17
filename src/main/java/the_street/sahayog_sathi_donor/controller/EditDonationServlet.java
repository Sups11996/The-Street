package the_street.sahayog_sathi_donor.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import the_street.sahayog_sathi_donor.dao.DonationDAO;
import the_street.sahayog_sathi_donor.dao.DonationInterface;
import the_street.sahayog_sathi_donor.model.Donation;
import the_street.sahayog_sathi_donor.model.User;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/donor/editDonation")
public class EditDonationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditDonationServlet.class.getName());
    private final DonationInterface donationDAO = new DonationDAO();

    // GET - load form pre-filled
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                res.sendRedirect(req.getContextPath() + "/donor/myDonations");
                return;
            }

            HttpSession session = req.getSession(false);
            User donor = (User) session.getAttribute("loggedInUser");

            Donation donation = donationDAO.getDonationById(Integer.parseInt(idParam.trim()));

            if (donation == null || donation.getDonorId() != donor.getUserId()) {
                session.setAttribute("errorMessage", "Donation not found or access denied.");
                res.sendRedirect(req.getContextPath() + "/donor/myDonations");
                return;
            }

            if (!"AVAILABLE".equalsIgnoreCase(donation.getStatus())) {
                session.setAttribute("errorMessage", "Only AVAILABLE donations can be edited.");
                res.sendRedirect(req.getContextPath() + "/donor/myDonations");
                return;
            }

            req.setAttribute("donation", donation);
            req.getRequestDispatcher("/donor/editDonation.jsp").forward(req, res);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading edit form.", e);
            res.sendRedirect(req.getContextPath() + "/donor/myDonations");
        }
    }

    // POST - save changes
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            User donor = (User) session.getAttribute("loggedInUser");

            String idParam     = req.getParameter("donationId");
            String title       = req.getParameter("title");
            String category    = req.getParameter("category");
            String quantityStr = req.getParameter("quantity");
            String description = req.getParameter("description");
            String location    = req.getParameter("location");

            if (isBlank(idParam) || isBlank(title) || isBlank(category)
                    || isBlank(quantityStr) || isBlank(description) || isBlank(location)) {
                req.setAttribute("errorMessage", "All fields are required.");
                Donation d = donationDAO.getDonationById(Integer.parseInt(idParam == null ? "0" : idParam));
                req.setAttribute("donation", d);
                req.getRequestDispatcher("/donor/editDonation.jsp").forward(req, res);
                return;
            }

            int quantity;
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                if (quantity <= 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                req.setAttribute("errorMessage", "Quantity must be a positive number.");
                Donation d = donationDAO.getDonationById(Integer.parseInt(idParam.trim()));
                req.setAttribute("donation", d);
                req.getRequestDispatcher("/donor/editDonation.jsp").forward(req, res);
                return;
            }

            Donation donation = new Donation();
            donation.setDonationId(Integer.parseInt(idParam.trim()));
            donation.setDonorId(donor.getUserId());
            donation.setTitle(title.trim());
            donation.setCategory(category.trim().toUpperCase());
            donation.setQuantity(quantity);
            donation.setDescription(description.trim());
            donation.setLocation(location.trim());

            if (donationDAO.updateDonation(donation)) {
                session.setAttribute("successMessage", "Donation updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Update failed. Donation may no longer be editable.");
            }
            res.sendRedirect(req.getContextPath() + "/donor/myDonations");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating donation.", e);
            req.getSession().setAttribute("errorMessage", "Something went wrong. Please try again.");
            res.sendRedirect(req.getContextPath() + "/donor/myDonations");
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
