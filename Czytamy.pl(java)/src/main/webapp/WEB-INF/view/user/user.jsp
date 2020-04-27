<%@ page import="pl.czytamy.models.User" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");


    boolean userAccount = false;
    if(request.getSession().getAttribute("user") != null) {
        User sessionUser = (User) request.getSession().getAttribute("user");
        User attributeUser = (User) request.getAttribute("user");
        if (sessionUser.getId() == attributeUser.getId()) {
            userAccount = true;
        }
    }

%>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
    <style>
        body{
            font-family: 'Lato', sans-serif;
        }
        #container{
            width: 800px;
            margin: 50px auto;
        }
        #UserBox{
            background-color: #eaeaea;
            padding: 10px 30px;
        }
        #main hr{
            border: solid 1px gray;
        }
        #leftRow{
            float: left;
            width: 110px;
            padding: 10px;
            text-align: center;
            font-size: 16px;
        }
        #leftRow a:hover{
            opacity: 80%;
        }
        #rightRow{
            float: left;
            width: 580px;
            padding-left: 30px;
            padding-top: 20px;
            font-size: 17px;
        }
        #opinionCount{
            margin: 0 10px;
            color: #FF6700;
            font-size: 22px;
        }
        a:link{
            color: #597194;
            text-decoration: none;
        }
        a:visited{
            color: #597194;
        }
        a:hover{
            color: #FF6700;
        }
        h1{
            font-size: 26px;
        }
        #editAccount{
            text-decoration: none;
            font-size: 18px;
            border: #FF6700 solid 2px;
            padding: 6px 16px;
            background-color: #eaeaea;
        }
        #editAccount:hover{
            background-color: #FF6700;
            color: white;
        }
    </style>
</head>
<body>
<header>
    <div class="beam">
        <div id = "H_logo"><a href="http://localhost:8080/Czytamy_war_exploded/">Czytamy.pl</a></div>
        <div style= "float:right">
            <div id = "UserPanel">
                <% if (request.getSession().getAttribute("user") == null) { %>
                <a href="http://localhost:8080/Czytamy_war_exploded/login" style="margin: 0 5px">
                    Zaloguj się
                </a> |
                <a href="http://localhost:8080/Czytamy_war_exploded/registration" style="margin: 0 5px">
                    Zarejstruj się
                </a>
                <%} else {
                    User user = (User)request.getSession().getAttribute("user");%>
                Witaj <a href="http://localhost:8080/Czytamy_war_exploded/user/<%=user.getId()%>"> <%=user.getNick()%> </a> |
                <a href="http://localhost:8080/Czytamy_war_exploded/logout" style="margin: 0 5px">
                    Wyloguj się
                </a>
                <%}%>
            </div>
            <input type="search" name="name" placeholder="Wpisz tytul ksiazki ktorej szukasz" id = "H_search">
        </div>
        <div style="clear: both"></div>
    </div>
    <div id = "navigateBeam">
        <div class="beam">
            <div class="navOption">
                <a href="http://localhost:8080/Czytamy_war_exploded/books?sort=numberOfOpinionsDESC">KSIĄŻKI</a>
            </div>
            <div class="navOption">
                <a href="http://localhost:8080/Czytamy_war_exploded/authors?sort=DESC">AUTORZY</a>
            </div>
            <div class="navOption">
                <a href="http://localhost:8080/Czytamy_war_exploded/publishers?sort=bookDESC">WYDAWNICTWA</a>
            </div>
            <div class="navOption">
                <a href="http://localhost:8080/Czytamy_war_exploded/tags">TAGI</a>
            </div>
            <div style="clear: both"></div>
        </div>
    </div>
</header>
<div id = "container">
    <div id = "UserBox">
        <%  if(userAccount) {%>
        <h1>WITAJ, ${user.nick.toUpperCase()}</h1>
        <%} else {%>
        <h1>${user.nick.toUpperCase()}</h1>
        <%}%>

        <hr id="main" style="margin-top: -10px">

        <div id= "leftRow">
            <%  if(userAccount) {%>
            <a href="http://localhost:8080/Czytamy_war_exploded/user/${user.id}/uploadAvatar">
                <img src="${pageContext.request.contextPath}/${user.photo}" alt="Avatar" width="100px" height="100px" style="border-radius: 50%;padding-bottom: 10px"/>
            </a>
            <%} else {%>
                <img src="${pageContext.request.contextPath}/${user.photo}" alt="Avatar" width="100px" height="100px" style="border-radius: 50%;padding-bottom: 10px"/>
            <%}%>
            <c:if test="${user.place != null}">
                <div class="info">
                    ${user.place.toUpperCase()}
                </div>
            </c:if>
            <c:if test="${user.gender != null}">
                <div class="info">
                    ${user.gender}
                </div>
            </c:if>

            <div class="info" style="margin-top: 20px"> STATUS </div>
            <div class="info">
            <c:choose>
                <c:when test="${user.role == 1}">
                    Czytlenik
                </c:when>
                <c:otherwise>
                    Bibliotekarz
                </c:otherwise>
            </c:choose>
            </div>
        </div>
        <div id = "rightRow">
            <div style="float: left">Zrecenzowanych książek</div>
            <div id = "opinionCount" style="float: left; margin-top: -3px">${opinionCount}</div>
            <div style="clear: both"></div>
            <hr style="margin: 20px 0">
            <div style="clear: both"></div>
            <div>
            <c:choose>
                <c:when test="${user.description != null}">
                    ${user.description}
                </c:when>
                <c:otherwise>
                    <%  if(userAccount) {%>
                    Aktualnie nie posiadasz opisu. Dodaj opis aby inni użytkownicy
                    mogli Cię lepiej poznać.
                    <%} else {%>
                    Ten użytkownik nie posiada opisu konta.
                    <%}%>
                </c:otherwise>
            </c:choose>
            </div>
            <div style="float: right;">
                <%  if(userAccount) {%>
                <a href="http://localhost:8080/Czytamy_war_exploded/user/${user.id}/edit" id="editAccount">Uzupełnij dane</a>
                <%}%>
            </div>
        </div>
        <div style="clear: both"></div>
    </div>
</div>
</body>
</html>
