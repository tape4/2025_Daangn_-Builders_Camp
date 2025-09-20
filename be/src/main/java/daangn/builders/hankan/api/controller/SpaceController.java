package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.auth.LoginContext;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRegistrationRequest;
import daangn.builders.hankan.domain.space.SpaceService;
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

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/spaces")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Space", description = "공간 관리 API")
public class SpaceController {

    private final SpaceService spaceService;

    @PostMapping
    @Login
    @Operation(summary = "공간 등록", description = "새로운 보관 공간을 등록합니다.")
    public ResponseEntity<Space> registerSpace(@RequestBody SpaceRegistrationRequest request) {
        // 현재 로그인된 사용자를 소유자로 설정 (임시)
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자를 기본값으로 사용
            currentUserId = 1L;
        }
        
        SpaceRegistrationRequest updatedRequest = SpaceRegistrationRequest.builder()
                .name(request.getName())
                .description(request.getDescription())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .address(request.getAddress())
                .imageUrl(request.getImageUrl())
                .ownerId(currentUserId)
                .availableStartDate(request.getAvailableStartDate())
                .availableEndDate(request.getAvailableEndDate())
                .boxCapacityXs(request.getBoxCapacityXs())
                .boxCapacityS(request.getBoxCapacityS())
                .boxCapacityM(request.getBoxCapacityM())
                .boxCapacityL(request.getBoxCapacityL())
                .boxCapacityXl(request.getBoxCapacityXl())
                .build();

        Space space = spaceService.registerSpace(updatedRequest);
        return ResponseEntity.ok(space);
    }

    @GetMapping("/{spaceId}")
    @Operation(summary = "공간 상세 조회", description = "공간 ID로 상세 정보를 조회합니다.")
    public ResponseEntity<Space> getSpace(@PathVariable Long spaceId) {
        Space space = spaceService.findById(spaceId);
        return ResponseEntity.ok(space);
    }

    @GetMapping("/search/location")
    @Operation(summary = "위치 기반 공간 검색", description = "위치와 반경을 기준으로 공간을 검색합니다.")
    public ResponseEntity<Page<Object[]>> searchSpacesByLocation(
            @Parameter(description = "위도") @RequestParam Double latitude,
            @Parameter(description = "경도") @RequestParam Double longitude,
            @Parameter(description = "검색 반경 (km)") @RequestParam(defaultValue = "5.0") Double radiusKm,
            @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Object[]> spaces = spaceService.findSpacesNearLocation(latitude, longitude, radiusKm, pageable);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/search/date")
    @Operation(summary = "날짜별 이용 가능한 공간 검색", description = "특정 날짜에 이용 가능한 공간을 검색합니다.")
    public ResponseEntity<List<Space>> searchSpacesByDate(
            @Parameter(description = "검색 날짜 (YYYY-MM-DD)") @RequestParam LocalDate date) {
        
        List<Space> spaces = spaceService.findAvailableSpacesOnDate(date);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/search/location-and-date")
    @Operation(summary = "위치와 날짜 조건으로 공간 검색", description = "위치, 반경, 날짜 조건을 모두 만족하는 공간을 검색합니다.")
    public ResponseEntity<Page<Object[]>> searchSpacesByLocationAndDate(
            @Parameter(description = "위도") @RequestParam Double latitude,
            @Parameter(description = "경도") @RequestParam Double longitude,
            @Parameter(description = "검색 반경 (km)") @RequestParam(defaultValue = "5.0") Double radiusKm,
            @Parameter(description = "검색 날짜 (YYYY-MM-DD)") @RequestParam LocalDate date,
            @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Object[]> spaces = spaceService.findSpacesNearLocationOnDate(latitude, longitude, radiusKm, date, pageable);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/top-rated")
    @Operation(summary = "평점 높은 공간 조회", description = "평점이 높은 순서로 공간을 조회합니다.")
    public ResponseEntity<Page<Space>> getTopRatedSpaces(@PageableDefault(size = 20) Pageable pageable) {
        Page<Space> spaces = spaceService.findTopRatedSpaces(pageable);
        return ResponseEntity.ok(spaces);
    }

    @GetMapping("/my")
    @Login
    @Operation(summary = "내 공간 목록 조회", description = "현재 사용자가 소유한 공간 목록을 조회합니다.")
    public ResponseEntity<Page<Space>> getMySpaces(@PageableDefault(size = 20) Pageable pageable) {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 공간 소유자 ID 사용
            currentUserId = 3L;
        }
        
        Page<Space> spaces = spaceService.findByOwner(currentUserId, pageable);
        return ResponseEntity.ok(spaces);
    }

    @PatchMapping("/{spaceId}/image")
    @Login
    @Operation(summary = "공간 이미지 업데이트", description = "공간의 이미지를 업데이트합니다.")
    public ResponseEntity<Space> updateSpaceImage(
            @PathVariable Long spaceId,
            @Parameter(description = "새 이미지 URL") @RequestParam String imageUrl) {
        
        Space space = spaceService.updateSpaceImage(spaceId, imageUrl);
        return ResponseEntity.ok(space);
    }

    @PatchMapping("/{spaceId}/availability")
    @Login
    @Operation(summary = "공간 이용 가능 기간 업데이트", description = "공간의 이용 가능 기간을 업데이트합니다.")
    public ResponseEntity<Space> updateAvailabilityPeriod(
            @PathVariable Long spaceId,
            @Parameter(description = "시작 날짜") @RequestParam LocalDate startDate,
            @Parameter(description = "종료 날짜") @RequestParam LocalDate endDate) {
        
        Space space = spaceService.updateAvailabilityPeriod(spaceId, startDate, endDate);
        return ResponseEntity.ok(space);
    }

    @PatchMapping("/{spaceId}/capacity")
    @Login
    @Operation(summary = "공간 박스 용량 업데이트", description = "공간의 박스 용량을 업데이트합니다.")
    public ResponseEntity<Space> updateBoxCapacities(
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
            @PathVariable LocalDate date) {
        
        boolean available = spaceService.isSpaceAvailableOnDate(spaceId, date);
        return ResponseEntity.ok(available);
    }

    @GetMapping("/{spaceId}/capacity")
    @Operation(summary = "공간 총 박스 수 조회", description = "공간의 총 박스 수를 조회합니다.")
    public ResponseEntity<Integer> getTotalBoxCount(@PathVariable Long spaceId) {
        int totalCount = spaceService.getTotalBoxCount(spaceId);
        return ResponseEntity.ok(totalCount);
    }
}