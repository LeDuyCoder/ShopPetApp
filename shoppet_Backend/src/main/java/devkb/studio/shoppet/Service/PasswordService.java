package devkb.studio.shoppet.Service;

import org.springframework.stereotype.Service;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Service
public class PasswordService {

    private final PasswordEncoder passwordEncoder;

    public PasswordService() {
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    public String encode(String rawPassword) {
        return passwordEncoder.encode(rawPassword);
    }


    /**
     *
     * @author KiraDev
     * @return function check password
     * */
    public boolean checkPassword(String rawPassword, String storePassword){
        boolean isPasswordMatch = passwordEncoder.matches(rawPassword, storePassword);

        return isPasswordMatch;
    }
}
