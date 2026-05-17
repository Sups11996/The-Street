package com.the_street.the_street.utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ServletUtils {

    private static final String MSG_JSP = "/admin/message.jsp";

    /** Returns true if the current session belongs to an ADMIN, false + handles response otherwise. */
    public static boolean requireAdmin(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            forwardMessage(req, res, "Access denied. Admin privileges required.", "error");
            return false;
        }
        return true;
    }

    /**
     * Parses userId from a request parameter string.
     * Returns -1 and handles the response on failure.
     */
    public static int parseUserId(String param, HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (param == null || param.trim().isEmpty()) {
            forwardMessage(req, res, "Invalid user ID.", "error");
            return -1;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            forwardMessage(req, res, "Invalid user ID format.", "error");
            return -1;
        }
    }

    /** Sets message/messageType attributes and forwards to message.jsp. */
    public static void forwardMessage(HttpServletRequest req, HttpServletResponse res,
                                      String message, String type)
            throws ServletException, IOException {
        req.setAttribute("message", message);
        req.setAttribute("messageType", type);
        req.getRequestDispatcher(MSG_JSP).forward(req, res);
    }
}
