package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Builder
@Data
public class Product {
    private String product_id;
    private String name;
    private String description;
    private float price;
    private int stock_quantity;
    private String category_id;
    private Date created_at;
    private String image;
}
