package daangn.builders.hankan.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "사용자 통계 응답 DTO")
public class UserStatsResponse {
    
    @Schema(description = "전체 사용자 수", example = "1000")
    private long totalUserCount;
    
    @Schema(description = "활성 사용자 수", example = "800")
    private long activeUserCount;
    
    @Schema(description = "오늘 가입한 사용자 수", example = "10")
    private long todayRegistrationCount;
    
    public UserStatsResponse(long totalUserCount) {
        this.totalUserCount = totalUserCount;
        this.activeUserCount = totalUserCount; // 임시로 같은 값 설정
        this.todayRegistrationCount = 0; // 임시로 0 설정
    }
}