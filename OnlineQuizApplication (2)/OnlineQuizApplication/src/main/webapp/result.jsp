<%@ page session="true" %>
<%@ page import="java.util.*" %>

<%
/* ================= CACHE PROTECTION ================= */

response.setHeader(
    "Cache-Control",
    "no-cache, no-store, must-revalidate"
);

response.setHeader(
    "Pragma",
    "no-cache"
);

response.setDateHeader(
    "Expires",
    0
);

/* ================= SESSION CHECK ================= */

HttpSession sessionObj =
        request.getSession(false);

if(sessionObj == null ||
   sessionObj.getAttribute("user") == null){

    response.sendRedirect("login.html");
    return;
}

%>

<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Quiz Result</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    background:#f1f3f6;
    padding:40px;
}

.result-container{
    max-width:1100px;
    margin:auto;
}

.result-box{
    background:white;
    padding:35px;
    border-radius:10px;
    box-shadow:0 2px 12px rgba(0,0,0,0.1);
    margin-bottom:30px;
    text-align:center;
}

.result-box h1{
    color:#1d3557;
    margin-bottom:25px;
    font-size:36px;
}

.score{
    font-size:32px;
    color:#28a745;
    margin-bottom:20px;
    font-weight:bold;
}

.summary{
    display:flex;
    justify-content:center;
    gap:25px;
    flex-wrap:wrap;
    margin-top:20px;
}

.summary-card{
    background:#f8f9fa;
    border-radius:8px;
    padding:20px;
    width:200px;
    box-shadow:0 2px 8px rgba(0,0,0,0.08);
}

.summary-card h3{
    margin-bottom:10px;
    color:#1d3557;
}

.summary-card p{
    font-size:26px;
    font-weight:bold;
}

.review-box{
    background:white;
    padding:25px;
    border-radius:10px;
    box-shadow:0 2px 12px rgba(0,0,0,0.1);
}

.review-title{
    font-size:28px;
    margin-bottom:25px;
    color:#1d3557;
}

.question-card{
    border:1px solid #ddd;
    border-left:6px solid #999;
    border-radius:8px;
    padding:20px;
    margin-bottom:20px;
}

.correct{
    border-left-color:#28a745;
    background:#f1fff4;
}

.incorrect{
    border-left-color:#dc3545;
    background:#fff5f5;
}

.notvisited{
    border-left-color:#6c757d;
    background:#f5f5f5;
}

.q-title{
    font-size:20px;
    font-weight:bold;
    margin-bottom:15px;
    color:#1d3557;
}

.answer-row{
    margin:8px 0;
    font-size:17px;
}

.correct-text{
    color:#28a745;
    font-weight:bold;
}

.wrong-text{
    color:#dc3545;
    font-weight:bold;
}

.notvisited-text{
    color:#6c757d;
    font-weight:bold;
}

.btn-box{
    text-align:center;
    margin-top:35px;
}

.btn{
    display:inline-block;
    padding:14px 28px;
    background:#1d3557;
    color:white;
    text-decoration:none;
    border-radius:6px;
    font-size:18px;
    transition:0.3s;
}

.btn:hover{
    background:#16324f;
}

</style>

</head>

<body>

<%
List<Map<String,String>> questions =
(List<Map<String,String>>) request.getAttribute("questions");

Map<String,String> userAnswers =
(Map<String,String>) request.getAttribute("userAnswers");

Integer scoreObj =
(Integer) request.getAttribute("score");

Integer totalObj =
(Integer) request.getAttribute("total");

int score = (scoreObj != null) ? scoreObj : 0;
int total = (totalObj != null) ? totalObj : 0;

int correctCount = 0;
int incorrectCount = 0;
int notVisitedCount = 0;

if(questions == null){
    questions = new ArrayList<Map<String,String>>();
}

if(userAnswers == null){
    userAnswers = new HashMap<String,String>();
}

/* ================= COUNTING ================= */

for(Map<String,String> q : questions){

    String id = q.get("id");

    String userAns = userAnswers.get(id);

    String correctAns = q.get("answer");

    if(userAns == null ||
       userAns.trim().isEmpty()){

        notVisitedCount++;
    }
    else if(userAns.trim()
            .equalsIgnoreCase(
                    correctAns.trim())){

        correctCount++;
    }
    else{

        incorrectCount++;
    }
}
%>

<div class="result-container">

    <!-- RESULT SUMMARY -->

    <div class="result-box">

        <h1>Quiz Result</h1>

        <div class="score">

            Score :
            <%= score %>
            /
            <%= total %>

        </div>

        <div class="summary">

            <div class="summary-card">

                <h3>Correct</h3>

                <p style="color:#28a745;">
                    <%= correctCount %>
                </p>

            </div>

            <div class="summary-card">

                <h3>Incorrect</h3>

                <p style="color:#dc3545;">
                    <%= incorrectCount %>
                </p>

            </div>

            <div class="summary-card">

                <h3>Not Visited</h3>

                <p style="color:#6c757d;">
                    <%= notVisitedCount %>
                </p>

            </div>

        </div>

    </div>

    <!-- QUESTION REVIEW -->

    <div class="review-box">

        <div class="review-title">
            Question Review
        </div>

<%
int i = 1;

for(Map<String,String> q : questions){

    String id = q.get("id");

    String userAns =
            userAnswers.get(id);

    String correctAns =
            q.get("answer");

    String statusClass = "";
    String statusText = "";

    if(userAns == null ||
       userAns.trim().isEmpty()){

        statusClass = "notvisited";

        statusText =
        "<span class='notvisited-text'>Not Visited</span>";
    }
    else if(userAns.trim()
            .equalsIgnoreCase(
                    correctAns.trim())){

        statusClass = "correct";

        statusText =
        "<span class='correct-text'>Correct</span>";
    }
    else{

        statusClass = "incorrect";

        statusText =
        "<span class='wrong-text'>Incorrect</span>";
    }

    /* ================= USER ANSWER TEXT ================= */

    String userAnswerText =
            "Not Answered";

    if(userAns != null){

        if(userAns.equals("A"))
            userAnswerText =
                    q.get("option1");

        else if(userAns.equals("B"))
            userAnswerText =
                    q.get("option2");

        else if(userAns.equals("C"))
            userAnswerText =
                    q.get("option3");

        else if(userAns.equals("D"))
            userAnswerText =
                    q.get("option4");
    }

    /* ================= CORRECT ANSWER TEXT ================= */

    String correctAnswerText = "";

    if(correctAns.equals("A"))
        correctAnswerText =
                q.get("option1");

    else if(correctAns.equals("B"))
        correctAnswerText =
                q.get("option2");

    else if(correctAns.equals("C"))
        correctAnswerText =
                q.get("option3");

    else if(correctAns.equals("D"))
        correctAnswerText =
                q.get("option4");
%>

        <div class="question-card <%= statusClass %>">

            <div class="q-title">

                Question <%= i %> :
                <%= q.get("question") %>

            </div>

            <div class="answer-row">

                <b>Your Answer :</b>

                <%= userAnswerText %>

            </div>

            <div class="answer-row">

                <b>Correct Answer :</b>

                <span class="correct-text">

                    <%= correctAnswerText %>

                </span>

            </div>

            <div class="answer-row">

                <b>Status :</b>

                <%= statusText %>

            </div>

        </div>

<%
i++;
}
%>

    </div>

    <!-- BUTTON -->

    <div class="btn-box">

        <a href="dashboard.jsp"
           class="btn">

            Back To Dashboard

        </a>

    </div>

</div>

<script>

/* ================= DISABLE BACK BUTTON ================= */

history.pushState(null, null, location.href);

window.onpopstate = function () {

    history.go(1);
};

</script>

</body>
</html>