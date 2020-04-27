package pl.czytamy.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import pl.czytamy.models.Opinion;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class OpinionDAO {
    private JdbcTemplate template;
    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int save(Opinion opinion){
        String sql = "INSERT INTO opinion(user_id, book_id, date_published, comment, rating)" +
                    " VALUES("+opinion.getUser_id()+","
                +opinion.getBook_id()+",'"
                +opinion.getDate_published()+"','"
                +opinion.getComment()+"',"
                +opinion.getRating()+")";
        return template.update(sql);
    }

    public int update(Opinion opinion){
        String sql = "UPDATE opinion SET date_published='" + opinion.getDate_published()+
                "',comment='"+opinion.getComment()+
                "',rating="+opinion.getRating()+
                " WHERE book_id="+opinion.getBook_id()+
                " AND user_id="+opinion.getUser_id();
        return template.update(sql);
    }

    public int delete(int id){
        String sql = "DELETE from opinion WHERE id ="+id+"";
        return template.update(sql);
    }

    public Opinion getOpinionByID(int id){
        String sql = "SELECT * FROM opinion WHERE id=?";
        return template.queryForObject(sql, new Object[]{id}, new BeanPropertyRowMapper<Opinion>(Opinion.class));
    }

    public int getOpinionCountByUserID(int id){
        String sql = "SELECT COUNT(user_id) FROM opinion WHERE user_id=?";
        return template.queryForObject(sql, new Object[]{id}, Integer.class);
    }

    public List<Opinion> getOpinionByBookID(int book_id){
        return template.query("select * from `czytamy.pl`.opinion where book_id = ? ORDER BY date_published DESC",
                new Object[]{book_id},
                new RowMapper<Opinion>() {
                    public Opinion mapRow(ResultSet rs, int row) throws SQLException {
                        Opinion opinion = new Opinion();
                        opinion.setId(rs.getInt(1));
                        opinion.setUser_id(rs.getInt(2));
                        opinion.setBook_id(rs.getInt(3));
                        opinion.setDate_published(rs.getString(4));
                        opinion.setComment(rs.getString(5));
                        opinion.setRating(rs.getInt(6));
                        return opinion;
                    }
                });
    }
}
