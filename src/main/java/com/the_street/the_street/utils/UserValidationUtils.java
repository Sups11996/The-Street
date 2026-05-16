package com.the_street.the_street.utils;

public class UserValidationUtils {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final String PHONE_REGEX = "^[0-9]{10}$";
    private static final String NAME_REGEX  = "^[A-Za-z ]+$";

    /** Returns null if valid, or an error message string if invalid. */
    public static String validateUserFields(String fullName, String email, String phone,
                                            String password, String confirmPassword) {
        if (isBlank(fullName) || isBlank(email) || isBlank(phone)
                || isBlank(password) || isBlank(confirmPassword)) {
            return "All required fields must be filled.";
        }
        if (!fullName.trim().matches(NAME_REGEX))
            return "Full name must contain only letters.";
        if (!email.trim().matches(EMAIL_REGEX))
            return "Please enter a valid email address.";
        if (!phone.trim().matches(PHONE_REGEX))
            return "Phone number must be 10 digits.";
        if (password.length() < 6)
            return "Password must be at least 6 characters.";
        if (!password.equals(confirmPassword))
            return "Passwords do not match.";
        return null;
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
