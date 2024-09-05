package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class paymentController {
    @Autowired
    private PostgresService postgresService; // Lớp dịch vụ PostgresService

    /**
     * Thêm một khoản thanh toán mới vào cơ sở dữ liệu.
     *
     * @param orderId ID của đơn hàng
     * @param paymentMethod Phương thức thanh toán
     * @param status Trạng thái thanh toán
     * @return ResponseEntity với mã trạng thái HTTP:
     *         - HttpStatus.CREATED nếu thành công (201 Created).
     *         - HttpStatus.INTERNAL_SERVER_ERROR nếu có lỗi (500 Internal Server Error).
     */
    @PostMapping("/addPayment")
    public ResponseEntity<HttpStatus> addPayment(
            @RequestParam(value = "order_id") String orderId,
            @RequestParam(value = "payment_method") String paymentMethod,
            @RequestParam(value = "status") boolean status
    ) {
        String insertQuery = "INSERT INTO payments (payment_id, order_id, payment_method, status, created_at) VALUES (?, ?, ?, ?, ?)";
        int rowsInserted = postgresService.executeUpdate(insertQuery, UUID.randomUUID(), orderId, paymentMethod, status, LocalDate.now());

        if (rowsInserted > 0) {
            return new ResponseEntity<>(HttpStatus.CREATED); // Trả về 201 Created nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
        }
    }

    /**
     * Lấy thông tin thanh toán dựa trên payment_id hoặc tất cả thanh toán nếu không có payment_id.
     *
     * @param paymentId ID của thanh toán (tùy chọn)
     * @return ResponseEntity với thông tin thanh toán:
     *         - Nếu paymentId không được cung cấp:
     *           - HttpStatus.OK (200 OK) với danh sách thanh toán dưới dạng danh sách đối tượng Payment.
     *         - Nếu paymentId được cung cấp:
     *           - HttpStatus.OK (200 OK) với thông tin thanh toán nếu tìm thấy.
     *           - HttpStatus.NOT_FOUND (404 Not Found) nếu không tìm thấy.
     */
    @GetMapping("/getPayment")
    public ResponseEntity<?> getPayment(
            @RequestParam(value = "payment_id", required = false) String paymentId
    ) {
        String selectQuery;
        if (paymentId == null) {
            selectQuery = "SELECT * FROM payments"; // Lấy tất cả thanh toán
        } else {
            selectQuery = "SELECT * FROM payments WHERE payment_id = '" + paymentId + "'";
        }

        List<Map<String, Object>> result = postgresService.executeQuery(selectQuery);

        if (!result.isEmpty()) {
            if (paymentId == null) {
                // Nếu lấy tất cả thanh toán, chuyển đổi danh sách Map thành danh sách đối tượng Payment
                List<payment> payments = result.stream()
                        .map(paymentData -> devkb.studio.shoppet.model.payment.builder()
                                .payment_id((String) paymentData.get("payment_id"))
                                .order_id((String) paymentData.get("order_id"))
                                .payment_method((String) paymentData.get("payment_method"))
                                .status((Boolean) paymentData.get("status"))
                                .created_at((java.sql.Date) paymentData.get("created_at"))
                                .build())
                        .collect(Collectors.toList());

                return new ResponseEntity<>(payments, HttpStatus.OK); // Trả về 200 OK với danh sách thanh toán
            } else {
                // Nếu có payment_id, chỉ trả về một đối tượng Payment
                Map<String, Object> paymentData = result.get(0);
                payment payment = devkb.studio.shoppet.model.payment.builder()
                        .payment_id((String) paymentData.get("payment_id"))
                        .order_id((String) paymentData.get("order_id"))
                        .payment_method((String) paymentData.get("payment_method"))
                        .status((Boolean) paymentData.get("status"))
                        .created_at((java.sql.Date) paymentData.get("created_at"))
                        .build();

                return new ResponseEntity<>(payment, HttpStatus.OK); // Trả về 200 OK với thông tin thanh toán
            }
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 Not Found nếu không tìm thấy
        }
    }


    /**
     * Xóa một khoản thanh toán dựa trên payment_id.
     *
     * @param paymentId ID của thanh toán
     * @return ResponseEntity với mã trạng thái HTTP:
     *         - HttpStatus.NO_CONTENT (204 No Content) nếu thành công.
     *         - HttpStatus.INTERNAL_SERVER_ERROR (500 Internal Server Error) nếu có lỗi.
     */
    @DeleteMapping("/removePayment")
    public ResponseEntity<HttpStatus> removePayment(
            @RequestParam(value = "payment_id") String paymentId
    ) {
        // Tạo câu lệnh SQL DELETE
        String deleteQuery = "DELETE FROM payments WHERE payment_id = ?";
        int rowsDeleted = postgresService.executeUpdate(deleteQuery, paymentId);

        if (rowsDeleted > 0) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // Trả về 204 No Content nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
        }
    }
}

