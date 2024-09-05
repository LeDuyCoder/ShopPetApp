package devkb.studio.shoppet.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // Tắt CSRF protection
                .authorizeHttpRequests(authorize -> authorize
                        .anyRequest().permitAll() // Cho phép tất cả các yêu cầu không cần xác thực
                )
                .formLogin(AbstractHttpConfigurer::disable) // Tắt form login
                .httpBasic(AbstractHttpConfigurer::disable); // Tắt HTTP Basic Authentication

        return http.build();
    }
}