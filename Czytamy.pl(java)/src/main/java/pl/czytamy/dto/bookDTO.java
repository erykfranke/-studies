package pl.czytamy.dto;

import pl.czytamy.models.Author;
import pl.czytamy.models.Book;
import pl.czytamy.models.Publisher;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class bookDTO {
   private Book book;
   private String author_name;
   private String author_surname;
   private String publisher_name;

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
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

    public String getPublisher_name() {
        return publisher_name;
    }

    public void setPublisher_name(String publisher_name) {
        this.publisher_name = publisher_name;
    }

    public Map<String, String> checkAddBook(List<Book> books, Author author, Publisher publisher){
        Map<String, String> errors = new TreeMap<>();

        if(author == null){
            errors.put("author_error", "wpisany author nie istnieje w bazie danych");
        }
        if (publisher == null){
            errors.put("publisher_error", "wpisany wydawnca nie istnieje w bazie danych");
        }
        if (book.getTitle().isEmpty()){
            errors.put("title_error", "tytuł książki nie możę być pusty");
        }
        if (author_name.isEmpty()){
            errors.put("authorName_error", "imię autora książki nie możę być puste");
        }
        if (author_surname.isEmpty()){
            errors.put("authorSurname_error", "nazwisko autora książki nie możę być puste");
        }
        if (book.getDate_published().isEmpty()){
            errors.put("datePublished_error", "data wydania książki nie możę być pusta");
        }
        if (book.getNumber_of_pages() == 0){
            errors.put("pages_error", "liczba stron książki nie możę być równa 0");
        }
        if (book.getLanguage().isEmpty()){
            errors.put("language_error", "język książki nie możę być pusty");
        }
        if (book.getIsbn().isEmpty()){
            errors.put("isbn_error", "isbn nie może być pusty");
        } else {
            for (Book x: books){
                if(x.getIsbn().equals(book.getIsbn()) && x.getId() != book.getId()){
                    errors.put("isbn_error", "wpisany isbn widnieje już w bazie");
                }
            }
        }
        if(publisher_name.isEmpty()){
            errors.put("publisher_error", "wydawca książki nie możę być pusty");
        }
        return errors;
    }
}
