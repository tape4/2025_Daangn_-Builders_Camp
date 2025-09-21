package daangn.builders.hankan.common.auth;

import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
@ConditionalOnProperty(name = "jwt.enabled", havingValue = "true", matchIfMissing = true)
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        try {
            String token = jwtTokenProvider.resolveToken(request.getHeader("Authorization"));
            
            if (token != null && jwtTokenProvider.validateAccessToken(token)) {
                Long userId = jwtTokenProvider.getUserIdFromToken(token, true);
                String phoneNumber = jwtTokenProvider.getPhoneNumberFromToken(token, true);
                
                // Set authentication info in LoginContext for @Login annotation support
                LoginContext.setCurrentUserId(userId);
                LoginContext.setCurrentPhoneNumber(phoneNumber);
                
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        userId,
                        null,
                        List.of(new SimpleGrantedAuthority("ROLE_USER"))
                );
                
                SecurityContextHolder.getContext().setAuthentication(authentication);
                log.debug("Authenticated user: {}", userId);
            }
        } catch (Exception e) {
            log.debug("Authentication failed: {}", e.getMessage());
        }
        
        try {
            filterChain.doFilter(request, response);
        } finally {
            LoginContext.clear();
        }
    }
}