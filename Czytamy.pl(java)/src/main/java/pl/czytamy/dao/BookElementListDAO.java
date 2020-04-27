package pl.czytamy.dao;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.helpModels.BookListElement;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class BookElementListDAO {
    private NamedParameterJdbcTemplate jdbcTemplate;

    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<BookListElement> getBookByFilters(
            String category,
            List<Integer> tags_id,
            List<Integer> authors_id,
            List<Integer> publishers_id,
            String date_published_from,
            String date_published_to
        )
    {
        List<BookListElement> result = jdbcTemplate.query(
                buildSelect(category, tags_id, authors_id, publishers_id, date_published_from, date_published_to, true),
                sqlParameterSource(category, tags_id, authors_id, publishers_id, date_published_from, date_published_to),
                new BookListElementMapper()
        );
        result.addAll(jdbcTemplate.query(
                buildSelect(category, tags_id, authors_id, publishers_id, date_published_from, date_published_to, false),
                sqlParameterSource(category, tags_id, authors_id, publishers_id, date_published_from, date_published_to),
                new BookListElementMapper()
        ));
        return result;
    }

    static private MapSqlParameterSource sqlParameterSource (
            String category,
            List<Integer> tags_id,
            List<Integer> authors_id,
            List<Integer> publishers_id,
            String date_published_from,
            String date_published_to
        )
    {
        MapSqlParameterSource parameters = new MapSqlParameterSource();
        if (category != null){
            parameters.addValue("category", category);
        }
        parameters.addValues(addListParameters(tags_id, "tag_id"));
        parameters.addValues(addListParameters(authors_id, "author_id"));
        parameters.addValues(addListParameters(publishers_id, "publisher_id"));
        if (date_published_from != null) {
            parameters.addValue("date_published_from", date_published_from+"/01/01");
        }
        if (date_published_to != null) {
            parameters.addValue("date_published_to", date_published_to+"/12/31");
        }
        return parameters;
    }

    static private Map<String, ?> addListParameters (List<Integer> list, String paramName){
        Map<String, Integer> result = new TreeMap<>();
        if (list != null) {
            for (Integer x : list) {
                assert false;
                result.put(paramName + x, x);
            }
        }
        return result;
    }

    static private String buildSelect (
            String category,
            List<Integer> tags_id,
            List<Integer> authors_id,
            List<Integer> publishers_id,
            String date_published_from,
            String date_published_to,
            boolean havingRating
        )
    {
        String select = "";
        if (havingRating) {
            select += "SELECT B.id, B.title, B.cover, A.id, A.name, A.surname, AVG(O.rating), COUNT(O.rating)/2, B.date_published ";
        } else {
            select += "SELECT B.id, B.title, B.cover, A.id, A.name, A.surname, 0.0, 0, B.date_published ";
        }

        select += "FROM book B, author A, publisher P, tag T, booksTags BT, opinion O " +
                "WHERE B.author_id = A.id AND B.publisher_id = P.id " +
                "AND BT.tag_id = T.id AND BT.book_id = B.id ";

        if (havingRating) {
            select += "AND B.id = O.book_id ";
        } else {
            select += "AND B.id NOT IN ( SELECT B.id FROM book B, opinion O WHERE B.id = O.book_id GROUP BY B.id) ";
        }

        if (category != null) {
            select += "AND ( B.category LIKE :category ) ";
        }
        select += addToSelectConditions(tags_id, "T.id = :tag_id");
        select += addToSelectConditions(authors_id, "A.id = :author_id");
        select += addToSelectConditions(publishers_id, "P.id = :publisher_id");

        if (date_published_from != null){
            select += "AND B.date_published >= :date_published_from ";
        }
        if (date_published_to != null) {
            select += "AND B.date_published <= :date_published_to ";
        }
        return select + "GROUP BY B.id";
    }

    static private String addToSelectConditions(List<Integer> list, String condition) {
        if (list != null){
            String result = "AND ( "+ condition+list.get(0)+" ";
            for (int i = 1; i < list.size(); i++) {
                result += "OR " + condition+list.get(i)+" ";
            }
            return result + ") ";
        }
        return "";
    }

    private static final class BookListElementMapper implements RowMapper<BookListElement>{
        public BookListElement mapRow(ResultSet rs, int rowNum) throws SQLException{
            BookListElement bookListElement = new BookListElement();
            bookListElement.setBook_id(rs.getInt(1));
            bookListElement.setBook_title(rs.getString(2));
            bookListElement.setBook_cover(rs.getString(3));
            bookListElement.setAuthor_id(rs.getInt(4));
            bookListElement.setAuthor_name(rs.getString(5));
            bookListElement.setAuthor_surname(rs.getString(6));
            bookListElement.setAverage_rating(rs.getString(7).substring(0,3));
            bookListElement.setNumber_of_opinions(rs.getInt(8));
            bookListElement.setDate_published(rs.getString(9));
            return bookListElement;
        }
    }
}
