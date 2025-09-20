package daangn.builders.hankan.config;

import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
@RequiredArgsConstructor
@Slf4j
@Profile({"local", "dev"}) // local과 dev 프로파일에서만 실행
@Order(2) // DataInitializer 이후에 실행
public class TestTokenGenerator implements ApplicationRunner {

    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;
    
    // 테스트용 전화번호
    private static final String TEST_PHONE_NUMBER = "010-1234-5678";
    
    @Override
    public void run(ApplicationArguments args) {
        // 테스트 사용자 조회
        User testUser = userRepository.findByPhoneNumber(TEST_PHONE_NUMBER).orElse(null);
        
        if (testUser == null) {
            log.warn("Test user not found for phone: {}. Token generation skipped.", TEST_PHONE_NUMBER);
            return;
        }
        
        // 1년 유효기간을 가진 테스트 토큰 생성
        String testAccessToken = jwtTokenProvider.generateTestAccessToken(
            testUser.getId(), 
            TEST_PHONE_NUMBER, 
            Duration.ofDays(365)
        );
        
        log.info("========================================");
        log.info("🔑 Development Test Token Generated");
        log.info("========================================");
        log.info("User ID: {}", testUser.getId());
        log.info("Phone Number: {}", TEST_PHONE_NUMBER);
        log.info("Token: {}", testAccessToken);
        log.info("========================================");
        log.info("Use this token in Authorization header:");
        log.info("Authorization: Bearer {}", testAccessToken);
        log.info("========================================");
    }
}