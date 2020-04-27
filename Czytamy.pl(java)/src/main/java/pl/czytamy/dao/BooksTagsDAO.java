package pl.czytamy.dao;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.BooksTags;
import pl.czytamy.models.Tag;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class BooksTagsDAO {
    private JdbcTemplate template;
    private NamedParameterJdbcTemplate jdbcTemplate;
    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int add(int tag_id, int book_id){
        String sql = "INSERT INTO bookstags(tag_id, book_id) VALUES("+tag_id+","+book_id+")";
        return template.update(sql);
    }

    public int delete(int id){
        String sql = "DELETE from bookstags WHERE id ="+id+"";
        return template.update(sql);
    }

    public BooksTags getByTagIDAndBookID(int tag_id, int book_id){
        String sql = "SELECT * FROM bookstags WHERE tag_id =? AND book_id = ?";
        try {
            return template.queryForObject(sql, new Object[]{tag_id, book_id}, new BeanPropertyRowMapper<BooksTags>(BooksTags.class));
        } catch (org.springframework.dao.EmptyResultDataAccessException ignored) {
            return null;
        }
    }

    public List<BooksTags> getBooksTagsByBookId(int books_id){
        return template.query("select * from `czytamy.pl`.bookstags where book_id = ?",  new Object[]{books_id} ,new bookTagsElementMapper());
    }

    public List<BooksTags> getBooksTagsByTagId(int tag_id){
        return template.query("select * from `czytamy.pl`.bookstags where tag_id = ?", new Object[]{tag_id}, new bookTagsElementMapper());
    }

    public List<BooksTags> getBooksTags() {
        return template.query("select * from `czytamy.pl`.bookstags", new bookTagsElementMapper());
    }

    private static final class bookTagsElementMapper implements RowMapper<BooksTags>{
        public BooksTags mapRow(ResultSet rs, int rowNum) throws SQLException{
            BooksTags booksTags = new BooksTags();
            booksTags.setId(rs.getInt(1));
            booksTags.setTag_id(rs.getInt(2));
            booksTags.setBook_id(rs.getInt(3));
            return booksTags;
        }
    }
}
