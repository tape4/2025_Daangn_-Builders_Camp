package daangn.builders.hankan.domain.review;

import daangn.builders.hankan.domain.common.BaseEntity;
import daangn.builders.hankan.domain.reservation.Reservation;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.user.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "reviews")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Review extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // 리뷰 작성자
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reviewer_id", nullable = false)
    private User reviewer;
    
    // 예약 정보 (리뷰의 기준이 되는 예약)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reservation_id", nullable = false)
    private Reservation reservation;
    
    // 리뷰 타입
    @Enumerated(EnumType.STRING)
    @Column(name = "review_type", nullable = false, length = 10)
    private ReviewType reviewType;
    
    // 공간 리뷰인 경우
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "space_id")
    private Space space;
    
    // 사용자 리뷰인 경우 (평가받는 사용자)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reviewed_user_id")
    private User reviewedUser;
    
    @Column(name = "rating", nullable = false)
    private Integer rating; // 1~5점
    
    @Column(name = "comment", length = 1000)
    private String comment;
    
    
    @Builder
    public Review(User reviewer, Reservation reservation, ReviewType reviewType,
                  Space space, User reviewedUser, Integer rating, String comment) {
        this.reviewer = reviewer;
        this.reservation = reservation;
        this.reviewType = reviewType;
        this.space = space;
        this.reviewedUser = reviewedUser;
        this.rating = rating;
        this.comment = comment;
        
        // 리뷰 타입에 따른 검증
        if (reviewType == ReviewType.SPACE && space == null) {
            throw new IllegalArgumentException("Space review must have space information");
        }
        if (reviewType == ReviewType.USER && reviewedUser == null) {
            throw new IllegalArgumentException("User review must have reviewed user information");
        }
    }
    
    // 정적 팩토리 메서드
    public static Review createSpaceReview(User reviewer, Reservation reservation, 
                                         Space space, Integer rating, String comment) {
        return Review.builder()
                .reviewer(reviewer)
                .reservation(reservation)
                .reviewType(ReviewType.SPACE)
                .space(space)
                .rating(rating)
                .comment(comment)
                .build();
    }
    
    public static Review createUserReview(User reviewer, Reservation reservation,
                                        User reviewedUser, Integer rating, String comment) {
        return Review.builder()
                .reviewer(reviewer)
                .reservation(reservation)
                .reviewType(ReviewType.USER)
                .reviewedUser(reviewedUser)
                .rating(rating)
                .comment(comment)
                .build();
    }
    
    // 비즈니스 메서드
    public void updateReview(Integer rating, String comment) {
        if (rating != null && rating >= 1 && rating <= 5) {
            this.rating = rating;
        }
        if (comment != null) {
            this.comment = comment;
        }
    }
    
    public boolean isSpaceReview() {
        return reviewType == ReviewType.SPACE;
    }
    
    public boolean isUserReview() {
        return reviewType == ReviewType.USER;
    }
    
    public boolean isReviewedBy(User user) {
        return reviewer.equals(user);
    }
    
    public enum ReviewType {
        SPACE,  // 공간 리뷰
        USER    // 사용자 리뷰
    }
}