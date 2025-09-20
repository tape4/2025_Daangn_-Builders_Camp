package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.auth.LoginContext;
import daangn.builders.hankan.domain.reservation.Reservation;
import daangn.builders.hankan.domain.reservation.ReservationRequest;
import daangn.builders.hankan.domain.reservation.ReservationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservations")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Reservation", description = "예약 관리 API")
public class ReservationController {

    private final ReservationService reservationService;

    @PostMapping
    @Login
    @Operation(summary = "예약 생성", description = "새로운 예약을 생성합니다.")
    public ResponseEntity<Reservation> createReservation(@Valid @RequestBody ReservationRequest request) {
        // 현재 로그인된 사용자를 예약자로 설정 (임시)
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자를 기본값으로 사용
            currentUserId = 1L;
        }
        
        ReservationRequest updatedRequest = ReservationRequest.builder()
                .userId(currentUserId)
                .spaceId(request.getSpaceId())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .boxRequirementXs(request.getBoxRequirementXs())
                .boxRequirementS(request.getBoxRequirementS())
                .boxRequirementM(request.getBoxRequirementM())
                .boxRequirementL(request.getBoxRequirementL())
                .boxRequirementXl(request.getBoxRequirementXl())
                .totalPrice(request.getTotalPrice())
                .build();

        Reservation reservation = reservationService.createReservation(updatedRequest);
        return ResponseEntity.ok(reservation);
    }

    @GetMapping("/{reservationId}")
    @Login
    @Operation(summary = "예약 상세 조회", description = "예약 ID로 상세 정보를 조회합니다.")
    public ResponseEntity<Reservation> getReservation(@PathVariable Long reservationId) {
        Reservation reservation = reservationService.findById(reservationId);
        return ResponseEntity.ok(reservation);
    }

    @GetMapping("/my")
    @Login
    @Operation(summary = "내 예약 목록 조회", description = "현재 사용자의 예약 목록을 조회합니다.")
    public ResponseEntity<Page<Reservation>> getMyReservations(
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자 사용
            currentUserId = 1L;
        }
        
        Page<Reservation> reservations = reservationService.findByUser(currentUserId, pageable);
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/my/status/{status}")
    @Login
    @Operation(summary = "상태별 내 예약 조회", description = "특정 상태의 내 예약을 조회합니다.")
    public ResponseEntity<Page<Reservation>> getMyReservationsByStatus(
            @PathVariable Reservation.ReservationStatus status,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자 사용
            currentUserId = 1L;
        }
        
        Page<Reservation> reservations = reservationService.findByUserAndStatus(currentUserId, status, pageable);
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/space/{spaceId}")
    @Operation(summary = "공간별 예약 조회", description = "특정 공간의 예약 목록을 조회합니다.")
    public ResponseEntity<Page<Reservation>> getReservationsBySpace(
            @PathVariable Long spaceId,
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        
        Page<Reservation> reservations = reservationService.findBySpace(spaceId, pageable);
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/my-spaces")
    @Login
    @Operation(summary = "내 공간 예약 조회", description = "내가 소유한 공간들의 예약을 조회합니다.")
    public ResponseEntity<Page<Reservation>> getMySpaceReservations(
            @ParameterObject @PageableDefault(size = 20) Pageable pageable) {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 공간 소유자 ID 사용
            currentUserId = 3L;
        }
        
        Page<Reservation> reservations = reservationService.findBySpaceOwner(currentUserId, pageable);
        return ResponseEntity.ok(reservations);
    }

    @PatchMapping("/{reservationId}/confirm")
    @Login
    @Operation(summary = "예약 확정", description = "대기 중인 예약을 확정합니다.")
    public ResponseEntity<Reservation> confirmReservation(@PathVariable Long reservationId) {
        Reservation reservation = reservationService.confirmReservation(reservationId);
        return ResponseEntity.ok(reservation);
    }

    @PatchMapping("/{reservationId}/cancel")
    @Login
    @Operation(summary = "예약 취소", description = "예약을 취소합니다.")
    public ResponseEntity<Reservation> cancelReservation(@PathVariable Long reservationId) {
        Reservation reservation = reservationService.cancelReservation(reservationId);
        return ResponseEntity.ok(reservation);
    }

    @PatchMapping("/{reservationId}/check-in")
    @Login
    @Operation(summary = "체크인", description = "예약에 대해 체크인을 진행합니다.")
    public ResponseEntity<Reservation> checkIn(
            @PathVariable Long reservationId,
            @Parameter(description = "보관할 물건 설명") @RequestParam String itemDescription,
            @Parameter(description = "물건 이미지 URL") @RequestParam(required = false) String itemImageUrl) {
        
        Reservation reservation = reservationService.checkIn(reservationId, itemDescription, itemImageUrl);
        return ResponseEntity.ok(reservation);
    }

    @PatchMapping("/{reservationId}/check-out")
    @Login
    @Operation(summary = "체크아웃", description = "예약에 대해 체크아웃을 진행합니다.")
    public ResponseEntity<Reservation> checkOut(
            @PathVariable Long reservationId,
            @Parameter(description = "물건 상태") @RequestParam Reservation.ItemCondition itemCondition) {
        
        Reservation reservation = reservationService.checkOut(reservationId, itemCondition);
        return ResponseEntity.ok(reservation);
    }

    @GetMapping("/check-ins/today")
    @Login
    @Operation(summary = "오늘 체크인 대상 조회", description = "오늘 체크인 예정인 예약들을 조회합니다.")
    public ResponseEntity<List<Reservation>> getTodayCheckIns() {
        List<Reservation> reservations = reservationService.findTodayCheckIns();
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/check-outs/today")
    @Login
    @Operation(summary = "오늘 체크아웃 대상 조회", description = "오늘 체크아웃 예정인 예약들을 조회합니다.")
    public ResponseEntity<List<Reservation>> getTodayCheckOuts() {
        List<Reservation> reservations = reservationService.findTodayCheckOuts();
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/overdue")
    @Login
    @Operation(summary = "연체된 예약 조회", description = "체크아웃 기한이 지난 예약들을 조회합니다.")
    public ResponseEntity<List<Reservation>> getOverdueReservations() {
        List<Reservation> reservations = reservationService.findOverdueReservations();
        return ResponseEntity.ok(reservations);
    }

    @GetMapping("/check-review-eligibility")
    @Login
    @Operation(summary = "리뷰 작성 권한 확인", description = "특정 공간에 대한 리뷰 작성 권한이 있는지 확인합니다.")
    public ResponseEntity<Boolean> checkReviewEligibility(
            @Parameter(description = "공간 ID") @RequestParam Long spaceId) {
        
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            currentUserId = 1L;
        }
        
        boolean eligible = reservationService.hasUserCompletedReservationAtSpace(currentUserId, spaceId);
        return ResponseEntity.ok(eligible);
    }
}