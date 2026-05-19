package com.the_street.the_street.dao;

import com.the_street.the_street.model.Request;
import com.the_street.the_street.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for the 'requests' table.
 * All SQL queries use PreparedStatement to prevent SQL injection.
 */
public class RequestDAO implements RequestInterface {

    private static final Logger LOGGER = Logger.getLogger(RequestDAO.class.getName());

    // ── insertRequest ─────────────────────────────────────────────────

    @Override
    public boolean insertRequest(Request request) {
        String sql = "INSERT INTO requests (receiver_id, title, category, quantity, " +
                "urgency, description, location, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, request.getReceiverId());
            ps.setString(2, request.getTitle());
            ps.setString(3, request.getCategory());
            ps.setString(4, request.getQuantity());
            ps.setString(5, request.getUrgency());
            ps.setString(6, request.getDescription());
            ps.setString(7, request.getLocation());
            ps.setString(8, "PENDING"); // always starts as PENDING

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error inserting request.", e);
            return false;
        }
    }

    // ── getRequestsByReceiverId ───────────────────────────────────────

    @Override
    public ArrayList<Request> getRequestsByReceiverId(int receiverId) {
        ArrayList<Request> requests = new ArrayList<>();
        String sql = "SELECT * FROM requests WHERE receiver_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, receiverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(mapRequest(rs));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching requests by receiver ID.", e);
        }
        return requests;
    }

    // ── getRequestById ────────────────────────────────────────────────

    @Override
    public Request getRequestById(int requestId) {
        Request request = null;
        String sql = "SELECT * FROM requests WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                request = mapRequest(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching request by ID.", e);
        }
        return request;
    }

    // ── updateRequest ─────────────────────────────────────────────────

    @Override
    public boolean updateRequest(Request request) {
        // Only allow editing if the request is still PENDING
        String sql = "UPDATE requests SET title = ?, category = ?, quantity = ?, " +
                "urgency = ?, description = ?, location = ? " +
                "WHERE request_id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, request.getTitle());
            ps.setString(2, request.getCategory());
            ps.setString(3, request.getQuantity());
            ps.setString(4, request.getUrgency());
            ps.setString(5, request.getDescription());
            ps.setString(6, request.getLocation());
            ps.setInt(7, request.getRequestId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating request.", e);
            return false;
        }
    }

    // ── cancelRequest ─────────────────────────────────────────────────

    @Override
    public boolean cancelRequest(int requestId) {
        return updateRequestStatus(requestId, "CANCELLED");
    }

    // ── confirmReceipt ────────────────────────────────────────────────

    @Override
    public boolean confirmReceipt(int requestId) {
        return updateRequestStatus(requestId, "FULFILLED");
    }

    // ── updateRequestStatus ───────────────────────────────────────────

    @Override
    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE requests SET status = ? WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating request status.", e);
            return false;
        }
    }

    // ── countRequestsByReceiverId ─────────────────────────────────────

    @Override
    public int countRequestsByReceiverId(int receiverId) {
        String sql = "SELECT COUNT(*) FROM requests WHERE receiver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, receiverId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting requests.", e);
        }
        return 0;
    }

    // ── countRequestsByStatus ─────────────────────────────────────────

    @Override
    public int countRequestsByStatus(int receiverId, String status) {
        String sql = "SELECT COUNT(*) FROM requests WHERE receiver_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, receiverId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting requests by status.", e);
        }
        return 0;
    }

    // ── private helper ────────────────────────────────────────────────

    /**
     * Maps a ResultSet row to a Request object.
     * Reused by every SELECT method to avoid code duplication.
     */
    private Request mapRequest(ResultSet rs) throws Exception {
        Request r = new Request();
        r.setRequestId(rs.getInt("request_id"));
        r.setReceiverId(rs.getInt("receiver_id"));
        r.setTitle(rs.getString("title"));
        r.setCategory(rs.getString("category"));
        r.setQuantity(rs.getString("quantity"));
        r.setUrgency(rs.getString("urgency"));
        r.setDescription(rs.getString("description"));
        r.setLocation(rs.getString("location"));
        r.setStatus(rs.getString("status"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
