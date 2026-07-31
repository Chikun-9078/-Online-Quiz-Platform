package servlet;

import db.DBConnection;
import dao.ResultDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/SubmitQuizServlet")
public class SubmitQuizServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int score = 0;
        int total = 0;

        List<Map<String,String>> questions =
                new ArrayList<>();

        Map<String,String> userAnswers =
                new HashMap<>();

        try {

            String user =
                    (String) req.getSession()
                    .getAttribute("user");

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(
                    "SELECT * FROM questions");

            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                total++;

                String id =
                        rs.getString("id");

                String correctAnswer =
                        rs.getString("answer");

                String userAnswer =
                        req.getParameter("q" + id);

                // ================= SCORE =================

                if(userAnswer != null &&
                   userAnswer.equalsIgnoreCase(correctAnswer)){

                    score++;
                }

                // ================= STORE USER ANSWER =================

                userAnswers.put(id, userAnswer);

                // ================= STORE QUESTION DATA =================

                Map<String,String> q =
                        new HashMap<>();

                q.put("id", id);
                q.put("question",
                        rs.getString("question"));

                q.put("option1",
                        rs.getString("option1"));

                q.put("option2",
                        rs.getString("option2"));

                q.put("option3",
                        rs.getString("option3"));

                q.put("option4",
                        rs.getString("option4"));

                q.put("answer",
                        correctAnswer);

                questions.add(q);
            }

            // ================= SAVE RESULT =================

            new ResultDAO().save(user, total, score);

            // ================= SEND DATA TO JSP =================

            req.setAttribute("score", score);

            req.setAttribute("total", total);

            req.setAttribute("questions", questions);

            req.setAttribute("userAnswers", userAnswers);

            req.getRequestDispatcher("result.jsp")
                    .forward(req, res);

            con.close();

        } catch(Exception e){

            e.printStackTrace();

            res.getWriter().println(
                    "Error : " + e.getMessage()
            );
        }
    }

    protected void doGet(HttpServletRequest req,
                         HttpServletResponse res)
            throws ServletException, IOException {

        doPost(req, res);
    }
}