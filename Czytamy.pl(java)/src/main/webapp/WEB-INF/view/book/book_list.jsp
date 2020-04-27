<%@ page import="java.util.List" %>
<%@ page import="pl.czytamy.models.Tag" %>
<%@ page import="pl.czytamy.models.Author" %>
<%@ page import="pl.czytamy.models.Publisher" %>
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

    private boolean checkParameter(String[] parameter, String value)
    {
        if (parameter == null){
            return false;
        } else {
            assert false;
            return parameter[0].contains(value);
        }
    }

    private String setFiltersURL(
            String sort,
            String category,
            String[] tags_id,
            String[] authors_id,
            String[] publishers_id,
            String date_published_from,
            String date_published_to
    )
    {
        String resultURL = "http://localhost:8080/Czytamy_war_exploded/books?";
        if (sort != null){
            resultURL += "&sort="+sort;
        }
        if (category != null){
            resultURL += "&category="+category;
        }
        if (tags_id != null){
            resultURL += "&tags_id="+tags_id[0];
        }
        if (authors_id != null){
            resultURL += "&authors_id="+authors_id[0];
        }
        if (publishers_id != null){
            resultURL += "&publishers_id="+publishers_id[0];
        }
        if (date_published_from != null){
            resultURL += "&date_published_from="+date_published_from;
        }
        if (date_published_to != null){
            resultURL += "&date_published_to="+ date_published_to;
        }
        return resultURL;
    }

    private String[] setFilterLink(String id_value, String[] parameters){
        String[] currentTags = new String[1];
        String new_id;
        if (parameters != null) {
            new_id = parameters[0];
            if (!new_id.contains(String.valueOf(id_value))) {
                new_id += "," + id_value;
            } else {
                if (new_id.length() == 1) {
                    return null;
                } else if (new_id.startsWith(String.valueOf(id_value))) {
                    new_id = new_id.replace(id_value + ",", "");
                } else {
                    new_id = new_id.replace("," + id_value, "");
                }
            }
        } else {
            new_id = id_value;
        }
        currentTags[0] = new_id;
        return currentTags;
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
        #filters{
            float: left;
            width: 360px;
        }
        #filters a:link{
            color: black;
        }
        #filters a:visited{
            color: black;
        }
        #filters a:hover{
            color: #FF6700;
        }

        .sort{
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
        .sort:hover{
            border-bottom: solid #FF6700 2px;
        }
        .sort:focus{
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
        .check_box{
            height: 11px;
            width: 11px;
            float: left;
            border: darkgray 1px solid;
            margin-top: 6px;
            margin-left: 5px;
        }


        .filterContentList{
            width: 100%;
            height: 150px;
            overflow: auto;
        }
        .tag{
            font-size: 18px;
            width: 100%;
        }
        .filterContentList::-webkit-scrollbar {
            width: 5px;
        }
        /* Track */
        .filterContentList::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        /* Handle */
        .filterContentList::-webkit-scrollbar-thumb {
            background: #888;
        }
        /* Handle on hover */
        .filterContentList::-webkit-scrollbar-thumb:hover {
            background: #555;
        }

        .date{
            margin-left: 5px;
            margin-right: 5px;
            padding: 5px;
            font-size: 15px;
            width: 40px;
            border-left: none;
            border-top: none;
            border-right: none;
            border-bottom: lightgray 2px solid;
            text-align: center;
        }
        .date:hover{
            border-bottom: #FF6700 2px solid;
        }
        .date:focus{
            border-bottom: #FF6700 2px solid;
            outline: none
        }
        input[type=number]::-webkit-inner-spin-button,
        input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        #list{
            float: left;
            width: 680px;
            margin-left: 30px;
            margin-right: 30px;
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
            margin-top: 20px;
            margin-bottom: 20px;
            border: solid lightgray 0.5px;
        }

        <!-- List Style -->

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
        #addBook{
            font-size: 17px;
            border: #FF6700 solid 2px;
            padding: 7px 17px;
            background-color: white;
            font-weight: normal;
        }
        #addBook:hover{
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
                    User _user = (User)request.getSession().getAttribute("user");%>
                Witaj <a href="http://localhost:8080/Czytamy_war_exploded/user/<%=_user.getId()%>"> <%=_user.getNick()%> </a> |
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
    <div id = "filters">
        <div class="beam__">
            FILTRY
            <hr class="main">
        </div>
        <div class="filterElement">
            <div style="float: left; font-size: 18px; padding: 5px 10px">
                Sortuj:
            </div>
            <select class="sort" onchange="location = this.value;">
                <option value="<%out.print(setFiltersURL("datePublishedASC",
                        request.getParameter("category"),
                       request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("sort"),"datePublishedASC")) {%>selected<% } %>>
                    Data wydania rosnąco
                </option>
                <option value="<%out.print(setFiltersURL("datePublishedDESC",
                        request.getParameter("category"),
                       request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("sort"),"datePublishedDESC")) {%>selected<% } %>>
                    Data wydania malejąco
                </option>
                <option value="<%out.print(setFiltersURL("ratingASC",
                        request.getParameter("category"),
                       request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("sort"),"ratingASC")) {%>selected<% } %>>
                    Ocena rosnąco
                </option>
                <option value="<%out.print(setFiltersURL("ratingDESC",
                        request.getParameter("category"),
                       request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("sort"),"ratingDESC")) {%>selected<% } %>>
                    Ocena malejąco
                </option>
                <option value="<%out.print(setFiltersURL("numberOfOpinionsASC",
                        request.getParameter("category"),
                       request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("sort"),"numberOfOpinionsASC")) {%>selected<% } %>>
                    Liczba ocen rosnąco
                </option>
                <option value="<%out.print(setFiltersURL("numberOfOpinionsDESC",
                        request.getParameter("category"),
                       request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("sort"),"numberOfOpinionsDESC")) {%>selected<% } %>>
                    Liczba ocen malejąco
                </option>
            </select>
        </div>
        <div style="clear: both"></div>
        <hr class="filter">
        <div class="filterElement">
            KSIĄŻKI Z KATEGORII:
            <ul>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"),
                        "literatura piękna",
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("category"),"literatura piękna")){%>
                        style="color: #FF6700"<% } %>>
                        Literatura piękna
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"),
                        "fanstatyka, fantasy, science fiction",
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("category"),"fanstatyka, fantasy, science fiction")){%>
                        style="color: #FF6700"<% } %>>
                        Fanstatyka, fantasy, science fiction
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"),
                        "kryminał, sensacja, thiller",
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("category"),"kryminał, sensacja, thiller")){%>
                        style="color: #FF6700"<% } %>>
                        Kryminał, sensacja, thiller
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"),
                        "literatura obyczajowa, romans",
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("category"),"literatura obyczajowa, romans")){%>
                        style="color: #FF6700"<% } %>>
                        Literatura obyczajowa, romans
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"),
                        "litaratura faktu, publicystyka",
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("category"),"litaratura faktu, publicystyka")){%>
                        style="color: #FF6700"<% } %>>
                        Litaratura faktu, publicystyka
                    </a>
                </li>
                <li>
                    <a href="<%out.print(setFiltersURL(request.getParameter("sort"),
                        "autobiografie, biografia, pamiętnik",
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                            <% if(checkParameter(request.getParameter("category"),"autobiografie, biografia, pamiętnik")){%>
                       style="color: #FF6700"<% } %>>
                        Autobiografie, biografia, pamiętnik
                    </a>
                </li>
            </ul>
        </div>
        <hr class="filter">
        <div class="filterElement">
            <div style="margin-bottom: 10px"> TAGI </div>
            <div class="filterContentList">
            <%  List<Tag> tags = (List<Tag>) request.getAttribute("tags");
            for (Tag tag : tags) {%>
                <div class="tag">
                    <div class="check_box"
                        <% if(checkParameter(request.getParameterValues("tags_id"), String.valueOf(tag.getId()))){%>
                        style="background-color: #FF6700"<% } %>>
                    </div>
                    <div style="float: left; margin-left: 10px">
                    <a href="<% out.print(setFiltersURL(request.getParameter("sort"),
                        request.getParameter("category"),
                        setFilterLink(String.valueOf(tag.getId()), request.getParameterValues("tags_id")),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameterValues("tags_id"), String.valueOf(tag.getId()))){%>
                        style="color: #FF6700"<% } %>>
                        <%=tag.getName()%>
                    </a>
                    </div>
                    <div style="clear: both"></div>
                </div>
            <%}%>
            </div>
        </div>
        <hr class="filter">
        <div class="filterElement">
            <div style="margin-bottom: 15px"> ROK WYDANIA </div>
            <div style="float: left; margin-top: 3px; font-size: 17px; margin-left: 30px; margin-right: 5px">od</div>
            <div style="float: left; margin-left: 5px; font-size: 19px; border-bottom: lightgray solid 2px; height: 25px">
                <div style="float: left"><i class="demo-icon icon-calendar" style="color: #FF6700"></i></div>
                <div style="float: left">
                <select class="sort" style="border-bottom: white; padding: 2px; font-size: 16px" onchange="location = this.value;">
                <% for (int i = 1500; i <= 2019; i++) { %>
                    <option value="<% out.print(setFiltersURL(request.getParameter("sort"),
                        request.getParameter("category"),
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        String.valueOf(i),
                        request.getParameter("date_published_to")));%>"
                        <% if(checkParameter(request.getParameter("date_published_from"),  String.valueOf(i))) {%>selected<% } %>>
                        <%=i%>
                    </option>
               <%}%>
                </select>
                </div>
            </div>
            <div style="float: left; margin-top: 3px; font-size: 17px; margin-left: 25px; margin-right: 5px">od</div>
            <div style="float: left; margin-left: 5px; font-size: 19px; border-bottom: lightgray solid 2px; height: 25px">
                <div style="float: left"><i class="demo-icon icon-calendar" style="color: #FF6700"></i></div>
                <div style="float: left">
                    <select class="sort" style="border-bottom: white; padding: 2px; font-size: 16px" onchange="location = this.value;">
                        <% for (int i = 1500; i <= 2019; i++) { %>
                        <option value="<% out.print(setFiltersURL(request.getParameter("sort"),
                        request.getParameter("category"),
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        String.valueOf(i)));%>"
                        <% if(checkParameter(request.getParameter("date_published_to"),  String.valueOf(i))) {%>
                                selected
                            <%} else if (request.getParameter("date_published_to") == null && i == 2019) { %>
                            selected
                            <%}%>>
                            <%=i%>
                        </option>
                        <%}%>
                    </select>
                </div>
            </div>
            <div style="clear: both"></div>
        </div>
        <hr class="filter">
        <div class="filterElement">
            <div style="margin-bottom: 10px"> AUTORZY </div>
            <%  List<Author> authors = (List<Author>) request.getAttribute("authors");
                for (Author author : authors) {%>
            <div class="tag">
                <div class="check_box"
                        <% if(checkParameter(request.getParameterValues("authors_id"), String.valueOf(author.getId()))){%>
                     style="background-color: #FF6700"<% } %>>
                </div>
                <div style="float: left; margin-left: 10px">
                    <a href="<% out.print(setFiltersURL(request.getParameter("sort"),
                        request.getParameter("category"),
                        request.getParameterValues("tags_id"),
                        setFilterLink(String.valueOf(author.getId()), request.getParameterValues("authors_id")),
                        request.getParameterValues("publishers_id"),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                            <% if(checkParameter(request.getParameterValues("authors_id"), String.valueOf(author.getId()))){%>
                       style="color: #FF6700"<% } %>>
                        <%out.println(author.getName()+" "+author.getSurname());%>
                    </a>
                </div>
                <div style="clear: both"></div>
            </div>
            <%}%>
        </div>
        <hr class="filter">
        <div class="filterElement">
            <div style="margin-bottom: 10px"> WYDAWNICTWA </div>
            <%  List<Publisher> publishers = (List<Publisher>) request.getAttribute("publishers");
                for (Publisher publisher : publishers) {%>
            <div class="tag">
                <div class="check_box"
                        <% if(checkParameter(request.getParameterValues("publishers_id"), String.valueOf(publisher.getId()))){%>
                     style="background-color: #FF6700"<% } %>>
                </div>
                <div style="float: left; margin-left: 10px">
                    <a href="<% out.print(setFiltersURL(request.getParameter("sort"),
                        request.getParameter("category"),
                        request.getParameterValues("tags_id"),
                        request.getParameterValues("authors_id"),
                        setFilterLink(String.valueOf(publisher.getId()), request.getParameterValues("publishers_id")),
                        request.getParameter("date_published_from"),
                        request.getParameter("date_published_to")));%>"
                            <% if(checkParameter(request.getParameterValues("publishers_id"), String.valueOf(publisher.getId()))){%>
                       style="color: #FF6700"<% } %>>
                        <%=publisher.getName()%>
                    </a>
                </div>
                <div style="clear: both"></div>
            </div>
            <%}%>
        </div>
    </div>
    <div id = "list">
        <div class="beam__">
            <div style="float: left">
                KSIĄŻKI [${list.size()}]
            </div>
            <% if (request.getSession().getAttribute("user") != null) {
                User user = (User)request.getSession().getAttribute("user");
                if (user.getRole() == 2) {%>
                <div style="float: right; margin-top: -3px">
                    <a href="http://localhost:8080/Czytamy_war_exploded/books/addBook" id="addBook">
                        Dodaj książke
                    </a>
                </div>
                <%}%>
            <%}%>
            <div style="clear: both"></div>
            <hr class="main">
        </div>
        <c:forEach var="book" items="${list}">
                <div style="float: left">
                    <img src="${pageContext.request.contextPath}/${book.book_cover}" width="176" height="250">
                </div>
                <div id = "content">
                    <div class="listElem">
                        <a href="http://localhost:8080/Czytamy_war_exploded/book/${book.book_id}"> ${book.book_title}</a>
                    </div>
                    <div class="listElem" >
                        <a href="http://localhost:8080/Czytamy_war_exploded/author/${book.author_id}"> ${book.author_name} ${book.author_surname}</a>
                    </div>
                    <div class="listElem" style="float: left">Średnia ocen:</div>
                    <div class="listElem" style="color: #C92523; float: left; margin-left: 20px"><i class="demo-icon icon-star"></i></div>
                    <div class="listElem" style="color: #C92523; float: left; margin-left: 4px; font-size: 24px; margin-top: 18px">
                        <c:choose>
                            <c:when test="${book.average_rating != 'emp'}">
                                ${book.average_rating}
                            </c:when>
                            <c:otherwise>
                                0.0
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="listElem" style="float: left; margin-left: 4px;">/10</div>
                    <div id = "numberOfOpinions">
                            ${book.number_of_opinions} ocen
                    </div>
                </div>
                <div style="clear: both"></div>
                <hr style="border: black solid 0.5px"/>
        </c:forEach>
    </div>
</div>
</body>
</html>