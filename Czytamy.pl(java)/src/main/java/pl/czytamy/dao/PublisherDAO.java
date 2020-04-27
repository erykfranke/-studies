package pl.czytamy.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.Publisher;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PublisherDAO {
    private JdbcTemplate template;
    private NamedParameterJdbcTemplate jdbcTemplate;
    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int add(Publisher publisher){
        String sql = "INSERT INTO publisher(name, web_site, description)" +
                " VALUES('"+publisher.getName()+"','"+publisher.getWeb_site()+"','"+publisher.getDescription()+"')";
        return template.update(sql);
    }

    public int edit(Publisher publisher){
        String sql = "UPDATE publisher SET name='" + publisher.getName()+
                "',web_site='"+publisher.getWeb_site()+
                "',description='"+publisher.getDescription()+
                "' WHERE id="+publisher.getId();
        return template.update(sql);
    }

    public int updatePhoto(int id,String photo){
        String sql = "UPDATE publisher SET logo='" + photo +
                "' WHERE id="+id;
        return template.update(sql);
    }

    public Publisher getPublisherById(int id){
        return template.queryForObject(SELECT_BY_ID, new Object[]{id}, new BeanPropertyRowMapper<Publisher>(Publisher.class));
    }

    public Publisher getPublisherByName(String name){
        String sql = "SELECT * FROM publisher WHERE name = ?";
        try {
        return template.queryForObject(sql, new Object[]{name}, new BeanPropertyRowMapper<Publisher>(Publisher.class));
        }  catch (org.springframework.dao.EmptyResultDataAccessException ignored) {
            return null;
        }
    }

    public List<Publisher> getPublishers() {
        return template.query(SELECT_ALL, new PublisherMapper());
    }

    public List<Publisher> getPublishers(String category) {
        return template.query(SELECT_BY_ONLY_BOOK_CATEGORY, new Object[]{category}, new PublisherMapper());
    }

    public List<Publisher> getPublishersOrderByBookASC() {
        return template.query(SELECT_ORDER_BY_COUNT_BOOK_ASC, new PublisherMapper());
    }

    public List<Publisher> getPublishersOrderByBookASC(String category) {
        return template.query(SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_ASC, new Object[]{category}, new PublisherMapper());
    }

    public List<Publisher> getPublishersOrderByBookDESC() {
        return template.query(SELECT_ORDER_BY_COUNT_BOOK_DESC, new PublisherMapper());
    }

    public List<Publisher> getPublishersOrderByBookDESC(String category) {
        return template.query(SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_DESC, new Object[]{category}, new PublisherMapper());
    }

    private static final class PublisherMapper implements RowMapper<Publisher>{
        public Publisher mapRow(ResultSet rs, int rowNum) throws SQLException{
            Publisher publisher = new Publisher();
            publisher.setId(rs.getInt(1));
            publisher.setName(rs.getString(2));
            publisher.setWeb_site(rs.getString(3));
            publisher.setDescription(rs.getString(4));
            publisher.setLogo(rs.getString(5));
            return publisher;
        }
    }

    //-----------------------------------------------------------------------------------------------------------------

    final String SELECT_ALL = "select * from `czytamy.pl`.publisher";

    final String SELECT_BY_ID = "SELECT * FROM `czytamy.pl`.publisher WHERE id=?";

    final String SELECT_ORDER_BY_COUNT_BOOK_ASC =
            "SELECT publisher.*" +
            " FROM publisher, book" +
            " WHERE publisher.id = book.publisher_id" +
            " GROUP BY publisher.id" +
            " ORDER BY COUNT(book.publisher_id) ASC";

    final String SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_ASC =
            "SELECT publisher.*" +
            " FROM publisher, book" +
            " WHERE publisher.id = book.publisher_id" +
            " AND book.category = ?" +
            " GROUP BY publisher.id" +
            " ORDER BY COUNT(book.publisher_id) ASC";

    final String SELECT_ORDER_BY_COUNT_BOOK_DESC =
            "SELECT publisher.*" +
            " FROM publisher, book" +
            " WHERE publisher.id = book.publisher_id" +
            " GROUP BY publisher.id" +
            " ORDER BY COUNT(book.publisher_id) DESC";

    final String SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_DESC =
            "SELECT publisher.*" +
            " FROM publisher, book" +
            " WHERE publisher.id = book.publisher_id" +
            " AND book.category = ?" +
            " GROUP BY publisher.id" +
            " ORDER BY COUNT(book.publisher_id) DESC";

    final String SELECT_BY_ONLY_BOOK_CATEGORY =
            "SELECT publisher.* " +
            "FROM book, publisher " +
            "WHERE book.publisher_id = publisher.id " +
            "AND book.category = ? " +
            "GROUP BY publisher.id";
}
