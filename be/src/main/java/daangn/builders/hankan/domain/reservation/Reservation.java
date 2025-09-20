package daangn.builders.hankan.domain.reservation;

import daangn.builders.hankan.domain.common.BaseEntity;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.user.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Reservation extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // 예약자
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    // 예약된 공간
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "space_id", nullable = false)
    private Space space;
    
    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;
    
    @Column(name = "end_date", nullable = false)
    private LocalDate endDate;
    
    // 박스 요구사항
    @Column(name = "box_requirement_xs")
    private Integer boxRequirementXs = 0;
    
    @Column(name = "box_requirement_s")
    private Integer boxRequirementS = 0;
    
    @Column(name = "box_requirement_m")
    private Integer boxRequirementM = 0;
    
    @Column(name = "box_requirement_l")
    private Integer boxRequirementL = 0;
    
    @Column(name = "box_requirement_xl")
    private Integer boxRequirementXl = 0;
    
    @Column(name = "total_price", precision = 10, scale = 2)
    private BigDecimal totalPrice;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private ReservationStatus status = ReservationStatus.PENDING;
    
    // 체크인 정보
    @Column(name = "item_description", length = 1000)
    private String itemDescription;
    
    @Column(name = "check_in_time")
    private LocalDateTime checkInTime;
    
    // 단일 아이템 이미지 URL (요구사항에 따라 1개로 제한)
    @Column(name = "item_image_url", length = 500)
    private String itemImageUrl;
    
    // 체크아웃 정보
    @Column(name = "check_out_time")
    private LocalDateTime checkOutTime;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "item_condition", length = 20)
    private ItemCondition itemCondition;
    
    
    @Builder
    public Reservation(User user, Space space, LocalDate startDate, LocalDate endDate,
                      Integer boxRequirementXs, Integer boxRequirementS, Integer boxRequirementM,
                      Integer boxRequirementL, Integer boxRequirementXl, BigDecimal totalPrice) {
        this.user = user;
        this.space = space;
        this.startDate = startDate;
        this.endDate = endDate;
        this.boxRequirementXs = boxRequirementXs != null ? boxRequirementXs : 0;
        this.boxRequirementS = boxRequirementS != null ? boxRequirementS : 0;
        this.boxRequirementM = boxRequirementM != null ? boxRequirementM : 0;
        this.boxRequirementL = boxRequirementL != null ? boxRequirementL : 0;
        this.boxRequirementXl = boxRequirementXl != null ? boxRequirementXl : 0;
        this.totalPrice = totalPrice;
    }
    
    // 비즈니스 메서드
    public void confirm() {
        this.status = ReservationStatus.CONFIRMED;
    }
    
    public void cancel() {
        this.status = ReservationStatus.CANCELLED;
    }
    
    public void checkIn(String itemDescription, String itemImageUrl, LocalDateTime checkInTime) {
        this.itemDescription = itemDescription;
        this.itemImageUrl = itemImageUrl;
        this.checkInTime = checkInTime;
        this.status = ReservationStatus.CHECKED_IN;
    }
    
    public void checkOut(LocalDateTime checkOutTime, ItemCondition itemCondition) {
        this.checkOutTime = checkOutTime;
        this.itemCondition = itemCondition;
        this.status = ReservationStatus.COMPLETED;
    }
    
    public boolean isActive() {
        return status == ReservationStatus.CONFIRMED || status == ReservationStatus.CHECKED_IN;
    }
    
    public boolean isCompleted() {
        return status == ReservationStatus.COMPLETED;
    }
    
    public int getTotalBoxRequirement() {
        return boxRequirementXs + boxRequirementS + boxRequirementM + 
               boxRequirementL + boxRequirementXl;
    }
    
    public enum ReservationStatus {
        PENDING,    // 예약 대기
        CONFIRMED,  // 예약 확정
        CHECKED_IN, // 체크인 완료
        COMPLETED,  // 체크아웃 완료
        CANCELLED   // 예약 취소
    }
    
    public enum ItemCondition {
        EXCELLENT,  // 매우 좋음
        GOOD,       // 좋음
        FAIR,       // 보통
        POOR,       // 나쁨
        DAMAGED     // 손상됨
    }
}