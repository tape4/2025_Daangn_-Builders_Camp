package daangn.builders.hankan.common.auth;

import daangn.builders.hankan.common.exception.UserNotFoundException;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
@RequiredArgsConstructor
@Slf4j
public class LoginArgumentResolver implements HandlerMethodArgumentResolver {

    private final UserRepository userRepository;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(Login.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        
        Long userId = LoginContext.getCurrentUserId();
        
        if (userId == null) {
            log.warn("Login annotation used but no authenticated user found");
            return null;
        }
        
        if (parameter.getParameterType().equals(Long.class)) {
            return userId;
        }
        
        if (parameter.getParameterType().equals(User.class)) {
            return userRepository.findById(userId)
                    .orElseThrow(() -> new UserNotFoundException(userId));
        }
        
        return null;
    }
}