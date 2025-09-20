package daangn.builders.hankan.domain.reservation;

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
    private Long spaceId;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer boxRequirementXs;
    private Integer boxRequirementS;
    private Integer boxRequirementM;
    private Integer boxRequirementL;
    private Integer boxRequirementXl;
    private BigDecimal totalPrice;
}