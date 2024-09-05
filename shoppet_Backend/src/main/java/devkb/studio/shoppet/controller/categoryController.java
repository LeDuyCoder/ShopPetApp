package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.Service.PasswordService;
import devkb.studio.shoppet.Service.PostgresService;
import devkb.studio.shoppet.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@RestController
@RequestMapping("/api")
public class categoryController {
    private final PostgresService postgresService;

    @Autowired
    public categoryController(PostgresService postgresService, PasswordService passwordService) {
        this.postgresService = postgresService;
    }

    /**
     * Lấy danh sách các danh mục từ cơ sở dữ liệu.
     * Nếu tham số category_id được cung cấp, chỉ lấy danh mục với ID tương ứng.
     * Nếu không có tham số category_id, lấy tất cả các danh mục.
     *
     * @param category_id UUID của danh mục để tìm kiếm (có thể là null nếu muốn lấy tất cả các danh mục)
     * @return ResponseEntity chứa danh sách danh mục:
     *         - 200 OK nếu thành công, kèm theo danh sách danh mục.
     *         - 500 Internal Server Error nếu có lỗi xảy ra khi truy vấn cơ sở dữ liệu.
     */
    @GetMapping("/getCategory")
    public ResponseEntity<List<Category>> getCategory(
            @RequestParam(value = "category_id", defaultValue = "none") String category_id
    ){

        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM \"categories\"";
        if (!category_id.equals("none")) {
            query += " WHERE category_id = '" + category_id + "'";
        }

        List<Map<String, Object>> results = postgresService.executeQuery(query);

        if (results == null) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi khi truy vấn cơ sở dữ liệu
        }

        for (Map<String, Object> row : results) {
            Category category = Category.builder()
                    .category_id((String) row.get("category_id"))
                    .name((String) row.get("name"))
                    .parent_id((String) row.get("parent_id"))
                    .build();
            categories.add(category);
        }

        return ResponseEntity.ok(categories); // Trả về 200 OK với danh sách danh mục
    }

    /**
     * Kiểm tra sự tồn tại của danh mục dựa trên category_id.
     *
     * @param category_id UUID của danh mục để kiểm tra
     * @return true nếu danh mục tồn tại, false nếu không tồn tại
     */
    private boolean categoryExists(String category_id) {
        ResponseEntity<List<Category>> listCategories = this.getCategory(category_id);
        return !Objects.requireNonNull(listCategories.getBody()).isEmpty();
    }

    /**
     * Cập nhật thông tin danh mục dựa trên các tham số truyền vào.
     * Trả về mã trạng thái HTTP tương ứng với kết quả cập nhật và thông báo chi tiết.
     *
     * @param categoryId UUID của danh mục cần cập nhật
     * @param name Tên mới của danh mục (có thể null nếu không thay đổi)
     * @param parentId ID của danh mục cha mới (có thể null nếu không thay đổi)
     * @return ResponseEntity với mã trạng thái HTTP và thông báo chi tiết:
     *         - 200 OK nếu cập nhật thành công.
     *         - 400 Bad Request nếu không có điều kiện tìm kiếm hoặc không có trường nào để cập nhật.
     *         - 404 Not Found nếu không tìm thấy danh mục với categoryId.
     */
    @PutMapping("/updateCategory")
    public ResponseEntity<HttpStatus> updateCategory(
            @RequestParam(value = "category_id", required = false) String categoryId,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "parent_id", required = false) String parentId
    ) {
        // Kiểm tra sự tồn tại của categoryId
        if (categoryId == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST); // Không có điều kiện tìm kiếm
        }

        // Xây dựng câu lệnh SQL động dựa trên các tham số đã truyền vào
        StringBuilder queryBuilder = new StringBuilder("UPDATE \"categories\" SET ");
        List<Object> parameters = new ArrayList<>();

        if (name != null) {
            queryBuilder.append("name = ?, ");
            parameters.add(name);
        }
        if (parentId != null) {
            queryBuilder.append("parent_id = ?, ");
            parameters.add(parentId);
        }

        // Xóa dấu phẩy và khoảng trắng cuối cùng
        if (queryBuilder.length() > 0) {
            queryBuilder.setLength(queryBuilder.length() - 2); // Xóa dấu phẩy và khoảng trắng cuối cùng
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST); // Không có trường nào để cập nhật
        }

        // Thêm điều kiện WHERE
        queryBuilder.append(" WHERE category_id = ?");
        parameters.add(categoryId);

        // Thực hiện truy vấn cập nhật
        int rowsUpdated = postgresService.executeUpdate(queryBuilder.toString(), parameters.toArray());

        if (rowsUpdated > 0) {
            return new ResponseEntity<>(HttpStatus.OK); // Trả về 200 OK nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 nếu không tìm thấy
        }
    }

    /**
     * Thêm một danh mục mới vào cơ sở dữ liệu.
     * Kiểm tra xem category_id đã tồn tại chưa.
     *
     * @param categoryId UUID của danh mục mới
     * @param name Tên của danh mục
     * @param parentId ID của danh mục cha (có thể null nếu không có)
     * @return ResponseEntity với mã trạng thái HTTP và thông báo chi tiết:
     *         - 201 Created nếu thêm thành công.
     *         - 409 Conflict nếu category_id đã tồn tại.
     *         - 500 Internal Server Error nếu có lỗi xảy ra khi thực hiện truy vấn.
     */
    @PostMapping("/addCategory")
    public ResponseEntity<HttpStatus> addCategory(
            @RequestParam(value = "category_id") String categoryId,
            @RequestParam(value = "name") String name,
            @RequestParam(value = "parent_id", required = false) String parentId
    ) {
        // Kiểm tra sự tồn tại của category_id
        String checkQuery = "SELECT * FROM \"categories\" WHERE category_id = '" + categoryId + "'";
        List<Map<String, Object>> existingCategory = postgresService.executeQuery(checkQuery);

        if (!existingCategory.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.CONFLICT); // category_id đã tồn tại
        }

        // Tạo câu lệnh SQL INSERT
        String insertQuery = "INSERT INTO \"categories\" (category_id, name, parent_id) VALUES ('" +
                categoryId + "', '" +
                name + "', " +
                (parentId != null ? "'" + parentId + "'" : "NULL") + ")";

        // Thực hiện câu lệnh INSERT
        int rowsInserted = postgresService.executeUpdate(insertQuery);

        if (rowsInserted > 0) {
            return new ResponseEntity<>(HttpStatus.CREATED); // Trả về 201 Created nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
        }
    }

    /**
     * Xóa một danh mục khỏi cơ sở dữ liệu.
     *
     * @param categoryId UUID của danh mục cần xóa
     * @return ResponseEntity với mã trạng thái HTTP và thông báo chi tiết:
     *         - 204 No Content nếu xóa thành công.
     *         - 404 Not Found nếu không tìm thấy danh mục với categoryId.
     *         - 409 Conflict nếu không thể xóa do còn dữ liệu tham chiếu.
     */
    @DeleteMapping("/deleteCategory")
    public ResponseEntity<HttpStatus> deleteCategory(
            @RequestParam(value = "category_id") String categoryId
    ) {
        // Tạo câu lệnh SQL DELETE
        String deleteQuery = "DELETE FROM \"categories\" WHERE category_id = ?";

        try {
            // Thực hiện câu lệnh DELETE
            int rowsDeleted = postgresService.executeUpdate(deleteQuery, categoryId);

            if (rowsDeleted > 0) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT); // Trả về 204 No Content nếu thành công
            } else {
                return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 Not Found nếu không tìm thấy danh mục
            }
        } catch (DataIntegrityViolationException e) {
            // Xử lý lỗi khi có vi phạm ràng buộc khóa ngoại
            return new ResponseEntity<>(HttpStatus.CONFLICT); // Trả về 409 Conflict khi không thể xóa do còn dữ liệu tham chiếu
        }
    }
}
