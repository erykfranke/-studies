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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/fontello/css/fontello.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
    <title></title>
    <style>
        body{
            font-family: 'Lato', sans-serif;
        }
        #container{
            width: 1100px;
            margin-left: auto;
            margin-right: auto;
            margin-top: 40px;
        }
        #image{
            padding-left: 20px;
            padding-top: 20px;
            float: left;
        }
        #detail{
            float: left;
        }
        #title{
            background-color: #555555;
            color: white;
            font-size: 50px;
            padding-left: 20px;
            padding-top: 30px;
            padding-bottom: 30px;
            width: 764px;
            margin-top: 40px;
        }
        #numberBooks{
            font-size: 22px;
            padding: 15px;
        }
        #description{
            padding: 20px;
            font-size: 18px;
        }
        .element {
            float: left;
            padding: 3px;
            font-size: 18px;
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
        #listTitle{
            margin-top: 40px;
            font-size: 35px;
            margin-left: 30px;
            margin-right: 30px;
        }
        #list{
            margin-left: auto;
            margin-right: auto;
            width: 800px;
            padding: 30px;
        }
        #element{
            margin-top: 30px;
            margin-bottom: 30px;
        }
        #content{
            padding: 10px 50px;
            float: left;
        }
        .listElem{
            font-size: 20px;
            margin-top: 20px;
        }
        #numberOfOpinions {
            float: left;
            padding-right: 10px;
            padding-left: 10px;
            margin-left: 40px;
            margin-right: 40px;
            margin-top: 22px;
            border-left: #c5c5c5 1px solid;
            border-right: #c5c5c5 1px solid;
            color: #c5c5c5;
        }
        hr.main{
            border: solid lightgray 1px;
        }
        #editAuthor{
            font-size: 17px;
            border: #FF6700 solid 2px;
            padding: 7px 17px;
            background-color: #eaeaea;
            font-weight: normal;
        }
        #editAuthor:hover{
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
    <div style="background-color: #eaeaea">
        <div id = "image">
            <%  boolean vievfoto = false;
                if (request.getSession().getAttribute("user") != null) {
                    User user = (User)request.getSession().getAttribute("user");
                    if (user.getRole() == 2) { vievfoto = true; %>
            <a href="http://localhost:8080/Czytamy_war_exploded/authors/${author.id}/uploadPhoto">
                <img src="${pageContext.request.contextPath}/${author.photo}" width="246,4‬" height="350" style="border: white 15px solid"/>
            </a>
            <%}%>
            <%}%>
            <%if(!vievfoto) {%>
            <img src="${pageContext.request.contextPath}/${author.photo}" width="246,4‬" height="350" style="border: white 15px solid"/>
            <%}%>
        </div>
        <div id = "detail">
            <div id = "title">${author.name} ${author.surname}</div>
            <div style="padding-left: 40px; padding-right: 40px">
                <div id = numberBooks><i class="demo-icon icon-book" style="color: #FF6700"></i> ${books.size()} książek</div>
                <hr>
                <div class="element">Pisze książki:</div>
                <c:forEach var="category" items="${categories}">
                    <div class="element"><a href="">${category}</a>,</div>
                </c:forEach>
                <div style="clear: both"></div>
                <div style="padding: 3px; font-size: 17px">Urodzony: ${author.birth_date}</div>
            </div>
        </div>
        <div style="clear: both"></div>
        <div style="padding-left: 20px; padding-right: 20px; padding-top: 10px"><hr></div>
        <div id = "description">${author.description}</div>
        <% if (request.getSession().getAttribute("user") != null) {
            User user = (User)request.getSession().getAttribute("user");
            if (user.getRole() == 2) {%>
            <div style="float: right; margin-top: -3px; margin-right: 7px">
                <a href="http://localhost:8080/Czytamy_war_exploded/author/${author.id}/editAuthor" id="editAuthor">
                    Edytuj
                </a>
            </div>
            <div style="clear: both; height: 15px"></div>
            <%}%>
        <%}%>
    </div>
    <div id = "listTitle">Wszysktie książki</div>
    <hr>
    <div id = "list">
        <c:forEach var="books" items="${books}">
            <div id = "element">
                <div style="float: left">
                    <img src="${pageContext.request.contextPath}/${books.book_cover}" width="176" height="250">
                </div>
                <div id = "content">
                    <div class="listElem">
                        <a href="http://localhost:8080/Czytamy_war_exploded/book/${books.book_id}"> ${books.book_title}</a>
                    </div>
                    <div class="listElem" >
                            <a href="http://localhost:8080/Czytamy_war_exploded/author/${books.author_id}"> ${books.author_name} ${books.author_surname}</a>
                    </div>
                    <div class="listElem" style="float: left">Średnia ocen:</div>
                    <div class="listElem" style="color: #C92523; float: left; margin-left: 20px"><i class="demo-icon icon-star"></i></div>
                    <div class="listElem" style="color: #C92523; float: left; margin-left: 4px; font-size: 24px; margin-top: 18px">
                        <c:choose>
                            <c:when test="${books.average_rating != 'emp'}">
                                ${books.average_rating}
                            </c:when>
                            <c:otherwise>
                                0.0
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="listElem" style="float: left; margin-left: 4px;">/10</div>
                    <div id = "numberOfOpinions">
                            ${books.number_of_opinions} ocen
                    </div>
                </div>
                <div style="clear: both"></div>
                <hr class="main">
            </div>
        </c:forEach>
    </div>
</div>
</body>