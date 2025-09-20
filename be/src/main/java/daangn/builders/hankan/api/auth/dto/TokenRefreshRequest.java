package daangn.builders.hankan.api.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "토큰 갱신 요청")
public class TokenRefreshRequest {

    @NotBlank(message = "Refresh Token은 필수입니다")
    @Schema(description = "Refresh Token", example = "eyJhbGciOiJIUzUxMiJ9...", required = true)
    private String refreshToken;
}