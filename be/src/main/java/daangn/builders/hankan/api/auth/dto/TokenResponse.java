package daangn.builders.hankan.api.auth.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Schema(description = "토큰 응답")
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TokenResponse {

    @Schema(description = "Access Token", example = "eyJhbGciOiJIUzUxMiJ9...")
    private String accessToken;

    @Schema(description = "Refresh Token", example = "eyJhbGciOiJIUzUxMiJ9...")
    private String refreshToken;

    @Schema(description = "토큰 타입", example = "Bearer")
    private String tokenType;

    @Schema(description = "Access Token 만료 시간 (초)", example = "3600")
    private Long expiresIn;

    @Schema(description = "사용자 ID", example = "1")
    private Long userId;

    @Schema(description = "사용자 닉네임", example = "한칸이")
    private String nickname;

    @Schema(description = "사용자 전화번호", example = "010-1234-5678")
    private String phoneNumber;

    public static TokenResponse of(String accessToken, String refreshToken, Long expiresIn, Long userId, String nickname, String phoneNumber) {
        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(expiresIn)
                .userId(userId)
                .nickname(nickname)
                .phoneNumber(phoneNumber)
                .build();
    }
}