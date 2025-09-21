package daangn.builders.hankan.common.auth;

import daangn.builders.hankan.domain.user.User;

/**
 * JWT 인증 컨텍스트
 * ThreadLocal을 사용하여 현재 요청의 인증 정보를 저장
 */
public class LoginContext {
    
    private static final ThreadLocal<User> CURRENT_USER = new ThreadLocal<>();
    private static final ThreadLocal<Long> CURRENT_USER_ID = new ThreadLocal<>();
    private static final ThreadLocal<String> CURRENT_PHONE_NUMBER = new ThreadLocal<>();
    
    public static void setCurrentUser(User user) {
        CURRENT_USER.set(user);
        if (user != null) {
            CURRENT_USER_ID.set(user.getId());
        }
    }
    
    public static void setCurrentUserId(Long userId) {
        CURRENT_USER_ID.set(userId);
    }
    
    public static void setCurrentPhoneNumber(String phoneNumber) {
        CURRENT_PHONE_NUMBER.set(phoneNumber);
    }
    
    public static User getCurrentUser() {
        return CURRENT_USER.get();
    }
    
    public static Long getCurrentUserId() {
        return CURRENT_USER_ID.get();
    }
    
    public static String getCurrentPhoneNumber() {
        return CURRENT_PHONE_NUMBER.get();
    }
    
    public static void clear() {
        CURRENT_USER.remove();
        CURRENT_USER_ID.remove();
        CURRENT_PHONE_NUMBER.remove();
    }
    
    public static boolean isLoggedIn() {
        return getCurrentUserId() != null;
    }
}