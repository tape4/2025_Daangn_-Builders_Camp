package daangn.builders.hankan.domain.reservation;

import daangn.builders.hankan.common.exception.*;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRepository;
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
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final UserRepository userRepository;
    private final SpaceRepository spaceRepository;

    @Transactional
    public Reservation createReservation(ReservationRequest request) {
        log.info("Creating reservation for user {} at space {} from {} to {}", 
                request.getUserId(), request.getSpaceId(), request.getStartDate(), request.getEndDate());

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new UserNotFoundException(request.getUserId()));

        Space space = spaceRepository.findById(request.getSpaceId())
                .orElseThrow(() -> new SpaceNotFoundException(request.getSpaceId()));

        // 예약 가능한 날짜 범위 체크
        validateReservationDates(space, request.getStartDate(), request.getEndDate());

        // 박스 용량 체크
        validateBoxRequirements(space, request);
        
        // 가격 검증
        validatePrice(request.getTotalPrice());

        // 기간 중 충돌하는 예약 체크
        validateNoConflictingReservations(space.getId(), request.getStartDate(), request.getEndDate());

        Reservation reservation = Reservation.builder()
                .user(user)
                .space(space)
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .boxRequirementXs(request.getBoxRequirementXs())
                .boxRequirementS(request.getBoxRequirementS())
                .boxRequirementM(request.getBoxRequirementM())
                .boxRequirementL(request.getBoxRequirementL())
                .boxRequirementXl(request.getBoxRequirementXl())
                .totalPrice(request.getTotalPrice())
                .build();

        Reservation savedReservation = reservationRepository.save(reservation);
        log.info("Reservation created successfully with id: {}", savedReservation.getId());

        return savedReservation;
    }

    public Reservation findById(Long reservationId) {
        return reservationRepository.findById(reservationId)
                .orElseThrow(() -> new ReservationNotFoundException(reservationId));
    }

    public Page<Reservation> findByUser(Long userId, Pageable pageable) {
        return reservationRepository.findByUserIdOrderByCreatedAtDesc(userId, pageable);
    }

    public Page<Reservation> findByUserAndStatus(Long userId, Reservation.ReservationStatus status, Pageable pageable) {
        return reservationRepository.findByUserIdAndStatusOrderByCreatedAtDesc(userId, status, pageable);
    }

    public Page<Reservation> findBySpace(Long spaceId, Pageable pageable) {
        return reservationRepository.findBySpaceIdOrderByCreatedAtDesc(spaceId, pageable);
    }

    public Page<Reservation> findBySpaceOwner(Long ownerId, Pageable pageable) {
        return reservationRepository.findBySpaceOwnerIdOrderByCreatedAtDesc(ownerId, pageable);
    }

    @Transactional
    public Reservation confirmReservation(Long reservationId) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() != Reservation.ReservationStatus.PENDING) {
            throw new InvalidReservationStateException("대기 중인 예약만 확정할 수 있습니다");
        }

        reservation.confirm();
        log.info("Reservation {} confirmed", reservationId);
        
        return reservation;
    }

    @Transactional
    public Reservation cancelReservation(Long reservationId) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() == Reservation.ReservationStatus.COMPLETED) {
            throw new InvalidReservationStateException("완료된 예약은 취소할 수 없습니다");
        }

        reservation.cancel();
        log.info("Reservation {} cancelled", reservationId);
        
        return reservation;
    }

    @Transactional
    public Reservation checkIn(Long reservationId, String itemDescription, String itemImageUrl) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() != Reservation.ReservationStatus.CONFIRMED) {
            throw new InvalidReservationStateException("확정된 예약만 체크인할 수 있습니다");
        }

        // 체크인 날짜 검증 (시작 날짜 당일만 체크인 가능)
        LocalDate today = LocalDate.now();
        if (!today.equals(reservation.getStartDate())) {
            throw new InvalidReservationStateException("체크인은 예약 시작일에만 가능합니다");
        }

        reservation.checkIn(itemDescription, itemImageUrl, LocalDateTime.now());
        log.info("Reservation {} checked in", reservationId);
        
        return reservation;
    }

    @Transactional
    public Reservation checkOut(Long reservationId, Reservation.ItemCondition itemCondition) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() != Reservation.ReservationStatus.CHECKED_IN) {
            throw new InvalidReservationStateException("체크인된 예약만 체크아웃할 수 있습니다");
        }

        reservation.checkOut(LocalDateTime.now(), itemCondition);
        log.info("Reservation {} checked out with condition: {}", reservationId, itemCondition);
        
        return reservation;
    }

    public List<Reservation> findTodayCheckIns() {
        return reservationRepository.findReservationsForCheckInToday(LocalDate.now());
    }

    public List<Reservation> findTodayCheckOuts() {
        return reservationRepository.findReservationsForCheckOutToday(LocalDate.now());
    }

    public List<Reservation> findOverdueReservations() {
        return reservationRepository.findOverdueReservations(LocalDate.now());
    }

    public boolean hasUserCompletedReservationAtSpace(Long userId, Long spaceId) {
        return reservationRepository.existsByUserIdAndSpaceIdAndStatus(
                userId, spaceId, Reservation.ReservationStatus.COMPLETED);
    }

    private void validateReservationDates(Space space, LocalDate startDate, LocalDate endDate) {
        if (startDate.isAfter(endDate)) {
            throw new InvalidDateRangeException("시작일이 종료일보다 늦을 수 없습니다");
        }

        if (startDate.isBefore(LocalDate.now())) {
            throw new InvalidDateRangeException("과거 날짜에 대한 예약은 불가능합니다");
        }

        if (!space.isAvailableOn(startDate) || !space.isAvailableOn(endDate)) {
            throw new InvalidDateRangeException("해당 날짜에 공간을 이용할 수 없습니다");
        }
    }

    private void validateBoxRequirements(Space space, ReservationRequest request) {
        int totalRequired = (request.getBoxRequirementXs() != null ? request.getBoxRequirementXs() : 0) +
                           (request.getBoxRequirementS() != null ? request.getBoxRequirementS() : 0) +
                           (request.getBoxRequirementM() != null ? request.getBoxRequirementM() : 0) +
                           (request.getBoxRequirementL() != null ? request.getBoxRequirementL() : 0) +
                           (request.getBoxRequirementXl() != null ? request.getBoxRequirementXl() : 0);

        if (totalRequired == 0) {
            throw new InvalidBoxCapacityException("최소 1개 이상의 박스를 요청해야 합니다");
        }

        // 각 사이즈별 용량 체크
        if ((request.getBoxRequirementXs() != null ? request.getBoxRequirementXs() : 0) > space.getBoxCapacityXs() ||
            (request.getBoxRequirementS() != null ? request.getBoxRequirementS() : 0) > space.getBoxCapacityS() ||
            (request.getBoxRequirementM() != null ? request.getBoxRequirementM() : 0) > space.getBoxCapacityM() ||
            (request.getBoxRequirementL() != null ? request.getBoxRequirementL() : 0) > space.getBoxCapacityL() ||
            (request.getBoxRequirementXl() != null ? request.getBoxRequirementXl() : 0) > space.getBoxCapacityXl()) {
            throw new InvalidBoxCapacityException("요청한 박스 수가 공간의 수용 가능한 용량을 초과합니다");
        }
    }

    private void validateNoConflictingReservations(Long spaceId, LocalDate startDate, LocalDate endDate) {
        long conflictCount = reservationRepository.countActiveReservationsInPeriod(spaceId, startDate, endDate);
        if (conflictCount > 0) {
            throw new ConflictingReservationException("해당 기간에 이미 예약이 존재합니다");
        }
    }
    
    private void validatePrice(BigDecimal price) {
        if (price == null) {
            throw new IllegalArgumentException("Price is required");
        }
        if (price.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
    }
}