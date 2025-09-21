package daangn.builders.hankan.api.auth.controller;

import daangn.builders.hankan.api.auth.dto.TokenResponse;
import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.auth.LoginContext;
import daangn.builders.hankan.domain.auth.AuthService;
import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth/token")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Token", description = "토큰 관리 API")
public class TokenController {

    private final AuthService authService;
    private final JwtTokenProvider jwtTokenProvider;

    @PostMapping("/refresh")
    @Operation(summary = "토큰 갱신", description = "Refresh Token을 사용하여 새로운 Access Token과 Refresh Token을 발급받습니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "토큰 갱신 성공"),
            @ApiResponse(responseCode = "401", description = "유효하지 않은 Refresh Token"),
            @ApiResponse(responseCode = "404", description = "사용자를 찾을 수 없음")
    })
    public ResponseEntity<TokenResponse> refreshToken(
            @Parameter(description = "Refresh Token", required = true)
            @RequestHeader("Authorization") String authorizationHeader) {
        
        try {
            // Bearer 토큰에서 토큰 값 추출
            String refreshToken = jwtTokenProvider.resolveToken(authorizationHeader);
            
            if (refreshToken == null) {
                log.warn("Invalid authorization header format");
                return ResponseEntity.status(401).build();
            }
            
            TokenResponse response = authService.refreshToken(refreshToken);
            log.info("Token refreshed successfully for user: {}", response.getUserId());
            return ResponseEntity.ok(response);
            
        } catch (IllegalArgumentException e) {
            log.warn("Token refresh failed: {}", e.getMessage());
            return ResponseEntity.status(401).build();
        } catch (Exception e) {
            log.error("Unexpected error during token refresh", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/logout")
    @Login
    @Operation(summary = "로그아웃", description = "로그아웃 처리를 하고 Refresh Token을 무효화합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "로그아웃 성공"),
            @ApiResponse(responseCode = "401", description = "인증되지 않은 요청")
    })
    public ResponseEntity<Map<String, String>> logout() {
        try {
            Long userId = LoginContext.getCurrentUserId();
            if (userId == null) {
                return ResponseEntity.status(401).build();
            }
            
            authService.logout(userId);
            
            Map<String, String> response = new HashMap<>();
            response.put("message", "로그아웃되었습니다");
            
            log.info("User logged out successfully: {}", userId);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("Logout failed", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/validate")
    @Operation(summary = "토큰 유효성 검증", description = "Access Token의 유효성을 검증합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "유효한 토큰"),
            @ApiResponse(responseCode = "401", description = "유효하지 않은 토큰")
    })
    public ResponseEntity<Map<String, Object>> validateToken(
            @Parameter(description = "Access Token", required = true)
            @RequestHeader("Authorization") String authorizationHeader) {
        
        try {
            String accessToken = jwtTokenProvider.resolveToken(authorizationHeader);
            
            if (accessToken == null) {
                return ResponseEntity.status(401).build();
            }
            
            boolean isValid = jwtTokenProvider.validateAccessToken(accessToken);
            
            if (isValid) {
                Long userId = jwtTokenProvider.getUserIdFromToken(accessToken, true);
                String phoneNumber = jwtTokenProvider.getPhoneNumberFromToken(accessToken, true);
                
                Map<String, Object> response = new HashMap<>();
                response.put("valid", true);
                response.put("userId", userId);
                response.put("phoneNumber", phoneNumber);
                
                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> response = new HashMap<>();
                response.put("valid", false);
                return ResponseEntity.status(401).body(response);
            }
            
        } catch (Exception e) {
            log.error("Token validation failed", e);
            Map<String, Object> response = new HashMap<>();
            response.put("valid", false);
            return ResponseEntity.status(401).body(response);
        }
    }
}