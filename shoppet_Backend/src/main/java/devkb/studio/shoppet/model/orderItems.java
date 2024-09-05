package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class orderItems {
    private String orderItemID;
    private String orderID;
    private String productID;
    private int quantity;
    private double price;
}
