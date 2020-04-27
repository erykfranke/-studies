<%@ page import="pl.czytamy.models.User" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
%>
<%!
    private boolean checkParameter(String parameter, String value)
    {
        if (parameter == null){
            return false;
        } else {
            assert false;
            return parameter.equals(value);
        }
    }
    private String setFiltersURL(String sortValue, String category, String startLetter)
    {
        if (sortValue == null && startLetter == null){
            return "http://localhost:8080/Czytamy_war_exploded/publishers?category="+category;
        } else if (category == null && startLetter == null){
            return "http://localhost:8080/Czytamy_war_exploded/publishers?sort="+sortValue;
        } else if (category == null && sortValue == null){
            return "http://localhost:8080/Czytamy_war_exploded/publishers?startLetter="+startLetter;
        } else if (sortValue == null){
            return "http://localhost:8080/Czytamy_war_exploded/publishers?" +
                    "category="+category+
                    "&startLetter="+startLetter;
        } else if (category == null){
            return "http://localhost:8080/Czytamy_war_exploded/publishers?" +
                    "sort="+sortValue+
                    "&startLetter="+startLetter;
        } else if (startLetter == null){
            return "http://localhost:8080/Czytamy_war_exploded/publishers?" +
                    "sort="+sortValue+
                    "&category="+category;
        }
        else {
            assert false;
            return "http://localhost:8080/Czytamy_war_exploded/publishers?" +
                    "sort="+sortValue+
                    "&category="+category+
                    "&startLetter="+startLetter;
        }
    }
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
        }
        #filter{
            float: left;
            width: 360px;
        }
        .filterElement{
            margin: 20px 5px;
        }
        #list{
            float: left;
            width: 680px;
            margin-left: 30px;
            margin-right: 30px;
        }
        #listElement{
            float: left;
            width: 220px;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .beam__{
            font-size: 25px;
            font-weight: bold;
            margin-top: 50px;
            margin-bottom: 20px;
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
        hr.main{
            border: solid lightgray 1px;
        }
        hr.filter{
            margin-top: 30px;
            margin-bottom: 30px;
            border: solid lightgray 0.5px;
        }
        #sort{
            float: left;
            border-left: solid white 1px;
            border-top: solid white 1px;
            border-right: solid white 1px;
            border-bottom: solid lightgray 2px;
            font-size: 15px;
            padding: 5px 10px;
            -webkit-appearance: none;
            cursor: pointer;
        }
        #sort:hover{
            border-bottom: solid #FF6700 2px;
        }
        #sort:focus{
            outline: none;
            border-bottom: solid #FF6700 2px;
        }
        ul{
            list-style: none;
            padding-left: 2px;
            font-size: 18px;
            margin-top: 10px;
        }
        ul li:before{
            content: '\e802';
            color: #FF6700;
            padding: 5px;
        }
        li{
            margin-bottom: 5px;
        }
        .letter{
            float: left;
            padding: 2px;
        }
        #letterLink{
            width: 28px;
            height: 28px;
            display: block;
            background-color: #FF6700;
            color: white;
            font-size: 18px;
            text-align: center;
        }
        #letterLink:hover{
            background-color: #555555;
        }
        #addPublisher{
            font-size: 17px;
            border: #FF6700 solid 2px;
            padding: 7px 17px;
            background-color: white;
            font-weight: normal;
        }
        #addPublisher:hover{
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
                    User user__ = (User)request.getSession().getAttribute("user");%>
                Witaj <a href="http://localhost:8080/Czytamy_war_exploded/user/<%=user__.getId()%>"> <%=user__.getNick()%> </a> |
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
    <div id = "filter">
        <div class="beam__">
            FILTRY
            <hr class="main">
        </div>
        <div class="filterElement">
            <div style="float: left; font-size: 18px; padding: 5px 10px">
                Sortuj:
            </div>
            <select id="sort" onchange="location = this.value;">
                <option value="<%out.print(setFiltersURL("ASC", request.getParameter("category"), request.getParameter("startLetter")));%>"
                <% if(checkParameter(request.getParameter("sort"),"ASC")) {%>selected<% } %>>
                    AlfabetycznieA A-Z
                </option>
                <option value="<%out.print(setFiltersURL("DESC", request.getParameter("category"), request.getParameter("startLetter")));%>"
                <% if(checkParameter(request.getParameter("sort"),"DESC")) {%>selected<% } %>>
                    Alfabetycznie Z-A
                </option>
                <option value="<%out.print(setFiltersURL("bookASC", request.getParameter("category"), request.getParameter("startLetter")));%>"
                <% if(checkParameter(request.getParameter("sort"),"bookASC")) {%>selected<% } %>>
                    Najmniejsza liczba książek
                </option>
                <option value="<%out.print(setFiltersURL("bookDESC", request.getParameter("category"), request.getParameter("startLetter")));%>"
                <% if(checkParameter(request.getParameter("sort"),"bookDESC")) {%>selected<% } %>>
                    Największa liczba książek
                </option>
            </select>
        </div>
        <div style="clear: both"></div>
        <hr class="filter">
        <div class="filterElement">
           KSIĄŻKI Z KATEGORII:
            <ul>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"), "literatura piękna", request.getParameter("startLetter")));%>"
                    <% if(checkParameter(request.getParameter("category"),"literatura piękna")) {%>
                    style="color: #FF6700"<% } %>>
                        Literatura piękna
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"), "fanstatyka, fantasy, science fiction", request.getParameter("startLetter")));%>"
                    <% if(checkParameter(request.getParameter("category"),"fanstatyka, fantasy, science fiction")) {%>
                    style="color: #FF6700"<% } %>>
                        Fanstatyka, fantasy, science fiction
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"), "kryminał, sensacja, thiller", request.getParameter("startLetter")));%>"
                    <% if(checkParameter(request.getParameter("category"),"kryminał, sensacja, thiller")) {%>
                    style="color: #FF6700"<% } %>>
                        Kryminał, sensacja, thiller
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"), "literatura obyczajowa, romans", request.getParameter("startLetter")));%>"
                    <% if(checkParameter(request.getParameter("category"),"literatura obyczajowa, romans")) {%>
                    style="color: #FF6700"<% } %>>
                        Literatura obyczajowa, romans
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"), "litaratura faktu, publicystyka", request.getParameter("startLetter")));%>"
                    <% if(checkParameter(request.getParameter("category"),"litaratura faktu, publicystyka")) {%>
                    style="color: #FF6700"<% } %>>
                        Litaratura faktu, publicystyka
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"), "autobiografie, biografia, pamiętnik", request.getParameter("startLetter")));%>"
                    <% if(checkParameter(request.getParameter("category"),"autobiografie, biografia, pamiętnik")) {%>
                    style="color: #FF6700"<% } %>>
                        Autobiografie, biografia, pamiętnik
                    </a>
                </li>
            </ul>
        </div>
        <hr class="filter">
        <div class="filterElement">
            <div style="margin-bottom: 10px">ALFABETYCZNIE:</div>
            <% for(char i = 65; i <= 90; i++) {%>
                <div class="letter">
                    <a href="
                    <% if(!checkParameter(request.getParameter("startLetter"), String.valueOf(i))) {
                            out.print(setFiltersURL(request.getParameter("sort"), request.getParameter("category"), String.valueOf(i)));
                        } else {
                            out.print(setFiltersURL(request.getParameter("sort"), request.getParameter("category"), null));
                        }
                    %>"
                    id="letterLink" <% if(checkParameter(request.getParameter("startLetter"), String.valueOf(i))) {%>
                    style="background-color: #555555"<% } %>>
                        <%=i %>
                    </a>
                </div>
            <% } %>
            <div style="clear: both"></div>
        </div>
    </div>
    <div id = "list">
        <div class="beam__">
            <div style="float: left">
                WYDAWCY
            </div>
            <% if (request.getSession().getAttribute("user") != null) {
                User user = (User)request.getSession().getAttribute("user");
                if (user.getRole() == 2) {%>
                <div style="float: right; margin-top: -3px">
                    <a href="http://localhost:8080/Czytamy_war_exploded/publishers/addPublisher" id="addPublisher">
                        Dodaj wydawnictwo
                    </a>
                </div>
                <%}%>
            <%}%>
            <div style="clear: both"></div>
            <hr class="main">
        </div>
        <c:forEach var="publisher" items="${list}">
            <div id = "listElement">
                <a href="http://localhost:8080/Czytamy_war_exploded/publisher/${publisher.id}">
                        ${publisher.name}
                </a>
            </div>
        </c:forEach>
    </div>
</div>
