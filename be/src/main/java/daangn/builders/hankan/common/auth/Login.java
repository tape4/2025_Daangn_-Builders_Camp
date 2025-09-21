package daangn.builders.hankan.common.auth;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 로그인이 필요한 메서드에 사용하는 어노테이션
 * 향후 Spring Security JWT 토큰 인증과 연동될 예정
 */
@Target({ElementType.METHOD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface Login {
    /**
     * 로그인이 필수인지 여부 (기본값: true)
     */
    boolean required() default true;
}