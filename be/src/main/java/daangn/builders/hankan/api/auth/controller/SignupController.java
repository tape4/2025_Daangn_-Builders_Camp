package daangn.builders.hankan.api.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import daangn.builders.hankan.api.auth.dto.SignupRequest;
import daangn.builders.hankan.api.auth.dto.TokenResponse;
import daangn.builders.hankan.domain.auth.AuthService;
import daangn.builders.hankan.domain.user.Gender;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth/signup")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Signup", description = "회원가입 API")
public class SignupController {

    private final AuthService authService;

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "회원가입", description = "회원가입을 진행합니다. 성공 시 자동으로 로그인되며 토큰을 발급합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "회원가입 성공"),
            @ApiResponse(responseCode = "400", description = "유효성 검증 실패"),
            @ApiResponse(responseCode = "409", description = "이미 등록된 전화번호")
    })
    public ResponseEntity<TokenResponse> signup(
            @Parameter(description = "전화번호", required = true)
            @RequestParam("phoneNumber") String phoneNumber,
            
            @Parameter(description = "닉네임", required = true)
            @RequestParam("nickname") String nickname,
            
            @Parameter(description = "생년월일", required = true)
            @RequestParam("birthDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate birthDate,
            
            @Parameter(description = "성별 (MALE, FEMALE, OTHER)", required = true)
            @RequestParam("gender") Gender gender,
            
            @Parameter(description = "프로필 이미지", required = false)
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage) {
        
        try {
            // 프로필 이미지 처리 (임시로 S3 업로드 대신 로컬 처리)
            String profileImageUrl = null;
            if (profileImage != null && !profileImage.isEmpty()) {
                // TODO: S3 업로드 구현
                // 임시로 파일명을 사용한 URL 생성
                String filename = UUID.randomUUID().toString() + "_" + profileImage.getOriginalFilename();
                profileImageUrl = "https://hankan-s3-bucket.s3.ap-northeast-2.amazonaws.com/profiles/" + filename;
                log.info("프로필 이미지 업로드 예정: {}", profileImageUrl);
            }
            
            // SignupRequest 객체 생성
            SignupRequest request = SignupRequest.builder()
                    .phoneNumber(phoneNumber)
                    .nickname(nickname)
                    .birthDate(birthDate)
                    .gender(gender)
                    .build();
            
            TokenResponse response = authService.signup(request, profileImageUrl);
            log.info("Signup successful for phone: {}", phoneNumber);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
            
        } catch (Exception e) {
            log.error("Signup failed for phone: {}", phoneNumber, e);
            throw e;
        }
    }

    @GetMapping("/check-phone")
    @Operation(summary = "전화번호 중복 체크", description = "회원가입 전 전화번호 중복 여부를 확인합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 전화번호 형식")
    })
    public ResponseEntity<Map<String, Boolean>> checkPhoneAvailability(
            @Parameter(description = "확인할 전화번호", example = "010-1234-5678")
            @RequestParam String phoneNumber) {
        
        try {
            boolean available = authService.isPhoneNumberAvailable(phoneNumber);
            Map<String, Boolean> response = new HashMap<>();
            response.put("available", available);
            
            if (available) {
                log.info("Phone number is available: {}", phoneNumber);
            } else {
                log.info("Phone number is already registered: {}", phoneNumber);
            }
            
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.warn("Invalid phone number format: {}", phoneNumber);
            throw e;
        }
    }
}