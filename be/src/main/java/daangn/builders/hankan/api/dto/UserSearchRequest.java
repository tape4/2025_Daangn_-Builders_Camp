package daangn.builders.hankan.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "사용자 검색 요청 DTO")
public class UserSearchRequest {
    
    @NotBlank(message = "검색어는 필수입니다")
    @Size(min = 1, max = 50, message = "검색어는 1-50자 사이여야 합니다")
    @Schema(description = "검색할 닉네임", example = "한칸", required = true)
    private String nickname;
}