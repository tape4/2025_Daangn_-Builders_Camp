package daangn.builders.hankan.domain.space;

import com.fasterxml.jackson.annotation.JsonFormat;
import daangn.builders.hankan.domain.common.BaseEntity;
import daangn.builders.hankan.domain.user.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "spaces")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Space extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    @Column(name = "description", length = 1000)
    private String description;
    
    @Column(name = "latitude", nullable = false)
    private Double latitude;
    
    @Column(name = "longitude", nullable = false)
    private Double longitude;
    
    @Column(name = "address", nullable = false, length = 200)
    private String address;
    
    // 단일 이미지 URL (요구사항에 따라 1개로 제한)
    @Column(name = "image_url", length = 500)
    private String imageUrl;
    
    // 박스 용량 정보 (JSON으로 저장)
    @Column(name = "box_capacity_xs")
    private Integer boxCapacityXs = 0;
    
    @Column(name = "box_capacity_s")
    private Integer boxCapacityS = 0;
    
    @Column(name = "box_capacity_m")
    private Integer boxCapacityM = 0;
    
    @Column(name = "box_capacity_l")
    private Integer boxCapacityL = 0;
    
    @Column(name = "box_capacity_xl")
    private Integer boxCapacityXl = 0;
    
    // 평점 관련 필드
    @Column(name = "rating")
    private Double rating = 0.0;
    
    @Column(name = "review_count")
    private Integer reviewCount = 0;
    
    // 공간 소유자
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;
    
    // 이용 가능한 기간
    @Column(name = "available_start_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate availableStartDate;
    
    @Column(name = "available_end_date")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate availableEndDate;
    
    
    @Builder
    public Space(String name, String description, Double latitude, Double longitude,
                 String address, String imageUrl, User owner, LocalDate availableStartDate, LocalDate availableEndDate,
                 Integer boxCapacityXs, Integer boxCapacityS, Integer boxCapacityM,
                 Integer boxCapacityL, Integer boxCapacityXl) {
        this.name = name;
        this.description = description;
        this.latitude = latitude;
        this.longitude = longitude;
        this.address = address;
        this.imageUrl = imageUrl;
        this.owner = owner;
        this.availableStartDate = availableStartDate;
        this.availableEndDate = availableEndDate;
        this.boxCapacityXs = boxCapacityXs != null ? boxCapacityXs : 0;
        this.boxCapacityS = boxCapacityS != null ? boxCapacityS : 0;
        this.boxCapacityM = boxCapacityM != null ? boxCapacityM : 0;
        this.boxCapacityL = boxCapacityL != null ? boxCapacityL : 0;
        this.boxCapacityXl = boxCapacityXl != null ? boxCapacityXl : 0;
    }
    
    // 비즈니스 메서드
    public void updateImage(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public void updateRating(double rating, int reviewCount) {
        this.rating = rating;
        this.reviewCount = reviewCount;
    }
    
    public void updateAvailablePeriod(LocalDate startDate, LocalDate endDate) {
        this.availableStartDate = startDate;
        this.availableEndDate = endDate;
    }
    
    public void updateBoxCapacity(Integer xs, Integer s, Integer m, Integer l, Integer xl) {
        if (xs != null) this.boxCapacityXs = xs;
        if (s != null) this.boxCapacityS = s;
        if (m != null) this.boxCapacityM = m;
        if (l != null) this.boxCapacityL = l;
        if (xl != null) this.boxCapacityXl = xl;
    }
    
    // 특정 날짜에 이용 가능한지 확인
    public boolean isAvailableOn(LocalDate date) {
        return availableStartDate != null && availableEndDate != null &&
               (date.isEqual(availableStartDate) || date.isAfter(availableStartDate)) &&
               (date.isEqual(availableEndDate) || date.isBefore(availableEndDate));
    }
    
    // 총 박스 수 계산
    public int getTotalBoxCount() {
        return boxCapacityXs + boxCapacityS + boxCapacityM + boxCapacityL + boxCapacityXl;
    }
}