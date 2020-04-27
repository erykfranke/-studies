package pl.czytamy.dto;

import java.util.ArrayList;
import java.util.List;

public class booksFiltersDTO {
    private String sort;
    private String category;
    private List<Integer> tags_id;
    private List<Integer> authors_id;
    private List<Integer> publishers_id;
    private String date_published_from;
    private String date_published_to;

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public List<Integer> getTags_id() {
        return tags_id;
    }

    public void setTags_id(List<Integer> tags_id) {
        this.tags_id = tags_id;
    }

    public List<Integer> getAuthors_id() {
        return authors_id;
    }

    public void setAuthors_id(List<Integer> authors_id) {
        this.authors_id = authors_id;
    }

    public List<Integer> getPublishers_id() {
        return publishers_id;
    }

    public void setPublishers_id(List<Integer> publishers_id) {
        this.publishers_id = publishers_id;
    }

    public String getDate_published_from() {
        return date_published_from;
    }

    public void setDate_published_from(String date_published_from) {
        this.date_published_from = date_published_from;
    }

    public String getDate_published_to() {
        return date_published_to;
    }

    public void setDate_published_to(String date_published_to) {
        this.date_published_to = date_published_to;
    }
}
