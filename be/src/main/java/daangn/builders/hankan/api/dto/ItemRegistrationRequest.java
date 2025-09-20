package daangn.builders.hankan.api.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "물품 보관 요청 등록 DTO")
public class ItemRegistrationRequest {

    @NotBlank(message = "제목은 필수입니다")
    @Size(min = 2, max = 100, message = "제목은 2-100자 사이여야 합니다")
    @Schema(description = "물품 제목", example = "겨울 옷 보관")
    private String title;

    @Size(max = 500, message = "설명은 500자 이하여야 합니다")
    @Schema(description = "물품 설명", example = "겨울 패딩과 코트 등 부피가 큰 겨울 옷들을 보관하고자 합니다")
    private String description;

    @NotNull(message = "가로 크기는 필수입니다")
    @Positive(message = "가로 크기는 0보다 커야 합니다")
    @Max(value = 200, message = "가로 크기는 200cm를 초과할 수 없습니다")
    @Schema(description = "가로 크기 (cm)", example = "50.0")
    private Double width;

    @NotNull(message = "세로 크기는 필수입니다")
    @Positive(message = "세로 크기는 0보다 커야 합니다")
    @Max(value = 200, message = "세로 크기는 200cm를 초과할 수 없습니다")
    @Schema(description = "세로 크기 (cm)", example = "40.0")
    private Double height;

    @NotNull(message = "깊이는 필수입니다")
    @Positive(message = "깊이는 0보다 커야 합니다")
    @Max(value = 200, message = "깊이는 200cm를 초과할 수 없습니다")
    @Schema(description = "깊이 (cm)", example = "30.0")
    private Double depth;

    @NotNull(message = "시작 날짜는 필수입니다")
    @FutureOrPresent(message = "시작 날짜는 오늘 이후여야 합니다")
    @Schema(description = "보관 시작일", example = "2025-10-01")
    private LocalDate startDate;

    @NotNull(message = "종료 날짜는 필수입니다")
    @Future(message = "종료 날짜는 미래여야 합니다")
    @Schema(description = "보관 종료일", example = "2025-12-31")
    private LocalDate endDate;

    @NotNull(message = "최소 가격은 필수입니다")
    @PositiveOrZero(message = "최소 가격은 0 이상이어야 합니다")
    @DecimalMax(value = "1000000", message = "가격은 1,000,000원을 초과할 수 없습니다")
    @Schema(description = "희망 최소 가격", example = "30000")
    private BigDecimal minPrice;

    @NotNull(message = "최대 가격은 필수입니다")
    @Positive(message = "최대 가격은 0보다 커야 합니다")
    @DecimalMax(value = "1000000", message = "가격은 1,000,000원을 초과할 수 없습니다")
    @Schema(description = "희망 최대 가격", example = "50000")
    private BigDecimal maxPrice;

    // 검증 메서드
    @AssertTrue(message = "종료일은 시작일 이후여야 합니다")
    @Schema(hidden = true)
    public boolean isValidDateRange() {
        if (startDate == null || endDate == null) {
            return true; // null 체크는 @NotNull에서 처리
        }
        return !endDate.isBefore(startDate);
    }

    @AssertTrue(message = "최대 가격은 최소 가격 이상이어야 합니다")
    @Schema(hidden = true)
    public boolean isValidPriceRange() {
        if (minPrice == null || maxPrice == null) {
            return true; // null 체크는 @NotNull에서 처리
        }
        return maxPrice.compareTo(minPrice) >= 0;
    }
}