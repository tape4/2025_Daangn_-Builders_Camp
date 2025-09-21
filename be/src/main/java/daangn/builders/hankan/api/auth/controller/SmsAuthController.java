package daangn.builders.hankan.api.auth.controller;

import daangn.builders.hankan.api.auth.dto.SmsVerificationCheckRequest;
import daangn.builders.hankan.api.auth.dto.SmsVerificationRequest;
import daangn.builders.hankan.api.auth.dto.SmsVerificationResponse;
import daangn.builders.hankan.domain.auth.sms.SmsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth/sms")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "SMS Authentication", description = "SMS 인증 API")
public class SmsAuthController {

    private final SmsService smsService;

    @PostMapping("/send")
    @Operation(summary = "인증번호 발송", description = "휴대폰 번호로 6자리 인증번호를 발송합니다. 인증번호는 3분간 유효합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "인증번호 발송 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 전화번호 형식"),
            @ApiResponse(responseCode = "500", description = "SMS 발송 실패")
    })
    public ResponseEntity<SmsVerificationResponse> sendVerificationCode(
            @Valid @RequestBody SmsVerificationRequest request) {
        
        try {
            String normalizedPhone = smsService.normalizePhoneNumber(request.getPhoneNumber());
            boolean sent = smsService.sendVerificationCode(normalizedPhone);
            
            if (sent) {
                log.info("Verification code sent to {}", normalizedPhone);
                return ResponseEntity.ok(
                        SmsVerificationResponse.success("인증번호가 발송되었습니다. 3분 이내에 입력해주세요.")
                );
            } else {
                log.warn("Failed to send verification code to {}", normalizedPhone);
                return ResponseEntity.internalServerError().body(
                        SmsVerificationResponse.failure("인증번호 발송에 실패했습니다. 잠시 후 다시 시도해주세요.")
                );
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(
                    SmsVerificationResponse.failure(e.getMessage())
            );
        } catch (Exception e) {
            log.error("Unexpected error sending verification code", e);
            return ResponseEntity.internalServerError().body(
                    SmsVerificationResponse.failure("시스템 오류가 발생했습니다.")
            );
        }
    }

    @PostMapping("/verify")
    @Operation(summary = "인증번호 확인", description = "발송된 인증번호를 확인합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "인증 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청 또는 인증 실패"),
            @ApiResponse(responseCode = "404", description = "인증번호를 찾을 수 없거나 만료됨")
    })
    public ResponseEntity<SmsVerificationResponse> verifyCode(
            @Valid @RequestBody SmsVerificationCheckRequest request) {
        
        try {
            String normalizedPhone = smsService.normalizePhoneNumber(request.getPhoneNumber());
            boolean verified = smsService.verifyCode(normalizedPhone, request.getCode());
            
            if (verified) {
                log.info("Verification successful for {}", normalizedPhone);
                
                return ResponseEntity.ok(
                        SmsVerificationResponse.success("인증이 완료되었습니다.")
                );
            } else {
                log.warn("Verification failed for {}", normalizedPhone);
                return ResponseEntity.badRequest().body(
                        SmsVerificationResponse.failure("인증번호가 일치하지 않거나 만료되었습니다.")
                );
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(
                    SmsVerificationResponse.failure(e.getMessage())
            );
        } catch (Exception e) {
            log.error("Unexpected error verifying code", e);
            return ResponseEntity.internalServerError().body(
                    SmsVerificationResponse.failure("시스템 오류가 발생했습니다.")
            );
        }
    }

    @PostMapping("/resend")
    @Operation(summary = "인증번호 재발송", description = "인증번호를 재발송합니다. 기존 인증번호는 무효화됩니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "인증번호 재발송 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 전화번호 형식"),
            @ApiResponse(responseCode = "500", description = "SMS 발송 실패")
    })
    public ResponseEntity<SmsVerificationResponse> resendVerificationCode(
            @Valid @RequestBody SmsVerificationRequest request) {
        
        try {
            String normalizedPhone = smsService.normalizePhoneNumber(request.getPhoneNumber());
            boolean sent = smsService.resendVerificationCode(normalizedPhone);
            
            if (sent) {
                log.info("Verification code resent to {}", normalizedPhone);
                return ResponseEntity.ok(
                        SmsVerificationResponse.success("인증번호가 재발송되었습니다. 3분 이내에 입력해주세요.")
                );
            } else {
                log.warn("Failed to resend verification code to {}", normalizedPhone);
                return ResponseEntity.internalServerError().body(
                        SmsVerificationResponse.failure("인증번호 재발송에 실패했습니다. 잠시 후 다시 시도해주세요.")
                );
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(
                    SmsVerificationResponse.failure(e.getMessage())
            );
        } catch (Exception e) {
            log.error("Unexpected error resending verification code", e);
            return ResponseEntity.internalServerError().body(
                    SmsVerificationResponse.failure("시스템 오류가 발생했습니다.")
            );
        }
    }
}