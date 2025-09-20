package daangn.builders.hankan.api.auth.dto;

import daangn.builders.hankan.domain.user.Gender;
import daangn.builders.hankan.domain.user.User;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "회원가입 요청")
public class SignupRequest {

    @NotBlank(message = "전화번호는 필수입니다")
    @Pattern(regexp = "^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$", message = "유효한 전화번호 형식이 아닙니다")
    @Schema(description = "전화번호", example = "010-1234-5678", required = true)
    private String phoneNumber;

    @NotBlank(message = "닉네임은 필수입니다")
    @Size(min = 2, max = 20, message = "닉네임은 2-20자 사이여야 합니다")
    @Schema(description = "닉네임", example = "한칸이", required = true)
    private String nickname;

    @NotNull(message = "생년월일은 필수입니다")
    @Past(message = "생년월일은 과거 날짜여야 합니다")
    @Schema(description = "생년월일", example = "1990-01-01", required = true)
    private LocalDate birthDate;

    @NotNull(message = "성별은 필수입니다")
    @Schema(description = "성별", example = "MALE", required = true)
    private Gender gender;
}