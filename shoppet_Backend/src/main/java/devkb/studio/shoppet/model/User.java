package devkb.studio.shoppet.model;

import devkb.studio.shoppet.ROLE_account;
import lombok.Builder;
import lombok.Data;

import java.sql.Date;
import java.util.UUID;

@Builder
@Data
public class User {
    private String uuid;
    private String username;
    private String password;
    private String mail;
    private String name;
    private long phone;
    private String address;
    private Date create_at;
    private ROLE_account role;
}
