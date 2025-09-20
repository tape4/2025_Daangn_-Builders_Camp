package daangn.builders.hankan.common.exception;

public class ResourceNotFoundException extends RuntimeException {
    
    public ResourceNotFoundException(String resourceType, Long id) {
        super(String.format("%s를 찾을 수 없습니다. ID: %d", resourceType, id));
    }
    
    public ResourceNotFoundException(String message) {
        super(message);
    }
}