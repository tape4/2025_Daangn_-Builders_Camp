package daangn.builders.hankan.common.exception;

public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String message) {
        super(message);
    }
    
    public UserNotFoundException(Long userId) {
        super("해당 ID의 사용자를 찾을 수 없습니다: " + userId);
    }
}