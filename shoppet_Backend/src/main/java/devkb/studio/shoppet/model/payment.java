package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Builder
@Data
public class payment {
    private String payment_id;
    private String order_id;
    private String payment_method;
    private boolean status;
    private Date created_at;
}
