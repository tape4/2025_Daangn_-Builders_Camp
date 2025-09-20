package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.api.dto.BoxCapacityResponse;
import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.auth.LoginContext;
import daangn.builders.hankan.common.service.S3Service;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRegistrationRequest;
import daangn.builders.hankan.domain.space.SpaceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/spaces")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Space", description = "공간 관리 API")
public class SpaceController {

    private final SpaceService spaceService;
    private final S3Service s3Service;

    @PostMapping(consumes = "multipart/form-data")
    @Login
    @Operation(summary = "공간 등록", description = "새로운 보관 공간을 등록합니다. 이미지 파일을 포함하여 등록합니다.")
    public ResponseEntity<Space> registerSpace(
            @Parameter(hidden = true) Long userId,
            @Parameter(description = "공간 이름") @RequestParam String name,
            @Parameter(description = "공간 설명") @RequestParam(required = false) String description,
            @Parameter(description = "위도") @RequestParam Double latitude,
            @Parameter(description = "경도") @RequestParam Double longitude,
            @Parameter(description = "주소") @RequestParam String address,
            @Parameter(description = "공간 이미지 파일", 
                      content = @io.swagger.v3.oas.annotations.media.Content(
                          mediaType = "multipart/form-data"
                      )) 
            @RequestParam(value = "image", required = false) MultipartFile imageFile,
            @Parameter(description = "이용 시작일 (YYYY-MM-DD)", example = "2025-09-24",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @RequestParam(required = false) LocalDate availableStartDate,
            @Parameter(description = "이용 종료일 (YYYY-MM-DD)", example = "2025-12-31",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @RequestParam(required = false) LocalDate availableEndDate,
            @Parameter(description = "XS 박스 개수") @RequestParam(required = false) Integer boxCapacityXs,
            @Parameter(description = "S 박스 개수") @RequestParam(required = false) Integer boxCapacityS,
            @Parameter(description = "M 박스 개수") @RequestParam(required = false) Integer boxCapacityM,
            @Parameter(description = "L 박스 개수") @RequestParam(required = false) Integer boxCapacityL,
            @Parameter(description = "XL 박스 개수") @RequestParam(required = false) Integer boxCapacityXl) {
        // 현재 로그인된 사용자를 소유자로 설정
        Long currentUserId = userId;
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자를 기본값으로 사용
            currentUserId = 1L;
        }
        
        // 이미지 파일 S3 업로드 처리
        String imageUrl = null;
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                // 파일 크기 검증 (10MB)
                s3Service.validateFileSize(imageFile, 10);
                // S3에 업로드
                imageUrl = s3Service.uploadImage(imageFile, S3Service.ImageType.SPACE);
                log.info("공간 이미지 업로드 성공: {}", imageUrl);
            } catch (Exception e) {
                log.error("공간 이미지 업로드 실패: {}", e.getMessage());
                throw new RuntimeException("이미지 업로드에 실패했습니다.", e);
            }
        }
        
        SpaceRegistrationRequest request = SpaceRegistrationRequest.builder()
                .name(name)
                .description(description)
                .latitude(latitude)
                .longitude(longitude)
                .address(address)
                .imageUrl(imageUrl)
                .ownerId(currentUserId)
                .availableStartDate(availableStartDate)
                .availableEndDate(availableEndDate)
                .boxCapacityXs(boxCapacityXs)
                .boxCapacityS(boxCapacityS)
                .boxCapacityM(boxCapacityM)
                .boxCapacityL(boxCapacityL)
                .boxCapacityXl(boxCapacityXl)
                .build();

        Space space = spaceService.registerSpace(request);
        return ResponseEntity.ok(space);
    }

    @GetMapping("/{spaceId}")
    @Operation(summary = "공간 상세 조회", description = "공간 ID로 상세 정보를 조회합니다.")
    public ResponseEntity<Space> getSpace(@PathVariable Long spaceId) {
        Space space = spaceService.findById(spaceId);
        return ResponseEntity.ok(space);
    }

    @GetMapping("/search/location")
    @Operation(summary = "위치 기반 공간 검색", description = "위치와 반경을 기준으로 공간을 검색합니다. 결과는 거리순으로 정렬됩니다.")
    public ResponseEntity<Page<Object[]>> searchSpacesByLocation(
            @Parameter(description = "위도") @RequestParam Double latitude,
            @Parameter(description = "경도") @RequestParam Double longitude,
            @Parameter(description = "검색 반경 (km)") @RequestParam(defaultValue = "5.0") Double radiusKm,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        // 정렬을 무시하고 페이징만 적용 (거리순 정렬은 쿼리에서 처리)
        Pageable unsortedPageable = org.springframework.data.domain.PageRequest.of(
            pageable.getPageNumber(), pageable.getPageSize());
        
        Page<Object[]> spaces = spaceService.findSpacesNearLocation(latitude, longitude, radiusKm, unsortedPageable);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/search/date")
    @Operation(summary = "날짜별 이용 가능한 공간 검색", description = "특정 날짜에 이용 가능한 공간을 검색합니다.")
    public ResponseEntity<List<Space>> searchSpacesByDate(
            @Parameter(description = "검색 날짜 (YYYY-MM-DD 형식, 예: 2025-09-24)", 
                      example = "2025-09-24",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @RequestParam LocalDate date) {
        
        List<Space> spaces = spaceService.findAvailableSpacesOnDate(date);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/search/location-and-date")
    @Operation(summary = "위치와 날짜 조건으로 공간 검색", description = "위치, 반경, 날짜 조건을 모두 만족하는 공간을 검색합니다. 결과는 거리순으로 정렬됩니다.")
    public ResponseEntity<Page<Object[]>> searchSpacesByLocationAndDate(
            @Parameter(description = "위도") @RequestParam Double latitude,
            @Parameter(description = "경도") @RequestParam Double longitude,
            @Parameter(description = "검색 반경 (km)") @RequestParam(defaultValue = "5.0") Double radiusKm,
            @Parameter(description = "검색 날짜 (YYYY-MM-DD 형식, 예: 2025-09-24)", 
                      example = "2025-09-24",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @RequestParam LocalDate date,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        // 정렬을 무시하고 페이징만 적용 (거리순 정렬은 쿼리에서 처리)
        Pageable unsortedPageable = org.springframework.data.domain.PageRequest.of(
            pageable.getPageNumber(), pageable.getPageSize());
        
        Page<Object[]> spaces = spaceService.findSpacesNearLocationOnDate(latitude, longitude, radiusKm, date, unsortedPageable);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/top-rated")
    @Operation(summary = "평점 높은 공간 조회", description = "평점이 높은 순서로 공간을 조회합니다.")
    public ResponseEntity<Page<Space>> getTopRatedSpaces(
            @ParameterObject @PageableDefault(size = 20, sort = "rating", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<Space> spaces = spaceService.findTopRatedSpaces(pageable);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/my")
    @Login
    @Operation(summary = "내 공간 목록 조회", description = "현재 사용자가 소유한 공간 목록을 조회합니다.")
    public ResponseEntity<Page<Space>> getMySpaces(
            @Parameter(hidden = true) Long userId,
            @ParameterObject @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        Long currentUserId = userId;
        if (currentUserId == null) {
            // 개발용: 공간 소유자 ID 사용
            currentUserId = 3L;
        }
        
        Page<Space> spaces = spaceService.findByOwner(currentUserId, pageable);
        return ResponseEntity.ok(spaces);
    }

    @PatchMapping(value = "/{spaceId}/image", consumes = "multipart/form-data")
    @Login
    @Operation(summary = "공간 이미지 업데이트", description = "공간의 이미지 파일을 업로드하여 업데이트합니다.")
    public ResponseEntity<Space> updateSpaceImage(
            @Parameter(hidden = true) Long userId,
            @PathVariable Long spaceId,
            @Parameter(description = "업로드할 이미지 파일", 
                      content = @io.swagger.v3.oas.annotations.media.Content(
                          mediaType = "multipart/form-data"
                      )) 
            @RequestParam("image") MultipartFile imageFile) {
        
        // 이미지 파일 S3 업로드 처리
        String imageUrl;
        try {
            // 파일 크기 검증 (10MB)
            s3Service.validateFileSize(imageFile, 10);
            // S3에 업로드
            imageUrl = s3Service.uploadImage(imageFile, S3Service.ImageType.SPACE);
            log.info("공간 이미지 업데이트 성공: {}", imageUrl);
        } catch (Exception e) {
            log.error("공간 이미지 업로드 실패: {}", e.getMessage());
            throw new RuntimeException("이미지 업로드에 실패했습니다.", e);
        }
        
        Space space = spaceService.updateSpaceImage(spaceId, imageUrl);
        return ResponseEntity.ok(space);
    }

    @PatchMapping("/{spaceId}/availability")
    @Login
    @Operation(summary = "공간 이용 가능 기간 업데이트", description = "공간의 이용 가능 기간을 업데이트합니다.")
    public ResponseEntity<Space> updateAvailabilityPeriod(
            @Parameter(hidden = true) Long userId,
            @PathVariable Long spaceId,
            @Parameter(description = "시작 날짜 (YYYY-MM-DD 형식, 예: 2025-09-24)", 
                      example = "2025-09-24",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @RequestParam LocalDate startDate,
            @Parameter(description = "종료 날짜 (YYYY-MM-DD 형식, 예: 2025-12-31)", 
                      example = "2025-12-31",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @RequestParam LocalDate endDate) {
        
        Space space = spaceService.updateAvailabilityPeriod(spaceId, startDate, endDate);
        return ResponseEntity.ok(space);
    }

    @PatchMapping("/{spaceId}/capacity")
    @Login
    @Operation(summary = "공간 박스 용량 업데이트", description = "공간의 박스 용량을 업데이트합니다.")
    public ResponseEntity<Space> updateBoxCapacities(
            @Parameter(hidden = true) Long userId,
            @PathVariable Long spaceId,
            @Parameter(description = "XS 박스 개수") @RequestParam(required = false) Integer xs,
            @Parameter(description = "S 박스 개수") @RequestParam(required = false) Integer s,
            @Parameter(description = "M 박스 개수") @RequestParam(required = false) Integer m,
            @Parameter(description = "L 박스 개수") @RequestParam(required = false) Integer l,
            @Parameter(description = "XL 박스 개수") @RequestParam(required = false) Integer xl) {
        
        Space space = spaceService.updateBoxCapacities(spaceId, xs, s, m, l, xl);
        return ResponseEntity.ok(space);
    }

    @GetMapping("/{spaceId}/availability/{date}")
    @Operation(summary = "특정 날짜 공간 이용 가능 여부 확인", description = "특정 날짜에 공간이 이용 가능한지 확인합니다.")
    public ResponseEntity<Boolean> checkAvailability(
            @PathVariable Long spaceId,
            @Parameter(description = "확인할 날짜 (YYYY-MM-DD 형식, 예: 2025-09-24)", 
                      example = "2025-09-24",
                      schema = @io.swagger.v3.oas.annotations.media.Schema(type = "string", format = "date"))
            @PathVariable LocalDate date) {
        
        boolean available = spaceService.isSpaceAvailableOnDate(spaceId, date);
        return ResponseEntity.ok(available);
    }

    @GetMapping("/{spaceId}/capacity")
    @Operation(summary = "공간 박스 용량 상세 조회", description = "공간의 박스 종류별 개수와 총 박스 수를 조회합니다.")
    public ResponseEntity<BoxCapacityResponse> getBoxCapacityDetails(@PathVariable Long spaceId) {
        Space space = spaceService.findById(spaceId);
        
        BoxCapacityResponse response = BoxCapacityResponse.builder()
                .xsCount(space.getBoxCapacityXs())
                .sCount(space.getBoxCapacityS())
                .mCount(space.getBoxCapacityM())
                .lCount(space.getBoxCapacityL())
                .xlCount(space.getBoxCapacityXl())
                .totalCount(space.getTotalBoxCount())
                .build();
        
        return ResponseEntity.ok(response);
    }
}