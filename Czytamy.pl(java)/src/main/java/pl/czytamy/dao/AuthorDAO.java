package pl.czytamy.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.Author;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class AuthorDAO {
    private JdbcTemplate template;
    private NamedParameterJdbcTemplate jdbcTemplate;
    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int add(Author author) {
        String sql = "INSERT INTO author(name, surname, birth_date, description)" +
                " VALUES('" + author.getName() + "','" + author.getSurname() + "','" + author.getBirth_date() + "','" + author.getDescription() + "')";
        return template.update(sql);
    }
    public int addWithOutDate(Author author){
        String sql = "INSERT INTO author(name, surname, description)" +
                " VALUES('"+author.getName()+"','"+author.getSurname()+"','"+author.getDescription()+"')";
        return template.update(sql);
    }

    public int edit(Author author){
        String sql = "UPDATE author SET name='" + author.getName()+
                "',surname='"+author.getSurname()+
                "',birth_date='"+author.getBirth_date()+
                "',description='"+author.getDescription()+
                "' WHERE id="+author.getId();
        return template.update(sql);
    }
    public int editWithOutDate(Author author){
        String sql = "UPDATE author SET name='" + author.getName()+
                "',surname='"+author.getSurname()+
                "',description='"+author.getDescription()+
                "' WHERE id="+author.getId();
        return template.update(sql);
    }

    public int updatePhoto(int id,String photo){
        String sql = "UPDATE author SET photo ='" + photo +
                "' WHERE id="+id;
        return template.update(sql);
    }

    public Author getAuthorByNameAndSurname(String name, String surname){
        String sql = "SELECT * FROM author WHERE name = ? AND surname = ?";
        try {
            return template.queryForObject(sql, new Object[]{name, surname}, new BeanPropertyRowMapper<Author>(Author.class));
        }  catch (org.springframework.dao.EmptyResultDataAccessException ignored) {
            return null;
        }
    }


    public Author getAuthorById(int id){
        return template.queryForObject(SELECT_BY_ID, new Object[]{id}, new BeanPropertyRowMapper<Author>(Author.class));
    }

    public List<Author> getAuthors(){
        return template.query(SELECT_ALL, new authorMapper());
    }

    public List<Author> getAuthors(String category) {
        return template.query(SELECT_BY_ONLY_BOOK_CATEGORY, new Object[]{category}, new authorMapper());
    }

    public List<Author> getAuthorsOrderByBookASC() {
        return template.query(SELECT_ORDER_BY_COUNT_BOOK_ASC, new authorMapper());
    }

    public List<Author> getAuthorsOrderByBookASC(String category) {
        return template.query(SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_ASC, new Object[]{category}, new authorMapper());
    }

    public List<Author> getAuthorsOrderByBookDESC() {
        return template.query(SELECT_ORDER_BY_COUNT_BOOK_DESC, new authorMapper());
    }

    public List<Author>getAuthorsOrderByBookDESC(String category) {
        return template.query(SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_DESC, new Object[]{category}, new authorMapper());
    }

    private static final class authorMapper implements RowMapper<Author>{
        public Author mapRow(ResultSet rs, int rowNum) throws SQLException{
            Author author = new Author();
            author.setId(rs.getInt(1));
            author.setName(rs.getString(2));
            author.setSurname(rs.getString(3));
            author.setBirth_date(rs.getString(4));
            author.setDescription(rs.getString(5));
            author.setPhoto(rs.getString(6));
            return author;
        }
    }

    //------------------------------------------------------------------------------------------------------------------

    final String SELECT_ALL = "SELECT * FROM author";

    final String SELECT_BY_ID = "SELECT * FROM author WHERE id=?";

    final String SELECT_ORDER_BY_COUNT_BOOK_ASC =
            "SELECT author.*" +
            " FROM author, book" +
            " WHERE author.id = book.author_id" +
            " GROUP BY author.id" +
            " ORDER BY COUNT(book.author_id) ASC";

    final String SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_ASC =
            "SELECT author.*" +
            " FROM author, book" +
            " WHERE author.id = book.author_id" +
            " AND book.category = ?" +
            " GROUP BY author.id" +
            " ORDER BY COUNT(book.author_id) ASC";

    final String SELECT_ORDER_BY_COUNT_BOOK_DESC =
            "SELECT author.*" +
            " FROM author, book" +
            " WHERE author.id = book.author_id" +
            " GROUP BY author.id" +
            " ORDER BY COUNT(book.author_id) DESC";

    final String SELECT_BY_BOOK_CATEGORY_ORDER_BY_COUNT_BOOK_DESC =
            "SELECT author.*" +
            " FROM author, book" +
            " WHERE author.id = book.author_id" +
            " AND book.category = ?" +
            " GROUP BY author.id" +
            " ORDER BY COUNT(book.author_id) DESC";

    final String SELECT_BY_ONLY_BOOK_CATEGORY =
            "SELECT author.* " +
            "FROM book, author " +
            "WHERE book.author_id = author.id " +
            "AND book.category = ? " +
            "GROUP BY author.id";
}

