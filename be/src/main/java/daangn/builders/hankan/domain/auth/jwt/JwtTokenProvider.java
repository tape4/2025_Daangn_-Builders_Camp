package daangn.builders.hankan.domain.auth.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Date;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtTokenProvider {

    @Value("${jwt.access-secret-key}")
    private String accessSecretKey;

    @Value("${jwt.refresh-secret-key}")
    private String refreshSecretKey;

    @Value("${jwt.access-token-expiration}")
    private long accessTokenExpiration;

    @Value("${jwt.refresh-token-expiration}")
    private long refreshTokenExpiration;

    private final RedisTemplate<String, String> redisTemplate;

    private static final String REFRESH_TOKEN_PREFIX = "refresh:";
    private static final String TOKEN_TYPE = "Bearer";

    /**
     * Access Token 생성
     */
    public String generateAccessToken(Long userId, String phoneNumber) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + accessTokenExpiration);
        
        return Jwts.builder()
                .setSubject(String.valueOf(userId))
                .claim("phoneNumber", phoneNumber)
                .claim("tokenType", "ACCESS")
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getAccessKey(), SignatureAlgorithm.HS512)
                .compact();
    }

    /**
     * Refresh Token 생성 및 Redis 저장
     */
    public String generateRefreshToken(Long userId, String phoneNumber) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + refreshTokenExpiration);
        
        String refreshToken = Jwts.builder()
                .setSubject(String.valueOf(userId))
                .claim("phoneNumber", phoneNumber)
                .claim("tokenType", "REFRESH")
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getRefreshKey(), SignatureAlgorithm.HS512)
                .compact();
        
        // Redis에 저장 (키: refresh:userId, 값: refreshToken, TTL: 1주일)
        String key = REFRESH_TOKEN_PREFIX + userId;
        redisTemplate.opsForValue().set(key, refreshToken, Duration.ofMillis(refreshTokenExpiration));
        
        log.info("Refresh token saved to Redis for user: {}", userId);
        
        return refreshToken;
    }

    /**
     * 테스트용 Access Token 생성 (개발 환경 전용)
     */
    public String generateTestAccessToken(Long userId, String phoneNumber, Duration validity) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + validity.toMillis());
        
        return Jwts.builder()
                .setSubject(String.valueOf(userId))
                .claim("phoneNumber", phoneNumber)
                .claim("tokenType", "ACCESS")
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getAccessKey(), SignatureAlgorithm.HS512)
                .compact();
    }
    
    /**
     * 토큰에서 userId 추출
     */
    public Long getUserIdFromToken(String token, boolean isAccessToken) {
        Claims claims = parseClaims(token, isAccessToken);
        return Long.parseLong(claims.getSubject());
    }

    /**
     * 토큰에서 전화번호 추출
     */
    public String getPhoneNumberFromToken(String token, boolean isAccessToken) {
        Claims claims = parseClaims(token, isAccessToken);
        return claims.get("phoneNumber", String.class);
    }

    /**
     * Access Token 유효성 검증
     */
    public boolean validateAccessToken(String token) {
        try {
            Claims claims = parseClaims(token, true);
            return !claims.getExpiration().before(new Date());
        } catch (Exception e) {
            log.error("Access token validation failed: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Refresh Token 유효성 검증 (Redis 확인 포함)
     */
    public boolean validateRefreshToken(String token) {
        try {
            Claims claims = parseClaims(token, false);
            Long userId = Long.parseLong(claims.getSubject());
            
            // Redis에서 저장된 토큰과 비교
            String key = REFRESH_TOKEN_PREFIX + userId;
            String storedToken = redisTemplate.opsForValue().get(key);
            
            if (storedToken == null || !storedToken.equals(token)) {
                log.warn("Refresh token not found in Redis or mismatch for user: {}", userId);
                return false;
            }
            
            return !claims.getExpiration().before(new Date());
        } catch (Exception e) {
            log.error("Refresh token validation failed: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Refresh Token 삭제 (로그아웃 시 사용)
     */
    public void deleteRefreshToken(Long userId) {
        String key = REFRESH_TOKEN_PREFIX + userId;
        redisTemplate.delete(key);
        log.info("Refresh token deleted for user: {}", userId);
    }

    /**
     * 토큰 파싱
     */
    private Claims parseClaims(String token, boolean isAccessToken) {
        SecretKey key = isAccessToken ? getAccessKey() : getRefreshKey();
        
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Access Token용 시크릿 키 생성
     */
    private SecretKey getAccessKey() {
        return Keys.hmacShaKeyFor(accessSecretKey.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * Refresh Token용 시크릿 키 생성
     */
    private SecretKey getRefreshKey() {
        return Keys.hmacShaKeyFor(refreshSecretKey.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * Bearer 토큰에서 토큰 값만 추출
     */
    public String resolveToken(String bearerToken) {
        if (bearerToken != null && bearerToken.startsWith(TOKEN_TYPE + " ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}