package daangn.builders.hankan.domain.review;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewRequest {
    
    private Long reviewerId;
    private Long reservationId;
    private Integer rating; // 1-5점
    private String comment;
}