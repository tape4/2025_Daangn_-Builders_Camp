package daangn.builders.hankan.common.exception;

public class InvalidItemStateException extends RuntimeException {
    
    public InvalidItemStateException(String message) {
        super(message);
    }
    
    public InvalidItemStateException(String currentState, String expectedState) {
        super(String.format("잘못된 물품 상태입니다. 현재: %s, 예상: %s", currentState, expectedState));
    }
}