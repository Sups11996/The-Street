package com.the_street.the_street.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.the_street.the_street.model.Donation;
import com.the_street.the_street.utils.DBConnection;

public class DonationDAO implements DonationInterface {

    private static final Logger LOGGER = Logger.getLogger(DonationDAO.class.getName());

    // INSERT a new donation
    @Override
    public boolean insertDonation(Donation donation) {
        String sql = "INSERT INTO donations (donor_id, title, category, quantity, description, location, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1,    donation.getDonorId());
            ps.setString(2, donation.getTitle());
            ps.setString(3, donation.getCategory());
            ps.setInt(4,    donation.getQuantity());
            ps.setString(5, donation.getDescription());
            ps.setString(6, donation.getLocation());
            ps.setString(7, donation.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error inserting donation.", e);
            return false;
        }
    }

    // GET donation by primary key
    @Override
    public Donation getDonationById(int donationId) {
        String sql = "SELECT * FROM donations WHERE donation_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapDonation(rs);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching donation by ID.", e);
        }
        return null;
    }

    // GET all donations for a specific donor, newest first
    @Override
    public ArrayList<Donation> getDonationsByDonorId(int donorId) {
        ArrayList<Donation> list = new ArrayList<>();
        String sql = "SELECT * FROM donations WHERE donor_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapDonation(rs));
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching donations for donor.", e);
        }
        return list;
    }

    // UPDATE editable fields — only AVAILABLE donations can be edited
    @Override
    public boolean updateDonation(Donation donation) {
        String sql = "UPDATE donations SET title = ?, category = ?, quantity = ?, " +
                "description = ?, location = ? " +
                "WHERE donation_id = ? AND donor_id = ? AND status = 'AVAILABLE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, donation.getTitle());
            ps.setString(2, donation.getCategory());
            ps.setInt(3,    donation.getQuantity());
            ps.setString(4, donation.getDescription());
            ps.setString(5, donation.getLocation());
            ps.setInt(6,    donation.getDonationId());
            ps.setInt(7,    donation.getDonorId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating donation.", e);
            return false;
        }
    }

    // CANCEL — sets status to CANCELLED, only if still AVAILABLE and owned by this donor
    @Override
    public boolean cancelDonation(int donationId, int donorId) {
        String sql = "UPDATE donations SET status = 'CANCELLED' " +
                "WHERE donation_id = ? AND donor_id = ? AND status = 'AVAILABLE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donationId);
            ps.setInt(2, donorId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error cancelling donation.", e);
            return false;
        }
    }

    // COUNT all donations for a donor
    @Override
    public int countDonationsByDonor(int donorId) {
        String sql = "SELECT COUNT(*) FROM donations WHERE donor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting donations.", e);
        }
        return 0;
    }

    // COUNT donations for a donor filtered by status
    @Override
    public int countDonationsByDonorAndStatus(int donorId, String status) {
        String sql = "SELECT COUNT(*) FROM donations WHERE donor_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donorId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting donations by status.", e);
        }
        return 0;
    }

    // Private helper — maps a ResultSet row to a Donation object
    private Donation mapDonation(ResultSet rs) throws Exception {
        Donation d = new Donation();
        d.setDonationId(rs.getInt("donation_id"));
        d.setDonorId(rs.getInt("donor_id"));
        d.setTitle(rs.getString("title"));
        d.setCategory(rs.getString("category"));
        d.setQuantity(rs.getInt("quantity"));
        d.setDescription(rs.getString("description"));
        d.setLocation(rs.getString("location"));
        d.setStatus(rs.getString("status"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        return d;
    }
}
