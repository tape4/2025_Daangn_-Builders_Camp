package daangn.builders.hankan.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "사용자 프로필 수정 요청 DTO")
public class UserProfileUpdateRequest {

    @Schema(description = "닉네임", example = "한칸이", minLength = 2, maxLength = 50)
    @Size(min = 2, max = 50, message = "닉네임은 2자 이상 50자 이하여야 합니다")
    private String nickname;

    @Schema(description = "프로필 이미지 URL", example = "https://example.com/profile.jpg")
    @Pattern(regexp = "^(https?://.+)?$", message = "올바른 URL 형식이어야 합니다")
    @Size(max = 500, message = "URL은 500자 이하여야 합니다")
    private String profileImageUrl;
}