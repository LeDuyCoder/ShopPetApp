package devkb.studio.shoppet.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PostgresService {
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public PostgresService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Method to execute a SQL query and return the result as a List of Map
    public List<Map<String, Object>> executeQuery(String sql) {
        return jdbcTemplate.queryForList(sql);
    }

    // Method to execute an update/insert/delete query
    public int executeUpdate(String sql, Object... params) {
        return jdbcTemplate.update(sql, params);
    }
}
