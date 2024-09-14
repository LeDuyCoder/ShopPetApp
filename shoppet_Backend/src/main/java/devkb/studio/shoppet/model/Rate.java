package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Rate {
    private String productID;
    private String userID;
    private int rate;
    private String comment;

}
