package daangn.builders.hankan.api.controller;

import daangn.builders.hankan.common.exception.InvalidPhoneNumberFormatException;
import daangn.builders.hankan.common.exception.InvalidPageableParameterException;
import daangn.builders.hankan.common.exception.InvalidSearchParameterException;
import daangn.builders.hankan.api.dto.UserResponse;
import daangn.builders.hankan.api.dto.UserStatsResponse;
import daangn.builders.hankan.common.auth.Login;
import daangn.builders.hankan.common.service.S3Service;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Size;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "User", description = "사용자 관리 API")
public class UserController {

    private final UserService userService;
    private final S3Service s3Service;


    @GetMapping("/me")
    @Operation(
        summary = "내 정보 조회", 
        description = "현재 로그인한 사용자의 정보를 JWT 토큰에서 추출하여 조회합니다.",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(
            responseCode = "200", 
            description = "조회 성공",
            content = @Content(schema = @Schema(implementation = UserResponse.class))
        ),
        @ApiResponse(
            responseCode = "401", 
            description = "인증 실패 - 토큰이 없거나 유효하지 않음",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        ),
        @ApiResponse(
            responseCode = "404", 
            description = "사용자를 찾을 수 없음 - 토큰에 해당하는 사용자가 DB에 없음",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        )
    })
    public ResponseEntity<UserResponse> getMyInfo(
            @Parameter(hidden = true) @Login Long userId) {
        log.info("Getting user info for userId from token: {}", userId);
        User user = userService.findById(userId);
        return ResponseEntity.ok(UserResponse.from(user));
    }

    @GetMapping("/{userId}")
    @Operation(summary = "사용자 정보 조회", description = "특정 사용자의 정보를 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공"),
        @ApiResponse(responseCode = "404", description = "사용자를 찾을 수 없음")
    })
    public ResponseEntity<UserResponse> getUserInfo(
            @Parameter(description = "사용자 ID", required = true)
            @PathVariable Long userId) {
        log.info("Getting user info for userId: {}", userId);
        User user = userService.findById(userId);
        return ResponseEntity.ok(UserResponse.from(user));
    }

    @GetMapping("/phone/{phoneNumber}")
    @Operation(summary = "전화번호로 사용자 조회", description = "전화번호로 사용자를 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공"),
        @ApiResponse(responseCode = "404", description = "사용자를 찾을 수 없음")
    })
    public ResponseEntity<UserResponse> getUserByPhone(
            @Parameter(description = "전화번호", required = true)
            @PathVariable String phoneNumber) {
        log.info("Getting user by phone number");
        User user = userService.findByPhoneNumberOrThrow(phoneNumber);
        return ResponseEntity.ok(UserResponse.from(user));
    }

    @GetMapping("/search")
    @Operation(
        summary = "닉네임으로 사용자 검색", 
        description = "닉네임을 포함하는 사용자를 검색합니다. 페이지네이션 지원."
    )
    @ApiResponses({
        @ApiResponse(
            responseCode = "200", 
            description = "검색 성공",
            content = @Content(schema = @Schema(implementation = Page.class))
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "잘못된 검색 파라미터 - 닉네임 누락, 페이지 번호 오류 등",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        )
    })
    public ResponseEntity<Page<UserResponse>> searchByNickname(
            @Parameter(description = "검색할 닉네임 (부분 일치)", required = true, example = "테스트")
            @RequestParam(required = true) String nickname,
            @Parameter(description = "페이지 정보", hidden = true)
            @PageableDefault(size = 20, sort = "nickname", direction = Sort.Direction.ASC) Pageable pageable) {
        
        if (nickname == null || nickname.trim().isEmpty()) {
            throw new InvalidSearchParameterException("검색어를 입력해주세요.");
        }
        
        if (pageable.getPageNumber() < 0) {
            throw new InvalidPageableParameterException("page", String.valueOf(pageable.getPageNumber()));
        }
        
        if (pageable.getPageSize() <= 0 || pageable.getPageSize() > 100) {
            throw new InvalidPageableParameterException("size", String.valueOf(pageable.getPageSize()));
        }
        
        log.info("Searching users with nickname containing: {}, page: {}, size: {}", 
                nickname, pageable.getPageNumber(), pageable.getPageSize());
        
        try {
            Page<User> users = userService.findByNicknameContaining(nickname, pageable);
            return ResponseEntity.ok(users.map(UserResponse::from));
        } catch (Exception e) {
            log.error("Error searching users by nickname: {}", nickname, e);
            throw new RuntimeException("사용자 검색 중 오류가 발생했습니다.");
        }
    }

    @GetMapping("/top-rated")
    @Operation(
        summary = "평점 상위 사용자 조회", 
        description = "평점이 높은 순서대로 사용자를 조회합니다. 평점이 같은 경우 가입일 순으로 정렬."
    )
    @ApiResponses({
        @ApiResponse(
            responseCode = "200", 
            description = "조회 성공",
            content = @Content(schema = @Schema(implementation = Page.class))
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "잘못된 페이지 파라미터",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        )
    })
    public ResponseEntity<Page<UserResponse>> getTopRatedUsers(
            @Parameter(description = "페이지 정보", hidden = true)
            @PageableDefault(size = 20) Pageable pageable) {
        
        if (pageable.getPageNumber() < 0) {
            throw new InvalidPageableParameterException("page", String.valueOf(pageable.getPageNumber()));
        }
        
        if (pageable.getPageSize() <= 0 || pageable.getPageSize() > 100) {
            throw new InvalidPageableParameterException("size", String.valueOf(pageable.getPageSize()));
        }
        
        log.info("Getting top rated users, page: {}, size: {}", 
                pageable.getPageNumber(), pageable.getPageSize());
        
        try {
            Page<User> users = userService.findTopRatedUsers(pageable);
            return ResponseEntity.ok(users.map(UserResponse::from));
        } catch (Exception e) {
            log.error("Error fetching top rated users", e);
            throw new RuntimeException("상위 평점 사용자 조회 중 오류가 발생했습니다.");
        }
    }

    @PatchMapping(value = "/me", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(
        summary = "내 프로필 수정", 
        description = "현재 로그인한 사용자의 프로필을 수정합니다. 프로필 이미지는 파일로 업로드합니다.",
        security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses({
        @ApiResponse(
            responseCode = "200", 
            description = "수정 성공",
            content = @Content(schema = @Schema(implementation = UserResponse.class))
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "잘못된 요청 - 닉네임 형식 오류, 파일 크기 초과(10MB) 등",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        ),
        @ApiResponse(
            responseCode = "401", 
            description = "인증 실패",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        ),
        @ApiResponse(
            responseCode = "404", 
            description = "사용자를 찾을 수 없음",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        )
    })
    public ResponseEntity<UserResponse> updateMyProfile(
            @Parameter(hidden = true) @Login Long userId,
            @Parameter(description = "변경할 닉네임 (2-50자)")
            @RequestParam(required = false) 
            @Size(min = 2, max = 50, message = "닉네임은 2-50자 사이여야 합니다")
            String nickname,
            @Parameter(description = "프로필 이미지 파일 (JPG, PNG, 최대 10MB)")
            @RequestParam(required = false) 
            MultipartFile profileImage) {
        log.info("Updating profile for userId: {}", userId);
        
        String profileImageUrl = null;
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                // 파일 크기 검증 (10MB)
                s3Service.validateFileSize(profileImage, 10);
                // S3에 업로드
                profileImageUrl = s3Service.uploadImage(profileImage, S3Service.ImageType.PROFILE);
                log.info("Profile image uploaded successfully: {}", profileImageUrl);
            } catch (Exception e) {
                log.error("Failed to upload profile image: {}", e.getMessage());
                throw new RuntimeException("프로필 이미지 업로드에 실패했습니다.", e);
            }
        }
        
        User updatedUser = userService.updateProfile(userId, nickname, profileImageUrl);
        return ResponseEntity.ok(UserResponse.from(updatedUser));
    }


    @GetMapping("/check-phone")
    @Operation(
        summary = "전화번호 중복 확인", 
        description = "전화번호가 이미 등록되어 있는지 확인합니다. " +
                    "\n- true: 이미 등록된 전화번호 (사용 불가)" +
                    "\n- false: 사용 가능한 전화번호"
    )
    @ApiResponses({
        @ApiResponse(
            responseCode = "200", 
            description = "확인 성공",
            content = @Content(schema = @Schema(implementation = CheckPhoneResponse.class))
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "잘못된 전화번호 형식",
            content = @Content(schema = @Schema(implementation = ErrorResponse.class))
        )
    })
    public ResponseEntity<CheckPhoneResponse> checkPhoneNumber(
            @Parameter(description = "확인할 전화번호 (하이픈 제외, 예: 01012345678)", required = true, example = "01012345678")
            @RequestParam String phoneNumber) {
        
        if (phoneNumber == null || !phoneNumber.matches("^\\d{10,11}$")) {
            throw new InvalidPhoneNumberFormatException(phoneNumber != null ? phoneNumber : "null");
        }
        
        log.info("Checking phone number availability");
        boolean exists = userService.existsByPhoneNumber(phoneNumber);
        return ResponseEntity.ok(new CheckPhoneResponse(exists, !exists));
    }

    @GetMapping("/stats")
    @Operation(summary = "사용자 통계 조회", description = "전체 사용자 수 등의 통계를 조회합니다")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    public ResponseEntity<UserStatsResponse> getUserStatistics() {
        log.debug("Fetching user statistics");
        long totalCount = userService.getTotalUserCount();
        return ResponseEntity.ok(new UserStatsResponse(totalCount));
    }

    
    // Response DTOs
    @Schema(description = "전화번호 중복 확인 결과")
    public record CheckPhoneResponse(
        @Schema(description = "전화번호 존재 여부 (true=이미 사용중, false=사용가능)", example = "false")
        boolean exists,
        @Schema(description = "전화번호 사용 가능 여부 (true=사용가능, false=이미 사용중)", example = "true")
        boolean available
    ) {}
    
    public record ErrorResponse(
        @io.swagger.v3.oas.annotations.media.Schema(description = "에러 메시지", example = "사용자를 찾을 수 없습니다")
        String message,
        @io.swagger.v3.oas.annotations.media.Schema(description = "타임스탬프", example = "2024-01-01T10:00:00")
        String timestamp
    ) {}
}