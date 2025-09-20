package daangn.builders.hankan.config.swagger;

import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.time.Duration;

@Slf4j
@Configuration
public class SwaggerConfig {

    @Value("${api.server.url}")
    private String serverUrl;

    @Autowired(required = false)
    private JwtTokenProvider jwtTokenProvider;
    
    @Value("${spring.profiles.active:default}")
    private String activeProfile;

    @PostConstruct
    public void init() {
        log.info("Initializing Swagger API serverULR = {}", serverUrl);
    }

    @Bean
    public OpenAPI openAPI() {
        // Generate default token for dev environment
        String defaultToken = null;
        if (("local".equals(activeProfile) || "dev".equals(activeProfile)) && jwtTokenProvider != null) {
            defaultToken = jwtTokenProvider.generateTestAccessToken(1L, "010-1234-5678", Duration.ofDays(365));
            log.info("========================================");
            log.info("🔑 Swagger Default Token Generated for Development");
            log.info("Token is automatically set in Swagger UI");
            log.info("User ID: 1, Phone: 010-1234-5678");
            log.info("========================================");
        }
        
        SecurityScheme securityScheme = new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT Access Token")
                .in(SecurityScheme.In.HEADER);
        
        // Set default token for development
        if (defaultToken != null) {
            securityScheme.description("Default development token is pre-filled. Token: Bearer " + defaultToken);
        }
        
        return new OpenAPI()
                .info(info)
                .addServersItem(new Server().url(serverUrl))
                .addSecurityItem(new SecurityRequirement().addList("bearerAuth"))
                .components(
                        new Components()
                                .addSecuritySchemes("bearerAuth", securityScheme)
                );
    }

    Info info = new Info().title("APIS");
}
