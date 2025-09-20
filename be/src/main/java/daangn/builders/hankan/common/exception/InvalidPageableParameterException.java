package daangn.builders.hankan.common.exception;

public class InvalidPageableParameterException extends RuntimeException {
    public InvalidPageableParameterException(String message) {
        super(message);
    }
    
    public InvalidPageableParameterException(String parameter, String value) {
        super(String.format("잘못된 페이지 파라미터입니다. %s: %s", parameter, value));
    }
}