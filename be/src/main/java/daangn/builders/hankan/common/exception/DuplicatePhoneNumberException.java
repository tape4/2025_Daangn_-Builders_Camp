package daangn.builders.hankan.common.exception;

public class DuplicatePhoneNumberException extends RuntimeException {
    
    public DuplicatePhoneNumberException(String phoneNumber) {
        super(String.format("User with phone number %s already exists", maskPhoneNumber(phoneNumber)));
    }
    
    private static String maskPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.length() < 8) {
            return "****";
        }
        return phoneNumber.substring(0, 3) + "****" + phoneNumber.substring(phoneNumber.length() - 4);
    }
}