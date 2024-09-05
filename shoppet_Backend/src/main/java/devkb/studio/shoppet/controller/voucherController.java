package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.voucher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api")
public class voucherController {

    private final PostgresService postgresService;

    @Autowired
    public voucherController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Thêm một voucher mới.
     *
     * @param voucher đối tượng voucher chứa thông tin của voucher mới.
     * @return ResponseEntity với mã trạng thái và thông báo.
     * - `201 Created` nếu voucher được thêm thành công, kèm theo ID của voucher.
     * - `500 Internal Server Error` nếu không thể thêm voucher.
     */
    @PostMapping("/addVoucher")
    public ResponseEntity<String> addVoucher(@RequestBody voucher voucher) {

        String query = "INSERT INTO vouchers (voucher_id, code, discount, expiry_date, min_order_value) VALUES ('" +
                voucher.getVoucher_id() + "', '" + voucher.getCode() + "', " + voucher.getDiscount() + ", '" +
                voucher.getExpiryDate() + "', " + voucher.getMinOrder() + ")";

        int rowsInserted = postgresService.executeUpdate(query);

        if (rowsInserted > 0) {
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body("Voucher added successfully with ID: " + voucher.getVoucher_id());
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to add voucher.");
        }
    }

    /**
     * Xóa một voucher theo voucher_id.
     *
     * @param voucherId ID của voucher cần xóa.
     * @return ResponseEntity với mã trạng thái và thông báo.
     * - `200 OK` nếu voucher được xóa thành công, kèm theo ID của voucher.
     * - `404 Not Found` nếu không tìm thấy voucher để xóa.
     */
    @DeleteMapping("/removeVoucher")
    public ResponseEntity<String> removeVoucher(@RequestParam(value = "voucher_id") String voucherId) {
        String query = "DELETE FROM vouchers WHERE voucher_id = '" + voucherId + "'";

        int rowsDeleted = postgresService.executeUpdate(query);

        if (rowsDeleted > 0) {
            return ResponseEntity.status(HttpStatus.OK)
                    .body("Voucher removed successfully with ID: " + voucherId);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No voucher found to delete with ID: " + voucherId);
        }
    }

    /**
     * Lấy các voucher dựa trên voucher_id, code hoặc ngày.
     *
     * @param voucherId (Tùy chọn) ID của voucher.
     * @param code (Tùy chọn) Mã của voucher.
     * @param startDate (Tùy chọn) Ngày bắt đầu trong khoảng ngày.
     * @param endDate (Tùy chọn) Ngày kết thúc trong khoảng ngày.
     * @return ResponseEntity với mã trạng thái và danh sách các voucher hoặc thông báo nếu không tìm thấy.
     * - `200 OK` nếu có voucher được tìm thấy, kèm theo danh sách voucher.
     * - `404 Not Found` nếu không tìm thấy voucher phù hợp với tiêu chí.
     */
    @GetMapping("/getVouchers")
    public ResponseEntity<?> getVouchers(
            @RequestParam(value = "voucher_id", required = false) String voucherId,
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "startDate", required = false) Date startDate,
            @RequestParam(value = "endDate", required = false) Date endDate
    ) {
        String query = "SELECT * FROM vouchers";
        List<String> conditions = new ArrayList<>();

        if (voucherId != null && !voucherId.isEmpty()) {
            conditions.add("voucher_id = '" + voucherId + "'");
        }
        if (code != null && !code.isEmpty()) {
            conditions.add("code = '" + code + "'");
        }
        if (startDate != null && endDate != null) {
            conditions.add("expiry_date BETWEEN '" + startDate + "' AND '" + endDate + "'");
        }

        if (!conditions.isEmpty()) {
            query += " WHERE " + String.join(" AND ", conditions);
        }

        List<Map<String, Object>> results = postgresService.executeQuery(query);
        List<voucher> voucherList = new ArrayList<>();

        for (Map<String, Object> row : results) {
            voucher voucher = devkb.studio.shoppet.model.voucher.builder()
                    .voucher_id((String) row.get("voucher_id"))
                    .code((String) row.get("code"))
                    .discount(Float.parseFloat((String) row.get("discount")))
                    .expiryDate((java.sql.Date) row.get("expiry_date"))
                    .minOrder(Double.parseDouble((String) row.get("min_order_value")))
                    .build();
            voucherList.add(voucher);
        }

        if (!voucherList.isEmpty()) {
            return ResponseEntity.status(HttpStatus.OK).body(voucherList);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No vouchers found matching the criteria.");
        }
    }
}
