package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Builder
@Data
public class cart {
    private String cart_id;
    private String user_id;
    private Date created_at;
}
