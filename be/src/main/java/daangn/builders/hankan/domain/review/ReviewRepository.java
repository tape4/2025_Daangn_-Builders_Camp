package daangn.builders.hankan.domain.review;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    
    /**
     * 공간별 리뷰 조회
     */
    Page<Review> findBySpaceIdAndReviewTypeOrderByCreatedAtDesc(
            Long spaceId, Review.ReviewType reviewType, Pageable pageable);
    
    /**
     * 사용자별 받은 리뷰 조회
     */
    Page<Review> findByReviewedUserIdAndReviewTypeOrderByCreatedAtDesc(
            Long userId, Review.ReviewType reviewType, Pageable pageable);
    
    /**
     * 작성자별 리뷰 조회
     */
    Page<Review> findByReviewerIdOrderByCreatedAtDesc(Long reviewerId, Pageable pageable);
    
    /**
     * 특정 예약에 대한 리뷰 조회
     */
    List<Review> findByReservationId(Long reservationId);
    
    /**
     * 특정 예약에 대한 특정 타입의 리뷰 존재 여부
     */
    boolean existsByReservationIdAndReviewType(Long reservationId, Review.ReviewType reviewType);
    
    /**
     * 특정 사용자가 특정 예약에 대해 작성한 리뷰 조회
     */
    Optional<Review> findByReviewerIdAndReservationIdAndReviewType(
            Long reviewerId, Long reservationId, Review.ReviewType reviewType);
    
    /**
     * 공간의 평균 평점 계산
     */
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.space.id = :spaceId AND r.reviewType = 'SPACE'")
    Double calculateAverageSpaceRating(@Param("spaceId") Long spaceId);
    
    /**
     * 공간의 리뷰 수 조회
     */
    @Query("SELECT COUNT(r) FROM Review r WHERE r.space.id = :spaceId AND r.reviewType = 'SPACE'")
    Long countSpaceReviews(@Param("spaceId") Long spaceId);
    
    /**
     * 사용자의 평균 평점 계산
     */
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.reviewedUser.id = :userId AND r.reviewType = 'USER'")
    Double calculateAverageUserRating(@Param("userId") Long userId);
    
    /**
     * 사용자의 리뷰 수 조회
     */
    @Query("SELECT COUNT(r) FROM Review r WHERE r.reviewedUser.id = :userId AND r.reviewType = 'USER'")
    Long countUserReviews(@Param("userId") Long userId);
    
    /**
     * 공간별 평점 분포 조회
     */
    @Query("SELECT r.rating, COUNT(r) FROM Review r " +
           "WHERE r.space.id = :spaceId AND r.reviewType = 'SPACE' " +
           "GROUP BY r.rating ORDER BY r.rating")
    List<Object[]> getSpaceRatingDistribution(@Param("spaceId") Long spaceId);
    
    /**
     * 최근 리뷰 조회 (공간별)
     */
    @Query("SELECT r FROM Review r " +
           "WHERE r.space.id = :spaceId AND r.reviewType = 'SPACE' " +
           "ORDER BY r.createdAt DESC")
    List<Review> findRecentSpaceReviews(@Param("spaceId") Long spaceId, Pageable pageable);
    
    /**
     * 높은 평점 리뷰 조회 (공간별)
     */
    @Query("SELECT r FROM Review r " +
           "WHERE r.space.id = :spaceId AND r.reviewType = 'SPACE' AND r.rating >= :minRating " +
           "ORDER BY r.rating DESC, r.createdAt DESC")
    List<Review> findHighRatedSpaceReviews(
            @Param("spaceId") Long spaceId, 
            @Param("minRating") Integer minRating, 
            Pageable pageable);
}