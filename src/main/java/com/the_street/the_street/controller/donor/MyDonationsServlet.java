package com.the_street.the_street.controller.donor;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.the_street.the_street.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.the_street.the_street.dao.DonationDAO;
import com.the_street.the_street.dao.DonationInterface;
import com.the_street.the_street.model.Donation;

@WebServlet("/donor/myDonations")
public class MyDonationsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MyDonationsServlet.class.getName());
    private final DonationInterface donationDAO = new DonationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            User donor = (User) session.getAttribute("loggedInUser");

            String filter = req.getParameter("filter");

            ArrayList<Donation> allDonations = donationDAO.getDonationsByDonorId(donor.getUserId());

            ArrayList<Donation> displayList;
            if (filter != null && !filter.trim().isEmpty() && !filter.equalsIgnoreCase("ALL")) {
                displayList = new ArrayList<>();
                for (Donation d : allDonations) {
                    if (d.getStatus().equalsIgnoreCase(filter.trim())) {
                        displayList.add(d);
                    }
                }
            } else {
                displayList = allDonations;
            }

            req.setAttribute("donations", displayList);
            req.setAttribute("currentFilter", filter == null ? "ALL" : filter.toUpperCase());

            // Flash messages
            String success = (String) session.getAttribute("successMessage");
            String error   = (String) session.getAttribute("errorMessage");
            if (success != null) { req.setAttribute("successMessage", success); session.removeAttribute("successMessage"); }
            if (error   != null) { req.setAttribute("errorMessage",   error);   session.removeAttribute("errorMessage"); }

            req.getRequestDispatcher("/donor/myDonations.jsp").forward(req, res);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading my donations.", e);
            res.sendRedirect(req.getContextPath() + "/error.jsp");
        }
    }
}
