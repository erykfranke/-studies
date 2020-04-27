package pl.czytamy.models;

import javax.persistence.*;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Entity
@Table(name="Publisher")
public class Publisher implements Comparable<Publisher> {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    private String web_site;

    private String description;

    private String logo;

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

    public String getWeb_site() {
        return web_site;
    }

    public void setWeb_site(String web_site) {
        this.web_site = web_site;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    //------------------------------------------------------------------------------------------------------------------

    public Map<String, String> checkRegistration(Publisher newPublisher, List<Publisher> publishers){
        Map<String, String> errors = new TreeMap<>();

        if (newPublisher.getName().length() == 0){
            errors.put("name_error", "nazwa wydawcnitwa nie możę być pusta");
        } else {
            for (Publisher publisher : publishers) {
                if (publisher.getName().equals(newPublisher.getName()) && publisher.getId() != newPublisher.getId()) {
                    errors.put("name_error", "wydawcnitwo o takiej nazwie już istnieje w bazie");
                    break;
                }
            }
        }

        if (!newPublisher.getWeb_site().isEmpty()) {
            if (!newPublisher.getWeb_site().contains("http")) {
                errors.put("webSite_error", "nieporawny link");
            }
        }
        return errors;
    }

    @Override
    public int compareTo(Publisher publisher) {
        if (getName() == null || publisher.getName() == null) {
            return 0;
        }
        return getName().compareTo(publisher.getName());
    }
}
