package daangn.builders.hankan.api.dto;

import daangn.builders.hankan.domain.user.Gender;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "사용자 등록 요청 DTO")
public class UserRegistrationRequest {
    
    @NotBlank(message = "전화번호는 필수입니다")
    @Pattern(regexp = "^\\d{10,11}$", message = "전화번호는 10-11자리 숫자여야 합니다")
    @Schema(description = "전화번호 (하이픈 제외)", example = "01012345678", required = true)
    private String phoneNumber;
    
    @NotBlank(message = "닉네임은 필수입니다")
    @Size(min = 2, max = 50, message = "닉네임은 2-50자 사이여야 합니다")
    @Schema(description = "사용자 닉네임", example = "한칸이", required = true)
    private String nickname;
    
    @NotNull(message = "생년월일은 필수입니다")
    @Past(message = "생년월일은 과거 날짜여야 합니다")
    @Schema(description = "생년월일", example = "1990-01-01", required = true)
    private LocalDate birthDate;
    
    @NotNull(message = "성별은 필수입니다")
    @Schema(description = "성별", example = "MALE", required = true, allowableValues = {"MALE", "FEMALE", "OTHER"})
    private Gender gender;
    
    @Size(max = 500, message = "프로필 이미지 URL은 500자를 초과할 수 없습니다")
    @Pattern(regexp = "^(https?://.+)?$", message = "올바른 URL 형식이어야 합니다")
    @Schema(description = "프로필 이미지 URL", example = "https://example.com/profile.jpg")
    private String profileImageUrl;
}