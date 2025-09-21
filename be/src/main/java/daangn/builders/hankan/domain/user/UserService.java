package daangn.builders.hankan.domain.user;

import daangn.builders.hankan.api.dto.UserRegistrationRequest;
import daangn.builders.hankan.common.exception.DuplicatePhoneNumberException;
import daangn.builders.hankan.common.exception.UserNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

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
        Assert.notNull(request, "Registration request must not be null");
        Assert.hasText(request.getPhoneNumber(), "Phone number must not be empty");
        Assert.hasText(request.getNickname(), "Nickname must not be empty");
        
        log.info("Registering new user with phone: {}", maskPhoneNumber(request.getPhoneNumber()));
        
        // 중복 전화번호 체크
        if (userRepository.existsByPhoneNumber(request.getPhoneNumber())) {
            log.warn("Duplicate phone number registration attempt: {}", maskPhoneNumber(request.getPhoneNumber()));
            throw new DuplicatePhoneNumberException(request.getPhoneNumber());
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
        Assert.notNull(userId, "User ID must not be null");
        
        return userRepository.findById(userId)
                .orElseThrow(() -> {
                    log.error("User not found with id: {}", userId);
                    return new UserNotFoundException(userId);
                });
    }

    public Optional<User> findByPhoneNumber(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber);
    }

    public User findByPhoneNumberOrThrow(String phoneNumber) {
        Assert.hasText(phoneNumber, "Phone number must not be empty");
        
        return findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> {
                    log.error("User not found with phone number: {}", maskPhoneNumber(phoneNumber));
                    return new UserNotFoundException("User not found with phone number: " + maskPhoneNumber(phoneNumber));
                });
    }

    public Page<User> findByNicknameContaining(String nickname, Pageable pageable) {
        return userRepository.findByNicknameContainingIgnoreCase(nickname, pageable);
    }

    public Page<User> findTopRatedUsers(Pageable pageable) {
        return userRepository.findAllByOrderByRatingDesc(pageable);
    }

    @Transactional
    public User updateProfile(Long userId, String nickname, String profileImageUrl) {
        Assert.notNull(userId, "User ID must not be null");
        
        log.info("Updating profile for userId: {} with nickname: {}", userId, nickname);
        
        User user = findById(userId);
        user.updateProfile(nickname, profileImageUrl);
        
        User updatedUser = userRepository.save(user);
        log.info("User profile updated successfully for id: {}", userId);
        
        return updatedUser;
    }

    @Transactional
    public User updateRating(Long userId, double newRating, int newReviewCount) {
        Assert.notNull(userId, "User ID must not be null");
        Assert.isTrue(newRating >= 0 && newRating <= 5, "Rating must be between 0 and 5");
        Assert.isTrue(newReviewCount >= 0, "Review count must not be negative");
        
        User user = findById(userId);
        user.updateRating(newRating, newReviewCount);
        
        User updatedUser = userRepository.save(user);
        log.info("User rating updated for id: {} - rating: {}, reviews: {}", userId, newRating, newReviewCount);
        
        return updatedUser;
    }

    public boolean existsByPhoneNumber(String phoneNumber) {
        Assert.hasText(phoneNumber, "Phone number must not be empty");
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