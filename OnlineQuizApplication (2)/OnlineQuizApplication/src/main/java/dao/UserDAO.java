package dao;

import java.sql.*;
import db.DBConnection;
import util.PasswordUtil;

public class UserDAO {

    // USER LOGIN
    public boolean userLogin(String username, String password) throws Exception {

        String sql = "SELECT 1 FROM users WHERE username=? AND password=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, PasswordUtil.hash(password));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // USER EXISTS
    public boolean userExists(String username) throws Exception {

        String sql = "SELECT 1 FROM users WHERE username=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ADMIN LOGIN
    public boolean adminLogin(String username, String password) throws Exception {

        String sql = "SELECT 1 FROM admin WHERE username=? AND password=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, PasswordUtil.hash(password)); 

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    public boolean adminExists(String username) {

        boolean exists = false;

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                    "SELECT * FROM admin WHERE username=?");

            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            exists = rs.next();

            con.close();

        } catch(Exception e) {

            e.printStackTrace();
        }

        return exists;
    }

    // RESET USER PASSWORD
    public boolean resetPassword(String username, String name, String newPassword) throws Exception {

        String sql = "UPDATE users SET password=? WHERE username=? AND name=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, PasswordUtil.hash(newPassword));
            ps.setString(2, username);
            ps.setString(3, name);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        }
    }
}