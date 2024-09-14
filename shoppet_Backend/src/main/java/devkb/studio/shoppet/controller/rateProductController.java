package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.Rate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@RestController
@RequestMapping("/api")
public class rateProductController {

    private final PostgresService postgresService;

    @Autowired
    public rateProductController(PostgresService postgresService) {
        this.postgresService = postgresService;
    }

    /**
     * Lấy tất cả các đánh giá sản phẩm dựa trên các tham số (productID hoặc userID).
     *
     * @param productID ID của sản phẩm (tùy chọn).
     * @param userID ID của người dùng (tùy chọn).
     * @return ResponseEntity với danh sách các đối tượng Rate.
     * - `200 OK` nếu có đánh giá hoặc danh sách đánh giá rỗng.
     */
    @GetMapping("/getRates")
    public ResponseEntity<List<Rate>> getRates(
            @RequestParam(value = "productID", defaultValue = "none") String productID,
            @RequestParam(value = "userID", defaultValue = "none") String userID
    ) {
        List<Rate> rates = new ArrayList<>();

        String query = getString(productID, userID);

        List<Map<String, Object>> results = postgresService.executeQuery(query);

        for (Map<String, Object> row : results) {
            Rate rate = Rate.builder()
                    .productID((String) row.get("productID"))
                    .userID((String) row.get("userID"))
                    .rate((Integer) row.get("rate"))
                    .comment((String) row.get("comment"))
                    .build();
            rates.add(rate);
        }

        return ResponseEntity.ok(rates);
    }

    private static String getString(String productID, String userID) {
        String query = "SELECT * FROM rate_product";
        boolean hasCondition = false;

        if (!productID.equals("none") || !userID.equals("none")) {
            query += " WHERE";

            if (!productID.equals("none")) {
                query += " productID = '" + productID + "'";
                hasCondition = true;
            }
            if (!userID.equals("none")) {
                if (hasCondition) {
                    query += " AND";
                }
                query += " userID = '" + userID + "'";
            }
        }
        return query;
    }

    /**
     * Thêm một đánh giá mới cho sản phẩm.
     *
     * @param productID ID của sản phẩm.
     * @param userID ID của người dùng.
     * @param rate Điểm đánh giá.
     * @param comment Bình luận về sản phẩm.
     * @return ResponseEntity với mã trạng thái HTTP tương ứng.
     * - `201 Created` nếu đánh giá được thêm thành công.
     * - `500 Internal Server Error` nếu có lỗi xảy ra trong quá trình thêm đánh giá.
     */
    @PostMapping("/addRate")
    public ResponseEntity<HttpStatus> addRate(
            @RequestParam(value = "productID") String productID,
            @RequestParam(value = "userID") String userID,
            @RequestParam(value = "rate") int rate,
            @RequestParam(value = "comment", defaultValue = "none") String comment
    ) {
        // Tạo câu lệnh SQL INSERT
        String query = "INSERT INTO rate_product (productID, userID, rate, comment) VALUES (" +
                "'" + productID + "', " +
                "'" + userID + "', " +
                rate + ", " +
                "'" + comment + "')";

        int rowsInserted = postgresService.executeUpdate(query);

        if (rowsInserted > 0) {
            return new ResponseEntity<>(HttpStatus.CREATED); // Trả về 201 Created nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
        }
    }

    /**
     * Xóa một đánh giá theo ID sản phẩm và ID người dùng.
     *
     * @param productID ID của sản phẩm.
     * @param userID ID của người dùng.
     * @return ResponseEntity với mã trạng thái HTTP tương ứng.
     * - `204 No Content` nếu đánh giá được xóa thành công.
     * - `404 Not Found` nếu không tìm thấy đánh giá để xóa.
     */
    @DeleteMapping("/deleteRate")
    public ResponseEntity<HttpStatus> deleteRate(
            @RequestParam(value = "productID") String productID,
            @RequestParam(value = "userID") String userID
    ) {
        String query = "DELETE FROM rate_product WHERE productID = '" + productID + "' AND userID = '" + userID + "'";
        int rowsDeleted = postgresService.executeUpdate(query);

        if (rowsDeleted > 0) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // Trả về 204 No Content nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 nếu không tìm thấy
        }
    }
}
