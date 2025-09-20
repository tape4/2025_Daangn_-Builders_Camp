package daangn.builders.hankan.api.dto;

import daangn.builders.hankan.domain.item.Item;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "물품 보관 요청 응답 DTO")
public class ItemResponse {

    @Schema(description = "물품 ID", example = "1")
    private Long id;

    @Schema(description = "제목", example = "겨울 옷 보관")
    private String title;

    @Schema(description = "설명", example = "겨울 패딩과 코트 등 부피가 큰 겨울 옷들을 보관하고자 합니다")
    private String description;

    @Schema(description = "이미지 URL", example = "https://s3-bucket/items/image.jpg")
    private String imageUrl;

    @Schema(description = "가로 크기 (cm)", example = "50.0")
    private Double width;

    @Schema(description = "세로 크기 (cm)", example = "40.0")
    private Double height;

    @Schema(description = "깊이 (cm)", example = "30.0")
    private Double depth;

    @Schema(description = "부피 (cm³)", example = "60000.0")
    private Double volume;

    @Schema(description = "사이즈 카테고리", example = "L")
    private String sizeCategory;

    @Schema(description = "보관 시작일", example = "2025-10-01")
    private LocalDate startDate;

    @Schema(description = "보관 종료일", example = "2025-12-31")
    private LocalDate endDate;

    @Schema(description = "희망 최소 가격", example = "30000")
    private BigDecimal minPrice;

    @Schema(description = "희망 최대 가격", example = "50000")
    private BigDecimal maxPrice;

    @Schema(description = "소유자 정보")
    private OwnerInfo owner;

    @Schema(description = "상태", example = "ACTIVE")
    private String status;

    @Schema(description = "등록일시", example = "2025-09-21T10:00:00")
    private LocalDateTime createdAt;

    @Schema(description = "수정일시", example = "2025-09-21T10:00:00")
    private LocalDateTime updatedAt;

    @Getter
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "소유자 정보")
    public static class OwnerInfo {
        @Schema(description = "사용자 ID", example = "1")
        private Long id;

        @Schema(description = "닉네임", example = "사용자123")
        private String nickname;

        @Schema(description = "프로필 이미지 URL", example = "https://s3-bucket/profiles/user.jpg")
        private String profileImageUrl;

        @Schema(description = "평점", example = "4.5")
        private Double rating;
    }

    public static ItemResponse from(Item item) {
        return ItemResponse.builder()
                .id(item.getId())
                .title(item.getTitle())
                .description(item.getDescription())
                .imageUrl(item.getImageUrl())
                .width(item.getWidth())
                .height(item.getHeight())
                .depth(item.getDepth())
                .volume(item.getVolume())
                .sizeCategory(item.getSizeCategory())
                .startDate(item.getStartDate())
                .endDate(item.getEndDate())
                .minPrice(item.getMinPrice())
                .maxPrice(item.getMaxPrice())
                .owner(OwnerInfo.builder()
                        .id(item.getOwner().getId())
                        .nickname(item.getOwner().getNickname())
                        .profileImageUrl(item.getOwner().getProfileImageUrl())
                        .rating(item.getOwner().getRating())
                        .build())
                .status(item.getStatus().name())
                .createdAt(item.getCreatedAt())
                .updatedAt(item.getUpdatedAt())
                .build();
    }
}