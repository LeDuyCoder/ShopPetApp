package devkb.studio.shoppet;

import devkb.studio.shoppet.controller.userController;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.OpenAPI;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class ShoppetBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(ShoppetBackendApplication.class, args);
	}

	@Bean
	public OpenAPI customOpenAPI() {
		Info info = new Info().title("Shop Pet API").version("1.0").description("API documentation for Shop Pet");
		return new OpenAPI().info(info);
	}

}
