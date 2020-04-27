package pl.czytamy.models.helpModels;

import java.util.Collections;
import java.util.Comparator;

public class BookListElement {
    private int book_id;
    private String book_title;
    private String book_cover;
    private int author_id;
    private String author_name;
    private String author_surname;
    private String average_rating;
    private int number_of_opinions;
    private String date_published;

    public int getBook_id() {
        return book_id;
    }

    public void setBook_id(int book_id) {
        this.book_id = book_id;
    }

    public String getBook_title() {
        return book_title;
    }

    public void setBook_title(String book_title) {
        this.book_title = book_title;
    }

    public String getBook_cover() {
        return book_cover;
    }

    public void setBook_cover(String book_cover) {
        this.book_cover = book_cover;
    }

    public int getAuthor_id() {
        return author_id;
    }

    public void setAuthor_id(int author_id) {
        this.author_id = author_id;
    }

    public String getAuthor_name() {
        return author_name;
    }

    public void setAuthor_name(String author_name) {
        this.author_name = author_name;
    }

    public String getAuthor_surname() {
        return author_surname;
    }

    public void setAuthor_surname(String author_surname) {
        this.author_surname = author_surname;
    }

    public String getAverage_rating() {
        return average_rating;
    }

    public void setAverage_rating(String average_rating) {
        this.average_rating = average_rating;
    }

    public int getNumber_of_opinions() {
        return number_of_opinions;
    }

    public void setNumber_of_opinions(int number_of_opinions) {
        this.number_of_opinions = number_of_opinions;
    }

    public String getDate_published() {
        return date_published;
    }

    public void setDate_published(String date_published) {
        this.date_published = date_published;
    }

    public static class NumberOfOpinionsSorter implements Comparator<BookListElement>
    {
        @Override
        public int compare(BookListElement bookListElement, BookListElement t1) {
            return bookListElement.getNumber_of_opinions() - t1.getNumber_of_opinions();
        }
    }

    public static class DatePublishedSorter implements Comparator<BookListElement>
    {
        @Override
        public int compare(BookListElement bookListElement, BookListElement t1) {
            return bookListElement.getDate_published().compareTo(t1.getDate_published());
        }
    }

    public static class RatingSorter implements Comparator<BookListElement>
    {
        @Override
        public int compare(BookListElement bookListElement, BookListElement t1) {
            return bookListElement.getAverage_rating().compareTo(t1.getAverage_rating());
        }
    }

}

