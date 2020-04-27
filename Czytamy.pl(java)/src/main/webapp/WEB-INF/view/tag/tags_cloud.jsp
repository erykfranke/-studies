<%@ page import="pl.czytamy.models.User" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE HTML>
<html lang="pl">
<head>
    <meta charset="UTF-8" />
    <title>Chmura tagów książek</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/fontello/css/fontello.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
    <style>
        body{
            font-family: 'Lato', sans-serif;
        }
        #container{
            width: 1100px;
            margin-left: auto;
            margin-right: auto;
            margin-top: 30px;
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
        #createAccount{
            font-size: 17px;
            border: #FF6700 solid 2px;
            padding: 7px 17px;
            background-color: white;
        }
        #createAccount:hover{
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
    <div style="font-size: 25px; padding-top: 15px; padding-bottom: 10px">
        <div style="float: left; margin-top: 7px">Chmura tagów książek</div>
        <% if (request.getSession().getAttribute("user") != null) {
            User user = (User)request.getSession().getAttribute("user");
            if (user.getRole() == 2) {%>
            <div style="padding-right: 5px; padding-top: 5px; float: right">
                <a href="http://localhost:8080/Czytamy_war_exploded/removeTag" id="createAccount">
                    Usuń Tag
                </a>
            </div>
            <%}%>
        <%}%>
        <div style="clear: both"></div>
        <hr style="border: lightgray solid thin"/>
    </div>
    <c:forEach var = "tag" items="${list}">
        <a href="http://localhost:8080/Czytamy_war_exploded/books?sort=numberOfOpinionsDESC&tags_id=${tag.tag_id}" style="float: left; font-size: ${(tag.count*2)+14}px; padding: 4px">${tag.tag_name}</a>
    </c:forEach>
</div>
</body>
</html>