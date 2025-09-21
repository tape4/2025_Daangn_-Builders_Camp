package daangn.builders.hankan.domain.auth;

import daangn.builders.hankan.api.auth.dto.*;
import daangn.builders.hankan.common.exception.DuplicateReviewException;
import daangn.builders.hankan.common.exception.UserNotFoundException;
import daangn.builders.hankan.domain.auth.jwt.JwtTokenProvider;
import daangn.builders.hankan.domain.auth.sms.SmsService;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class AuthService {

    private final UserRepository userRepository;
    private final SmsService smsService;
    private final JwtTokenProvider jwtTokenProvider;

    @Value("${jwt.access-token-expiration}")
    private long accessTokenExpiration;

    /**
     * 로그인 처리
     */
    @Transactional
    public TokenResponse login(LoginRequest request) {
        // 1. 전화번호 정규화
        String normalizedPhone = smsService.normalizePhoneNumber(request.getPhoneNumber());
        
        // 2. SMS 인증번호 확인
        boolean verified = smsService.verifyCode(normalizedPhone, request.getVerificationCode());
        if (!verified) {
            throw new IllegalArgumentException("인증번호가 일치하지 않거나 만료되었습니다");
        }
        
        // 3. 사용자 조회
        User user = userRepository.findByPhoneNumber(normalizedPhone)
                .orElseThrow(() -> new UserNotFoundException("등록되지 않은 전화번호입니다. 회원가입을 진행해주세요."));
        
        // 4. 토큰 생성
        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), normalizedPhone);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId(), normalizedPhone);
        
        log.info("User logged in successfully: {}", user.getId());
        
        return TokenResponse.of(
                accessToken,
                refreshToken,
                accessTokenExpiration / 1000, // 초 단위로 변환
                user.getId(),
                user.getNickname(),
                normalizedPhone
        );
    }

    /**
     * 회원가입 처리
     */
    @Transactional
    public TokenResponse signup(SignupRequest request, String profileImageUrl) {
        // 1. 전화번호 정규화
        String normalizedPhone = smsService.normalizePhoneNumber(request.getPhoneNumber());
        
        // 2. 중복 체크
        if (userRepository.existsByPhoneNumber(normalizedPhone)) {
            throw new DuplicateReviewException("이미 등록된 전화번호입니다");
        }
        
        // 3. 사용자 생성
        User newUser = User.builder()
                .phoneNumber(normalizedPhone)
                .nickname(request.getNickname())
                .birthDate(request.getBirthDate())
                .gender(request.getGender())
                .profileImageUrl(profileImageUrl)
                .build();
        
        User savedUser = userRepository.save(newUser);
        
        // 4. 토큰 생성
        String accessToken = jwtTokenProvider.generateAccessToken(savedUser.getId(), normalizedPhone);
        String refreshToken = jwtTokenProvider.generateRefreshToken(savedUser.getId(), normalizedPhone);
        
        log.info("New user signed up successfully: {}", savedUser.getId());
        
        return TokenResponse.of(
                accessToken,
                refreshToken,
                accessTokenExpiration / 1000,
                savedUser.getId(),
                savedUser.getNickname(),
                normalizedPhone
        );
    }

    /**
     * 토큰 갱신
     */
    public TokenResponse refreshToken(String refreshToken) {
        // 1. Refresh Token 검증
        if (!jwtTokenProvider.validateRefreshToken(refreshToken)) {
            throw new IllegalArgumentException("유효하지 않거나 만료된 Refresh Token입니다");
        }
        
        // 2. 토큰에서 사용자 정보 추출
        Long userId = jwtTokenProvider.getUserIdFromToken(refreshToken, false);
        String phoneNumber = jwtTokenProvider.getPhoneNumberFromToken(refreshToken, false);
        
        // 3. 사용자 확인
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("사용자를 찾을 수 없습니다"));
        
        // 4. 기존 Refresh Token 삭제
        jwtTokenProvider.deleteRefreshToken(userId);
        
        // 5. 새로운 토큰 생성
        String newAccessToken = jwtTokenProvider.generateAccessToken(userId, phoneNumber);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(userId, phoneNumber);
        
        log.info("Tokens refreshed for user: {}", userId);
        
        return TokenResponse.of(
                newAccessToken,
                newRefreshToken,
                accessTokenExpiration / 1000,
                user.getId(),
                user.getNickname(),
                phoneNumber
        );
    }

    /**
     * 로그아웃
     */
    @Transactional
    public void logout(Long userId) {
        // Refresh Token 삭제
        jwtTokenProvider.deleteRefreshToken(userId);
        log.info("User logged out: {}", userId);
    }

    /**
     * 전화번호 중복 체크
     */
    public boolean isPhoneNumberAvailable(String phoneNumber) {
        String normalizedPhone = smsService.normalizePhoneNumber(phoneNumber);
        return !userRepository.existsByPhoneNumber(normalizedPhone);
    }
}