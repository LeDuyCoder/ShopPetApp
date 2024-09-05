package devkb.studio.shoppet.model;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Builder
@Data
public class adminLog {
    private UUID log_id;
    private UUID admin_id;
    private String action;
    private String timestamp;
}
