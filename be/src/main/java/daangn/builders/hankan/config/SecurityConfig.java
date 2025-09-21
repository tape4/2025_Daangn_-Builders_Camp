package daangn.builders.hankan.config;

import daangn.builders.hankan.common.auth.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.CsrfConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfigurationSource;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@Profile("!test")
public class SecurityConfig {

    private final CorsConfigurationSource corsConfigurationSource;
    
    @Autowired(required = false)
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    /**
     * 0. Chain for Swagger
     */
    @Bean
    @Order(0)
    public SecurityFilterChain swaggerSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher(
                        "/swagger-ui/**",
                        "/swagger-ui.html",
                        "/v3/api-docs/**",
                        "/swagger-resources/**",
                        "/webjars/**"
                )
                .csrf(CsrfConfigurer::disable)
                .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
                .httpBasic(Customizer.withDefaults());
        return http.build();
    }

    /**
     * 1. Main API Security Filter Chain with JWT
     */
    @Bean
    @Order(1)
    public SecurityFilterChain apiSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher("/api/**")
                .csrf(CsrfConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // Public authentication endpoints
                        .requestMatchers(HttpMethod.POST, "/api/auth/sms/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/auth/login").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/auth/signup").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/auth/signup/check-phone").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/auth/token/refresh").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/auth/token/validate").permitAll()
                        
                        // Debug endpoint (development only)
                        .requestMatchers("/api/debug/**").permitAll()
                        
                        // Health check
                        .requestMatchers(HttpMethod.GET, "/api/health").permitAll()
                        
                        // Public space search endpoints
                        .requestMatchers(HttpMethod.GET, "/api/spaces/search/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/spaces/top-rated").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/spaces/*/availability/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/spaces/*/capacity").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/spaces/*").permitAll()
                        
                        // All other API endpoints require authentication
                        .anyRequest().authenticated()
                );
        
        if (jwtAuthenticationFilter != null) {
            http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        }
        
        return http.build();
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return web -> web.ignoring()
                .requestMatchers(
                        "/health-check",
                        "/actuator/prometheus"
                );
    }
}