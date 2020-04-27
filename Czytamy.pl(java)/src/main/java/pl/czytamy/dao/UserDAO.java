package pl.czytamy.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.User;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class UserDAO {
    private JdbcTemplate template;
    private NamedParameterJdbcTemplate jdbcTemplate;
    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int save(String nick, String email, String password){
        String sql = "INSERT INTO user(nick, email, password) VALUES('"+nick+"','"+email+"','"+password+"')";
        return template.update(sql);
    }

    public int update(User user){
        String sql = "UPDATE user SET nick='" + user.getNick()+
                "',place='"+user.getPlace()+
                "',gender='"+user.getGender()+
                "',description='"+user.getDescription()+
                "' WHERE id="+user.getId();
        return template.update(sql);
    }

    public int updatePhoto(int id,String photo){
        String sql = "UPDATE user SET photo='" + photo +
                "' WHERE id="+id;
        return template.update(sql);
    }

    public User getUserByID(int id){
        String sql = "SELECT * FROM `czytamy.pl`.user WHERE id=?";
        return template.queryForObject(sql, new Object[]{id}, new BeanPropertyRowMapper<User>(User.class));
    }

    public List<User> getUsersByID(int id){
        return template.query("select * from `czytamy.pl`.user where id = ?",
                new Object[]{id},
                new RowMapper<User>(){
            public User mapRow(ResultSet rs, int row) throws SQLException {
                User user = new User();
                user.setId(rs.getInt(1));
                user.setNick(rs.getString(2));
                user.setEmail(rs.getString(3));
                user.setPassword(rs.getString(4));
                user.setGender(rs.getString(5));
                user.setPlace(rs.getString(6));
                user.setDescription(rs.getString(7));
                user.setPhoto(rs.getString(8));
                user.setRole(rs.getInt(9));
                return user;
            }
        });
    }

    public List<User> getUsers(){
        return template.query("select * from `czytamy.pl`.user", new RowMapper<User>(){
            public User mapRow(ResultSet rs, int row) throws SQLException {
                User user = new User();
                user.setId(rs.getInt(1));
                user.setNick(rs.getString(2));
                user.setEmail(rs.getString(3));
                user.setPassword(rs.getString(4));
                user.setGender(rs.getString(5));
                user.setPlace(rs.getString(6));
                user.setDescription(rs.getString(7));
                user.setPhoto(rs.getString(8));
                user.setRole(rs.getInt(9));
                return user;
            }
        });
    }
}
