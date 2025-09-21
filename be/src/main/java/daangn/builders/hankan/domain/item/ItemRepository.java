package daangn.builders.hankan.domain.item;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ItemRepository extends JpaRepository<Item, Long> {

    // 소유자별 조회
    Page<Item> findByOwnerId(Long ownerId, Pageable pageable);
    
    Page<Item> findByOwnerIdAndStatus(Long ownerId, Item.ItemStatus status, Pageable pageable);

    // 상태별 조회
    Page<Item> findByStatus(Item.ItemStatus status, Pageable pageable);

    // 날짜 범위로 조회 (특정 날짜에 보관이 필요한 아이템)
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND :date BETWEEN i.startDate AND i.endDate")
    List<Item> findAvailableItemsOnDate(@Param("date") LocalDate date);

    // 날짜 범위로 페이징 조회
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND :date BETWEEN i.startDate AND i.endDate")
    Page<Item> findAvailableItemsOnDate(@Param("date") LocalDate date, Pageable pageable);

    // 가격 범위로 조회
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND i.minPrice <= :maxBudget AND i.maxPrice >= :minBudget")
    Page<Item> findByPriceRange(@Param("minBudget") BigDecimal minBudget, 
                                @Param("maxBudget") BigDecimal maxBudget, 
                                Pageable pageable);

    // 사이즈 카테고리별 조회 (계산된 부피 기준)
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND (i.width * i.height * i.depth) <= :maxVolume")
    Page<Item> findBySizeLimit(@Param("maxVolume") Double maxVolume, Pageable pageable);

    // 복합 조건 검색: 날짜 + 가격 범위
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND :date BETWEEN i.startDate AND i.endDate " +
           "AND i.minPrice <= :maxBudget AND i.maxPrice >= :minBudget")
    Page<Item> findByDateAndPriceRange(@Param("date") LocalDate date,
                                       @Param("minBudget") BigDecimal minBudget,
                                       @Param("maxBudget") BigDecimal maxBudget,
                                       Pageable pageable);

    // 복합 조건 검색: 날짜 + 사이즈
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND :date BETWEEN i.startDate AND i.endDate " +
           "AND (i.width * i.height * i.depth) <= :maxVolume")
    Page<Item> findByDateAndSize(@Param("date") LocalDate date,
                                 @Param("maxVolume") Double maxVolume,
                                 Pageable pageable);

    // 최신 등록 아이템
    Page<Item> findByStatusOrderByCreatedAtDesc(Item.ItemStatus status, Pageable pageable);

    // 곧 시작될 아이템 (다음 N일 이내)
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND i.startDate BETWEEN :today AND :futureDate " +
           "ORDER BY i.startDate ASC")
    Page<Item> findUpcomingItems(@Param("today") LocalDate today,
                                 @Param("futureDate") LocalDate futureDate,
                                 Pageable pageable);

    // 제목 또는 설명으로 검색
    @Query("SELECT i FROM Item i WHERE i.status = 'ACTIVE' " +
           "AND (LOWER(i.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(i.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Item> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    // 통계
    long countByStatus(Item.ItemStatus status);
    
    long countByOwnerId(Long ownerId);

    // ID와 소유자로 조회 (권한 확인용)
    Optional<Item> findByIdAndOwnerId(Long id, Long ownerId);
}