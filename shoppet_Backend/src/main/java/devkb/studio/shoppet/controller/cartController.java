package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.cart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api")
public class cartController {

    private final PostgresService postgresService;

    @Autowired
    public cartController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Lấy thông tin giỏ hàng theo card_id hoặc user_id.
     *
     * @param card_id ID của giỏ hàng (có thể là null nếu không tìm theo card_id)
     * @param user_id ID của người dùng (có thể là null nếu không tìm theo user_id)
     * @return Danh sách giỏ hàng phù hợp dưới dạng ResponseEntity
     *
     * Mã trạng thái trả về:
     * - 200 OK: Nếu lấy thành công và trả về danh sách giỏ hàng phù hợp
     */
    @GetMapping("/getCart")
    public ResponseEntity<List<cart>> getCart(
            @RequestParam(value = "card_id", defaultValue = "none") String card_id,
            @RequestParam(value = "user_id", defaultValue = "none") String user_id
    ) {
        List<cart> cartItems = new ArrayList<>();

        String query = "SELECT * FROM \"cart\"";
        if (!card_id.equals("none") || !user_id.equals("none")) {
            query += " WHERE";
            if (!card_id.equals("none")) {
                query += " card_id = '" + card_id + "'";
            }
            if (!user_id.equals("none")) {
                if (!card_id.equals("none")) {
                    query += " AND";
                }
                query += " user_id = '" + user_id + "'";
            }
        }

        List<Map<String, Object>> results = postgresService.executeQuery(query);

        for (Map<String, Object> row : results) {
            cart cartItem = cart.builder()
                    .cart_id((String) row.get("card_id"))
                    .user_id((String) row.get("user_id"))
                    .created_at((Date) row.get("create_at"))
                    .build();
            cartItems.add(cartItem);
        }

        return ResponseEntity.ok(cartItems);
    }

    /**
     * Thêm một giỏ hàng mới.
     *
     * @param user_id ID của người dùng
     * @return ResponseEntity với mã trạng thái và body chứa card_id
     *
     * Mã trạng thái trả về:
     * - 201 CREATED: Nếu giỏ hàng được tạo thành công và trả về card_id của giỏ hàng mới
     * - 500 INTERNAL SERVER ERROR: Nếu có lỗi xảy ra trong quá trình thêm giỏ hàng
     */
    @PostMapping("/addCart")
    public ResponseEntity<String> addCart(
            @RequestParam(value = "user_id") String user_id
    ) {
        String card_id;
        boolean isUnique;
        Date createdAt = Date.valueOf(LocalDate.now());

        // Tạo một card_id duy nhất
        do {
            card_id = String.valueOf(UUID.randomUUID());
            // Kiểm tra nếu card_id đã tồn tại
            ResponseEntity<List<cart>> existingCart = this.getCart(card_id, "none");
            isUnique = existingCart.getBody().isEmpty();
        } while (!isUnique);

        // Tạo câu lệnh SQL INSERT
        String query = "INSERT INTO cart (card_id, user_id, create_at) VALUES (" +
                "'" + card_id + "', " +
                "'" + user_id + "', " +
                "'" + createdAt.toString() + "')";

        int rowsInserted = postgresService.executeUpdate(query);

        if (rowsInserted > 0) {
            return new ResponseEntity<>(card_id, HttpStatus.CREATED); // Trả về 201 Created nếu thành công
        } else {
            return new ResponseEntity<>(card_id, HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 Internal Server Error nếu có lỗi
        }
    }

    /**
     * Xóa giỏ hàng dựa trên card_id hoặc user_id.
     *
     * @param card_id ID của giỏ hàng (có thể là null nếu không xóa theo card_id)
     * @param user_id ID của người dùng (có thể là null nếu không xóa theo user_id)
     * @return ResponseEntity với thông báo thành công hoặc lỗi
     *
     * Mã trạng thái trả về:
     * - 200 OK: Nếu giỏ hàng được xóa thành công và trả về thông báo thành công
     * - 400 BAD REQUEST: Nếu không cung cấp ít nhất một trong hai tham số card_id hoặc user_id
     * - 404 NOT FOUND: Nếu không tìm thấy giỏ hàng để xóa
     */
    @DeleteMapping("/removeCart")
    public ResponseEntity<String> removeCart(
            @RequestParam(value = "card_id", defaultValue = "none") String card_id,
            @RequestParam(value = "user_id", defaultValue = "none") String user_id
    ) {
        // Kiểm tra xem ít nhất một tham số có được cung cấp hay không
        if (card_id.equals("none") && user_id.equals("none")) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("At least one of card_id or user_id must be provided.");
        }

        // Tạo câu lệnh SQL DELETE
        String query = "DELETE FROM cart";
        query += " WHERE";
        if (!card_id.equals("none")) {
            query += " card_id ='" + card_id + "'";
        }
        if (!user_id.equals("none")) {
            if (!card_id.equals("none")) {
                query += " AND";
            }
            query += " user_id='" + user_id + "'";
        }

        int rowsDeleted = postgresService.executeUpdate(query);

        if (rowsDeleted > 0) {
            return ResponseEntity.status(HttpStatus.OK)
                    .body("Cart removed successfully. card_id: " + card_id + ", user_id: " + user_id);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("No cart found to delete with card_id: " + card_id + " or user_id: " + user_id);
        }
    }
}
