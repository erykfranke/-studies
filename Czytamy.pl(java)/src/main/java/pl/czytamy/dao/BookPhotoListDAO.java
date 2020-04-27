package pl.czytamy.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import pl.czytamy.models.helpModels.BookPhotoList;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;


public class BookPhotoListDAO {
    private JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }
    public List<BookPhotoList> getBooks(){
        return template.query("SELECT book.id, book.cover FROM `czytamy.pl`.book ORDER BY book.date_published DESC",
            new RowMapper<BookPhotoList>() {
                public BookPhotoList mapRow(ResultSet rs, int row) throws SQLException {
                    BookPhotoList book = new BookPhotoList();
                    book.setBook_id(rs.getInt(1));
                    book.setPhoto(rs.getString(2));
                    return book;
                }
            });
    }

}
