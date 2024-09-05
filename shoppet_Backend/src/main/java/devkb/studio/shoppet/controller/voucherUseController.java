package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.voucherUse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class voucherUseController {

    private final PostgresService postgresService;

    @Autowired
    public voucherUseController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Thêm một voucher cho người dùng, đảm bảo mỗi voucher chỉ có thể thêm một lần.
     *
     * @param userId     ID của người dùng
     * @param voucher_id ID của voucher
     * @return ResponseEntity với mã trạng thái và thông báo kết quả.
     * - `201 Created` nếu voucher được thêm thành công cho người dùng.
     * - `409 Conflict` nếu voucher đã tồn tại cho người dùng.
     * - `500 Internal Server Error` nếu không thể thêm voucher.
     */
    @PostMapping("/addVoucherUse")
    public ResponseEntity<String> addVoucherUse(
            @RequestParam("userId") String userId,
            @RequestParam("voucher_id") String voucher_id
    ) {
        // Kiểm tra nếu voucher_id đã tồn tại cho userId
        String checkQuery = "SELECT * FROM voucher_use WHERE user_id = '" + userId + "' AND voucher_id = '" + voucher_id + "'";
        List<Map<String, Object>> existingVouchers = postgresService.executeQuery(checkQuery);

        if (!existingVouchers.isEmpty()) {
            // Nếu voucher đã tồn tại, trả về thông báo lỗi
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body("Voucher already added for this user.");
        }

        // Nếu voucher chưa tồn tại, thêm nó vào bảng
        String insertQuery = "INSERT INTO voucher_use (user_id, voucher_id) VALUES (" +
                "'" + userId + "', " +
                "'" + voucher_id + "')";

        int rowsInserted = postgresService.executeUpdate(insertQuery);

        if (rowsInserted > 0) {
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body("Voucher added successfully for user ID: " + userId);
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to add voucher.");
        }
    }

    /**
     * Lấy tất cả voucher theo ID người dùng và tùy chọn theo voucher_id.
     *
     * @param userId ID của người dùng (tùy chọn)
     * @param voucherId (Tùy chọn) ID của voucher để lọc kết quả
     * @return ResponseEntity chứa danh sách các voucher hoặc thông báo lỗi.
     * - `200 OK` nếu có voucher được tìm thấy, kèm theo danh sách voucher.
     * - `404 Not Found` nếu không tìm thấy voucher phù hợp với tiêu chí.
     */
    @GetMapping("/getVouchersByUserId")
    public ResponseEntity<List<voucherUse>> getVouchersByUserId(
            @RequestParam(value = "userId", required = false) String userId,
            @RequestParam(value = "voucherId", required = false) String voucherId
    ) {
        // Xây dựng câu lệnh SQL dựa trên tham số nhập vào
        StringBuilder queryBuilder = new StringBuilder("SELECT * FROM voucher_use");

        List<String> conditions = new ArrayList<>();

        if (userId != null && !userId.isEmpty()) {
            conditions.add("user_id = '" + userId + "'");
        }

        if (voucherId != null && !voucherId.isEmpty()) {
            conditions.add("voucher_id = '" + voucherId + "'");
        }

        if (!conditions.isEmpty()) {
            queryBuilder.append(" WHERE ").append(String.join(" AND ", conditions));
        }

        String query = queryBuilder.toString();

        List<Map<String, Object>> results = postgresService.executeQuery(query);
        List<voucherUse> vouchers = new ArrayList<>();

        for (Map<String, Object> row : results) {
            voucherUse voucher = voucherUse.builder()
                    .userId((String) row.get("user_id"))
                    .voucher_id((String) row.get("voucher_id"))
                    .build();
            vouchers.add(voucher);
        }

        if (!vouchers.isEmpty()) {
            return ResponseEntity.status(HttpStatus.OK).body(vouchers);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ArrayList<>());
        }
    }

}
