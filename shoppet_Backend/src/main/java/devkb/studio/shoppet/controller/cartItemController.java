package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.cartItems;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api")
public class cartItemController {

    private final PostgresService postgresService;

    @Autowired
    public cartItemController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Thêm một mục vào giỏ hàng.
     *
     * @param cartID ID của giỏ hàng
     * @param product_ID ID của sản phẩm
     * @return ResponseEntity với mã trạng thái và body chứa cartItemID
     *
     * Mã trạng thái trả về:
     * - 201 CREATED: Nếu mục giỏ hàng được thêm thành công và trả về cartItemID
     * - 500 INTERNAL SERVER ERROR: Nếu có lỗi xảy ra khi thêm mục vào giỏ hàng
     */
    @PostMapping("/addCartItem")
    public ResponseEntity<String> addCartItem(
            @RequestParam(value = "cartID") String cartID,
            @RequestParam(value = "product_ID") String product_ID
    ) {
        String cartItemID = UUID.randomUUID().toString(); // Tạo UUID ngẫu nhiên cho cartItemID

        // Tạo câu lệnh SQL INSERT
        String query = "INSERT INTO cart_items (cart_item_id, cart_id, product_id) VALUES (" +
                "'" + cartItemID + "', " +
                "'" + cartID + "', " +
                "'" + product_ID + "')";

        int rowsInserted = postgresService.executeUpdate(query);

        if (rowsInserted > 0) {
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(cartItemID);
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to add cart item.");
        }
    }

    /**
     * Xóa một mục trong giỏ hàng theo cartID.
     *
     * @param cartID ID của giỏ hàng (bắt buộc)
     * @return ResponseEntity với mã trạng thái và thông báo
     *
     * Mã trạng thái trả về:
     * - 200 OK: Nếu các mục trong giỏ hàng được xóa thành công và trả về thông báo
     * - 400 BAD REQUEST: Nếu cartID không được cung cấp hoặc trống
     * - 404 NOT FOUND: Nếu không tìm thấy các mục trong giỏ hàng để xóa
     */
    @DeleteMapping("/removeCartItem")
    public ResponseEntity<String> removeCartItem(
            @RequestParam(value = "cartID") String cartID
    ) {
        // Kiểm tra xem cartID có được cung cấp hay không
        if (cartID == null || cartID.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("cartID is required and cannot be empty.");
        }

        // Tạo câu lệnh SQL DELETE
        String query = "DELETE FROM cart_items WHERE cart_id = '" + cartID + "'";

        int rowsDeleted = postgresService.executeUpdate(query);

        if (rowsDeleted > 0) {
            return ResponseEntity.status(HttpStatus.OK)
                    .body("Cart items removed successfully from cartID: " + cartID);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No cart items found for cartID: " + cartID);
        }
    }

    /**
     * Lấy các mục trong giỏ hàng theo cartID.
     *
     * @param cartID ID của giỏ hàng (có thể là null nếu không tìm theo cartID)
     * @return ResponseEntity với mã trạng thái và danh sách các mục giỏ hàng hoặc thông báo nếu không tìm thấy
     *
     * Mã trạng thái trả về:
     * - 200 OK: Nếu lấy thành công và trả về danh sách các mục giỏ hàng
     * - 404 NOT FOUND: Nếu không tìm thấy các mục giỏ hàng cho cartID cung cấp
     */
    @GetMapping("/getCartItems")
    public ResponseEntity<?> getCartItems(
            @RequestParam(value = "cartID", required = false) String cartID
    ) {
        // Tạo câu lệnh SQL để lấy các mục trong giỏ hàng
        String query = "SELECT * FROM cart_items";
        if (cartID != null && !cartID.isEmpty()) {
            query += " WHERE cart_id = '" + cartID + "'";
        }

        // Thực hiện truy vấn
        List<Map<String, Object>> results = postgresService.executeQuery(query);
        List<cartItems> cartItemList = new ArrayList<>();

        // Chuyển đổi kết quả từ truy vấn thành danh sách các đối tượng cartItems
        for (Map<String, Object> row : results) {
            cartItems item = cartItems.builder()
                    .cartItemID((String) row.get("cart_item_id"))
                    .cartID((String) row.get("cart_id"))
                    .product_ID((String) row.get("product_id"))
                    .build();
            cartItemList.add(item);
        }

        // Kiểm tra và trả về danh sách các mục giỏ hàng hoặc thông báo không tìm thấy
        if (!cartItemList.isEmpty()) {
            return ResponseEntity.status(HttpStatus.OK).body(cartItemList);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Collections.singletonList("No cart items found for cartID: " + cartID));
        }
    }
}
