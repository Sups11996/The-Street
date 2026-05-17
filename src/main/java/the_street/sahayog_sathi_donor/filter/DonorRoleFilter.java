package the_street.sahayog_sathi_donor.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;


//Protects all donor and ensures the session user exists AND has role DONOR
@WebFilter("/donor/*")
public class DonorRoleFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(DonorRoleFilter.class.getName());

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        try {
            HttpSession session = req.getSession(false);

            if (session == null || session.getAttribute("loggedInUser") == null) {
                res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
                return;
            }

            String role = (String) session.getAttribute("role");
            if (!"DONOR".equalsIgnoreCase(role)) {
                res.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
                return;
            }

            // Prevent browser back-button after logout
            res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            res.setHeader("Pragma", "no-cache");
            res.setDateHeader("Expires", 0);

            chain.doFilter(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DonorRoleFilter.", e);
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
        }
    }
}
