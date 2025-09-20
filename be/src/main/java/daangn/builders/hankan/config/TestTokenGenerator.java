package daangn.builders.hankan.config;

import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
@RequiredArgsConstructor
@Slf4j
@Profile({"local", "dev"}) // local과 dev 프로파일에서만 실행
public class TestTokenGenerator implements ApplicationRunner {

    private final JwtTokenProvider jwtTokenProvider;
    
    // 테스트용 고정 사용자 정보
    private static final Long TEST_USER_ID = 1L;
    private static final String TEST_PHONE_NUMBER = "010-1234-5678";
    
    @Override
    public void run(ApplicationArguments args) {
        // 1년 유효기간을 가진 테스트 토큰 생성
        String testAccessToken = jwtTokenProvider.generateTestAccessToken(TEST_USER_ID, TEST_PHONE_NUMBER, Duration.ofDays(365));
        
        log.info("========================================");
        log.info("🔑 Development Test Token Generated");
        log.info("========================================");
        log.info("User ID: {}", TEST_USER_ID);
        log.info("Phone Number: {}", TEST_PHONE_NUMBER);
        log.info("Token: {}", testAccessToken);
        log.info("========================================");
        log.info("Use this token in Authorization header:");
        log.info("Authorization: Bearer {}", testAccessToken);
        log.info("========================================");
    }
}