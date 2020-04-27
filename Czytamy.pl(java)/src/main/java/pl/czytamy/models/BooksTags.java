package pl.czytamy.models;

import javax.persistence.*;

@Entity
@Table(name="BookTags")
public class BooksTags {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private int tag_id;

    @Column(nullable = false)
    private int book_id;

    //------------------------------------------------------------------------------------------------------------------
    public BooksTags() {
        this.tag_id = 0;
        this.book_id = 0;
    }

    public BooksTags(int tag_id, int book_id) {
        this.tag_id = tag_id;
        this.book_id = book_id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTag_id() {
        return tag_id;
    }

    public void setTag_id(int tag_id) {
        this.tag_id = tag_id;
    }

    public int getBook_id() {
        return book_id;
    }

    public void setBook_id(int book_id) {
        this.book_id = book_id;
    }
}
