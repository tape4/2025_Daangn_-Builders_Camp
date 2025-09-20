package daangn.builders.hankan.common.auth;

import daangn.builders.hankan.domain.user.User;

/**
 * 임시 로그인 컨텍스트 (개발용)
 * 향후 Spring Security 컨텍스트로 대체될 예정
 */
public class LoginContext {
    
    private static final ThreadLocal<User> CURRENT_USER = new ThreadLocal<>();
    
    public static void setCurrentUser(User user) {
        CURRENT_USER.set(user);
    }
    
    public static User getCurrentUser() {
        return CURRENT_USER.get();
    }
    
    public static Long getCurrentUserId() {
        User user = getCurrentUser();
        return user != null ? user.getId() : null;
    }
    
    public static void clear() {
        CURRENT_USER.remove();
    }
    
    public static boolean isLoggedIn() {
        return getCurrentUser() != null;
    }
}