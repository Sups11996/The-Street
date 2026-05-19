package com.the_street.the_street.dao;

import com.the_street.the_street.model.User;

import java.util.ArrayList;

public interface UserInterface {

    // Authentication
    boolean insertUser(User user);
    User getUserByEmail(String email);
    User getUserByPhone(String phone);

    // Admin user management
    ArrayList<User> getAllUsers();
    User getUserById(int userId);
    boolean updateUser(User user);
    boolean deleteUser(int userId);

    // Duplicate validation for updates
    boolean isEmailExistsForOtherUser(String email, int userId);
    boolean isPhoneExistsForOtherUser(String phone, int userId);

    // Admin status actions
    boolean updateUserStatus(int userId, String status);
    boolean approveUser(int userId);
    boolean rejectUser(int userId);
    boolean blockUser(int userId);

    // Dashboard count cards
    int countUsers();
    int countPendingUsers();
    int countActiveUsers();

    // Profile password update
    boolean updatePassword(int userId, String hashedPassword);
}
