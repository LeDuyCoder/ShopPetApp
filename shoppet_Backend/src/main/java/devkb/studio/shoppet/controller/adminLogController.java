package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api")
public class adminLogController {

    private final PostgresService postgresService;

    @Autowired
    public adminLogController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Thêm một log mới vào bảng admin_log.
     *
     * @param admin_id UUID của admin thực hiện hành động
     * @param action Hành động được thực hiện
     * @return ResponseEntity chứa mã trạng thái HTTP và thông điệp phù hợp
     *
     * Mã trạng thái trả về:
     * - 201 CREATED: Nếu log được tạo thành công và trả về UUID của log mới
     * - 404 NOT FOUND: Nếu không tìm thấy người dùng với admin_id
     * - 403 FORBIDDEN: Nếu người dùng không phải là admin
     * - 500 INTERNAL SERVER ERROR: Nếu có lỗi xảy ra trong quá trình thêm log
     */
    @PostMapping("/addLog")
    public ResponseEntity<String> addLog(
            @RequestParam(value = "admin_id") UUID admin_id,
            @RequestParam(value = "action") String action
    ) {
        // Query để kiểm tra xem user với admin_id có phải là admin không
        String roleCheckQuery = "SELECT * FROM \"user\" WHERE user_id = '" + admin_id.toString() + "'";
        List<Map<String, Object>> results = postgresService.executeQuery(roleCheckQuery);

        if (results.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found."); // Trả về 404 nếu không tìm thấy user
        }

        String role = (String) results.get(0).get("role");

        if (!"ADMIN".equalsIgnoreCase(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("User is not an admin."); // Trả về 403 nếu user không phải là admin
        }

        UUID log_id = UUID.randomUUID();
        long currentTimeMillis = System.currentTimeMillis();
        Date date = new Date(currentTimeMillis);
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss-dd-MM-yyyy");
        String timestamp = sdf.format(date);

        String query = "INSERT INTO admin_log (log_id, admin_id, action, timestamp) VALUES (" +
                "'" + log_id.toString() + "', " +
                "'" + admin_id.toString() + "', " +
                "'" + action + "', " +
                "'" + timestamp + "')";

        int rowsInserted = postgresService.executeUpdate(query);

        if (rowsInserted > 0) {
            return ResponseEntity.status(HttpStatus.CREATED).body("Log created successfully with ID: " + log_id.toString()); // Trả về 201 Created nếu thành công
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Internal server error occurred."); // Trả về 500 nếu có lỗi
        }
    }

    /**
     * Lấy thông tin các log từ bảng admin_log.
     * Nếu tham số id được cung cấp, chỉ lấy log với id tương ứng.
     * Nếu không có tham số id, lấy tất cả các log.
     *
     * @param id UUID của log để tìm kiếm (có thể là null nếu muốn lấy tất cả các log)
     * @return ResponseEntity chứa danh sách log nếu thành công, hoặc mã lỗi nếu có lỗi xảy ra
     *
     * Mã trạng thái trả về:
     * - 200 OK: Nếu lấy thành công và trả về danh sách các log
     * - 500 INTERNAL SERVER ERROR: Nếu có lỗi xảy ra trong quá trình lấy log
     */
    @GetMapping("/getLogs")
    public ResponseEntity<?> getLogs(@RequestParam(required = false) UUID id) {
        try {
            if (id != null) {
                // Lấy log theo UUID
                return ResponseEntity.ok(postgresService.executeQuery("SELECT * FROM admin_log WHERE log_id = '" + id.toString() + "'"));
            } else {
                // Lấy tất cả log
                return ResponseEntity.ok(postgresService.executeQuery("SELECT * FROM admin_log"));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage()); // Trả về 500 nếu có lỗi
        }
    }

    /**
     * Xóa một log khỏi bảng admin_log dựa trên log_id.
     *
     * @param log_id UUID của log cần xóa
     * @return ResponseEntity với thông báo thành công hoặc lỗi
     *
     * Mã trạng thái trả về:
     * - 200 OK: Nếu log được xóa thành công
     * - 404 NOT FOUND: Nếu không tìm thấy log với log_id cung cấp
     */
    @DeleteMapping("/deleteLog")
    public ResponseEntity<String> deleteLog(@RequestParam(value = "log_id") UUID log_id) {
        String query = "DELETE FROM admin_log WHERE log_id = '" + log_id.toString() + "'";

        int rowsDeleted = postgresService.executeUpdate(query);

        if (rowsDeleted > 0) {
            return ResponseEntity.status(HttpStatus.OK).body("Log deleted successfully."); // Trả về 200 OK nếu thành công
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Log not found."); // Trả về 404 nếu không tìm thấy log
        }
    }
}
