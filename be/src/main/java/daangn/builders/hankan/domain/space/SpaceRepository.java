package daangn.builders.hankan.domain.space;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface SpaceRepository extends JpaRepository<Space, Long> {
    
    /**
     * 소유자별 공간 조회
     */
    Page<Space> findByOwnerId(Long ownerId, Pageable pageable);
    
    /**
     * 위치 기반 공간 검색 (반경 내 검색)
     * Haversine 공식을 사용한 거리 계산
     */
    @Query("SELECT s, " +
           "(6371 * acos(cos(radians(:lat)) * cos(radians(s.latitude)) * " +
           "cos(radians(s.longitude) - radians(:lng)) + " +
           "sin(radians(:lat)) * sin(radians(s.latitude)))) AS distance " +
           "FROM Space s " +
           "WHERE (6371 * acos(cos(radians(:lat)) * cos(radians(s.latitude)) * " +
           "cos(radians(s.longitude) - radians(:lng)) + " +
           "sin(radians(:lat)) * sin(radians(s.latitude)))) <= :radiusKm " +
           "ORDER BY distance")
    Page<Object[]> findByLocationWithinRadius(
            @Param("lat") Double latitude,
            @Param("lng") Double longitude,
            @Param("radiusKm") double radiusKm,
            Pageable pageable);
    
    /**
     * 특정 날짜에 이용 가능한 공간 검색
     */
    @Query("SELECT s FROM Space s " +
           "WHERE :date >= s.availableStartDate AND :date <= s.availableEndDate")
    List<Space> findByAvailableDate(@Param("date") LocalDate date);
    
    /**
     * 위치와 날짜 조건으로 공간 검색
     */
    @Query("SELECT s, " +
           "(6371 * acos(cos(radians(:lat)) * cos(radians(s.latitude)) * " +
           "cos(radians(s.longitude) - radians(:lng)) + " +
           "sin(radians(:lat)) * sin(radians(s.latitude)))) AS distance " +
           "FROM Space s " +
           "WHERE :date >= s.availableStartDate AND :date <= s.availableEndDate " +
           "AND (6371 * acos(cos(radians(:lat)) * cos(radians(s.latitude)) * " +
           "cos(radians(s.longitude) - radians(:lng)) + " +
           "sin(radians(:lat)) * sin(radians(s.latitude)))) <= :radiusKm " +
           "ORDER BY distance")
    Page<Object[]> findByLocationAndDate(
            @Param("lat") Double latitude,
            @Param("lng") Double longitude,
            @Param("radiusKm") double radiusKm,
            @Param("date") LocalDate date,
            Pageable pageable);
    
    /**
     * 평점 높은 순으로 공간 조회
     */
    Page<Space> findAllByOrderByRatingDesc(Pageable pageable);
    
    /**
     * 공간의 평균 평점과 리뷰 수 계산
     */
    @Query("SELECT AVG(r.rating), COUNT(r) FROM Review r WHERE r.space.id = :spaceId")
    Object[] calculateSpaceRating(@Param("spaceId") Long spaceId);
}