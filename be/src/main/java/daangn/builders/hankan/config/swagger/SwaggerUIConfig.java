package daangn.builders.hankan.config.swagger;

import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springdoc.core.customizers.GlobalOpenApiCustomizer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.time.Duration;

@Slf4j
@Configuration
@RequiredArgsConstructor
@Profile({"local", "dev"})
public class SwaggerUIConfig {
    
    private final JwtTokenProvider jwtTokenProvider;
    
    @Bean
    public GlobalOpenApiCustomizer devTokenCustomizer() {
        return openApi -> {
            // Generate a development token
            String devToken = jwtTokenProvider.generateTestAccessToken(1L, "010-1234-5678", Duration.ofDays(365));
            
            // Add the token to the description with instructions
            if (openApi.getComponents() != null && 
                openApi.getComponents().getSecuritySchemes() != null &&
                openApi.getComponents().getSecuritySchemes().containsKey("bearerAuth")) {
                
                String instructions = String.format(
                    "Development token (User ID: 1, Phone: 010-1234-5678):\n\n" +
                    "Click 'Authorize' button and paste this token:\n\n" +
                    "%s\n\n" +
                    "Note: This token is valid for 1 year in dev environment only.",
                    devToken
                );
                
                openApi.getComponents().getSecuritySchemes()
                    .get("bearerAuth")
                    .setDescription(instructions);
                
                log.info("========================================");
                log.info("🔑 Swagger UI - Development Token Ready");
                log.info("Token is displayed in the Authorization dialog");
                log.info("User ID: 1, Phone: 010-1234-5678");
                log.info("========================================");
            }
        };
    }
}