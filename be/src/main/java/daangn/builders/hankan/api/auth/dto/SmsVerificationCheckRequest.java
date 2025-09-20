package daangn.builders.hankan.api.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "SMS 인증번호 확인 요청")
public class SmsVerificationCheckRequest {

    @NotBlank(message = "전화번호는 필수입니다")
    @Pattern(regexp = "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$", message = "유효한 전화번호 형식이 아닙니다")
    @Schema(description = "전화번호", example = "010-1234-5678", required = true)
    private String phoneNumber;

    @NotBlank(message = "인증번호는 필수입니다")
    @Size(min = 6, max = 6, message = "인증번호는 6자리여야 합니다")
    @Pattern(regexp = "^[0-9]{6}$", message = "인증번호는 6자리 숫자여야 합니다")
    @Schema(description = "인증번호", example = "123456", required = true)
    private String code;
}