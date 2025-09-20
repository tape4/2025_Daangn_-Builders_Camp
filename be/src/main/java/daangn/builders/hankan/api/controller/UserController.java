package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.auth.LoginContext;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRegistrationRequest;
import daangn.builders.hankan.domain.user.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "User", description = "사용자 관리 API")
public class UserController {

    private final UserService userService;

    @PostMapping("/register")
    @Operation(summary = "사용자 등록", description = "새로운 사용자를 등록합니다.")
    public ResponseEntity<User> registerUser(@RequestBody UserRegistrationRequest request) {
        User user = userService.registerUser(request);
        
        // 개발용: 등록 후 자동 로그인
        LoginContext.setCurrentUser(user);
        
        return ResponseEntity.ok(user);
    }

    @GetMapping("/me")
    @Login
    @Operation(summary = "내 프로필 조회", description = "현재 로그인한 사용자의 프로필을 조회합니다.")
    public ResponseEntity<User> getMyProfile() {
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자 사용
            currentUserId = 1L;
        }
        
        User user = userService.findById(currentUserId);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/{userId}")
    @Operation(summary = "사용자 프로필 조회", description = "특정 사용자의 프로필을 조회합니다.")
    public ResponseEntity<User> getUserProfile(@PathVariable Long userId) {
        User user = userService.findById(userId);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/phone/{phoneNumber}")
    @Operation(summary = "전화번호로 사용자 조회", description = "전화번호로 사용자를 조회합니다.")
    public ResponseEntity<User> getUserByPhone(@PathVariable String phoneNumber) {
        User user = userService.findByPhoneNumberOrThrow(phoneNumber);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/search")
    @Operation(summary = "닉네임으로 사용자 검색", description = "닉네임을 포함하는 사용자를 검색합니다.")
    public ResponseEntity<Page<User>> searchUsersByNickname(
            @Parameter(description = "검색할 닉네임") @RequestParam String nickname,
            @PageableDefault(size = 20) Pageable pageable) {
        
        Page<User> users = userService.findByNicknameContaining(nickname, pageable);
        return ResponseEntity.ok(users);
    }

    @GetMapping("/top-rated")
    @Operation(summary = "평점 높은 사용자 조회", description = "평점이 높은 순서로 사용자를 조회합니다.")
    public ResponseEntity<Page<User>> getTopRatedUsers(@PageableDefault(size = 20) Pageable pageable) {
        Page<User> users = userService.findTopRatedUsers(pageable);
        return ResponseEntity.ok(users);
    }

    @PatchMapping("/profile")
    @Login
    @Operation(summary = "프로필 업데이트", description = "사용자의 프로필 정보를 업데이트합니다.")
    public ResponseEntity<User> updateProfile(
            @Parameter(description = "새 닉네임") @RequestParam(required = false) String nickname,
            @Parameter(description = "새 프로필 이미지 URL") @RequestParam(required = false) String profileImageUrl) {
        
        Long currentUserId = LoginContext.getCurrentUserId();
        if (currentUserId == null) {
            // 개발용: 첫 번째 사용자 사용
            currentUserId = 1L;
        }
        
        User user = userService.updateProfile(currentUserId, nickname, profileImageUrl);
        return ResponseEntity.ok(user);
    }

    @PostMapping("/login-dev")
    @Operation(summary = "개발용 로그인", description = "개발용 임시 로그인 기능입니다.")
    public ResponseEntity<String> devLogin(@Parameter(description = "사용자 ID") @RequestParam Long userId) {
        User user = userService.findById(userId);
        LoginContext.setCurrentUser(user);
        return ResponseEntity.ok("Logged in as: " + user.getNickname());
    }

    @PostMapping("/logout-dev")
    @Operation(summary = "개발용 로그아웃", description = "개발용 임시 로그아웃 기능입니다.")
    public ResponseEntity<String> devLogout() {
        LoginContext.clear();
        return ResponseEntity.ok("Logged out successfully");
    }

    @GetMapping("/check-phone")
    @Operation(summary = "전화번호 중복 확인", description = "전화번호 중복 여부를 확인합니다.")
    public ResponseEntity<Boolean> checkPhoneNumber(
            @Parameter(description = "확인할 전화번호") @RequestParam String phoneNumber) {
        
        boolean exists = userService.existsByPhoneNumber(phoneNumber);
        return ResponseEntity.ok(exists);
    }

    @GetMapping("/stats/total")
    @Operation(summary = "총 사용자 수 조회", description = "전체 사용자 수를 조회합니다.")
    public ResponseEntity<Long> getTotalUserCount() {
        long count = userService.getTotalUserCount();
        return ResponseEntity.ok(count);
    }
}