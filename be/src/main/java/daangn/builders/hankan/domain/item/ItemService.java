package daangn.builders.hankan.domain.item;

import daangn.builders.hankan.api.dto.ItemRegistrationRequest;
import daangn.builders.hankan.common.exception.ResourceNotFoundException;
import daangn.builders.hankan.common.exception.UnauthorizedException;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ItemService {

    private final ItemRepository itemRepository;
    private final UserRepository userRepository;

    /**
     * 물품 보관 요청 등록
     */
    @Transactional
    public Item registerItem(Long userId, ItemRegistrationRequest request, String imageUrl) {
        User owner = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", userId));

        // 날짜 검증
        if (request.getStartDate().isAfter(request.getEndDate())) {
            throw new IllegalArgumentException("시작일은 종료일보다 이전이어야 합니다");
        }

        // 가격 검증
        if (request.getMinPrice().compareTo(request.getMaxPrice()) > 0) {
            throw new IllegalArgumentException("최소 가격은 최대 가격보다 작거나 같아야 합니다");
        }

        Item item = Item.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .imageUrl(imageUrl)
                .width(request.getWidth())
                .height(request.getHeight())
                .depth(request.getDepth())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .minPrice(request.getMinPrice())
                .maxPrice(request.getMaxPrice())
                .owner(owner)
                .status(Item.ItemStatus.ACTIVE)
                .build();

        Item savedItem = itemRepository.save(item);
        log.info("Item registered: id={}, owner={}, title={}", 
                savedItem.getId(), owner.getId(), savedItem.getTitle());

        return savedItem;
    }

    /**
     * 물품 조회
     */
    public Item findById(Long itemId) {
        return itemRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Item", itemId));
    }

    /**
     * 물품 삭제
     */
    @Transactional
    public void deleteItem(Long userId, Long itemId) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Item", itemId));

        // 소유자 확인
        if (!item.getOwner().getId().equals(userId)) {
            throw new UnauthorizedException("이 물품을 삭제할 권한이 없습니다");
        }

        // ACTIVE 상태인 경우만 삭제 가능
        if (item.getStatus() != Item.ItemStatus.ACTIVE) {
            throw new IllegalStateException("활성 상태의 물품만 삭제할 수 있습니다");
        }

        itemRepository.delete(item);
        log.info("Item deleted: id={}, owner={}", itemId, userId);
    }

    /**
     * 물품 상태 업데이트
     */
    @Transactional
    public Item updateItemStatus(Long userId, Long itemId, Item.ItemStatus status) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Item", itemId));

        // 소유자 확인
        if (!item.getOwner().getId().equals(userId)) {
            throw new UnauthorizedException("이 물품의 상태를 변경할 권한이 없습니다");
        }

        item.updateStatus(status);
        log.info("Item status updated: id={}, status={}", itemId, status);
        return item;
    }

    /**
     * 물품 이미지 업데이트
     */
    @Transactional
    public Item updateItemImage(Long userId, Long itemId, String imageUrl) {
        Item item = itemRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Item", itemId));

        // 소유자 확인
        if (!item.getOwner().getId().equals(userId)) {
            throw new UnauthorizedException("이 물품의 이미지를 수정할 권한이 없습니다");
        }

        item.updateImage(imageUrl);
        log.info("Item image updated: id={}, imageUrl={}", itemId, imageUrl);
        return item;
    }

    // === 조회 메서드들 ===

    /**
     * 내 물품 목록 조회
     */
    public Page<Item> findMyItems(Long userId, Pageable pageable) {
        return itemRepository.findByOwnerId(userId, pageable);
    }

    /**
     * 내 물품 상태별 조회
     */
    public Page<Item> findMyItemsByStatus(Long userId, Item.ItemStatus status, Pageable pageable) {
        return itemRepository.findByOwnerIdAndStatus(userId, status, pageable);
    }

    /**
     * 활성 물품 목록 조회
     */
    public Page<Item> findActiveItems(Pageable pageable) {
        return itemRepository.findByStatus(Item.ItemStatus.ACTIVE, pageable);
    }

    /**
     * 날짜별 이용 가능한 물품 조회
     */
    public Page<Item> findItemsByDate(LocalDate date, Pageable pageable) {
        return itemRepository.findAvailableItemsOnDate(date, pageable);
    }

    /**
     * 가격 범위로 물품 조회
     */
    public Page<Item> findItemsByPriceRange(BigDecimal minBudget, BigDecimal maxBudget, Pageable pageable) {
        if (minBudget.compareTo(maxBudget) > 0) {
            throw new IllegalArgumentException("최소 예산은 최대 예산보다 작거나 같아야 합니다");
        }
        return itemRepository.findByPriceRange(minBudget, maxBudget, pageable);
    }

    /**
     * 사이즈 제한으로 물품 조회
     */
    public Page<Item> findItemsBySizeLimit(Double maxVolume, Pageable pageable) {
        if (maxVolume <= 0) {
            throw new IllegalArgumentException("최대 부피는 0보다 커야 합니다");
        }
        return itemRepository.findBySizeLimit(maxVolume, pageable);
    }

    /**
     * 날짜와 가격 범위로 물품 조회
     */
    public Page<Item> findItemsByDateAndPrice(LocalDate date, BigDecimal minBudget, 
                                              BigDecimal maxBudget, Pageable pageable) {
        if (minBudget.compareTo(maxBudget) > 0) {
            throw new IllegalArgumentException("최소 예산은 최대 예산보다 작거나 같아야 합니다");
        }
        return itemRepository.findByDateAndPriceRange(date, minBudget, maxBudget, pageable);
    }

    /**
     * 날짜와 사이즈로 물품 조회
     */
    public Page<Item> findItemsByDateAndSize(LocalDate date, Double maxVolume, Pageable pageable) {
        if (maxVolume <= 0) {
            throw new IllegalArgumentException("최대 부피는 0보다 커야 합니다");
        }
        return itemRepository.findByDateAndSize(date, maxVolume, pageable);
    }

    /**
     * 최신 등록 물품 조회
     */
    public Page<Item> findRecentItems(Pageable pageable) {
        return itemRepository.findByStatusOrderByCreatedAtDesc(Item.ItemStatus.ACTIVE, pageable);
    }

    /**
     * 곧 시작될 물품 조회
     */
    public Page<Item> findUpcomingItems(int daysAhead, Pageable pageable) {
        LocalDate today = LocalDate.now();
        LocalDate futureDate = today.plusDays(daysAhead);
        return itemRepository.findUpcomingItems(today, futureDate, pageable);
    }

    /**
     * 키워드로 물품 검색
     */
    public Page<Item> searchItems(String keyword, Pageable pageable) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("검색어를 입력해주세요");
        }
        return itemRepository.searchByKeyword(keyword.trim(), pageable);
    }

    /**
     * 물품 통계
     */
    public Map<String, Long> getItemStatistics() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("total", itemRepository.count());
        stats.put("active", itemRepository.countByStatus(Item.ItemStatus.ACTIVE));
        stats.put("matched", itemRepository.countByStatus(Item.ItemStatus.MATCHED));
        stats.put("completed", itemRepository.countByStatus(Item.ItemStatus.COMPLETED));
        return stats;
    }

    /**
     * 사용자별 물품 통계
     */
    public long getUserItemCount(Long userId) {
        return itemRepository.countByOwnerId(userId);
    }
}