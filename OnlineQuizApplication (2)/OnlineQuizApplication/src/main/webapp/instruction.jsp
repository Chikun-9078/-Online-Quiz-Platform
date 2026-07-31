<%@ page session="true" %>

<%
    response.setHeader("Cache-Control",
            "no-cache, no-store, must-revalidate");

    response.setHeader("Pragma", "no-cache");

    response.setDateHeader("Expires", 0);

    HttpSession sessionObj = request.getSession(false);

    if(sessionObj == null ||
       sessionObj.getAttribute("user") == null){

        response.sendRedirect("login.html");
        return;
    }

    String user =
        (String) sessionObj.getAttribute("user");
%>

<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Instructions</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Segoe UI, Arial, sans-serif;
}

body{
    background:#f1f3f6;
    overflow:hidden;
}

/* ================= TOP BLUE STRIP ================= */

.top-line{
    height:6px;
    background:#1a73e8;
}

/* ================= MAIN LAYOUT ================= */

.main-container{
    display:flex;
    height:calc(100vh - 6px);
}

/* ================= LEFT PANEL ================= */

.left-panel{
    width:82%;
    background:#ffffff;
    border-right:1px solid #c7c7c7;
    display:flex;
    flex-direction:column;
}

/* ================= HEADER ================= */

.header{
    background:#d9edf7;
    color:#2d3e50;
    padding:16px 22px;
    font-size:28px;
    font-weight:600;
    border-bottom:1px solid #bcdff1;
}

/* ================= CONTENT ================= */

.content{
    flex:1;
    overflow-y:auto;
    padding:35px 45px;
    line-height:1.8;
    font-size:19px;
    color:#222;
}

/* SCROLLBAR */
.content::-webkit-scrollbar{
    width:10px;
}

.content::-webkit-scrollbar-thumb{
    background:#9aa7b1;
    border-radius:5px;
}

.content h2{
    text-align:center;
    margin-bottom:35px;
    color:#1d3557;
    font-size:34px;
}

.content h3{
    color:#1d3557;
    margin-bottom:22px;
    text-decoration:underline;
    font-size:24px;
}

.content ol{
    margin-left:35px;
}

.content li{
    margin-bottom:16px;
}

/* ================= POINT BOX ================= */

.point-box{
    background:#f8fbff;
    border-left:5px solid #1a73e8;
    padding:18px 20px;
    margin-bottom:18px;
    border-radius:6px;
    box-shadow:0 2px 8px rgba(0,0,0,0.05);
    transition:0.3s;
}

.point-box:hover{
    transform:translateX(5px);
}

/* ================= STATUS ================= */

.status-title{
    margin-top:35px;
    margin-bottom:20px;
    font-size:24px;
    font-weight:600;
    color:#1d3557;
}

.status-row{
    display:flex;
    align-items:center;
    gap:18px;
    margin:18px 0;
}

.status-box{
    width:42px;
    height:42px;
    border-radius:6px;
    display:flex;
    justify-content:center;
    align-items:center;
    font-weight:bold;
    color:white;
    font-size:18px;
}

.gray{
    background:#d6d6d6;
    color:#222;
    border:1px solid #999;
}

.orange{
    background:#ff7a00;
}

.green{
    background:#28a745;
}

.purple{
    background:#7b4bc4;
}

/* ================= BOTTOM ================= */

.bottom-box{
    border-top:1px solid #d0d0d0;
    padding:18px 24px;
    background:#fafafa;
}

/* ================= CHECKBOX ================= */

.checkbox-box{
    font-size:17px;
    margin-bottom:28px;
    color:#222;
}

.checkbox-box input{
    transform:scale(1.3);
    margin-right:12px;
    cursor:pointer;
}

/* ================= BUTTON ================= */

.btn-container{
    text-align:center;
}

.start-btn{
    background:#5dade2;
    color:white;
    border:none;
    padding:15px 45px;
    font-size:20px;
    border-radius:4px;
    font-weight:600;
    opacity:0.5;
    cursor:not-allowed;
    transition:0.3s;
}

.start-btn.enabled{
    opacity:1;
    cursor:pointer;
    background:#3498db;
}

.start-btn.enabled:hover{
    background:#217dbb;
    transform:translateY(-2px);
}

/* ================= RIGHT PANEL ================= */

.right-panel{
    width:18%;
    background:#ffffff;
    display:flex;
    flex-direction:column;
    align-items:center;
    padding-top:55px;
}

/* PROFILE */

.profile-circle{
    width:90px;
    height:90px;
    border-radius:50%;
    background:#1a73e8;
    display:flex;
    justify-content:center;
    align-items:center;
    color:white;
    font-size:36px;
    font-weight:bold;
    margin-bottom:25px;
}

.user-name{
    font-size:24px;
    font-weight:600;
    color:#375a7f;
    text-align:center;
    padding:0 10px;
}

/* ================= INFO BOX ================= */

.exam-info{
    margin-top:40px;
    width:85%;
    background:#f7f9fc;
    border:1px solid #d6dde5;
    border-radius:6px;
    padding:18px;
}

.exam-info p{
    margin-bottom:14px;
    font-size:15px;
    color:#333;
}

/* ================= FOOTER ================= */

.footer{
    background:#607d8b;
    color:white;
    text-align:center;
    padding:8px;
    font-size:14px;
    letter-spacing:1px;
}

</style>
</head>

<body>

<div class="top-line"></div>

<div class="main-container">

    <div class="left-panel">

        <div class="header">
            Instructions
        </div>

        <div class="content">

            <h2>
                Please read the instructions carefully
            </h2>

            <h3>General Instructions:</h3>

<div class="point-box">
    1. Total duration of examination is 20 minutes.
</div>

<div class="point-box">
    2. Timer will appear on the top-right corner of the screen.
</div>

<div class="point-box">
    3. Do not refresh, switch tabs, or minimize the browser.
</div>

<div class="point-box">
    4. Fullscreen mode is mandatory throughout the assessment.
</div>

<div class="point-box">
    5. Clicking outside the exam window may auto submit the test.
</div>

            <br>

            <div class="status-row">

                <div class="status-box gray">
                    1
                </div>

                <div>
                    Not Visited
                </div>

            </div>

            <div class="status-row">

                <div class="status-box orange">
                    2
                </div>

                <div>
                    Current Question
                </div>

            </div>

            <div class="status-row">

                <div class="status-box green">
                    3
                </div>

                <div>
                    Answered Question
                </div>

            </div>

            <div class="status-row">

                <div class="status-box purple">
                    4
                </div>

                <div>
                    Marked For Review
                </div>

            </div>

        </div>

        <div class="bottom-box">

            <div class="checkbox-box">

                <input type="checkbox"
                       id="agreeCheck">

                I have read and understood the instructions.

            </div>

            <div class="btn-container">

                <button
                    id="startBtn"
                    class="start-btn"
                    disabled
                    onclick="startQuiz()">

                    I am ready to begin

                </button>

            </div>

        </div>

        <div class="footer">
            Version : 17.07.00
        </div>

    </div>

    <div class="right-panel">

    <div class="profile-circle">
        <%= user.substring(0,1).toUpperCase() %>
    </div>

    <div class="user-name">
        <%= user.toUpperCase() %>
    </div>

    <div class="exam-info">

        <p><b>Exam:</b> Online Assessment</p>

        <p><b>Total Questions:</b> 20</p>

        <p><b>Duration:</b> 20 Minutes</p>

        <p><b>Status:</b> Ready</p>

    </div>

</div>

<script>

let checkBox =
    document.getElementById("agreeCheck");

let startBtn =
    document.getElementById("startBtn");

checkBox.addEventListener("change", function(){

    if(this.checked){

        startBtn.disabled = false;

        startBtn.classList.add("enabled");
    }
    else{

        startBtn.disabled = true;

        startBtn.classList.remove("enabled");
    }

});

function startQuiz(){

    window.location.href = "QuizServlet";
}

</script>

</body>
</html>