package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.orderItems;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class orderItemsController {
    private final PostgresService postgresService;

    // Constructor injection for PostgresService
    public orderItemsController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Thêm các order items dựa trên danh sách các đối tượng orderItems.
     *
     * @param itemsList Danh sách các đối tượng orderItems
     * @return ResponseEntity với trạng thái và thông báo chi tiết:
     *         - 201 Created nếu thêm thành công.
     */
    @PostMapping("/addItems")
    public ResponseEntity<String> addItems(@RequestBody List<orderItems> itemsList) {

        for (orderItems item : itemsList) {
            String orderItemID = item.getOrderItemID();
            String orderId = item.getOrderID();
            String productId = item.getProductID();
            int quantity = item.getQuantity();
            double price = item.getPrice();

            // Kiểm tra nếu sản phẩm đã tồn tại trong đơn hàng
            String querySelect = "SELECT * FROM \"order_Items\" WHERE order_id = '" + orderId +
                    "' AND product_id = '" + productId + "'";
            List<Map<String, Object>> existingItems = postgresService.executeQuery(querySelect);

            if (!existingItems.isEmpty()) {
                // Nếu sản phẩm đã tồn tại trong đơn hàng, tiếp tục mà không thêm mới
                continue;
            }

            // Nếu không tồn tại, thêm mới sản phẩm vào đơn hàng
            String queryInsert = "INSERT INTO \"order_Items\" (order_item_id, order_id, product_id, quantity, price) " +
                    "VALUES ('" + orderItemID + "', '" + orderId + "', '" + productId + "', " + quantity + ", " + price + ")";
            postgresService.executeUpdate(queryInsert);
        }

        return ResponseEntity.status(HttpStatus.CREATED).body("Items added successfully.");
    }

    /**
     * Lấy danh sách order items dựa trên orderID hoặc tất cả nếu không có orderID.
     *
     * @param orderId ID của đơn hàng (tùy chọn)
     * @return ResponseEntity với danh sách order items:
     *         - 200 OK nếu thành công, kèm theo danh sách các order items.
     *         - 500 Internal Server Error nếu có lỗi xảy ra khi truy vấn cơ sở dữ liệu.
     */
    @GetMapping("/getOrderItems")
    public ResponseEntity<List<orderItems>> getOrderItems(
            @RequestParam(value = "order_id", required = false) String orderId) {

        String query;
        if (orderId == null || orderId.isEmpty()) {
            // Nếu không truyền order_id, lấy tất cả
            query = "SELECT * FROM \"order_Items\"";
        } else {
            // Nếu có order_id, lấy theo order_id
            query = "SELECT * FROM \"order_Items\" WHERE order_id = '" + orderId + "'";
        }

        // Thực hiện truy vấn và lấy kết quả
        List<Map<String, Object>> results = postgresService.executeQuery(query);

        if (results == null) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi khi truy vấn cơ sở dữ liệu
        }

        // Chuyển đổi kết quả từ Map<String, Object> thành List<orderItems>
        List<orderItems> orderItemsList = results.stream()
                .map(result -> orderItems.builder()
                        .orderItemID((String) result.get("order_item_id"))
                        .orderID((String) result.get("order_id"))
                        .productID((String) result.get("product_id"))
                        .quantity((Integer) result.get("quantity"))
                        .price(Double.parseDouble((String) result.get("price")))
                        .build())
                .collect(Collectors.toList());

        // Trả về ResponseEntity với danh sách orderItems
        return ResponseEntity.ok(orderItemsList); // Trả về 200 OK với danh sách orderItems
    }

    /**
     * Xóa tất cả order items theo orderID.
     *
     * @param orderId ID của đơn hàng cần xóa items
     * @return ResponseEntity với trạng thái và thông báo chi tiết:
     *         - 200 OK nếu xóa thành công.
     *         - 404 Not Found nếu không tìm thấy bất kỳ order items nào với orderId.
     */
    @DeleteMapping("/removeItems")
    public ResponseEntity<String> removeItems(@RequestParam("order_id") String orderId) {
        // Tạo câu lệnh SQL DELETE
        String deleteQuery = "DELETE FROM \"order_Items\" WHERE order_id = '" + orderId + "'";
        int rowsAffected = postgresService.executeUpdate(deleteQuery);

        if (rowsAffected > 0) {
            return ResponseEntity.ok("Items removed successfully."); // Trả về 200 OK nếu xóa thành công
        } else {
            return new ResponseEntity<>("No items found for the given order ID.", HttpStatus.NOT_FOUND); // Trả về 404 nếu không tìm thấy items
        }
    }
}
