package daangn.builders.hankan.api.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "SMS 인증 응답")
public class SmsVerificationResponse {

    @Schema(description = "처리 성공 여부", example = "true")
    private boolean success;

    @Schema(description = "응답 메시지", example = "인증번호가 발송되었습니다")
    private String message;

    public static SmsVerificationResponse success(String message) {
        return SmsVerificationResponse.builder()
                .success(true)
                .message(message)
                .build();
    }


    public static SmsVerificationResponse failure(String message) {
        return SmsVerificationResponse.builder()
                .success(false)
                .message(message)
                .build();
    }
}