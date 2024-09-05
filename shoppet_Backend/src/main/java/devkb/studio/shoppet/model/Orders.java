package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;
import java.util.List;

@Builder
@Data
public class Orders {
    private String order_id;
    private String user_id;
    private float total_price;
    private String status;
    private Date created_at;
    private List<String> voucher_id;
}
