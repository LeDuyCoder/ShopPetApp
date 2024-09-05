package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PasswordService;
import devkb.studio.shoppet.Service.PostgresService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api")
public class ordersController {
    private final PostgresService postgresService;

    @Autowired
    public ordersController(PostgresService postgresService, PasswordService passwordService) {
        this.postgresService = postgresService;
    }

    /**
     * Tạo một đơn hàng mới với thông tin mặc định.
     * Nếu user_id không được cung cấp, giá trị mặc định là "none".
     *
     * @param user_id ID của người dùng (có thể là null nếu không có)
     * @return ResponseEntity với trạng thái tạo thành công:
     *         - 201 Created nếu tạo đơn hàng thành công.
     */
    @PostMapping("/createOrder")
    public ResponseEntity<String> createOrder(
            @RequestParam(value = "user_id", defaultValue = "none") String user_id) {

        // Generate a new UUID for the order
        String order_id = UUID.randomUUID().toString();

        // Set default values
        float total_price = 0.0f;
        String status = "Pending";  // Example status, adjust as needed
        Date created_at = new Date(); // Current date and time

        // SQL query to insert the new order into the database
        String query = "INSERT INTO orders (order_id, user_id, total_price, status, created_at) " +
                "VALUES (?, ?, ?, ?, ?)";

        // Execute the query using PostgresService
        int rowsAffected = postgresService.executeUpdate(query, order_id, user_id, total_price, status, created_at);

        if (rowsAffected > 0) {
            return ResponseEntity.status(HttpStatus.CREATED).body("Order created successfully."); // Trả về 201 Created nếu thành công
        } else {
            return new ResponseEntity<>("Failed to create order.", HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 Internal Server Error nếu thất bại
        }
    }

    /**
     * Cập nhật giá tổng của đơn hàng dựa trên order_id.
     *
     * @param order_id ID của đơn hàng cần cập nhật
     * @param total_price Giá tổng mới của đơn hàng
     * @return ResponseEntity với trạng thái cập nhật thành công:
     *         - 200 OK nếu cập nhật thành công.
     *         - 404 Not Found nếu không tìm thấy đơn hàng.
     */
    @PostMapping("/updateTotalPrice")
    public ResponseEntity<String> updateTotalPrice(
            @RequestParam("order_id") String order_id,
            @RequestParam("total_price") double total_price) {

        String query = "UPDATE orders SET total_price = ? WHERE order_id = ?";
        int rowsAffected = postgresService.executeUpdate(query, total_price, order_id);

        if (rowsAffected > 0) {
            return ResponseEntity.ok("Total price updated successfully."); // Trả về 200 OK nếu cập nhật thành công
        } else {
            return new ResponseEntity<>("Order not found.", HttpStatus.NOT_FOUND); // Trả về 404 Not Found nếu không tìm thấy đơn hàng
        }
    }

    /**
     * Cập nhật trạng thái của đơn hàng dựa trên order_id.
     *
     * @param order_id ID của đơn hàng cần cập nhật
     * @param status Trạng thái mới của đơn hàng
     * @return ResponseEntity với trạng thái cập nhật thành công:
     *         - 200 OK nếu cập nhật thành công.
     *         - 404 Not Found nếu không tìm thấy đơn hàng.
     */
    @PostMapping("/updateStatus")
    public ResponseEntity<String> updateStatus(
            @RequestParam("order_id") String order_id,
            @RequestParam("status") String status) {

        String query = "UPDATE orders SET status = ? WHERE order_id = ?";
        int rowsAffected = postgresService.executeUpdate(query, status, order_id);

        if (rowsAffected > 0) {
            return ResponseEntity.ok("Status updated successfully."); // Trả về 200 OK nếu cập nhật thành công
        } else {
            return new ResponseEntity<>("Order not found.", HttpStatus.NOT_FOUND); // Trả về 404 Not Found nếu không tìm thấy đơn hàng
        }
    }

    /**
     * Xóa một đơn hàng dựa trên order_id.
     *
     * @param order_id ID của đơn hàng cần xóa
     * @return ResponseEntity với trạng thái xóa thành công:
     *         - 200 OK nếu xóa thành công.
     *         - 404 Not Found nếu không tìm thấy đơn hàng.
     */
    @DeleteMapping("/deleteOrder")
    public ResponseEntity<String> deleteOrder(@RequestParam("order_id") String order_id) {
        String query = "DELETE FROM orders WHERE order_id = ?";
        int rowsAffected = postgresService.executeUpdate(query, order_id);

        if (rowsAffected > 0) {
            return ResponseEntity.ok("Order deleted successfully."); // Trả về 200 OK nếu xóa thành công
        } else {
            return new ResponseEntity<>("Order not found.", HttpStatus.NOT_FOUND); // Trả về 404 Not Found nếu không tìm thấy đơn hàng
        }
    }

    /**
     * Lấy danh sách đơn hàng dựa trên order_id hoặc user_id.
     * Nếu không cung cấp order_id hoặc user_id, lấy tất cả các đơn hàng.
     *
     * @param order_id ID của đơn hàng để tìm kiếm (có thể là null nếu không tìm kiếm theo ID)
     * @param user_id ID của người dùng để tìm kiếm (có thể là null nếu không tìm kiếm theo người dùng)
     * @return ResponseEntity với danh sách đơn hàng:
     *         - 200 OK nếu thành công, kèm theo danh sách đơn hàng.
     */
    @GetMapping("/getOrders")
    public ResponseEntity<List<Map<String, Object>>> getOrders(
            @RequestParam(value = "order_id", required = false) String order_id,
            @RequestParam(value = "user_id", required = false) String user_id) {

        String query;

        if (order_id != null) {
            query = "SELECT * FROM orders WHERE order_id = '" + order_id + "'";
        } else if (user_id != null) {
            query = "SELECT * FROM orders WHERE user_id = '" + user_id + "'";
        } else {
            query = "SELECT * FROM orders";
        }

        List<Map<String, Object>> results = postgresService.executeQuery(query);

        return ResponseEntity.ok(results); // Trả về 200 OK với danh sách đơn hàng
    }
}
