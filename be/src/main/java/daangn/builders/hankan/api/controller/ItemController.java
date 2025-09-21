package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.api.dto.ItemRegistrationRequest;
import daangn.builders.hankan.api.dto.ItemResponse;
import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.service.S3Service;
import daangn.builders.hankan.domain.item.Item;
import daangn.builders.hankan.domain.item.ItemService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/api/items")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Item", description = "물품 보관 요청 API")
@Validated
public class ItemController {

    private final ItemService itemService;
    private final S3Service s3Service;

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(
        summary = "물품 보관 요청 등록",
        description = "보관이 필요한 물품을 등록합니다. 이미지를 함께 업로드할 수 있습니다.",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "등록 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 요청"),
        @ApiResponse(responseCode = "401", description = "인증 실패"),
        @ApiResponse(responseCode = "413", description = "파일 크기 초과")
    })
    public ResponseEntity<ItemResponse> registerItem(
            @Parameter(hidden = true) @Login Long userId,
            @Valid @ModelAttribute ItemRegistrationRequest request,
            @Parameter(description = "물품 이미지 (최대 10MB)")
            @RequestParam(value = "image", required = false) MultipartFile imageFile) {

        String imageUrl = null;
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                s3Service.validateFileSize(imageFile, 10);
                imageUrl = s3Service.uploadImage(imageFile, S3Service.ImageType.ITEM);
                log.info("물품 이미지 업로드 성공: {}", imageUrl);
            } catch (Exception e) {
                log.error("물품 이미지 업로드 실패: {}", e.getMessage());
                throw new RuntimeException("이미지 업로드에 실패했습니다.", e);
            }
        }

        Item item = itemService.registerItem(userId, request, imageUrl);
        return ResponseEntity.status(HttpStatus.CREATED).body(ItemResponse.from(item));
    }

    @GetMapping("/{itemId}")
    @Operation(summary = "물품 상세 조회", description = "물품 ID로 상세 정보를 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공"),
        @ApiResponse(responseCode = "404", description = "물품을 찾을 수 없음")
    })
    public ResponseEntity<ItemResponse> getItem(@PathVariable Long itemId) {
        Item item = itemService.findById(itemId);
        return ResponseEntity.ok(ItemResponse.from(item));
    }

    @DeleteMapping("/{itemId}")
    @Operation(
        summary = "물품 삭제",
        description = "등록한 물품을 삭제합니다. 본인이 등록한 물품만 삭제 가능합니다.",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "삭제 성공"),
        @ApiResponse(responseCode = "401", description = "인증 실패"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "물품을 찾을 수 없음")
    })
    public ResponseEntity<Void> deleteItem(
            @Parameter(hidden = true) @Login Long userId,
            @PathVariable Long itemId) {
        itemService.deleteItem(userId, itemId);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping(value = "/{itemId}/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(
        summary = "물품 이미지 업데이트",
        description = "물품의 이미지를 업데이트합니다.",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "업데이트 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 요청"),
        @ApiResponse(responseCode = "401", description = "인증 실패"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "물품을 찾을 수 없음")
    })
    public ResponseEntity<ItemResponse> updateItemImage(
            @Parameter(hidden = true) @Login Long userId,
            @PathVariable Long itemId,
            @Parameter(description = "새 이미지 파일", required = true)
            @RequestParam("image") MultipartFile imageFile) {

        String imageUrl;
        try {
            s3Service.validateFileSize(imageFile, 10);
            imageUrl = s3Service.uploadImage(imageFile, S3Service.ImageType.ITEM);
            log.info("물품 이미지 업데이트 성공: {}", imageUrl);
        } catch (Exception e) {
            log.error("물품 이미지 업로드 실패: {}", e.getMessage());
            throw new RuntimeException("이미지 업로드에 실패했습니다.", e);
        }

        Item item = itemService.updateItemImage(userId, itemId, imageUrl);
        return ResponseEntity.ok(ItemResponse.from(item));
    }

    @PatchMapping("/{itemId}/status")
    @Operation(
        summary = "물품 상태 변경",
        description = "물품의 상태를 변경합니다 (ACTIVE, MATCHED, COMPLETED, CANCELLED)",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "변경 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 상태 값"),
        @ApiResponse(responseCode = "401", description = "인증 실패"),
        @ApiResponse(responseCode = "403", description = "권한 없음"),
        @ApiResponse(responseCode = "404", description = "물품을 찾을 수 없음")
    })
    public ResponseEntity<ItemResponse> updateItemStatus(
            @Parameter(hidden = true) @Login Long userId,
            @PathVariable Long itemId,
            @Parameter(description = "변경할 상태", required = true)
            @RequestParam Item.ItemStatus status) {
        Item item = itemService.updateItemStatus(userId, itemId, status);
        return ResponseEntity.ok(ItemResponse.from(item));
    }

    @GetMapping("/my")
    @Operation(
        summary = "내 물품 목록 조회",
        description = "내가 등록한 물품 목록을 조회합니다",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공"),
        @ApiResponse(responseCode = "401", description = "인증 실패")
    })
    public ResponseEntity<Page<ItemResponse>> getMyItems(
            @Parameter(hidden = true) @Login Long userId,
            @Parameter(description = "상태 필터 (선택)")
            @RequestParam(required = false) Item.ItemStatus status,
            @ParameterObject @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) 
            Pageable pageable) {
        
        Page<Item> items = (status != null) 
            ? itemService.findMyItemsByStatus(userId, status, pageable)
            : itemService.findMyItems(userId, pageable);
        
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/search/date")
    @Operation(summary = "날짜별 물품 검색", description = "특정 날짜에 보관이 필요한 물품을 검색합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "검색 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 날짜 형식")
    })
    public ResponseEntity<Page<ItemResponse>> searchByDate(
            @Parameter(description = "검색 날짜", required = true, example = "2025-10-01")
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findItemsByDate(date, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/search/price")
    @Operation(summary = "가격 범위로 물품 검색", description = "예산 범위 내의 물품을 검색합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "검색 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 가격 범위")
    })
    public ResponseEntity<Page<ItemResponse>> searchByPriceRange(
            @Parameter(description = "최소 예산", required = true, example = "10000")
            @RequestParam @Positive BigDecimal minBudget,
            @Parameter(description = "최대 예산", required = true, example = "50000")
            @RequestParam @Positive BigDecimal maxBudget,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findItemsByPriceRange(minBudget, maxBudget, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/search/size")
    @Operation(summary = "사이즈로 물품 검색", description = "최대 부피 이내의 물품을 검색합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "검색 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 부피 값")
    })
    public ResponseEntity<Page<ItemResponse>> searchBySize(
            @Parameter(description = "최대 부피 (cm³)", required = true, example = "60000")
            @RequestParam @Positive Double maxVolume,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findItemsBySizeLimit(maxVolume, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/search/date-and-price")
    @Operation(summary = "날짜와 가격으로 물품 검색", description = "날짜와 가격 조건을 모두 만족하는 물품을 검색합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "검색 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 파라미터")
    })
    public ResponseEntity<Page<ItemResponse>> searchByDateAndPrice(
            @Parameter(description = "검색 날짜", required = true)
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @Parameter(description = "최소 예산", required = true)
            @RequestParam @Positive BigDecimal minBudget,
            @Parameter(description = "최대 예산", required = true)
            @RequestParam @Positive BigDecimal maxBudget,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findItemsByDateAndPrice(date, minBudget, maxBudget, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/search/date-and-size")
    @Operation(summary = "날짜와 사이즈로 물품 검색", description = "날짜와 사이즈 조건을 모두 만족하는 물품을 검색합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "검색 성공"),
        @ApiResponse(responseCode = "400", description = "잘못된 파라미터")
    })
    public ResponseEntity<Page<ItemResponse>> searchByDateAndSize(
            @Parameter(description = "검색 날짜", required = true)
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @Parameter(description = "최대 부피 (cm³)", required = true)
            @RequestParam @Positive Double maxVolume,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findItemsByDateAndSize(date, maxVolume, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/search/keyword")
    @Operation(summary = "키워드로 물품 검색", description = "제목 또는 설명에 키워드가 포함된 물품을 검색합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "검색 성공"),
        @ApiResponse(responseCode = "400", description = "검색어가 비어있음")
    })
    public ResponseEntity<Page<ItemResponse>> searchByKeyword(
            @Parameter(description = "검색 키워드", required = true, example = "겨울")
            @RequestParam String keyword,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.searchItems(keyword, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/recent")
    @Operation(summary = "최근 등록 물품 조회", description = "최근에 등록된 활성 물품을 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    public ResponseEntity<Page<ItemResponse>> getRecentItems(
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findRecentItems(pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/upcoming")
    @Operation(summary = "곧 시작될 물품 조회", description = "가까운 미래에 보관이 시작될 물품을 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    public ResponseEntity<Page<ItemResponse>> getUpcomingItems(
            @Parameter(description = "며칠 이내", example = "7")
            @RequestParam(defaultValue = "7") int daysAhead,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Item> items = itemService.findUpcomingItems(daysAhead, pageable);
        return ResponseEntity.ok(items.map(ItemResponse::from));
    }

    @GetMapping("/stats")
    @Operation(summary = "물품 통계 조회", description = "전체 물품 통계를 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    public ResponseEntity<Map<String, Long>> getItemStatistics() {
        return ResponseEntity.ok(itemService.getItemStatistics());
    }
}