package daangn.builders.hankan.common.exception;

public class ItemNotFoundException extends RuntimeException {
    
    public ItemNotFoundException(Long itemId) {
        super("물품을 찾을 수 없습니다. ID: " + itemId);
    }
    
    public ItemNotFoundException(String message) {
        super(message);
    }
}