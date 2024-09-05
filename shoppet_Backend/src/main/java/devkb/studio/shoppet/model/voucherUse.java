package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class voucherUse {
    private String userId;
    private String voucher_id;
}
