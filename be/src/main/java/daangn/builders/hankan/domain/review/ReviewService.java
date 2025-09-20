package daangn.builders.hankan.domain.review;

import daangn.builders.hankan.domain.reservation.Reservation;
import daangn.builders.hankan.domain.reservation.ReservationRepository;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRepository;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final ReservationRepository reservationRepository;
    private final UserRepository userRepository;
    private final SpaceRepository spaceRepository;

    @Transactional
    public Review createSpaceReview(ReviewRequest request) {
        log.info("Creating space review for reservation {}", request.getReservationId());

        Reservation reservation = reservationRepository.findById(request.getReservationId())
                .orElseThrow(() -> new IllegalArgumentException("Reservation not found with id: " + request.getReservationId()));

        validateReviewEligibility(reservation, request.getReviewerId(), Review.ReviewType.SPACE);

        User reviewer = userRepository.findById(request.getReviewerId())
                .orElseThrow(() -> new IllegalArgumentException("Reviewer not found with id: " + request.getReviewerId()));

        Review review = Review.createSpaceReview(
                reviewer, 
                reservation, 
                reservation.getSpace(), 
                request.getRating(), 
                request.getComment()
        );

        Review savedReview = reviewRepository.save(review);
        
        // 공간 평점 업데이트
        updateSpaceRating(reservation.getSpace().getId());
        
        log.info("Space review created successfully with id: {}", savedReview.getId());
        return savedReview;
    }

    @Transactional
    public Review createUserReview(ReviewRequest request) {
        log.info("Creating user review for reservation {}", request.getReservationId());

        Reservation reservation = reservationRepository.findById(request.getReservationId())
                .orElseThrow(() -> new IllegalArgumentException("Reservation not found with id: " + request.getReservationId()));

        validateReviewEligibility(reservation, request.getReviewerId(), Review.ReviewType.USER);

        User reviewer = userRepository.findById(request.getReviewerId())
                .orElseThrow(() -> new IllegalArgumentException("Reviewer not found with id: " + request.getReviewerId()));

        // 리뷰 대상 결정 (예약자가 공간 소유자를 리뷰하거나, 소유자가 예약자를 리뷰)
        User reviewedUser = determineReviewedUser(reservation, reviewer);

        Review review = Review.createUserReview(
                reviewer, 
                reservation, 
                reviewedUser, 
                request.getRating(), 
                request.getComment()
        );

        Review savedReview = reviewRepository.save(review);
        
        // 사용자 평점 업데이트
        updateUserRating(reviewedUser.getId());
        
        log.info("User review created successfully with id: {}", savedReview.getId());
        return savedReview;
    }

    public Review findById(Long reviewId) {
        return reviewRepository.findById(reviewId)
                .orElseThrow(() -> new IllegalArgumentException("Review not found with id: " + reviewId));
    }

    public Page<Review> findSpaceReviews(Long spaceId, Pageable pageable) {
        return reviewRepository.findBySpaceIdAndReviewTypeOrderByCreatedAtDesc(
                spaceId, Review.ReviewType.SPACE, pageable);
    }

    public Page<Review> findUserReviews(Long userId, Pageable pageable) {
        return reviewRepository.findByReviewedUserIdAndReviewTypeOrderByCreatedAtDesc(
                userId, Review.ReviewType.USER, pageable);
    }

    public Page<Review> findReviewsByReviewer(Long reviewerId, Pageable pageable) {
        return reviewRepository.findByReviewerIdOrderByCreatedAtDesc(reviewerId, pageable);
    }

    public List<Review> findReviewsForReservation(Long reservationId) {
        return reviewRepository.findByReservationId(reservationId);
    }

    public Optional<Review> findExistingReview(Long reviewerId, Long reservationId, Review.ReviewType reviewType) {
        return reviewRepository.findByReviewerIdAndReservationIdAndReviewType(reviewerId, reservationId, reviewType);
    }

    public boolean hasReviewForReservation(Long reservationId, Review.ReviewType reviewType) {
        return reviewRepository.existsByReservationIdAndReviewType(reservationId, reviewType);
    }

    public List<Review> findHighRatedSpaceReviews(Long spaceId, Integer minRating, Pageable pageable) {
        return reviewRepository.findHighRatedSpaceReviews(spaceId, minRating, pageable);
    }

    public List<Review> findRecentSpaceReviews(Long spaceId, Pageable pageable) {
        return reviewRepository.findRecentSpaceReviews(spaceId, pageable);
    }

    public List<Object[]> getSpaceRatingDistribution(Long spaceId) {
        return reviewRepository.getSpaceRatingDistribution(spaceId);
    }

    @Transactional
    public Review updateReview(Long reviewId, Integer rating, String comment) {
        Review review = findById(reviewId);
        review.updateReview(rating, comment);
        
        // 평점 재계산
        if (review.isSpaceReview()) {
            updateSpaceRating(review.getSpace().getId());
        } else if (review.isUserReview()) {
            updateUserRating(review.getReviewedUser().getId());
        }
        
        log.info("Review {} updated", reviewId);
        return review;
    }

    private void validateReviewEligibility(Reservation reservation, Long reviewerId, Review.ReviewType reviewType) {
        // 완료된 예약인지 확인
        if (reservation.getStatus() != Reservation.ReservationStatus.COMPLETED) {
            throw new IllegalArgumentException("Reviews can only be created for completed reservations");
        }

        // 리뷰어가 예약 관련자인지 확인 (예약자 또는 공간 소유자)
        boolean isReserver = reservation.getUser().getId().equals(reviewerId);
        boolean isSpaceOwner = reservation.getSpace().getOwner().getId().equals(reviewerId);
        
        if (!isReserver && !isSpaceOwner) {
            throw new IllegalArgumentException("Only reservation participants can write reviews");
        }

        // 중복 리뷰 확인
        if (reviewRepository.existsByReservationIdAndReviewType(reservation.getId(), reviewType)) {
            throw new IllegalArgumentException("Review already exists for this reservation and type");
        }
    }

    private User determineReviewedUser(Reservation reservation, User reviewer) {
        // 예약자가 리뷰를 작성하면 공간 소유자를 리뷰
        if (reservation.getUser().getId().equals(reviewer.getId())) {
            return reservation.getSpace().getOwner();
        }
        // 공간 소유자가 리뷰를 작성하면 예약자를 리뷰
        else if (reservation.getSpace().getOwner().getId().equals(reviewer.getId())) {
            return reservation.getUser();
        }
        else {
            throw new IllegalArgumentException("Reviewer is not a participant in this reservation");
        }
    }

    @Transactional
    public void updateSpaceRating(Long spaceId) {
        Double averageRating = reviewRepository.calculateAverageSpaceRating(spaceId);
        Long reviewCount = reviewRepository.countSpaceReviews(spaceId);
        
        Space space = spaceRepository.findById(spaceId)
                .orElseThrow(() -> new IllegalArgumentException("Space not found with id: " + spaceId));
        
        space.updateRating(
                averageRating != null ? averageRating : 0.0, 
                reviewCount != null ? reviewCount.intValue() : 0
        );
        
        log.info("Updated space {} rating: {} ({} reviews)", spaceId, averageRating, reviewCount);
    }

    @Transactional
    public void updateUserRating(Long userId) {
        Double averageRating = reviewRepository.calculateAverageUserRating(userId);
        Long reviewCount = reviewRepository.countUserReviews(userId);
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + userId));
        
        user.updateRating(
                averageRating != null ? averageRating : 0.0, 
                reviewCount != null ? reviewCount.intValue() : 0
        );
        
        log.info("Updated user {} rating: {} ({} reviews)", userId, averageRating, reviewCount);
    }
}