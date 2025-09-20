package daangn.builders.hankan.domain.user;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public User registerUser(UserRegistrationRequest request) {
        log.info("Registering new user with phone: {}", maskPhoneNumber(request.getPhoneNumber()));
        
        // 중복 전화번호 체크
        if (userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
            throw new IllegalArgumentException("User with this phone number already exists");
        }

        User user = User.builder()
                .phoneNumber(request.getPhoneNumber())
                .nickname(request.getNickname())
                .birthDate(request.getBirthDate())
                .gender(request.getGender())
                .profileImageUrl(request.getProfileImageUrl())
                .build();

        User savedUser = userRepository.save(user);
        log.info("User registered successfully with id: {}", savedUser.getId());
        
        return savedUser;
    }

    public User findById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + userId));
    }

    public Optional<User> findByPhoneNumber(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber);
    }

    public User findByPhoneNumberOrThrow(String phoneNumber) {
        return findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new IllegalArgumentException("User not found with phone number: " + maskPhoneNumber(phoneNumber)));
    }

    public Page<User> findByNicknameContaining(String nickname, Pageable pageable) {
        return userRepository.findByNicknameContainingIgnoreCase(nickname, pageable);
    }

    public Page<User> findTopRatedUsers(Pageable pageable) {
        return userRepository.findAllByOrderByRatingDesc(pageable);
    }

    @Transactional
    public User updateProfile(Long userId, String nickname, String profileImageUrl) {
        User user = findById(userId);
        user.updateProfile(nickname, profileImageUrl);
        log.info("User profile updated for id: {}", userId);
        return user;
    }

    @Transactional
    public User updateRating(Long userId, double newRating, int newReviewCount) {
        User user = findById(userId);
        user.updateRating(newRating, newReviewCount);
        log.info("User rating updated for id: {} - rating: {}, reviews: {}", userId, newRating, newReviewCount);
        return user;
    }

    public boolean existsByPhoneNumber(String phoneNumber) {
        return userRepository.existsByPhoneNumber(phoneNumber);
    }

    public long getTotalUserCount() {
        return userRepository.count();
    }

    /**
     * 전화번호 마스킹 (로깅용)
     */
    private String maskPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.length() < 8) {
            return "****";
        }
        return phoneNumber.substring(0, 3) + "****" + phoneNumber.substring(phoneNumber.length() - 4);
    }
}