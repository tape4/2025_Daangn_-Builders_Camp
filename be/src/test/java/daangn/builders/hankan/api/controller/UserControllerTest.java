package daangn.builders.hankan.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import daangn.builders.hankan.api.dto.UserProfileUpdateRequest;
import daangn.builders.hankan.common.auth.LoginArgumentResolver;
import daangn.builders.hankan.common.exception.DuplicatePhoneNumberException;
import daangn.builders.hankan.common.exception.UserNotFoundException;
import daangn.builders.hankan.domain.user.Gender;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.containsString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@ActiveProfiles("test")
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private UserService userService;
    
    @MockitoBean
    private LoginArgumentResolver loginArgumentResolver;

    private User sampleUser;
    private User sampleUser2;
    
    @BeforeEach
    void setUp() throws Exception {
        // Sample user 1
        sampleUser = User.builder()
                .phoneNumber("010-1234-5678")
                .nickname("한칸이")
                .birthDate(LocalDate.of(1990, 1, 1))
                .gender(Gender.MALE)
                .profileImageUrl("https://example.com/profile1.jpg")
                .build();
        setUserId(sampleUser, 1L);
        sampleUser.updateRating(4.5, 10);
        
        // Sample user 2
        sampleUser2 = User.builder()
                .phoneNumber("010-9876-5432")
                .nickname("두칸이")
                .birthDate(LocalDate.of(1995, 5, 15))
                .gender(Gender.FEMALE)
                .profileImageUrl("https://example.com/profile2.jpg")
                .build();
        setUserId(sampleUser2, 2L);
        sampleUser2.updateRating(4.8, 20);
        
        // LoginArgumentResolver Mock 설정
        when(loginArgumentResolver.supportsParameter(org.mockito.ArgumentMatchers.any()))
                .thenReturn(true);
        when(loginArgumentResolver.resolveArgument(
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any(),
                org.mockito.ArgumentMatchers.any()
        )).thenReturn(1L);
    }
    
    private void setUserId(User user, Long id) {
        try {
            java.lang.reflect.Field idField = User.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(user, id);
        } catch (Exception e) {
            throw new RuntimeException("Failed to set user ID", e);
        }
    }

    @Test
    @DisplayName("GET /api/users/me - 내 정보 조회 성공")
    void getMyInfo_Success() throws Exception {
        when(userService.findById(1L)).thenReturn(sampleUser);

        mockMvc.perform(get("/api/users/me"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.phoneNumber").value("010-1234-5678"))
                .andExpect(jsonPath("$.nickname").value("한칸이"))
                .andExpect(jsonPath("$.gender").value("MALE"))
                .andExpect(jsonPath("$.rating").value(4.5))
                .andExpect(jsonPath("$.reviewCount").value(10));
    }

    @Test
    @DisplayName("GET /api/users/{userId} - 특정 사용자 정보 조회 성공")
    void getUserInfo_Success() throws Exception {
        when(userService.findById(2L)).thenReturn(sampleUser2);

        mockMvc.perform(get("/api/users/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(2))
                .andExpect(jsonPath("$.phoneNumber").value("010-9876-5432"))
                .andExpect(jsonPath("$.nickname").value("두칸이"))
                .andExpect(jsonPath("$.gender").value("FEMALE"))
                .andExpect(jsonPath("$.rating").value(4.8))
                .andExpect(jsonPath("$.reviewCount").value(20));
    }

    @Test
    @DisplayName("GET /api/users/{userId} - 존재하지 않는 사용자 (404)")
    void getUserInfo_NotFound() throws Exception {
        when(userService.findById(999L))
                .thenThrow(new UserNotFoundException(999L));

        mockMvc.perform(get("/api/users/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").exists());
    }

    @Test
    @DisplayName("GET /api/users/phone/{phoneNumber} - 전화번호로 사용자 조회 성공")
    void getUserByPhone_Success() throws Exception {
        when(userService.findByPhoneNumberOrThrow("010-1234-5678"))
                .thenReturn(sampleUser);

        mockMvc.perform(get("/api/users/phone/010-1234-5678"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.phoneNumber").value("010-1234-5678"))
                .andExpect(jsonPath("$.nickname").value("한칸이"));
    }

    @Test
    @DisplayName("GET /api/users/phone/{phoneNumber} - 존재하지 않는 전화번호 (404)")
    void getUserByPhone_NotFound() throws Exception {
        when(userService.findByPhoneNumberOrThrow("010-0000-0000"))
                .thenThrow(new UserNotFoundException("User not found with phone number: 010****0000"));

        mockMvc.perform(get("/api/users/phone/010-0000-0000"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test
    @Disabled("Multipart 테스트 환경 문제")
    @DisplayName("PATCH /api/users/me - 닉네임과 프로필 이미지 모두 수정 성공")
    void updateMyProfile_Success() throws Exception {
        User updatedUser = User.builder()
                .phoneNumber("01012345678")
                .nickname("새닉네임")
                .birthDate(LocalDate.of(1990, 1, 1))
                .gender(Gender.MALE)
                .profileImageUrl("https://example.com/new-profile.jpg")
                .build();
        setUserId(updatedUser, 1L);

        when(userService.updateProfile(eq(1L), eq("새닉네임"), isNull()))
                .thenReturn(updatedUser);

        org.springframework.mock.web.MockMultipartFile profileImage = new org.springframework.mock.web.MockMultipartFile(
                "profileImage", "profile.jpg", MediaType.IMAGE_JPEG_VALUE, "test image".getBytes());

        mockMvc.perform(multipart("/api/users/me")
                        .file(profileImage)
                        .param("nickname", "새닉네임")
                        .contentType(MediaType.MULTIPART_FORM_DATA)
                        .with(request -> {
                            request.setMethod("PATCH");
                            return request;
                        }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nickname").value("새닉네임"))
                .andExpect(jsonPath("$.profileImageUrl").value("https://example.com/new-profile.jpg"));
    }
    
    @Test
    @Disabled("Multipart 테스트 환경 문제")
    @DisplayName("PATCH /api/users/me - 닉네임만 수정")
    void updateMyProfile_OnlyNickname() throws Exception {
        User updatedUser = User.builder()
                .phoneNumber("01012345678")
                .nickname("닉네임만변경")
                .birthDate(LocalDate.of(1990, 1, 1))
                .gender(Gender.MALE)
                .build();
        setUserId(updatedUser, 1L);

        when(userService.updateProfile(eq(1L), eq("닉네임만변경"), isNull()))
                .thenReturn(updatedUser);

        // 빈 파일 생성
        org.springframework.mock.web.MockMultipartFile emptyFile = new org.springframework.mock.web.MockMultipartFile(
                "profileImage", "", MediaType.MULTIPART_FORM_DATA_VALUE, new byte[0]);

        mockMvc.perform(multipart("/api/users/me")
                        .file(emptyFile)
                        .param("nickname", "닉네임만변경")
                        .contentType(MediaType.MULTIPART_FORM_DATA)
                        .with(request -> {
                            request.setMethod("PATCH");
                            return request;
                        }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nickname").value("닉네임만변경"));
    }
    
    @Test
    @Disabled("Multipart 테스트 환경 문제")
    @DisplayName("PATCH /api/users/me - 프로필 이미지만 수정")
    void updateMyProfile_OnlyProfileImage() throws Exception {
        User updatedUser = User.builder()
                .phoneNumber("01012345678")
                .nickname("한칸이")  // 기존 닉네임 유지
                .birthDate(LocalDate.of(1990, 1, 1))
                .gender(Gender.MALE)
                .profileImageUrl("https://s3.amazonaws.com/bucket/new-image.jpg")
                .build();
        setUserId(updatedUser, 1L);

        when(userService.updateProfile(eq(1L), isNull(), isNull()))
                .thenReturn(updatedUser);

        org.springframework.mock.web.MockMultipartFile profileImage = new org.springframework.mock.web.MockMultipartFile(
                "profileImage", "new-profile.jpg", MediaType.IMAGE_JPEG_VALUE, "image data".getBytes());

        mockMvc.perform(multipart("/api/users/me")
                        .file(profileImage)
                        .contentType(MediaType.MULTIPART_FORM_DATA)
                        .with(request -> {
                            request.setMethod("PATCH");
                            return request;
                        }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nickname").value("한칸이"))
                .andExpect(jsonPath("$.profileImageUrl").value("https://s3.amazonaws.com/bucket/new-image.jpg"));
    }

    @Test
    @Disabled("Validation 테스트 환경 문제")
    @DisplayName("PATCH /api/users/me - 짧은 닉네임 검증 (2자 미만)")
    void updateMyProfile_InvalidNickname() throws Exception {
        // 빈 파일
        org.springframework.mock.web.MockMultipartFile emptyFile = new org.springframework.mock.web.MockMultipartFile(
                "profileImage", "", MediaType.MULTIPART_FORM_DATA_VALUE, new byte[0]);

        mockMvc.perform(multipart("/api/users/me")
                        .file(emptyFile)
                        .param("nickname", "a")  // 1자 - 너무 짧음
                        .contentType(MediaType.MULTIPART_FORM_DATA)
                        .with(request -> {
                            request.setMethod("PATCH");
                            return request;
                        }))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/users/search - 닉네임으로 검색 성공")
    void searchByNickname_Success() throws Exception {
        List<User> users = Arrays.asList(sampleUser, sampleUser2);
        Page<User> page = new PageImpl<>(users, PageRequest.of(0, 20), 2);

        when(userService.findByNicknameContaining(eq("칸"), any(Pageable.class)))
                .thenReturn(page);

        mockMvc.perform(get("/api/users/search")
                        .param("nickname", "칸")
                        .param("page", "0")
                        .param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].nickname").value("한칸이"))
                .andExpect(jsonPath("$.content[1].nickname").value("두칸이"))
                .andExpect(jsonPath("$.totalElements").value(2));
    }

    @Test
    @DisplayName("GET /api/users/search - 닉네임 파라미터 누락 (400)")
    void searchByNickname_MissingParameter() throws Exception {
        mockMvc.perform(get("/api/users/search"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/users/top-rated - 평점 상위 사용자 조회 성공")
    void getTopRatedUsers_Success() throws Exception {
        List<User> users = Arrays.asList(sampleUser2, sampleUser); // 평점순
        Page<User> page = new PageImpl<>(users, PageRequest.of(0, 20), 2);

        when(userService.findTopRatedUsers(any(Pageable.class)))
                .thenReturn(page);

        mockMvc.perform(get("/api/users/top-rated")
                        .param("page", "0")
                        .param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].rating").value(4.8))
                .andExpect(jsonPath("$.content[1].rating").value(4.5))
                .andExpect(jsonPath("$.totalElements").value(2));
    }

    @Test
    @DisplayName("GET /api/users/check-phone - 전화번호 중복 확인 (중복됨)")
    void checkPhoneNumber_Exists() throws Exception {
        when(userService.existsByPhoneNumber("01012345678"))
                .thenReturn(true);

        mockMvc.perform(get("/api/users/check-phone")
                        .param("phoneNumber", "01012345678"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.exists").value(true))
                .andExpect(jsonPath("$.available").value(false));
    }

    @Test
    @DisplayName("GET /api/users/check-phone - 전화번호 중복 확인 (사용 가능)")
    void checkPhoneNumber_NotExists() throws Exception {
        when(userService.existsByPhoneNumber("01000000000"))
                .thenReturn(false);

        mockMvc.perform(get("/api/users/check-phone")
                        .param("phoneNumber", "01000000000"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.exists").value(false))
                .andExpect(jsonPath("$.available").value(true));
    }

    @Test
    @DisplayName("GET /api/users/check-phone - 전화번호 파라미터 누락 (400)")
    void checkPhoneNumber_MissingParameter() throws Exception {
        mockMvc.perform(get("/api/users/check-phone"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/users/stats - 사용자 통계 조회 성공")
    void getUserStats_Success() throws Exception {
        when(userService.getTotalUserCount()).thenReturn(1000L);

        mockMvc.perform(get("/api/users/stats"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.totalUserCount").value(1000));
    }

    @Test
    @DisplayName("GET /api/users/search - 페이징 파라미터 테스트")
    void searchByNickname_WithPaging() throws Exception {
        List<User> users = Arrays.asList(sampleUser);
        Page<User> page = new PageImpl<>(users, PageRequest.of(1, 10), 25);

        when(userService.findByNicknameContaining(eq("한칸"), any(Pageable.class)))
                .thenReturn(page);

        mockMvc.perform(get("/api/users/search")
                        .param("nickname", "한칸")
                        .param("page", "1")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.pageable.pageNumber").value(1))
                .andExpect(jsonPath("$.pageable.pageSize").value(10))
                .andExpect(jsonPath("$.totalElements").value(25))
                .andExpect(jsonPath("$.totalPages").value(3));
    }

    @Test
    @Disabled("Multipart 테스트 환경 문제")
    @DisplayName("PATCH /api/users/me - 빈 요청 (모든 필드 null/empty)")
    void updateMyProfile_EmptyRequest() throws Exception {
        // 기존 사용자 정보 그대로 반환
        when(userService.updateProfile(eq(1L), isNull(), isNull()))
                .thenReturn(sampleUser);

        org.springframework.mock.web.MockMultipartFile emptyFile = new org.springframework.mock.web.MockMultipartFile(
                "profileImage", "", MediaType.MULTIPART_FORM_DATA_VALUE, new byte[0]);

        mockMvc.perform(multipart("/api/users/me")
                        .file(emptyFile)
                        .contentType(MediaType.MULTIPART_FORM_DATA)
                        .with(request -> {
                            request.setMethod("PATCH");
                            return request;
                        }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nickname").value("한칸이")); // 변경 없음
    }

    @Test
    @Disabled("Validation 테스트는 실제 환경에서만 동작")
    @DisplayName("PATCH /api/users/me - 잘못된 프로필 이미지 URL (400)")
    void updateMyProfile_InvalidUrl() throws Exception {
        UserProfileUpdateRequest request = UserProfileUpdateRequest.builder()
                .profileImageUrl("not-a-valid-url")
                .build();

        mockMvc.perform(patch("/api/users/me")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/users/top-rated - 빈 결과")
    void getTopRatedUsers_EmptyResult() throws Exception {
        Page<User> emptyPage = new PageImpl<>(Arrays.asList(), PageRequest.of(0, 20), 0);

        when(userService.findTopRatedUsers(any(Pageable.class)))
                .thenReturn(emptyPage);

        mockMvc.perform(get("/api/users/top-rated"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content").isEmpty())
                .andExpect(jsonPath("$.totalElements").value(0));
    }

    @Test
    @DisplayName("GET /api/users/{userId} - 잘못된 타입의 ID (400)")
    void getUserInfo_InvalidIdType() throws Exception {
        mockMvc.perform(get("/api/users/not-a-number"))
                .andExpect(status().isBadRequest());
    }
}