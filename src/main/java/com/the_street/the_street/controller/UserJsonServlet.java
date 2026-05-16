package com.the_street.the_street.controller;

import com.the_street.the_street.dao.UserDAO;
import com.the_street.the_street.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/user-json")
public class UserJsonServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            res.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        try {
            String param = req.getParameter("userId");
            if (param == null || param.trim().isEmpty()) {
                res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            User u = userDAO.getUserById(Integer.parseInt(param.trim()));
            if (u == null) { res.setStatus(HttpServletResponse.SC_NOT_FOUND); return; }

            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");
            PrintWriter out = res.getWriter();
            out.print("{\"userId\":" + u.getUserId()
                + ",\"fullName\":"    + q(u.getFullName())
                + ",\"email\":"       + q(u.getEmail())
                + ",\"phone\":"       + q(u.getPhone())
                + ",\"role\":"        + q(u.getRole())
                + ",\"address\":"     + q(u.getAddress())
                + ",\"status\":"      + q(u.getStatus())
                + ",\"profileImage\":" + q(u.getProfileImage() != null ? u.getProfileImage() : "")
                + "}");
            out.flush();
        } catch (NumberFormatException e) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private String q(String v) {
        if (v == null) return "\"\"";
        return "\"" + v.replace("\\","\\\\").replace("\"","\\\"")
                       .replace("\n","\\n").replace("\r","\\r") + "\"";
    }
}
