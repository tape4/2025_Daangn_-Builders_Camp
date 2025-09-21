package daangn.builders.hankan.domain.auth.sms;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
@RequiredArgsConstructor
@Slf4j
public class SmsService {

    private final DefaultMessageService messageService;
    private final RedisTemplate<String, String> redisTemplate;

    @Value("${coolsms.phone-number}")
    private String senderPhoneNumber;

    private static final String VERIFICATION_KEY_PREFIX = "sms:verification:";
    private static final Duration VERIFICATION_TTL = Duration.ofMinutes(3);
    private static final int VERIFICATION_CODE_LENGTH = 6;

    /**
     * SMS 인증번호 발송
     * @param phoneNumber 수신자 전화번호
     * @return 발송 성공 여부
     */
    public boolean sendVerificationCode(String phoneNumber) {
        try {
            // 6자리 랜덤 숫자 생성
            String verificationCode = generateVerificationCode();
            
            // Redis에 저장 (키: sms:verification:전화번호, 값: 인증번호, TTL: 3분)
            String key = VERIFICATION_KEY_PREFIX + phoneNumber;
            redisTemplate.opsForValue().set(key, verificationCode, VERIFICATION_TTL);
            
            // SMS 메시지 생성
            Message message = new Message();
            message.setFrom(senderPhoneNumber);
            message.setTo(phoneNumber);
            message.setText(String.format("[한칸] 인증번호는 [%s]입니다. 3분 이내에 입력해주세요.", verificationCode));
            
            // SMS 발송
            SingleMessageSentResponse response = messageService.sendOne(new SingleMessageSendingRequest(message));
            
            log.info("SMS sent successfully to {}, messageId: {}", phoneNumber, response.getMessageId());
            return true;
            
        } catch (Exception e) {
            log.error("Failed to send SMS to {}: {}", phoneNumber, e.getMessage(), e);
            return false;
        }
    }

    /**
     * 인증번호 검증
     * @param phoneNumber 전화번호
     * @param code 입력한 인증번호
     * @return 검증 성공 여부
     */
    public boolean verifyCode(String phoneNumber, String code) {
        try {
            String key = VERIFICATION_KEY_PREFIX + phoneNumber;
            String storedCode = redisTemplate.opsForValue().get(key);
            
            if (storedCode == null) {
                log.warn("Verification code not found or expired for {}", phoneNumber);
                return false;
            }
            
            boolean isValid = storedCode.equals(code);
            
            if (isValid) {
                // 검증 성공 시 Redis에서 삭제
                redisTemplate.delete(key);
                log.info("Verification successful for {}", phoneNumber);
            } else {
                log.warn("Invalid verification code for {}", phoneNumber);
            }
            
            return isValid;
            
        } catch (Exception e) {
            log.error("Error verifying code for {}: {}", phoneNumber, e.getMessage(), e);
            return false;
        }
    }

    /**
     * 인증번호 재발송
     * @param phoneNumber 수신자 전화번호
     * @return 발송 성공 여부
     */
    public boolean resendVerificationCode(String phoneNumber) {
        // 기존 인증번호 삭제
        String key = VERIFICATION_KEY_PREFIX + phoneNumber;
        redisTemplate.delete(key);
        
        // 새로운 인증번호 발송
        return sendVerificationCode(phoneNumber);
    }

    /**
     * 6자리 랜덤 숫자 생성
     * @return 6자리 숫자 문자열
     */
    private String generateVerificationCode() {
        return RandomStringUtils.randomNumeric(VERIFICATION_CODE_LENGTH);
    }

    /**
     * 전화번호 포맷 검증 및 정규화
     * @param phoneNumber 전화번호
     * @return 정규화된 전화번호
     */
    public String normalizePhoneNumber(String phoneNumber) {
        // 하이픈, 공백 제거
        String normalized = phoneNumber.replaceAll("[\\s-]", "");
        
        // 한국 전화번호 형식 검증 (010, 011, 016, 017, 018, 019로 시작하는 10~11자리)
        if (!normalized.matches("^01[0-9]{8,9}$")) {
            throw new IllegalArgumentException("유효하지 않은 전화번호 형식입니다");
        }
        
        return normalized;
    }
}