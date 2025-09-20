package daangn.builders.hankan.domain.reservation;

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
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + request.getUserId()));

        Space space = spaceRepository.findById(request.getSpaceId())
                .orElseThrow(() -> new IllegalArgumentException("Space not found with id: " + request.getSpaceId()));

        // 예약 가능한 날짜 범위 체크
        validateReservationDates(space, request.getStartDate(), request.getEndDate());

        // 박스 용량 체크
        validateBoxRequirements(space, request);

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
                .orElseThrow(() -> new IllegalArgumentException("Reservation not found with id: " + reservationId));
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
            throw new IllegalStateException("Only pending reservations can be confirmed");
        }

        reservation.confirm();
        log.info("Reservation {} confirmed", reservationId);
        
        return reservation;
    }

    @Transactional
    public Reservation cancelReservation(Long reservationId) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() == Reservation.ReservationStatus.COMPLETED) {
            throw new IllegalStateException("Completed reservations cannot be cancelled");
        }

        reservation.cancel();
        log.info("Reservation {} cancelled", reservationId);
        
        return reservation;
    }

    @Transactional
    public Reservation checkIn(Long reservationId, String itemDescription, String itemImageUrl) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() != Reservation.ReservationStatus.CONFIRMED) {
            throw new IllegalStateException("Only confirmed reservations can be checked in");
        }

        // 체크인 날짜 검증 (시작 날짜 당일만 체크인 가능)
        LocalDate today = LocalDate.now();
        if (!today.equals(reservation.getStartDate())) {
            throw new IllegalStateException("Check-in is only allowed on the reservation start date");
        }

        reservation.checkIn(itemDescription, itemImageUrl, LocalDateTime.now());
        log.info("Reservation {} checked in", reservationId);
        
        return reservation;
    }

    @Transactional
    public Reservation checkOut(Long reservationId, Reservation.ItemCondition itemCondition) {
        Reservation reservation = findById(reservationId);
        
        if (reservation.getStatus() != Reservation.ReservationStatus.CHECKED_IN) {
            throw new IllegalStateException("Only checked-in reservations can be checked out");
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
            throw new IllegalArgumentException("Start date cannot be after end date");
        }

        if (startDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Cannot make reservations for past dates");
        }

        if (!space.isAvailableOn(startDate) || !space.isAvailableOn(endDate)) {
            throw new IllegalArgumentException("Space is not available for the requested dates");
        }
    }

    private void validateBoxRequirements(Space space, ReservationRequest request) {
        int totalRequired = (request.getBoxRequirementXs() != null ? request.getBoxRequirementXs() : 0) +
                           (request.getBoxRequirementS() != null ? request.getBoxRequirementS() : 0) +
                           (request.getBoxRequirementM() != null ? request.getBoxRequirementM() : 0) +
                           (request.getBoxRequirementL() != null ? request.getBoxRequirementL() : 0) +
                           (request.getBoxRequirementXl() != null ? request.getBoxRequirementXl() : 0);

        if (totalRequired == 0) {
            throw new IllegalArgumentException("At least one box must be requested");
        }

        // 각 사이즈별 용량 체크
        if ((request.getBoxRequirementXs() != null ? request.getBoxRequirementXs() : 0) > space.getBoxCapacityXs() ||
            (request.getBoxRequirementS() != null ? request.getBoxRequirementS() : 0) > space.getBoxCapacityS() ||
            (request.getBoxRequirementM() != null ? request.getBoxRequirementM() : 0) > space.getBoxCapacityM() ||
            (request.getBoxRequirementL() != null ? request.getBoxRequirementL() : 0) > space.getBoxCapacityL() ||
            (request.getBoxRequirementXl() != null ? request.getBoxRequirementXl() : 0) > space.getBoxCapacityXl()) {
            throw new IllegalArgumentException("Box requirements exceed space capacity");
        }
    }

    private void validateNoConflictingReservations(Long spaceId, LocalDate startDate, LocalDate endDate) {
        long conflictCount = reservationRepository.countActiveReservationsInPeriod(spaceId, startDate, endDate);
        if (conflictCount > 0) {
            throw new IllegalArgumentException("Space is already reserved for the requested period");
        }
    }
}