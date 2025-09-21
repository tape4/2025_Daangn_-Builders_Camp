package daangn.builders.hankan.api.auth.controller;

import daangn.builders.hankan.api.auth.dto.LoginRequest;
import daangn.builders.hankan.api.auth.dto.TokenResponse;
import daangn.builders.hankan.domain.auth.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth/login")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Login", description = "로그인 API")
public class LoginController {

    private final AuthService authService;

    @PostMapping
    @Operation(summary = "로그인", description = "전화번호와 SMS 인증번호로 로그인합니다. 성공 시 Access Token과 Refresh Token을 발급합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "로그인 성공"),
            @ApiResponse(responseCode = "400", description = "인증 실패 또는 잘못된 요청"),
            @ApiResponse(responseCode = "404", description = "등록되지 않은 사용자")
    })
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
        try {
            TokenResponse response = authService.login(request);
            log.info("Login successful for phone: {}", request.getPhoneNumber());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Login failed for phone: {}", request.getPhoneNumber(), e);
            throw e;
        }
    }
}