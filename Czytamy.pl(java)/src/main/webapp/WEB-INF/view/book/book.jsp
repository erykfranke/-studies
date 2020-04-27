<%@ page import="pl.czytamy.models.User" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
%>
<%!
        private boolean checkParameter(HttpServletRequest parameter, String value)
        {
            if (parameter.getAttribute("haveOpinion") == null){
                return false;
            } else {
                assert false;
                return parameter.getAttribute("haveOpinion").toString().equals(value);
            }
        }
%>
<!DOCTYPE HTML>
<html lang="pl">
<head>
    <meta charset="UTF-8" />
    <title>${book.title}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/fontello/css/fontello.css" type="text/css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
    <style>
        body{
            font-family: 'Lato', sans-serif;
        }
        #container{
            margin-top: 60px;
            width: 1100px;
            margin-left: auto;
            margin-right: auto;
            font-family: 'Lato', sans-serif;
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
            padding: 20px;
            width: 638px;
            margin-top: 40px;
        }
        #author{
            font-size: 28px;
            padding: 20px;
        }
        #category{
            font-size: 25px;
            padding-left: 20px;
            padding-top: 5px;
            padding-bottom: 20px;
        }
        #description{
            padding: 20px;
            font-size: 18px;
        }
        .element{
            margin-top: 10px;
            font-size: 18px;
            float: left;
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
        #tag{
            float: left;
            padding: 5px;
            border: solid #597194 thin;
            margin-left: auto;
            margin-right: auto;
        }
        #tag:hover{
            background-color: #597194;
            color: white;
        }
        #addTag{
            float: left;
            padding: 5px;
            color: #FF6700;
            border: solid #FF6700 thin;
            margin-left: auto;
            margin-right: auto;
        }
        #addTag:hover{
            background-color: #FF6700;
            color: white;
        }
        #rating{
            padding: 10px;
            padding-top: 20px;
            padding-bottom: 20px;
            width: 190px;
            float: right;
            background-color: white;
            font-size: 18px;
            margin-right: 20px;
        }
        .ratingElement{
            text-align: center;
            font-size: 20px;
            padding: 2px;
            margin-left: auto;
            margin-right: auto;
        }
        .elem{
            float: left;
        }
        #listTitle{
            margin-top: 40px;
            font-size: 25px;
            margin-left: 30px;
            margin-right: 30px;
        }
        #list{
            width: 965px;
            margin-left: auto;
            margin-right: auto;
        }
        .photo{
            float: left;
            width: 50px;
            margin-left: 0px;
            margin-right: 20px;
        }
        .text{
            font-size: 17px;
            float: left;
            width: 850px;
            margin-right: 10px;
            background-color: #E2E6EC;
        }
        #triangle-topright {
            border-top: 40px solid #E2E6EC;
            border-left: 30px solid transparent;
            float: left;
            margin-top: 25px;
        }
        #triangle-topleft {
            width: 0;
            height: 0;
            border-top: 32px solid #E2E6EC;
            border-right: 32px solid transparent;
        }

        hr.main{
            border: solid lightgray 0.5px;
            margin-left: 10px;
            margin-right: 10px;
        }

        #textBox{
            margin-top: 15px;
            font-size: 15px;
            width: 90%;
            height: 70%;
            border: none;
            white-space: initial;
            overflow: hidden;
            resize: none;
        }
        #textBox:focus{
            outline: none
        }
        .slider {
            -webkit-appearance: none;
            width: 100%;
            height: 10px;
            background: lightgray;
            outline: none;
        }

        .slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 12px;
            height: 12px;
            background: #C92523;
            cursor: pointer;
        }
        #output{
            color: #C92523;
            font-size: 22px;
            border: none;
        }
        #output:hover{
            cursor: default;
        }
        #addComent{
            font-size: 17px;
            border: #FF6700 solid 2px;
            padding: 10px 20px;
            background-color: white;
        }
        #addComent:hover{
            background-color: #FF6700;
            color: white;
        }
        #editBook{
            font-size: 17px;
            border: #FF6700 solid 2px;
            padding: 7px 17px;
            background-color: #eaeaea;
            font-weight: normal;
        }
        #editBook:hover{
            background-color: #FF6700;
            color: white;
        }

    </style>
    <script>
        window.onload = function(){
            document.getElementById('author_site').href = 'http://localhost:8080/Czytamy_war_exploded/author/' + ${author.id};
            document.getElementById('publisher_site').href = 'http://localhost:8080/Czytamy_war_exploded/publisher/' + ${publisher.id};
        };
    </script>
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
                    <a href="http://localhost:8080/Czytamy_war_exploded/book/${book.id}/uploadCover">
                        <img src="${pageContext.request.contextPath}/${book.cover}" style="border: white 15px solid" height="500" width="352"/>
                    </a>
                    <%}%>
                <%}%>
                <%if(!vievfoto) {%>
                    <img src="${pageContext.request.contextPath}/${book.cover}" style="border: white 15px solid" height="500" width="352"/>
                <%}%>
            </div>
            <div id = "detail">
                <div id = "title">${book.title}</div>
                <div id = "author">
                    <a href="" id="author_site"> ${author.name} ${author.surname}</a>
                </div>
                <div id = "category">
                    <a href="http://localhost:8080/Czytamy_war_exploded/books?sort=numberOfOpinionsDESC&category=${book.category}">
                        ${book.category}
                    </a>
                </div>
                <div style="width: 628px; padding-left: 20px">
                    <hr>
                    <div style="float: left; width: 395px">
                        <c:if test="${book.original_title != null}">
                        <div>
                            <div class="element" style="width: 160px">Liczba stron:</div>
                            <div class="element" style="width: 200px">${book.original_title}</div>
                        </div>
                        </c:if>
                        <div style="clear: both">
                            <div class="element" style="width: 160px">Data wydania:</div>
                            <div class="element" style="width: 200px">${book.date_published}</div>
                        </div>
                        <c:if test="${book.polish_date_published != null}">
                        <div style="clear: both">
                            <div class="element" style="width: 160px">Liczba stron:</div>
                            <div class="element" style="width: 200px">${book.polish_date_published}</div>
                        </div>
                        </c:if>
                        <div style="clear: both">
                            <div class="element" style="width: 160px">Liczba stron:</div>
                            <div class="element" style="width: 200px">${book.number_of_pages}</div>
                        </div>
                        <div style="clear: both">
                            <div class="element" style="width: 160px">Język:</div>
                            <div class="element" style="width: 200px">${book.language}</div>
                        </div>
                        <div style="clear: both">
                            <div class="element" style="width: 160px">ISBN:</div>
                            <div class="element" style="width: 200px">${book.isbn}</div>
                        </div>
                        <div style="clear: both">
                            <div class="element" style="width: 160px">Wydawnictwo:</div>
                            <a href="" id="publisher_site" class="element" style="width: 200px">${publisher.name}</a>
                        </div>
                        <div style="clear: both">
                            <div class="element" style="width: 160px">Kategoria:</div>
                            <div class="element" style="width: 200px">${book.category}</div>
                        </div>
                    </div>
                    <div style="float: right">
                        <div id="rating">
                            <div class="ratingElement" style="margin-bottom: 16px">Średnia ocena:</div>
                            <div style="margin-left: auto; margin-right: auto; width: 120px">
                                <div class="elem" style="color: #C92523; margin-top: 18px"><i class="demo-icon icon-star"></i></div>
                                <div class="elem" style="font-size: 37px; color: #C92523">
                                <c:choose>
                                    <c:when test="${averageOpinion != 'emp'}">
                                        ${averageOpinion}
                                    </c:when>
                                    <c:otherwise>
                                            0.0
                                    </c:otherwise>
                                </c:choose>
                                </div>
                                <div class="elem" style="font-size: 20px; margin-top: 15px; margin-left: 5px">/ 10</div>
                                <div style="clear: both"></div>
                            </div>
                            <div class="ratingElement" style="margin-top: 16px">z ${opinions.size()} opini</div>
                        </div>
                    </div>
                    <div style="clear: both">
                        <div class="element" style="width: 160px">Tagi:</div>
                        <div style="width: 400px; float: left; margin-top: 5px">
                        <c:forEach var="tag" items="${tags}">
                            <div style="padding-right: 5px; padding-top: 5px; float: left">
                                <a href="http://localhost:8080/Czytamy_war_exploded/books?sort=numberOfOpinionsDESC&tags_id=${tag.id}" id="tag">
                                        ${tag.name}
                                </a>
                            </div>
                        </c:forEach>
                            <% if (request.getSession().getAttribute("user") != null) {
                             User user2 = (User)request.getSession().getAttribute("user");
                                if (user2.getRole() == 2) {%>
                                <div style="padding-right: 5px; padding-top: 5px; float: left">
                                    <a href="http://localhost:8080/Czytamy_war_exploded/book/${book.id}/addTag" id="addTag">
                                        Dodaj Tag
                                    </a>
                                </div>
                                <%}%>
                            <%}%>
                        </div>
                    </div>
                </div>
            </div>
            <div style="clear: both"></div>
            <div id = "description">${book.description}</div>
            <% if (request.getSession().getAttribute("user") != null) {
                User user3 = (User)request.getSession().getAttribute("user");
                if (user3.getRole() == 2) {%>
                <div style="float: right; margin-top: -3px; margin-right: 7px">
                    <a href="http://localhost:8080/Czytamy_war_exploded/book/${book.id}/editBook" id="editBook">
                        Edytuj
                    </a>
                </div>
                <div style="clear: both; height: 15px"></div>
                <%}%>
            <%}%>
        </div>
        <div id = "listTitle">OPINIE [${opinions.size()}]</div>
        <hr class="main">




        <div style="padding-top: 30px; margin-left: 70px; margin-right: 100px; height: 270px">
        <% if (request.getSession().getAttribute("user") != null) {
        User user = (User)request.getSession().getAttribute("user");
            if (checkParameter(request ,"false")) {%>
            <form:form method="POST" modelAttribute="userOpinion" action="addComment">
            <form:hidden path="user_id" value = "${userOpinion.user_id}"/>
            <form:hidden path="book_id" value = "${userOpinion.book_id}"/>
            <div style="padding: 10px 0px">DODAJ OPINIĘ</div>
            <div style="text-align: center">
                <div style="float: left; width: 150px; height: 120px; background-color: #E2E6EC">
                    <div style="margin-top: 20px">
                        <img src="${pageContext.request.contextPath}/<%=user.getPhoto()%>" alt="Avatar" width="80px" height="80px" style="border-radius: 50%"/>
                    </div>
                </div>

            <div style="float: left; width: 750px; height: 120px; background-color: #eaeaea">
                <form:textarea path="comment" id="textBox" placeholder="Wpisz treść opini o książce"/>
            </div>
            </div>
            <div style="clear: both"></div>
        <div id = "triangle-topleft" style="float: left"></div>
        <div style="margin-top: 50px; margin-left: 70px">
            <div style="float: left; margin-top: 3px">TWOJA OCENA</div>
            <div style="float: left; margin-left: 10px; margin-top: 3px">
                <input type="range" name="sliderInput" class="slider" oninput="output.value=this.value" min="0" max="10">
            </div>
            <div style="float: left; margin-left: 10px">
                <form:input path="rating" type="text" id="output" value="5" readonly="true" style="width: 24px"/>
                <i class="demo-icon icon-star" style = "color: #C92523; font-size: 17px"></i>
            </div>
        </div>
        <input type="submit" id="addComent" placeholder="Utwórz konto" value="addComment" style="float:right; margin-top: -10px"/>
        </div>
        <hr class="main" style="margin-bottom: 60px">
        </form:form>
        <%} else {%>
            <form:form method="POST" modelAttribute="userOpinion" action="editComment">
            <form:hidden path="user_id" value = "${userOpinion.user_id}"/>
            <form:hidden path="book_id" value = "${userOpinion.book_id}"/>
            <div style="padding: 10px 0px">TWOJA OPINIA</div>
            <div style="text-align: center">
                <div style="float: left; width: 150px; height: 120px; background-color: #E2E6EC">
                    <div style="margin-top: 20px">
                        <img src="${pageContext.request.contextPath}/<%=user.getPhoto()%>" alt="Avatar" width="80px" height="80px" style="border-radius: 50%"/>
                    </div>
                </div>
                <div style="float: left; width: 750px; height: 120px; background-color: #eaeaea">
                    <form:textarea path="comment" id="textBox" placeholder="Wpisz treść opini o książce" value="${userOpinion.comment}" cssStyle="border: solid 1px #FF6700"/>
                </div>
                <div style="clear: both"></div>
            </div>
            <div id = "triangle-topleft" style="float: left"></div>
            <div style="margin-top: 50px; margin-left: 70px">
                <div style="float: left; margin-top: 3px">TWOJA OCENA</div>
                <div style="float: left; margin-left: 10px; margin-top: 3px">
                    <input type="range" name="sliderInput" class="slider" value="${userOpinion.rating}" oninput="output.value=this.value" min="0" max="10">
                </div>
                <div style="float: left; margin-left: 10px">
                    <form:input path="rating" type="text" id="output" value="${userOpinion.rating}" readonly="true" cssStyle="width: 24px"/>
                    <i class="demo-icon icon-star" style = "color: #C92523; font-size: 17px"></i>
                </div>
            </div>
            <input type="submit" id="addComent" placeholder="Utwórz konto" value="editComment" style="float:right; margin-top: -10px"/>
            </form:form>
            <form:form method="POST" modelAttribute="userOpinion" action="deleteComment">
                <form:hidden path="book_id" value = "${userOpinion.book_id}"/>
                <form:hidden path="id" value = "${userOpinion.id}"/>
                <input type="submit" id="addComent" placeholder="Utwórz konto" value="deleteComment" style="float:right; margin-top: -10px; margin-right: 20px"/>
            </form:form>
        </div>
        <hr class="main" style="margin-bottom: 60px">

        <%}%>
    <%}%>

        <div id = "list">
            <c:forEach var="userOpinion" items="${usersOpinions}">
            <div class="photo">
                <img src="${pageContext.request.contextPath}/${userOpinion.user.photo}" alt="Avatar" width=65px" height="65px" style="border-radius: 50%"/>
            </div>
                <div id="triangle-topright"></div>
            <div class="text">
                <div style="padding: 20px">
                    <div style="float: left; padding-right: 20px; border-right: 1px darkgray solid">
                        <a href="http://localhost:8080/Czytamy_war_exploded/user/${userOpinion.user.id}">${userOpinion.user.nick}</a>
                    </div>
                    <div style="float: left; padding-left: 20px">${userOpinion.opinion.date_published}</div>
                    <div style="float: right; width: 100px">
                        <div style="float: right; margin-left: 4px; margin-top: 4px; font-size: 18px">/10</div>
                        <div style="float: right; color: #C92523; font-size: 22px">${userOpinion.opinion.rating}</div>
                        <div style="float: right; color: #C92523; margin-right: 4px;  margin-top: 9px; font-size: 14px"><i class="demo-icon icon-star"></i></div>
                    </div>
                    <div style="clear: both"></div>
                </div>
                <div style="margin-left: 20px; margin-right: 20px; margin-bottom: 20px; padding-top: 20px; border-top: 1px darkgray solid">
                    ${userOpinion.opinion.comment}
                </div>
            </div>
                <div style="clear: both; padding-top: 50px"></div>
            </c:forEach>
        </div>
    </div>
</body>