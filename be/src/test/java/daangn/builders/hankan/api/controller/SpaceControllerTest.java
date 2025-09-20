package daangn.builders.hankan.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRegistrationRequest;
import daangn.builders.hankan.domain.space.SpaceService;
import daangn.builders.hankan.domain.space.SpaceRepository;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class SpaceControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private SpaceService spaceService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SpaceRepository spaceRepository;

    private User testUser;

    @BeforeEach
    void setUp() {
        // 각 테스트마다 고유한 전화번호로 사용자 생성
        String uniquePhone = "010-" + (System.currentTimeMillis() % 100000000L);
        testUser = User.builder()
                .phoneNumber(uniquePhone)
                .nickname("테스트유저")
                .birthDate(LocalDate.of(1990, 1, 1))
                .build();
        testUser = userRepository.save(testUser);
    }

    private SpaceRegistrationRequest createValidRequest() {
        return SpaceRegistrationRequest.builder()
                .name("테스트 공간")
                .description("테스트용 공간입니다")
                .latitude(37.5665)
                .longitude(126.9780)
                .address("서울특별시 중구")
                .imageUrl("https://example.com/image.jpg")
                .availableStartDate(LocalDate.of(2025, 9, 20))
                .availableEndDate(LocalDate.of(2025, 12, 31))
                .boxCapacityXs(5)
                .boxCapacityS(10)
                .boxCapacityM(8)
                .boxCapacityL(3)
                .boxCapacityXl(1)
                .ownerId(testUser.getId())
                .build();
    }

    @Test
    @DisplayName("공간 등록 - 성공")
    void registerSpace_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();

        // When & Then
        mockMvc.perform(post("/api/spaces")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"))
                .andExpect(jsonPath("$.description").value("테스트용 공간입니다"))
                .andExpect(jsonPath("$.address").value("서울특별시 중구"));
    }

    @Test
    @DisplayName("공간 등록 - 음수 박스 용량으로 실패")
    void registerSpace_FailWithNegativeCapacity() throws Exception {
        // Given
        SpaceRegistrationRequest request = SpaceRegistrationRequest.builder()
                .name("테스트 공간")
                .description("테스트용 공간입니다")
                .latitude(37.5665)
                .longitude(126.9780)
                .address("서울특별시 중구")
                .boxCapacityXs(-1)  // 음수 값
                .boxCapacityS(10)
                .boxCapacityM(8)
                .boxCapacityL(3)
                .boxCapacityXl(1)
                .availableStartDate(LocalDate.of(2025, 9, 20))
                .availableEndDate(LocalDate.of(2025, 12, 31))
                .ownerId(testUser.getId())
                .build();

        // When & Then
        mockMvc.perform(post("/api/spaces")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Bad Request"))
                .andExpect(jsonPath("$.message").value("박스 용량은 음수가 될 수 없습니다. 0 이상의 값을 입력해주세요."));
    }

    @Test
    @DisplayName("공간 등록 - 총 박스 용량 0으로 실패")
    void registerSpace_FailWithZeroTotalCapacity() throws Exception {
        // Given
        SpaceRegistrationRequest request = SpaceRegistrationRequest.builder()
                .name("테스트 공간")
                .description("테스트용 공간입니다")
                .latitude(37.5665)
                .longitude(126.9780)
                .address("서울특별시 중구")
                .boxCapacityXs(0)
                .boxCapacityS(0)
                .boxCapacityM(0)
                .boxCapacityL(0)
                .boxCapacityXl(0)
                .availableStartDate(LocalDate.of(2025, 9, 20))
                .availableEndDate(LocalDate.of(2025, 12, 31))
                .ownerId(testUser.getId())
                .build();

        // When & Then
        mockMvc.perform(post("/api/spaces")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Bad Request"))
                .andExpect(jsonPath("$.message").value("공간의 총 박스 용량은 0개일 수 없습니다. 최소 1개 이상의 박스를 설정해주세요."));
    }

    @Test
    @DisplayName("공간 상세 조회 - 성공")
    void getSpace_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/" + savedSpace.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"))
                .andExpect(jsonPath("$.description").value("테스트용 공간입니다"));
    }

    @Test
    @DisplayName("공간 상세 조회 - 존재하지 않는 공간으로 실패")
    void getSpace_FailWithNotFound() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/spaces/999999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999999"));
    }

    @Test
    @DisplayName("위치 기반 공간 검색 - 성공")
    void searchSpacesByLocation_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/search/location")
                .param("latitude", "37.5665")
                .param("longitude", "126.9780")
                .param("radiusKm", "10.0"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("날짜별 이용 가능한 공간 검색 - 성공")
    void searchSpacesByDate_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/search/date")
                .param("date", "2025-10-15"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    @Test
    @DisplayName("위치와 날짜 조건으로 공간 검색 - 성공")
    void searchSpacesByLocationAndDate_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/search/location-and-date")
                .param("latitude", "37.5665")
                .param("longitude", "126.9780")
                .param("radiusKm", "10.0")
                .param("date", "2025-10-15"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("평점 높은 공간 조회 - 성공")
    void getTopRatedSpaces_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/top-rated"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("내 공간 목록 조회 - 성공")
    void getMySpaces_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/my"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("공간 이미지 업데이트 - 성공")
    void updateSpaceImage_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);
        
        MockMultipartFile file = new MockMultipartFile(
                "image", 
                "test.jpg", 
                MediaType.IMAGE_JPEG_VALUE, 
                "test image content".getBytes()
        );

        // When & Then
        mockMvc.perform(multipart("/api/spaces/" + savedSpace.getId() + "/image")
                .file(file)
                .with(request1 -> {
                    request1.setMethod("PATCH");
                    return request1;
                }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.imageUrl").value("https://temp-s3-bucket/test.jpg"));
    }

    @Test
    @DisplayName("공간 이미지 업데이트 - 존재하지 않는 공간으로 실패")
    void updateSpaceImage_FailWithNotFound() throws Exception {
        // Given
        MockMultipartFile file = new MockMultipartFile(
                "image", 
                "test.jpg", 
                MediaType.IMAGE_JPEG_VALUE, 
                "test image content".getBytes()
        );

        // When & Then
        mockMvc.perform(multipart("/api/spaces/999999/image")
                .file(file)
                .with(request -> {
                    request.setMethod("PATCH");
                    return request;
                }))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999999"));
    }

    @Test
    @DisplayName("공간 이용 가능 기간 업데이트 - 성공")
    void updateAvailabilityPeriod_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(patch("/api/spaces/" + savedSpace.getId() + "/availability")
                .param("startDate", "2025-10-01")
                .param("endDate", "2025-11-30"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.availableStartDate").isArray())
                .andExpect(jsonPath("$.availableStartDate[0]").value(2025))
                .andExpect(jsonPath("$.availableStartDate[1]").value(10))
                .andExpect(jsonPath("$.availableStartDate[2]").value(1))
                .andExpect(jsonPath("$.availableEndDate").isArray())
                .andExpect(jsonPath("$.availableEndDate[0]").value(2025))
                .andExpect(jsonPath("$.availableEndDate[1]").value(11))
                .andExpect(jsonPath("$.availableEndDate[2]").value(30));
    }

    @Test
    @DisplayName("공간 박스 용량 업데이트 - 성공")
    void updateBoxCapacities_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(patch("/api/spaces/" + savedSpace.getId() + "/capacity")
                .param("xs", "10")
                .param("s", "15")
                .param("m", "12")
                .param("l", "5")
                .param("xl", "2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.boxCapacityXs").value(10))
                .andExpect(jsonPath("$.boxCapacityS").value(15));
    }

    @Test
    @DisplayName("공간 박스 용량 업데이트 - 음수 값으로 실패")
    void updateBoxCapacities_FailWithNegativeValue() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(patch("/api/spaces/" + savedSpace.getId() + "/capacity")
                .param("xs", "-1")
                .param("s", "15"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Bad Request"))
                .andExpect(jsonPath("$.message").value("박스 용량은 음수가 될 수 없습니다. 0 이상의 값을 입력해주세요."));
    }

    @Test
    @DisplayName("특정 날짜 공간 이용 가능 여부 확인 - 성공")
    void checkAvailability_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/" + savedSpace.getId() + "/availability/2025-10-15"))
                .andExpect(status().isOk())
                .andExpect(content().string("true"));
    }

    @Test
    @DisplayName("특정 날짜 공간 이용 가능 여부 확인 - 존재하지 않는 공간으로 실패")
    void checkAvailability_FailWithNotFound() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/spaces/999999/availability/2025-10-15"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999999"));
    }

    @Test
    @DisplayName("공간 박스 용량 상세 조회 - 성공")
    void getBoxCapacityDetails_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space savedSpace = spaceService.registerSpace(request);

        // When & Then
        mockMvc.perform(get("/api/spaces/" + savedSpace.getId() + "/capacity"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.xsCount").value(5))
                .andExpect(jsonPath("$.sCount").value(10))
                .andExpect(jsonPath("$.mCount").value(8))
                .andExpect(jsonPath("$.lCount").value(3))
                .andExpect(jsonPath("$.xlCount").value(1))
                .andExpect(jsonPath("$.totalCount").value(27));
    }

    @Test
    @DisplayName("공간 박스 용량 상세 조회 - 존재하지 않는 공간으로 실패")
    void getBoxCapacityDetails_FailWithNotFound() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/spaces/999999/capacity"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999999"));
    }

    @Test
    @DisplayName("위치 기반 공간 검색 - 잘못된 파라미터로도 정상 응답 (현재 구현)")
    void searchSpacesByLocation_HandleInvalidParams() throws Exception {
        // When & Then - 위도가 범위를 벗어나도 빈 결과 반환 (현재 구현 방식)
        mockMvc.perform(get("/api/spaces/search/location")
                .param("latitude", "999")  // 잘못된 위도
                .param("longitude", "126.9780")
                .param("radiusKm", "10.0"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content").isEmpty());
    }

    @Test
    @DisplayName("날짜별 이용 가능한 공간 검색 - 잘못된 날짜 형식으로 실패")
    void searchSpacesByDate_FailWithInvalidDateFormat() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/spaces/search/date")
                .param("date", "invalid-date"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Bad Request"));
    }
}