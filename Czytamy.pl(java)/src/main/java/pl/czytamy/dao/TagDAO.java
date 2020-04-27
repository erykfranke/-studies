package pl.czytamy.dao;

import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import pl.czytamy.models.Tag;
import pl.czytamy.models.helpModels.TagsCount;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class TagDAO {
    private JdbcTemplate template;
    private NamedParameterJdbcTemplate jdbcTemplate;
    public void setJdbcTemplate(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public int add(Tag tag){
        String sql = "INSERT INTO tag(name) VALUES('"+tag.getName()+"')";
        return template.update(sql);
    }

    public int delete(int id){
        String sql = "DELETE from tag WHERE id ="+id+"";
        return template.update(sql);
    }

    public Tag getTagById(int id){
        String sql = "SELECT * FROM `czytamy.pl`.tag WHERE id=?";
        try {
            return template.queryForObject(sql, new Object[]{id}, new BeanPropertyRowMapper<Tag>(Tag.class));
        } catch (org.springframework.dao.EmptyResultDataAccessException ignored) {
            return null;
        }
    }

    public Tag getTagByName(String name){
        String sql = "SELECT * FROM `czytamy.pl`.tag WHERE name = ?";
        try {
            return template.queryForObject(sql, new Object[]{name}, new BeanPropertyRowMapper<Tag>(Tag.class));
        } catch (org.springframework.dao.EmptyResultDataAccessException ignored) {
            return null;
        }
    }

    public List<Tag> getTags() {
        return template.query("SELECT * FROM `czytamy.pl`.tag", new RowMapper<Tag>() {
            public Tag mapRow(ResultSet rs, int row) throws SQLException {
                Tag tag = new Tag();
                tag.setId(rs.getInt(1));
                tag.setName(rs.getString(2));
                return tag;
            }
        });
    }

    public List<TagsCount> getTagsCount() {
        return template.query(SELECT_COUNT_TAG, new RowMapper<TagsCount>() {
            public TagsCount mapRow(ResultSet rs, int row) throws SQLException {
                TagsCount tagsCount = new TagsCount();
                tagsCount.setTag_id(rs.getInt(1));
                tagsCount.setTag_name(rs.getString(2));
                tagsCount.setCount(rs.getInt(3));
                return tagsCount;
            }
        });
    }

    final String SELECT_COUNT_TAG =
            "SELECT tag.id, tag.name, COUNT(bookstags.book_id) " +
            "FROM tag, bookstags " +
            "WHERE tag.id = bookstags.tag_id " +
            "GROUP BY tag.name " +
            "ORDER BY tag.name";
}
