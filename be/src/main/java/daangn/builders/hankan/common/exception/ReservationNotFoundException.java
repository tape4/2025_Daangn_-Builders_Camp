package daangn.builders.hankan.common.exception;

public class ReservationNotFoundException extends RuntimeException {
    public ReservationNotFoundException(String message) {
        super(message);
    }
    
    public ReservationNotFoundException(Long reservationId) {
        super("해당 ID의 예약을 찾을 수 없습니다: " + reservationId);
    }
}