package pl.czytamy.models;

import javax.persistence.*;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Entity
@Table(name="Author")
public class Author implements Comparable<Author>{
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String surname;

    private String birth_date;

    private String description;

    private String photo;

    //------------------------------------------------------------------------------------------------------------------

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getBirth_date() {
        return birth_date;
    }

    public void setBirth_date(String birth_date) {
        this.birth_date = birth_date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    //------------------------------------------------------------------------------------------------------------------

    public Map<String, String> checkAddAuthor(Author author){
        Map<String, String> errors = new TreeMap<>();
        if (author.getName().length() == 0){
            errors.put("name_error", "imię nie może być puste");
        }
        if (author.getSurname().length() == 0){
            errors.put("surname_error", "nazwisko nie może być puste");
        }
        return errors;
    }

    @Override
    public int compareTo(Author author) {
        if (getSurname() == null || author.getSurname() == null) {
            return 0;
        }
        return getSurname().compareTo(author.getSurname());
    }
}
