package com.the_street.the_street.dao;

import com.the_street.the_street.model.User;
import com.the_street.the_street.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO implements UserInterface {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    @Override
    public boolean insertUser(User user) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role, address, status, profile_image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getStatus());
            ps.setString(8, user.getProfileImage());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error inserting user.", e);
            return false;
        }
    }

    @Override
    public User getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapUser(rs);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by email.", e);
        }

        return user;
    }

    @Override
    public User getUserByPhone(String phone) {
        User user = null;
        String sql = "SELECT * FROM users WHERE phone = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapUser(rs);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by phone.", e);
        }

        return user;
    }

    @Override
    public ArrayList<User> getAllUsers() {
        ArrayList<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all users.", e);
        }

        return users;
    }

    @Override
    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = mapUser(rs);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by ID.", e);
        }

        return user;
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, role = ?, address = ?, status = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getStatus());
            ps.setInt(7, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user.", e);
        }

        return false;
    }

    @Override
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting user.", e);
        }

        return false;
    }

    @Override
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user status.", e);
        }

        return false;
    }

    @Override
    public boolean approveUser(int userId) {
        return updateUserStatus(userId, "ACTIVE");
    }

    @Override
    public boolean rejectUser(int userId) {
        return updateUserStatus(userId, "REJECTED");
    }

    @Override
    public boolean blockUser(int userId) {
        return updateUserStatus(userId, "BLOCKED");
    }

    @Override
    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting users.", e);
        }

        return 0;
    }

    @Override
    public int countPendingUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "PENDING");
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting pending users.", e);
        }

        return 0;
    }

    // Helper method to avoid duplication
    private User mapUser(ResultSet rs) throws Exception {
        User user = new User();

        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setAddress(rs.getString("address"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setProfileImage(rs.getString("profile_image"));

        return user;
    }
}