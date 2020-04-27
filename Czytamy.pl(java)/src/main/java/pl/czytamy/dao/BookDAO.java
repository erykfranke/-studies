package pl.czytamy.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.Book;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class BookDAO {
    private JdbcTemplate template;
    private NamedParameterJdbcTemplate jdbcTemplate;
    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int add(Book book) {
        String sql = "INSERT INTO book(title, oryginal_title, author_id, category, date_published, polish_date_published, number_of_pages, language, isbn, publisher_id, description)" +
                " VALUES('" + book.getTitle() +
                "','" + book.getOriginal_title() +
                "'," + book.getAuthor_id() +
                ",'" + book.getCategory() +
                "','" + book.getDate_published() +
                "','" + book.getPolish_date_published() +
                "'," + book.getNumber_of_pages() +
                ",'" + book.getLanguage() +
                "','" + book.getIsbn() +
                "'," + book.getPublisher_id() +
                ",'" + book.getDescription() + "')";
        return template.update(sql);
    }

    public int addWithOutDate(Book book) {
        String sql = "INSERT INTO book(title, oryginal_title, author_id, category, date_published, number_of_pages, language, isbn, publisher_id, description)" +
                " VALUES('" + book.getTitle() +
                "','" + book.getOriginal_title() +
                "'," + book.getAuthor_id() +
                ",'" + book.getCategory() +
                "','" + book.getDate_published() +
                "'," + book.getNumber_of_pages() +
                ",'" + book.getLanguage() +
                "','" + book.getIsbn() +
                "'," + book.getPublisher_id() +
                ",'" + book.getDescription() + "')";
        return template.update(sql);
    }

    public int edit(Book book){
        String sql = "UPDATE book SET title='" + book.getTitle()+
                "',oryginal_title='"+book.getOriginal_title()+
                "',author_id="+book.getAuthor_id()+
                ",category='"+book.getCategory()+
                "',date_published='"+book.getDate_published()+
                "',polish_date_published='"+book.getPolish_date_published()+
                "',number_of_pages="+book.getNumber_of_pages()+
                ",language='"+book.getLanguage()+
                "',isbn='"+book.getIsbn()+
                "',publisher_id="+book.getPublisher_id()+
                ",description='"+book.getDescription()+
                "' WHERE id="+book.getId();
        return template.update(sql);
    }
    public int editWithOutDate(Book book){
        String sql = "UPDATE book SET title='" + book.getTitle()+
                "',oryginal_title='"+book.getOriginal_title()+
                "',author_id="+book.getAuthor_id()+
                ",category='"+book.getCategory()+
                "',date_published='"+book.getDate_published()+
                "',number_of_pages="+book.getNumber_of_pages()+
                ",language='"+book.getLanguage()+
                "',isbn='"+book.getIsbn()+
                "',publisher_id="+book.getPublisher_id()+
                ",description='"+book.getDescription()+
                "' WHERE id="+book.getId();
        return template.update(sql);
    }

    public int updatePhoto(int id,String photo){
        String sql = "UPDATE book SET cover='" + photo +
                "' WHERE id="+id;
        return template.update(sql);
    }


    public Book getBookById(int id){
        String sql = "SELECT * FROM `czytamy.pl`.book WHERE id=?";
        return template.queryForObject(sql, new Object[]{id}, new BeanPropertyRowMapper<Book>(Book.class));
    }

    public Book getBookByISBN(String isbn){
        String sql = "SELECT * FROM `czytamy.pl`.book WHERE isbn=?";
        return template.queryForObject(sql, new Object[]{isbn}, new BeanPropertyRowMapper<Book>(Book.class));
    }

    public List<Book>getAll(){
        String sql = "SELECT * FROM `czytamy.pl`.book";
        return template.query("select * from `czytamy.pl`.book",
                new RowMapper<Book>() {
                    public Book mapRow(ResultSet rs, int row) throws SQLException {
                        Book book = new Book();
                        book.setId(rs.getInt(1));
                        book.setTitle(rs.getString(2));
                        book.setOriginal_title(rs.getString(3));
                        book.setAuthor_id(rs.getInt(4));
                        book.setCategory(rs.getString(5));
                        book.setDate_published(rs.getString(6));
                        book.setPolish_date_published(rs.getString(7));
                        book.setNumber_of_pages(rs.getInt(8));
                        book.setLanguage(rs.getString(9));
                        book.setIsbn(rs.getString(10));
                        book.setPublisher_id(rs.getInt(11));
                        book.setDescription(rs.getString(12));
                        book.setCover(rs.getString(13));
                        return book;
                    }
                });
    }
}
