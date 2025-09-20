package daangn.builders.hankan.domain.reservation;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationRequest {
    
    private Long userId;
    
    @NotNull(message = "공간 ID는 필수입니다")
    private Long spaceId;
    
    @NotNull(message = "시작일은 필수입니다")
    @FutureOrPresent(message = "시작일은 현재 또는 미래여야 합니다")
    private LocalDate startDate;
    
    @NotNull(message = "종료일은 필수입니다")
    private LocalDate endDate;
    
    @Min(value = 0, message = "박스 수량은 0 이상이어야 합니다")
    private Integer boxRequirementXs;
    
    @Min(value = 0, message = "박스 수량은 0 이상이어야 합니다")
    private Integer boxRequirementS;
    
    @Min(value = 0, message = "박스 수량은 0 이상이어야 합니다")
    private Integer boxRequirementM;
    
    @Min(value = 0, message = "박스 수량은 0 이상이어야 합니다")
    private Integer boxRequirementL;
    
    @Min(value = 0, message = "박스 수량은 0 이상이어야 합니다")
    private Integer boxRequirementXl;
    
    @NotNull(message = "총 가격은 필수입니다")
    @DecimalMin(value = "0.0", inclusive = false, message = "총 가격은 0보다 커야 합니다")
    private BigDecimal totalPrice;
}