package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.ROLE_account;
import devkb.studio.shoppet.Service.PasswordService;
import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.Product;
import devkb.studio.shoppet.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/api")
public class productController {

    private final PostgresService postgresService;

    @Autowired
    public productController(PostgresService postgresService, PasswordService passwordService) {
        this.postgresService = postgresService;
    }

    /**
     * Lấy danh sách sản phẩm dựa trên các tham số lọc.
     * Nếu không cung cấp tham số nào, trả về tất cả sản phẩm.
     *
     * @param product_id ID của sản phẩm (có thể null nếu không tìm theo ID)
     * @param name Tên sản phẩm (có thể null nếu không tìm theo tên)
     * @param category_id ID của danh mục sản phẩm (có thể null nếu không tìm theo danh mục)
     * @return Danh sách các sản phẩm phù hợp dưới dạng ResponseEntity
     *         - Nếu thành công, trả về danh sách sản phẩm và mã lỗi 200 (OK).
     *         - Nếu không tìm thấy sản phẩm nào, trả về danh sách trống và mã lỗi 204 (No Content).
     */
    @GetMapping("/getProduct")
    public ResponseEntity<List<Product>> getProducts(
            @RequestParam(value = "product_id", defaultValue = "none") String product_id,
            @RequestParam(value = "name", defaultValue = "none") String name,
            @RequestParam(value = "category_id", defaultValue = "none") String category_id
    ){

        List<Product> Product_Item = new ArrayList<>();

        String query = "SELECT * FROM \"products\"";
        if (!product_id.equals("none") || !name.equals("none") || !category_id.equals("none")) {
            query += " WHERE";
            if (!product_id.equals("none")) {
                query += " product_id = '" + product_id + "'";
            }
            if (!name.equals("none")) {
                if (!product_id.equals("none")) {
                    query += " AND";
                }
                query += " name = '" + name + "'";
            }
            if (!category_id.equals("none")) {
                if (!product_id.equals("none") || !name.equals("none")) {
                    query += " AND";
                }
                query += " category_id = '" + category_id + "'";
            }
        }

        List<Map<String, Object>> results = postgresService.executeQuery(query);

        System.out.println(results.toString());

        for (Map<String, Object> row : results) {
            Product product = Product.builder()
                    .product_id((String) row.get("product_id"))
                    .name((String) row.get("name"))
                    .description((String) row.get("description"))
                    .price(Float.parseFloat(row.get("price").toString()))
                    .stock_quantity(Integer.parseInt(row.get("stock_quantity").toString()))
                    .category_id((String) row.get("category_id"))
                    .created_at((Date) row.get("created_at"))
                    .image((String) row.get("image"))
                    .build();
            Product_Item.add(product);
        }

        // Trả về danh sách các sản phẩm
        return ResponseEntity.ok(Product_Item);
    }

    /**
     * Tạo một sản phẩm mới với thông tin được cung cấp.
     * Nếu sản phẩm với tên đã tồn tại, trả về mã lỗi 409 (Conflict).
     * Nếu tạo sản phẩm thành công, trả về mã lỗi 201 (Created).
     * Nếu có lỗi trong quá trình tạo sản phẩm, trả về mã lỗi 500 (Internal Server Error).
     *
     * @param name Tên sản phẩm
     * @param description Mô tả sản phẩm
     * @param price Giá sản phẩm
     * @param stockQuantity Số lượng sản phẩm trong kho
     * @param categoryId ID của danh mục sản phẩm
     * @param image Đường dẫn đến hình ảnh sản phẩm
     * @return ResponseEntity với mã lỗi tương ứng
     *         - Nếu tên sản phẩm đã tồn tại, trả về mã lỗi 409 (Conflict).
     *         - Nếu tạo sản phẩm thành công, trả về mã lỗi 201 (Created).
     *         - Nếu có lỗi trong quá trình tạo sản phẩm, trả về mã lỗi 500 (Internal Server Error).
     */
    @PostMapping("/createProduct")
    public ResponseEntity<HttpStatus> createNewProduct(
            @RequestParam(value = "name", defaultValue = "none") String name,
            @RequestParam(value = "description", defaultValue = "none") String description,
            @RequestParam(value = "price", defaultValue = "0.0") float price,
            @RequestParam(value = "stock_quantity", defaultValue = "0") int stockQuantity,
            @RequestParam(value = "category_id", defaultValue = "none") String categoryId,
            @RequestParam(value = "image", defaultValue = "none") String image
    ) {
        ResponseEntity<List<Product>> listProduct = this.getProducts("none", name, "none");
        if(!Objects.requireNonNull(listProduct.getBody()).isEmpty()){
            return new ResponseEntity<>(HttpStatus.CONFLICT);
        } else {
            UUID productId = UUID.nameUUIDFromBytes(name.getBytes(StandardCharsets.UTF_8));
            Date createdAt = Date.valueOf(LocalDate.now());

            // Tạo câu lệnh SQL INSERT
            String query = "INSERT INTO products (product_id, name, description, price, stock_quantity, category_id, created_at, image) VALUES (" +
                    "'" + productId.toString() + "', " +
                    "'" + name + "', " +
                    "'" + description + "', " +
                    "'" + price + "', " +
                    "'" + stockQuantity + "', " +
                    "'" + categoryId + "', " +
                    "'" + createdAt.toString() + "', " +
                    "'" + image + "')";

            int rowsInserted = postgresService.executeUpdate(query);

            if (rowsInserted > 0) {
                return new ResponseEntity<>(HttpStatus.CREATED); // Trả về 201 Created nếu thành công
            } else {
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
            }
        }
    }

    /**
     * Cập nhật thông tin của một sản phẩm dựa trên product_id.
     * Nếu sản phẩm không tồn tại, trả về mã lỗi 404 (Not Found).
     * Nếu cập nhật thành công, trả về mã lỗi 200 (OK).
     * Nếu có lỗi trong quá trình cập nhật, trả về mã lỗi 500 (Internal Server Error).
     *
     * @param productId ID của sản phẩm cần cập nhật
     * @param name Tên sản phẩm mới (có thể null nếu không thay đổi)
     * @param description Mô tả sản phẩm mới (có thể null nếu không thay đổi)
     * @param price Giá sản phẩm mới (có thể là 0.0 nếu không thay đổi)
     * @param stockQuantity Số lượng sản phẩm trong kho mới (có thể là 0 nếu không thay đổi)
     * @param categoryId ID của danh mục sản phẩm mới (có thể null nếu không thay đổi)
     * @param image Đường dẫn đến hình ảnh sản phẩm mới (có thể null nếu không thay đổi)
     * @return ResponseEntity với mã lỗi tương ứng
     *         - Nếu sản phẩm không tồn tại, trả về mã lỗi 404 (Not Found).
     *         - Nếu cập nhật thành công, trả về mã lỗi 200 (OK).
     *         - Nếu có lỗi trong quá trình cập nhật, trả về mã lỗi 500 (Internal Server Error).
     */
    @PutMapping("/updateProduct")
    public ResponseEntity<HttpStatus> updateProduct(
            @RequestParam(value = "product_id") String productId,
            @RequestParam(value = "name", defaultValue = "none") String name,
            @RequestParam(value = "description", defaultValue = "none") String description,
            @RequestParam(value = "price", defaultValue = "0.0") float price,
            @RequestParam(value = "stock_quantity", defaultValue = "0") int stockQuantity,
            @RequestParam(value = "category_id", defaultValue = "none") String categoryId,
            @RequestParam(value = "image", defaultValue = "none") String image
    ) {
        ResponseEntity<List<Product>> listProduct = this.getProducts(productId, "none", "none");
        if (Objects.requireNonNull(listProduct.getBody()).isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } else {
            // Build the SQL UPDATE query
            String query = "UPDATE products SET ";
            List<String> updates = new ArrayList<>();

            if (!name.equals("none")) updates.add("name = '" + name + "'");
            if (!description.equals("none")) updates.add("description = '" + description + "'");
            if (price != 0.0f) updates.add("price = " + price);
            if (stockQuantity != 0) updates.add("stock_quantity = " + stockQuantity);
            if (!categoryId.equals("none")) updates.add("category_id = '" + categoryId + "'");
            if (!image.equals("none")) updates.add("image = '" + image + "'");

            query += String.join(", ", updates) + " WHERE product_id = '" + productId + "'";

            int rowsUpdated = postgresService.executeUpdate(query);

            if (rowsUpdated > 0) {
                return new ResponseEntity<>(HttpStatus.OK); // Trả về 200 OK nếu thành công
            } else {
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
            }
        }
    }

    /**
     * Xóa một sản phẩm dựa trên product_id.
     * Nếu sản phẩm không tồn tại, trả về mã lỗi 404 (Not Found).
     * Nếu xóa thành công, trả về mã lỗi 200 (OK).
     * Nếu có lỗi trong quá trình xóa, trả về mã lỗi 500 (Internal Server Error).
     *
     * @param productId ID của sản phẩm cần xóa
     * @return ResponseEntity với mã lỗi tương ứng
     *         - Nếu sản phẩm không tồn tại, trả về mã lỗi 404 (Not Found).
     *         - Nếu xóa thành công, trả về mã lỗi 200 (O).
     *         - Nếu có lỗi trong quá trình xóa, trả về mã lỗi 500 (Internal Server Error).
     */
    @DeleteMapping("/removeProduct")
    public ResponseEntity<HttpStatus> removeProduct(
            @RequestParam(value = "product_id") String productId
    ) {
        ResponseEntity<List<Product>> listProduct = this.getProducts(productId, "none", "none");
        if (Objects.requireNonNull(listProduct.getBody()).isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } else {
            // Build the SQL DELETE query
            String query = "DELETE FROM products WHERE product_id = '" + productId + "'";

            int rowsDeleted = postgresService.executeUpdate(query);

            if (rowsDeleted > 0) {
                return new ResponseEntity<>(HttpStatus.OK); // Trả về 200 OK nếu thành công
            } else {
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
            }
        }
    }
}
