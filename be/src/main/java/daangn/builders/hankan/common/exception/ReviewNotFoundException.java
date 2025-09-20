package daangn.builders.hankan.common.exception;

public class ReviewNotFoundException extends RuntimeException {
    public ReviewNotFoundException(String message) {
        super(message);
    }
    
    public ReviewNotFoundException(Long reviewId) {
        super("해당 ID의 리뷰를 찾을 수 없습니다: " + reviewId);
    }
}