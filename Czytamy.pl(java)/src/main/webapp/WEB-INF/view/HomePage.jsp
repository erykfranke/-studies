<%@ page import="pl.czytamy.models.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE HTML>
<html lang="pl">
<head>
    <meta charset="UTF-8" />
    <title>Czytamy.pl</title>
    <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" type="text/css">

</head>
<body>

<header>
    <div class="beam" style="font-family: 'Lato', sans-serif;">
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
    <div id = "navigateBeam" style="font-family: 'Lato', sans-serif;">
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

    <div class="beam">
        <div style="font-size: 23px; margin-top: 30px; font-family: 'Lato', sans-serif;">Ostatnio wydane</div>
        <hr>
    <c:forEach var="bookCover" items="${boos}">
        <a href="http://localhost:8080/Czytamy_war_exploded/book/${bookCover.book_id}">
            <img src="${bookCover.photo}" style="float: left; margin: 10px 5px" width="210" height="298"/>
        </a>
    </c:forEach>
    </div>
    <div style="clear: both"></div>
</body>
</html>
