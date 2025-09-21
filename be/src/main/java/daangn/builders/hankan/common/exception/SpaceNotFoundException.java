package daangn.builders.hankan.common.exception;

public class SpaceNotFoundException extends RuntimeException {
    public SpaceNotFoundException(String message) {
        super(message);
    }
    
    public SpaceNotFoundException(Long spaceId) {
        super("해당 ID의 공간을 찾을 수 없습니다: " + spaceId);
    }
}