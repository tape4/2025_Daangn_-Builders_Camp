package daangn.builders.hankan.config;

import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.domain.user.User;
import org.springframework.context.annotation.Profile;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
@Profile("test")
public class TestLoginArgumentResolver implements HandlerMethodArgumentResolver {

    // Test user constants
    private static final Long TEST_USER_ID = 1L;
    private static final String TEST_PHONE_NUMBER = "010-1234-5678";

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(Login.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        
        if (parameter.getParameterType().equals(Long.class)) {
            return TEST_USER_ID;
        }
        
        if (parameter.getParameterType().equals(User.class)) {
            // Return a test user using builder
            User testUser = User.builder()
                    .phoneNumber(TEST_PHONE_NUMBER)
                    .nickname("Test User")
                    .build();
            // Note: ID will be set by JPA, so we can't set it directly in tests
            return testUser;
        }
        
        return null;
    }
}