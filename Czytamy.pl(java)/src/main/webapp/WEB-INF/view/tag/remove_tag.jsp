<%@ page import="pl.czytamy.models.User" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
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
            width: 600px;
            margin: 50px auto;
            background-color: #eaeaea;
        }
        #registrationBox{
            padding: 40px;
            text-align: center;
        }
        .textBox{
            font-size: 15px;
            width: 100%;
            height: 30px;
            padding: 10px;
            background-color: #eaeaea;
            border-top: none;
            border-right: none;
            border-left: none;
            border-bottom: gray 2px solid;
        }
        .textBox:hover{
            border-bottom: #FF6700 2px solid;
        }
        .textBox:focus{
            border-bottom: #FF6700 2px solid;
            outline: none
        }
        .element{
            text-align: left;
            margin: 30px 10px;
            font-size: 13px;
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
            font-size: 20px;
            border: #FF6700 solid 2px;
            padding: 10px 20px;
            background-color: #eaeaea;
        }
        #createAccount:hover{
            background-color: #FF6700;
            color: white;
        }
        .error{
            font-size: 14px;
            color: red;
        }
    </style>
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
    <div id = "registrationBox">
        <h1>Usuń tag</h1>
        <form:form method="POST" modelAttribute="form" action="removeTag" accept-charset="UTF-8">
            <div class="element">
                <%if(request.getAttribute("error") == null) {%>
                <div>Tag: </div>
                <%} else { String error =  request.getAttribute("error").toString();%>
                <div style="float: left">Tag: </div>
                <div style="float: left; margin-left: 10px" class="error"><%=error%></div>
                <%}%>
                <form:input path="name" cssClass="textBox" placeholder = "Wpisz nazwe taga do usunięcia"/>
            </div>
            <div style="margin-top: 80px">
                <input type="submit" placeholder="Utwórz konto" value="removeTag" id = "createAccount"/>
            </div>
        </form:form>
    </div>
</div>
</body>
</html>
