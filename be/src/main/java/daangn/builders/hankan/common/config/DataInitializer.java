package daangn.builders.hankan.common.config;

import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRepository;
import daangn.builders.hankan.domain.user.Gender;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;

import java.time.LocalDate;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class DataInitializer {

    private final UserRepository userRepository;
    private final SpaceRepository spaceRepository;

    @Bean
    @Profile({"local", "dev"})
    @Order(1) // TestTokenGenerator 보다 먼저 실행
    public ApplicationRunner initializeTestData() {
        return args -> {
            log.info("Initializing test data...");
            
            // 테스트 토큰용 사용자 생성
            if (!userRepository.existsByPhoneNumber("010-1234-5678")) {
                User testUser1 = User.builder()
                        .phoneNumber("010-1234-5678")
                        .nickname("테스트 토큰 사용자")
                        .birthDate(LocalDate.of(1990, 1, 1))
                        .gender(Gender.MALE)
                        .profileImageUrl("https://example.com/profile1.jpg")
                        .build();
                testUser1 = userRepository.save(testUser1);
                log.info("Created test token user with ID: {} (Phone: 010-1234-5678)", testUser1.getId());
            } else {
                User existingUser = userRepository.findByPhoneNumber("010-1234-5678").orElse(null);
                if (existingUser != null) {
                    log.info("Test token user already exists with ID: {} (Phone: 010-1234-5678)", existingUser.getId());
                }
            }

            if (!userRepository.existsByPhoneNumber("010-9876-5432")) {
                User testUser2 = User.builder()
                        .phoneNumber("010-9876-5432")
                        .nickname("예약사용자 테스트유저")
                        .birthDate(LocalDate.of(1995, 5, 15))
                        .gender(Gender.FEMALE)
                        .profileImageUrl("https://example.com/profile2.jpg")
                        .build();
                userRepository.save(testUser2);
                log.info("Created test user 2: {}", testUser2.getId());
            }

            // 공간 소유자 (테스트 사용자 3)
            User spaceOwner = null;
            if (!userRepository.existsByPhoneNumber("010-1111-2222")) {
                spaceOwner = User.builder()
                        .phoneNumber("010-1111-2222")
                        .nickname("공간소유자 테스트유저")
                        .birthDate(LocalDate.of(1985, 12, 20))
                        .gender(Gender.MALE)
                        .profileImageUrl("https://example.com/owner.jpg")
                        .build();
                spaceOwner = userRepository.save(spaceOwner);
                log.info("Created space owner: {}", spaceOwner.getId());
            } else {
                spaceOwner = userRepository.findByPhoneNumber("010-1111-2222").orElse(null);
            }

            // 테스트 공간 생성
            if (spaceOwner != null && spaceRepository.count() == 0) {
                Space testSpace1 = Space.builder()
                        .name("강남역 보관소")
                        .description("지하철역 근처 안전한 보관 공간입니다.")
                        .latitude(37.4981)
                        .longitude(127.0276)
                        .address("서울특별시 강남구 강남대로 역삼동")
                        .imageUrl("https://example.com/space1.jpg")
                        .owner(spaceOwner)
                        .availableStartDate(LocalDate.now())
                        .availableEndDate(LocalDate.now().plusMonths(3))
                        .boxCapacityXs(10)
                        .boxCapacityS(8)
                        .boxCapacityM(5)
                        .boxCapacityL(3)
                        .boxCapacityXl(2)
                        .build();
                spaceRepository.save(testSpace1);

                Space testSpace2 = Space.builder()
                        .name("홍대 창고")
                        .description("24시간 이용 가능한 넓은 보관소입니다.")
                        .latitude(37.5563)
                        .longitude(126.9245)
                        .address("서울특별시 마포구 홍익로 홍대입구역")
                        .imageUrl("https://example.com/space2.jpg")
                        .owner(spaceOwner)
                        .availableStartDate(LocalDate.now().minusDays(7))
                        .availableEndDate(LocalDate.now().plusMonths(6))
                        .boxCapacityXs(15)
                        .boxCapacityS(12)
                        .boxCapacityM(8)
                        .boxCapacityL(5)
                        .boxCapacityXl(3)
                        .build();
                spaceRepository.save(testSpace2);

                log.info("Created {} test spaces", 2);
            }

            log.info("Test data initialization completed. Users: {}, Spaces: {}", 
                    userRepository.count(), spaceRepository.count());
        };
    }
}