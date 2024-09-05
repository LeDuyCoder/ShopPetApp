package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class cartItems {
    private String cartItemID;
    private String cartID;
    private String product_ID;
}
