package daangn.builders.hankan.domain.reservation;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    
    /**
     * 사용자별 예약 조회
     */
    Page<Reservation> findByUserIdOrderByCreatedAtDesc(Long userId, Pageable pageable);
    
    /**
     * 사용자별 특정 상태의 예약 조회
     */
    Page<Reservation> findByUserIdAndStatusOrderByCreatedAtDesc(
            Long userId, Reservation.ReservationStatus status, Pageable pageable);
    
    /**
     * 공간별 예약 조회
     */
    Page<Reservation> findBySpaceIdOrderByCreatedAtDesc(Long spaceId, Pageable pageable);
    
    /**
     * 공간 소유자의 예약 조회
     */
    @Query("SELECT r FROM Reservation r WHERE r.space.owner.id = :ownerId ORDER BY r.createdAt DESC")
    Page<Reservation> findBySpaceOwnerIdOrderByCreatedAtDesc(@Param("ownerId") Long ownerId, Pageable pageable);
    
    /**
     * 특정 기간의 예약 조회
     */
    List<Reservation> findBySpaceIdAndStartDateLessThanEqualAndEndDateGreaterThanEqual(
            Long spaceId, LocalDate endDate, LocalDate startDate);
    
    /**
     * 특정 공간의 특정 날짜 예약 여부 확인
     */
    @Query("SELECT r FROM Reservation r " +
           "WHERE r.space.id = :spaceId " +
           "AND r.status IN ('CONFIRMED', 'CHECKED_IN') " +
           "AND :date BETWEEN r.startDate AND r.endDate")
    List<Reservation> findActiveReservationsOnDate(
            @Param("spaceId") Long spaceId, 
            @Param("date") LocalDate date);
    
    /**
     * 체크인 대상 예약 조회 (오늘 시작하는 확정된 예약)
     */
    @Query("SELECT r FROM Reservation r " +
           "WHERE r.status = 'CONFIRMED' " +
           "AND r.startDate = :today")
    List<Reservation> findReservationsForCheckInToday(@Param("today") LocalDate today);
    
    /**
     * 체크아웃 대상 예약 조회 (오늘 종료하는 체크인된 예약)
     */
    @Query("SELECT r FROM Reservation r " +
           "WHERE r.status = 'CHECKED_IN' " +
           "AND r.endDate = :today")
    List<Reservation> findReservationsForCheckOutToday(@Param("today") LocalDate today);
    
    /**
     * 사용자와 공간에 대한 완료된 예약 존재 여부 (리뷰 작성 권한 확인용)
     */
    boolean existsByUserIdAndSpaceIdAndStatus(
            Long userId, Long spaceId, Reservation.ReservationStatus status);
    
    /**
     * 특정 날짜 범위 내 활성 예약 수 조회
     */
    @Query("SELECT COUNT(r) FROM Reservation r " +
           "WHERE r.space.id = :spaceId " +
           "AND r.status IN ('CONFIRMED', 'CHECKED_IN') " +
           "AND r.startDate <= :endDate " +
           "AND r.endDate >= :startDate")
    long countActiveReservationsInPeriod(
            @Param("spaceId") Long spaceId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);
    
    /**
     * 연체된 예약 조회 (체크아웃 기한이 지난 체크인 상태 예약)
     */
    @Query("SELECT r FROM Reservation r " +
           "WHERE r.status = 'CHECKED_IN' " +
           "AND r.endDate < :currentDate")
    List<Reservation> findOverdueReservations(@Param("currentDate") LocalDate currentDate);
}