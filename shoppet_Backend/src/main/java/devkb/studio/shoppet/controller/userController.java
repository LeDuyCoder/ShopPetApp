package devkb.studio.shoppet.controller;

import devkb.studio.shoppet.ROLE_account;
import devkb.studio.shoppet.Service.PasswordService;
import devkb.studio.shoppet.Service.PostgresService;
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
public class userController {

    private final PostgresService postgresService;
    private final PasswordService passwordService;

    @Autowired
    public userController(PostgresService postgresService, PasswordService passwordService) {
        this.postgresService = postgresService;
        this.passwordService = passwordService;
    }


    /**
     * Lấy thông tin người dùng từ cơ sở dữ liệu.
     *
     * @param user_id ID của người dùng (tùy chọn).
     * @param username Tên đăng nhập của người dùng (tùy chọn).
     * @return ResponseEntity với danh sách các đối tượng User.
     * - `200 OK` nếu tìm thấy người dùng hoặc danh sách người dùng rỗng.
     */
    @GetMapping("/getUser")
    public ResponseEntity<List<User>> getUsers(
            @RequestParam(value = "user_id", defaultValue = "none") String user_id,
            @RequestParam(value = "username", defaultValue = "none") String username
    ) {
        List<User> users = new ArrayList<>();

        String query = "SELECT * FROM \"user\"";
        if (!user_id.equals("none") || !username.equals("none")) {
            query += " WHERE";
            if (!user_id.equals("none")) {
                query += " user_id = '" + user_id + "'";
            }
            if (!username.equals("none")) {
                if (!user_id.equals("none")) {
                    query += " AND";
                }
                query += " username = '" + username + "'";
            }
        }

        List<Map<String, Object>> results = postgresService.executeQuery(query);

        for (Map<String, Object> row : results) {
            User user = User.builder()
                    .uuid((String) row.get("user_id"))
                    .username((String) row.get("username"))
                    .password((String) row.get("password"))
                    .name((String) row.get("name"))
                    .mail((String) row.get("mail"))
                    .phone(row.get("phone") != null ? Long.parseLong(row.get("phone").toString()) : null)
                    .address((String) row.get("address"))
                    .create_at((Date) row.get("created_at"))
                    .role("USER".equals(row.get("role")) ? ROLE_account.USER : ROLE_account.ADMIN)
                    .build();
            users.add(user);
        }

        return ResponseEntity.ok(users);
    }


    /**
     * Tạo tài khoản người dùng mới.
     *
     * @param username Tên đăng nhập của người dùng.
     * @param password Mật khẩu của người dùng.
     * @param mail Email của người dùng.
     * @param name Tên của người dùng.
     * @param phone Số điện thoại của người dùng.
     * @param address Địa chỉ của người dùng.
     * @return ResponseEntity với mã trạng thái HTTP tương ứng.
     * - `201 Created` nếu tài khoản được tạo thành công.
     * - `409 Conflict` nếu tên đăng nhập đã tồn tại.
     * - `500 Internal Server Error` nếu có lỗi xảy ra trong quá trình tạo tài khoản.
     */
    @PostMapping("/createAccount")
    public ResponseEntity<HttpStatus> createNewAccount(
            @RequestParam(value = "username", defaultValue = "none") String username,
            @RequestParam(value = "password", defaultValue = "none") String password,
            @RequestParam(value = "mail", defaultValue = "none") String mail,
            @RequestParam(value = "name", defaultValue = "none") String name,
            @RequestParam(value = "phone", defaultValue = "0") long phone,
            @RequestParam(value = "address", defaultValue = "none") String address
    ) {
        ResponseEntity<List<User>> listUser = this.getUsers("none", username);
        if(!Objects.requireNonNull(listUser.getBody()).isEmpty()){
            return new ResponseEntity<>(HttpStatus.CONFLICT);
        }else{
            UUID user_id = UUID.nameUUIDFromBytes(username.getBytes(StandardCharsets.UTF_8));
            Date stampTime = Date.valueOf(LocalDate.now());

            // Tạo câu lệnh SQL INSERT
            String query = "INSERT INTO \"user\" (user_id, username, password, name, mail, phone, address, created_at, role) VALUES (" +
                    "'" + user_id.toString() + "', " +
                    "'" + username + "', " +
                    "'" + this.passwordService.encode(password) + "', " +
                    "'" + name + "', " +
                    "'" + mail + "', " +
                    "'" + phone + "', " +
                    "'" + address + "', " +
                    "'" + stampTime.toString() + "', "  +
                    "'" + ROLE_account.USER.toString() + "')";

            int rowsInserted = postgresService.executeUpdate(query);

            if (rowsInserted > 0) {
                return new ResponseEntity<>(HttpStatus.CREATED); // Trả về 201 Created nếu thành công
            } else {
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // Trả về 500 nếu có lỗi
            }
        }
    }

    /**
     * Kiểm tra xem người dùng có tồn tại hay không.
     *
     * @param username Tên đăng nhập của người dùng.
     * @return true nếu người dùng tồn tại, false nếu không tồn tại.
     */
    @GetMapping("/checkUser")
    private boolean userExists(String username) {
        ResponseEntity<List<User>> listUser = this.getUsers("none", username);
        return !Objects.requireNonNull(listUser.getBody()).isEmpty();
    }

    /**
     * Cập nhật thông tin người dùng.
     *
     * @param user_id ID của người dùng (tùy chọn).
     * @param username Tên đăng nhập của người dùng (tùy chọn).
     * @param name Tên của người dùng (tùy chọn).
     * @param mail Email của người dùng (tùy chọn).
     * @param password Mật khẩu của người dùng (tùy chọn).
     * @param phone Số điện thoại của người dùng (tùy chọn).
     * @param address Địa chỉ của người dùng (tùy chọn).
     * @return ResponseEntity với mã trạng thái HTTP tương ứng.
     * - `200 OK` nếu thông tin người dùng được cập nhật thành công.
     * - `400 Bad Request` nếu không có `user_id` hoặc `username` để xác định người dùng.
     * - `404 Not Found` nếu không tìm thấy người dùng để cập nhật.
     */
    @PutMapping("/updateUser")
    public ResponseEntity<HttpStatus> updateUser(
            @RequestParam(value = "user_id", required = false) String user_id,
            @RequestParam(value = "username", required = false) String username,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "mail", required = false) String mail,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam(value = "phone", required = false) Long phone,
            @RequestParam(value = "address", required = false) String address
    ) {
        // Kiểm tra sự tồn tại của user dựa trên user_id hoặc username
        if (user_id == null && username == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        StringBuilder queryBuilder = new StringBuilder("UPDATE \"user\" SET ");
        List<Object> parameters = new ArrayList<>();

        if (name != null) {
            queryBuilder.append("name = ?, ");
            parameters.add(name);
        }
        if (mail != null) {
            queryBuilder.append("mail = ?, ");
            parameters.add(mail);
        }
        if (password != null) {
            queryBuilder.append("password = ?, ");
            parameters.add(passwordService.encode(password)); // Mã hóa mật khẩu trước khi lưu
        }
        if (phone != null) {
            queryBuilder.append("phone = ?, ");
            parameters.add(phone);
        }
        if (address != null) {
            queryBuilder.append("address = ?, ");
            parameters.add(address);
        }

        if (!queryBuilder.isEmpty()) {
            queryBuilder.setLength(queryBuilder.length() - 2);
        }

        // Thêm điều kiện WHERE
        queryBuilder.append(" WHERE ");
        if (user_id != null) {
            queryBuilder.append("user_id = ?");
            parameters.add(user_id);
        } else {
            queryBuilder.append("username = ?");
            parameters.add(username);
        }

        // Thực hiện truy vấn cập nhật
        int rowsUpdated = postgresService.executeUpdate(queryBuilder.toString(), parameters.toArray());

        if (rowsUpdated > 0) {
            return new ResponseEntity<>(HttpStatus.OK); // Trả về 200 OK nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 nếu không tìm thấy
        }
    }

    /**
     * Xóa người dùng theo ID.
     *
     * @param user_id ID của người dùng cần xóa.
     * @return ResponseEntity với mã trạng thái HTTP tương ứng.
     * - `204 No Content` nếu người dùng được xóa thành công.
     * - `404 Not Found` nếu không tìm thấy người dùng để xóa.
     */
    @DeleteMapping("/deleteUser/{user_id}")
    public ResponseEntity<HttpStatus> deleteUser(@PathVariable String user_id) {
        String query = "DELETE FROM \"user\" WHERE user_id = \" "+user_id+"\"";
        int rowsDeleted = postgresService.executeUpdate(query);

        if (rowsDeleted > 0) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // Trả về 204 No Content nếu thành công
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 nếu không tìm thấy
        }
    }

    /**
     * Kiểm tra mật khẩu của người dùng.
     *
     * @param username Tên đăng nhập của người dùng.
     * @param password Mật khẩu của người dùng.
     * @return ResponseEntity với mã trạng thái HTTP tương ứng.
     * - `200 OK` nếu mật khẩu chính xác.
     * - `401 Unauthorized` nếu mật khẩu không chính xác hoặc không tìm thấy người dùng.
     */
    @PostMapping("/checkpass")
    public ResponseEntity<HttpStatus> checkpass(
            @RequestParam(value = "username", required = false) String username,
            @RequestParam(value = "password", required = false) String password
    ) {
        if (username == null || password == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST); // Trả về 400 Bad Request nếu thiếu thông tin
        }

        // Truy vấn người dùng dựa trên username
        ResponseEntity<List<User>> listUser = this.getUsers("none", username);
        List<User> users = listUser.getBody();

        if (users == null || users.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND); // Trả về 404 Not Found nếu không tìm thấy người dùng
        }

        User user = users.get(0);

        // Kiểm tra mật khẩu
        if (passwordService.checkPassword(password, user.getPassword())) {
            return new ResponseEntity<>(HttpStatus.OK); // Trả về 200 OK nếu mật khẩu chính xác
        } else {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); // Trả về 401 Unauthorized nếu mật khẩu không chính xác
        }
    }
}
