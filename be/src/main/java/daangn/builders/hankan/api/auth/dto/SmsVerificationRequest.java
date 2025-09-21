package daangn.builders.hankan.api.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "SMS 인증번호 발송 요청")
public class SmsVerificationRequest {

    @NotBlank(message = "전화번호는 필수입니다")
    @Pattern(regexp = "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$", message = "유효한 전화번호 형식이 아닙니다")
    @Schema(description = "수신자 전화번호", example = "010-1234-5678", required = true)
    private String phoneNumber;
}