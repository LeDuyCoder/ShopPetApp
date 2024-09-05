package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Builder
@Data
public class voucher {
    private String voucher_id;
    private String code;
    private float discount;
    private Date expiryDate;
    private double minOrder;
}
