package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.auth.LoginContext;
import daangn.builders.hankan.domain.review.Review;
import daangn.builders.hankan.domain.review.ReviewRequest;
import daangn.builders.hankan.domain.review.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Review", description = "리뷰 관리 API")
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping("/space")
    @Login
    @Operation(summary = "공간 리뷰 작성", description = "공간에 대한 리뷰를 작성합니다.")
    public ResponseEntity<Review> createSpaceReview(@RequestBody ReviewRequest request) {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자 사용
            currentUserId = 1L;
        }
        
        ReviewRequest updatedRequest = ReviewRequest.builder()
                .reviewerId(currentUserId)
                .reservationId(request.getReservationId())
                .rating(request.getRating())
                .comment(request.getComment())
                .build();

        Review review = reviewService.createSpaceReview(updatedRequest);
        return ResponseEntity.ok(review);
    }

    @PostMapping("/user")
    @Login
    @Operation(summary = "사용자 리뷰 작성", description = "사용자에 대한 리뷰를 작성합니다.")
    public ResponseEntity<Review> createUserReview(@RequestBody ReviewRequest request) {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자 사용
            currentUserId = 1L;
        }
        
        ReviewRequest updatedRequest = ReviewRequest.builder()
                .reviewerId(currentUserId)
                .reservationId(request.getReservationId())
                .rating(request.getRating())
                .comment(request.getComment())
                .build();

        Review review = reviewService.createUserReview(updatedRequest);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/{reviewId}")
    @Operation(summary = "리뷰 상세 조회", description = "리뷰 ID로 상세 정보를 조회합니다.")
    public ResponseEntity<Review> getReview(@PathVariable Long reviewId) {
        Review review = reviewService.findById(reviewId);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/space/{spaceId}")
    @Operation(summary = "공간 리뷰 목록 조회", description = "특정 공간의 리뷰 목록을 조회합니다.")
    public ResponseEntity<Page<Review>> getSpaceReviews(
            @PathVariable Long spaceId,
            @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Review> reviews = reviewService.findSpaceReviews(spaceId, pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "사용자 리뷰 목록 조회", description = "특정 사용자가 받은 리뷰 목록을 조회합니다.")
    public ResponseEntity<Page<Review>> getUserReviews(
            @PathVariable Long userId,
            @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Review> reviews = reviewService.findUserReviews(userId, pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/my-written")
    @Login
    @Operation(summary = "내가 작성한 리뷰 조회", description = "현재 사용자가 작성한 리뷰 목록을 조회합니다.")
    public ResponseEntity<Page<Review>> getMyWrittenReviews(@PageableDefault(size = 20) Pageable pageable) {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            currentUserId = 1L;
        }
        
        Page<Review> reviews = reviewService.findReviewsByReviewer(currentUserId, pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/reservation/{reservationId}")
    @Operation(summary = "예약별 리뷰 조회", description = "특정 예약에 대한 리뷰들을 조회합니다.")
    public ResponseEntity<List<Review>> getReservationReviews(@PathVariable Long reservationId) {
        List<Review> reviews = reviewService.findReviewsForReservation(reservationId);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/space/{spaceId}/high-rated")
    @Operation(summary = "공간 고평점 리뷰 조회", description = "공간의 고평점 리뷰들을 조회합니다.")
    public ResponseEntity<List<Review>> getHighRatedSpaceReviews(
            @PathVariable Long spaceId,
            @Parameter(description = "최소 평점 (1-5)") @RequestParam(defaultValue = "4") Integer minRating,
            @PageableDefault(size = 10) Pageable pageable) {
        
        List<Review> reviews = reviewService.findHighRatedSpaceReviews(spaceId, minRating, pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/space/{spaceId}/recent")
    @Operation(summary = "공간 최신 리뷰 조회", description = "공간의 최신 리뷰들을 조회합니다.")
    public ResponseEntity<List<Review>> getRecentSpaceReviews(
            @PathVariable Long spaceId,
            @PageableDefault(size = 10) Pageable pageable) {
        
        List<Review> reviews = reviewService.findRecentSpaceReviews(spaceId, pageable);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/space/{spaceId}/rating-distribution")
    @Operation(summary = "공간 평점 분포 조회", description = "공간의 평점 분포를 조회합니다.")
    public ResponseEntity<List<Object[]>> getSpaceRatingDistribution(@PathVariable Long spaceId) {
        List<Object[]> distribution = reviewService.getSpaceRatingDistribution(spaceId);
        return ResponseEntity.ok(distribution);
    }

    @PatchMapping("/{reviewId}")
    @Login
    @Operation(summary = "리뷰 수정", description = "작성한 리뷰를 수정합니다.")
    public ResponseEntity<Review> updateReview(
            @PathVariable Long reviewId,
            @Parameter(description = "새 평점 (1-5)") @RequestParam(required = false) Integer rating,
            @Parameter(description = "새 댓글") @RequestParam(required = false) String comment) {
        
        Review review = reviewService.updateReview(reviewId, rating, comment);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/check-existing")
    @Login
    @Operation(summary = "기존 리뷰 확인", description = "특정 예약에 대한 리뷰 작성 여부를 확인합니다.")
    public ResponseEntity<Optional<Review>> checkExistingReview(
            @Parameter(description = "예약 ID") @RequestParam Long reservationId,
            @Parameter(description = "리뷰 타입") @RequestParam Review.ReviewType reviewType) {
        
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            currentUserId = 1L;
        }
        
        Optional<Review> review = reviewService.findExistingReview(currentUserId, reservationId, reviewType);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/check-review-permission")
    @Login
    @Operation(summary = "리뷰 작성 권한 확인", description = "특정 예약에 대한 리뷰 작성 권한이 있는지 확인합니다.")
    public ResponseEntity<Boolean> checkReviewPermission(
            @Parameter(description = "예약 ID") @RequestParam Long reservationId,
            @Parameter(description = "리뷰 타입") @RequestParam Review.ReviewType reviewType) {
        
        boolean hasReview = reviewService.hasReviewForReservation(reservationId, reviewType);
        return ResponseEntity.ok(!hasReview); // 리뷰가 없으면 작성 가능
    }

    @PostMapping("/space/{spaceId}/update-rating")
    @Login
    @Operation(summary = "공간 평점 재계산", description = "공간의 평점을 재계산합니다 (관리자용).")
    public ResponseEntity<String> updateSpaceRating(@PathVariable Long spaceId) {
        reviewService.updateSpaceRating(spaceId);
        return ResponseEntity.ok("Space rating updated successfully");
    }

    @PostMapping("/user/{userId}/update-rating")
    @Login
    @Operation(summary = "사용자 평점 재계산", description = "사용자의 평점을 재계산합니다 (관리자용).")
    public ResponseEntity<String> updateUserRating(@PathVariable Long userId) {
        reviewService.updateUserRating(userId);
        return ResponseEntity.ok("User rating updated successfully");
    }
}