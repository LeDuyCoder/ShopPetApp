package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Builder
@Data
public class visit {
    private  String userID;
    private Date date;
}
