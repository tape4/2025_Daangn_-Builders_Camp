package daangn.builders.hankan.common.exception;

public class InvalidPhoneNumberFormatException extends RuntimeException {
    public InvalidPhoneNumberFormatException(String phoneNumber) {
        super("잘못된 전화번호 형식입니다: " + phoneNumber + ". 하이픈 없이 10-11자리 숫자만 입력해주세요.");
    }
}