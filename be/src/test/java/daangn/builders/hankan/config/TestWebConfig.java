package daangn.builders.hankan.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
@Profile("test")
public class TestWebConfig implements WebMvcConfigurer {

    private final TestLoginArgumentResolver testLoginArgumentResolver;
    
    public TestWebConfig(TestLoginArgumentResolver testLoginArgumentResolver) {
        this.testLoginArgumentResolver = testLoginArgumentResolver;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(testLoginArgumentResolver);
    }
}