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
            resize: none;
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
        #select{
            font-size: 20px;
            border: #FF6700 solid 2px;
            padding: 10px 20px;
            background-color: #eaeaea;
        }
        #select:hover{
            background-color: #FF6700;
            color: white;
        }
        .select{
            border-left: solid #eaeaea 1px;
            border-top: solid #eaeaea 1px;
            border-right: solid #eaeaea 1px;
            border-bottom: solid gray 2px;
            font-size: 15px;
            width: 100%;
            height: 31px;
            padding: 3px;
            padding-left: 10px;
            background-color: #eaeaea;
            -webkit-appearance: none;
            cursor: pointer;
        }
        .select:hover{
            border-bottom: solid #FF6700 2px;
        }
        .select:focus{
            outline: none;
            border-bottom: solid #FF6700 2px;
        }
        .error{
            font-size: 14px;
            color: red;
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
    <div id = "registrationBox">
        <h1>Dodaj nową książke</h1>
        <form:form method="POST" modelAttribute="book" action="addBook" accept-charset="UTF-8">
            <div class="element">
                <div>Tytuł: </div>
                <form:input path="book.title" cssClass="textBox" placeholder = "Wpisz tytuł książki"/>
                <%if(request.getAttribute("title_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("title_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>Oryginalny Tytuł (opcjonalne): </div>
                <form:input path="book.original_title" cssClass="textBox" placeholder = "Wpisz oryginalny tytuł książki"/>
            </div>

            <div class="element">
                <div>Imię autora </div>
                <form:input path="author_name" cssClass="textBox" placeholder = "Wpisz imie autora"/>
                <%if(request.getAttribute("authorName_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("authorName_error").toString()%>
                </div>
                <%}%>
                <%if(request.getAttribute("author_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("author_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>Nazwisko autora </div>
                <form:input path="author_surname" cssClass="textBox" placeholder = "Wpisz nazwisko autora"/>
                <%if(request.getAttribute("authorSurname_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("authorSurname_error").toString()%>
                </div>
                <%}%>
                <%if(request.getAttribute("author_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("author_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>Wybierz kategorie</div>
                <form:select path="book.category" cssClass="select"  placeholder = "Wybierz kategorię książki">
                    <form:option value="literatura piękna" selected="true">literatura piękna</form:option>
                    <form:option value="fanstatyka, fantasy, sciencie fiction" selected="true">fanstatyka, fantasy, sciencie fiction</form:option>
                    <form:option value="kryminał, sensacja, thiller" selected="true">kryminał, sensacja, thiller</form:option>
                    <form:option value="literatura obyczajowa, romans" selected="true">literatura obyczajowa, romans</form:option>
                    <form:option value="literatura faktu, publicystyka" selected="true">literatura faktu, publicystyka</form:option>
                    <form:option value="autobiografie, biografia, pamiętnik" selected="true">autobiografie, biografia, pamiętnik</form:option>
                </form:select>
            </div>

            <div class="element">
                <div>Data wydania: </div>
                <form:input type="date" path="book.date_published" cssClass="textBox" placeholder = "Wpisz date wydnia ksiązki"/>
                <%if(request.getAttribute("datePublished_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("datePublished_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>Polska data wydania (opcjonalne)</div>
                <form:input type="date" path="book.polish_date_published" cssClass="textBox" placeholder = "Wpisz polską date wydnia ksiązki"/>
            </div>

            <div class="element">
                <div>Liczba stron </div>
                <form:input path="book.number_of_pages" cssClass="textBox" placeholder = "Wpisz liczbę stron książki"/>
                <%if(request.getAttribute("pages_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("pages_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>Język </div>
                <form:input path="book.language" cssClass="textBox" placeholder = "Wpisz język książki"/>
                <%if(request.getAttribute("language_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("language_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>ISBN </div>
                <form:input path="book.isbn" cssClass="textBox" placeholder = "Wpisz ISBN książki"/>
                <%if(request.getAttribute("isbn_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("isbn_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>ISBN </div>
                <form:input path="publisher_name" cssClass="textBox" placeholder = "Wpisz wydawcę książki"/>
                <%if(request.getAttribute("publisher_error") != null) {%>
                <div class="error">
                    <%=request.getAttribute("publisher_error").toString()%>
                </div>
                <%}%>
            </div>

            <div class="element">
                <div>Opis ksiązki (opcjonalne)</div>
                <form:input path="book.description" cssClass="textBox" placeholder = "Opis książki"/>
            </div>

            <div style="margin-top: 80px">
                <input type="submit" placeholder="Utwórz konto" value="addBook" id = "select"/>
            </div>
        </form:form>
    </div>
</div>
</body>
</html>
