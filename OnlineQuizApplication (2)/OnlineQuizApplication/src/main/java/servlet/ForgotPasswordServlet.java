package servlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import dao.UserDAO;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {
            String username = req.getParameter("username");
            String name = req.getParameter("name");
            String password = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");

            // ================= BASIC VALIDATION =================
            if (username == null || name == null || password == null || confirmPassword == null ||
                username.trim().isEmpty() || name.trim().isEmpty() || 
                password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {

                res.sendRedirect("forgot.html?error=empty");
                return;
            }

            username = username.trim();
            name = name.trim();
            password = password.trim();
            confirmPassword = confirmPassword.trim();

            // ================= PASSWORD VALIDATION =================
            if (password.length() < 8) {
                res.sendRedirect("forgot.html?error=password_length");
                return;
            }

            if (!password.equals(confirmPassword)) {
                res.sendRedirect("forgot.html?error=password_mismatch");
                return;
            }

            // ================= RESET PASSWORD =================
            UserDAO dao = new UserDAO();
            boolean success = dao.resetPassword(username, name, password);

            if (success) {
                res.sendRedirect("login.html?reset=success");
            } else {
                res.sendRedirect("forgot.html?error=user_not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("forgot.html?error=server");
        }
    }
}
