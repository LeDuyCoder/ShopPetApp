package devkb.studio.shoppet.model;


import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class Category {
    private String category_id;
    private String name;
    private String parent_id;
}
