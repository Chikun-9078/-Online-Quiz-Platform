<%@ page session="true" %>
<%
    // ================= CACHE PROTECTION =================
    response.setHeader("Cache-Control",
            "no-cache, no-store, must-revalidate"); // HTTP 1.1

    response.setHeader("Pragma", "no-cache"); // HTTP 1.0

    response.setDateHeader("Expires", 0); // Proxies

    // ================= SESSION CHECK =================
    HttpSession sessionObj = request.getSession(false);

    if(sessionObj == null ||
       sessionObj.getAttribute("user") == null){

        response.sendRedirect("login.html");
        return;
    }

    String user =
        (String) sessionObj.getAttribute("user");
%>

<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, sans-serif;
}

body{
    background:#f1f3f6;
}

/* ================= HEADER ================= */

.top-header{
    background:#1d3557;
    color:white;
    padding:14px 25px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    position:fixed;
    width:100%;
    top:0;
    z-index:1000;
}

.logo-title{
    font-size:20px;
    font-weight:bold;
}

.timer-box{
    background:white;
    color:#1d3557;
    padding:10px 18px;
    border-radius:5px;
    font-weight:bold;
}

/* ================= MAIN ================= */

.main-wrapper{
    display:flex;
    margin-top:75px;
    height:calc(100vh - 75px);
}

/* ================= LEFT SIDE ================= */

.quiz-container{
    width:82%;
    padding:20px;
}

/* ================= QUESTION CARD ================= */

.quiz-box{
    background:white;
    border:1px solid #ddd;
    border-radius:6px;
    padding:25px;
    display:none;
}

.quiz-box.active{
    display:block;
}

.question-title{
    font-size:24px;
    font-weight:bold;
    margin-bottom:20px;
}

.question-text{
    font-size:22px;
    line-height:1.6;
    margin-bottom:30px;
}

/* ================= OPTIONS ================= */

/* ================= OPTIONS ================= */

.option{
    display:flex;
    align-items:flex-start;
    gap:12px;

    width:100%;

    border:1px solid #d0d0d0;
    padding:18px;
    margin-bottom:18px;

    border-radius:6px;

    transition:0.3s;
    cursor:pointer;

    font-size:20px;
    line-height:1.6;

    background:white;

    word-break:break-word;
}

.option:hover{
    background:#eef4ff;
    border-color:#2a6fdb;
}

.option input{
    margin-top:5px;
    transform:scale(1.3);
    cursor:pointer;
    flex-shrink:0;
}

/* ================= BUTTONS ================= */

.question-actions{
    display:flex;
    justify-content:space-between;
    margin-top:30px;
}

.btn{
    border:none;
    padding:12px 24px;
    border-radius:4px;
    cursor:pointer;
    font-size:16px;
    font-weight:bold;
}

.prev-btn{
    background:#6c757d;
    color:white;
}

.next-btn{
    background:#007bff;
    color:white;
}

.submit-btn{
    background:#28a745;
    color:white;
}

/* ================= RIGHT PANEL ================= */

.side-panel{
    width:18%;
    background:#ffffff;
    border-left:1px solid #ddd;
    padding:20px;
    overflow-y:auto;
}

.side-panel h3{
    margin-bottom:20px;
    color:#1d3557;
}

.status-box{
    display:flex;
    gap:15px;
    margin-bottom:20px;
    flex-wrap:wrap;
}

.status{
    font-size:14px;
}

.q-grid{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:10px;
}

.q-btn{
    width:45px;
    height:45px;
    border:none;
    border-radius:4px;
    background:#e9ecef;
    cursor:pointer;
    font-weight:bold;
}

.q-btn:hover{
    background:#007bff;
    color:white;
}

/* ANSWERED */
.answered-q{
    background:#28a745;
    color:white;
}

/* CURRENT ACTIVE */
.active-q{
    background:#ff6b00 !important;
    color:white;
}

/* ================= WARNING BOX ================= */

.warning-box{
    background:#fff3cd;
    border:1px solid #ffeeba;
    padding:15px;
    margin-bottom:25px;
    border-radius:5px;
    color:#856404;
    font-weight:bold;
}
</style>
</head>

<body>

<!-- HEADER -->
<div class="top-header">

    <div class="logo-title">
        Online Assessment
    </div>

    <div class="timer-box">
        Time Left :
        <span id="timer">05:00</span>
    </div>

</div>

<div class="main-wrapper">

    <!-- LEFT SIDE -->
    <div class="quiz-container">

        <div class="warning-box">
            ⚠ Note: This question is mandatory for you to attempt.
        </div>

<form action="SubmitQuizServlet" method="post">

<%
List<Map<String, String>> questions =
(List<Map<String, String>>) request.getAttribute("questions");

if(questions != null && !questions.isEmpty()){

    int i = 1;

    for(Map<String, String> q : questions){
%>

<div class="quiz-box <%= (i==1) ? "active" : "" %>"
     id="question<%=i%>">

    <div class="question-title">
        Question No. <%=i%>
    </div>

    <div class="question-text">
        <%=q.get("question")%>
    </div>

    <label class="option">
        <input type="radio"
               name="q<%=q.get("id")%>"
               value="A">

        A. <%=q.get("option1")%>
    </label>

    <label class="option">
        <input type="radio"
               name="q<%=q.get("id")%>"
               value="B">

        B. <%=q.get("option2")%>
    </label>

    <label class="option">
        <input type="radio"
               name="q<%=q.get("id")%>"
               value="C">

        C. <%=q.get("option3")%>
    </label>

    <label class="option">
        <input type="radio"
               name="q<%=q.get("id")%>"
               value="D">

        D. <%=q.get("option4")%>
    </label>

    <div class="question-actions">

        <% if(i > 1){ %>

        <button type="button"
                class="btn prev-btn"
                onclick="showQuestion(<%=i-1%>)">

            Previous

        </button>

        <% } else { %>

        <div></div>

        <% } %>

        <% if(i < questions.size()){ %>

        <button type="button"
                class="btn next-btn"
                onclick="showQuestion(<%=i+1%>)">

            Save & Next

        </button>

        <% } else { %>

        <button type="submit"
                class="btn submit-btn">

            Submit Quiz

        </button>

        <% } %>

    </div>

</div>

<%
        i++;
    }
}
%>

</form>
</div>

<!-- RIGHT PANEL -->
<div class="side-panel">

    <h3>Choose Question</h3>

    <div class="status-box">
        <div class="status">🟢 Answered</div>
        <div class="status">🟠 Not Answered</div>
        <div class="status">⚪ Not Visited</div>
    </div>

    <div class="q-grid">

<%
if(questions != null){

    for(int j=1; j<=questions.size(); j++){
%>

<button type="button"
        class="q-btn"
        onclick="showQuestion(<%=j%>)">

    <%=j%>

</button>

<%
    }
}
%>

    </div>

</div>

</div>

<!-- SCRIPT -->
<script>

/* =========================================
   START QUIZ SECURITY
========================================= */

let warningCount = 0;
let quizSubmitted = false;

/* =========================================
   SHOW QUESTION
========================================= */

function showQuestion(num){

    let allQuestions =
        document.querySelectorAll(".quiz-box");

    allQuestions.forEach(q => {
        q.classList.remove("active");
    });

    document
        .getElementById("question" + num)
        .classList.add("active");

    let allBtns =
        document.querySelectorAll(".q-btn");

    // REMOVE ACTIVE ONLY
    allBtns.forEach(btn => {
        btn.classList.remove("active-q");
    });

    // UPDATE ANSWERED STATUS
    updateQuestionStatus();

    // CURRENT QUESTION = ORANGE
    allBtns[num - 1]
        .classList.add("active-q");
}


/*update Questions Status*/
 function updateQuestionStatus() {

    let allBtns =
        document.querySelectorAll(".q-btn");

    allBtns.forEach((btn, index) => {

        let qBox =
            document.getElementById(
                "question" + (index + 1)
            );

        let selected =
            qBox.querySelector(
                "input[type='radio']:checked"
            );

        // REMOVE ONLY ANSWERED COLOR
        btn.classList.remove("answered-q");

        // IF ANSWERED => GREEN
        if(selected){
            btn.classList.add("answered-q");
        }
    });

}

 document
 .querySelectorAll("input[type='radio']")
 .forEach(radio => {

     radio.addEventListener(
         "change",
         function(){

             updateQuestionStatus();
         }
     );

 });
 
 
 
 
 
/* =========================================
   TIMER
========================================= */

let time = 300;

let timer = setInterval(function(){

    if(quizSubmitted) return;

    let minutes = Math.floor(time / 60);
    let seconds = time % 60;

    seconds = seconds < 10
        ? "0" + seconds
        : seconds;

    document.getElementById("timer").innerText =
        minutes + ":" + seconds;

    time--;

    if(time < 0){

        clearInterval(timer);

        autoSubmitQuiz(
            "Time Up! Quiz Submitted."
        );
    }

}, 1000);

/* =========================================
   AUTO SUBMIT FUNCTION
========================================= */

function autoSubmitQuiz(message){

    if(quizSubmitted) return;

    quizSubmitted = true;

    alert(message);

    document.forms[0].submit();
}

/* =========================================
   DISABLE BACK BUTTON
========================================= */

history.pushState(null, null, location.href);

window.onpopstate = function () {

    history.go(1);
};

/* =========================================
   TAB SWITCH DETECTION
========================================= */

document.addEventListener(
    "visibilitychange",
    function () {

    if(document.hidden){

        warningCount++;

        // FIRST WARNING
        if(warningCount === 1){

            alert(
                "Warning!\n\n" +
                "Tab switching detected."
            );
        }

        // SECOND WARNING
        else if(warningCount === 2){

            alert(
                "Final Warning!\n\n" +
                "Next tab switch will submit quiz."
            );
        }

        // THIRD TIME
        else if(warningCount >= 3){

            autoSubmitQuiz(
                "Multiple tab switches detected.\nQuiz Submitted."
            );
        }
    }
});

/* =========================================
WINDOW BLUR DETECTION
========================================= */

window.addEventListener("blur", function(){

 if(quizSubmitted) return;

 warningCount++;

 // FIRST TIME = WARNING + AUTO SUBMIT
 alert(
     "Warning!\n\n" +
     "Window switching detected.\n" +
     "Quiz will be submitted automatically."
 );

 autoSubmitQuiz(
     "Window switch detected.\nQuiz Submitted."
 );

});
/* =========================================
   DISABLE RIGHT CLICK
========================================= */

document.addEventListener(
    "contextmenu",
    e => e.preventDefault()
);

/* =========================================
   DISABLE COPY / PASTE
========================================= */

["copy","cut","paste"].forEach(function(evt){

    document.addEventListener(evt, function(e){

        e.preventDefault();
    });

});

/* =========================================
DISABLE DEVTOOLS + ALT TAB
========================================= */

let altTabWarning = false;

document.addEventListener(
 "keydown",
 function(e){

 // ================= ALT + TAB =================
 if(e.altKey && e.key === "Tab"){

     e.preventDefault();

     // FIRST WARNING
     if(!altTabWarning){

         altTabWarning = true;

         alert(
             "Warning!\n\n" +
             "Alt + Tab is not allowed.\n" +
             "Next attempt will submit quiz."
         );
     }

     // SECOND TIME = SUBMIT
     else{

         autoSubmitQuiz(
             "Alt + Tab detected.\nQuiz Submitted."
         );
     }
 }

 // ================= F12 =================
 if(e.key === "F12"){
     e.preventDefault();
 }

 // ================= CTRL + SHIFT + I =================
 if(
     e.ctrlKey &&
     e.shiftKey &&
     e.key.toLowerCase() === "i"
 ){
     e.preventDefault();
 }

 // ================= CTRL + SHIFT + J =================
 if(
     e.ctrlKey &&
     e.shiftKey &&
     e.key.toLowerCase() === "j"
 ){
     e.preventDefault();
 }

 // ================= CTRL + U =================
 if(
     e.ctrlKey &&
     e.key.toLowerCase() === "u"
 ){
     e.preventDefault();
 }

});

/* =========================================
   FULLSCREEN
========================================= */

function enableFullscreen(){

    let elem = document.documentElement;

    if(elem.requestFullscreen){

        elem.requestFullscreen()
        .catch(err => {
            console.log(err);
        });
    }
}

/* =========================================
   START FULLSCREEN AFTER CLICK
========================================= */

document.addEventListener(
    "click",
    function startFS(){

    enableFullscreen();

    document.removeEventListener(
        "click",
        startFS
    );

});

/* =========================================
   EXIT FULLSCREEN DETECTION
========================================= */

document.addEventListener(
    "fullscreenchange",
    function(){

    if(!document.fullscreenElement){

        autoSubmitQuiz(
            "Fullscreen exited.\nQuiz Submitted."
        );
    }
});

/* =========================================
   SESSION CHECK
========================================= */

setInterval(function(){

    fetch("SessionCheckServlet")

    .then(res => res.text())

    .then(data => {

        if(data.trim() === "invalid"){

            window.location.href =
                "login.html";
        }

    });

}, 3000);

</script>

</body>
</html>

