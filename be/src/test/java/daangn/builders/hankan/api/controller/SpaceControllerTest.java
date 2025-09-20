package daangn.builders.hankan.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.space.SpaceRegistrationRequest;
import daangn.builders.hankan.domain.space.SpaceService;
import daangn.builders.hankan.domain.space.SpaceRepository;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import daangn.builders.hankan.common.exception.SpaceNotFoundException;
import daangn.builders.hankan.common.exception.InvalidBoxCapacityException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
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

    private User createTestUser() {
        return User.builder()
                .phoneNumber("010-1234-5678")
                .nickname("테스트유저")
                .birthDate(LocalDate.of(1990, 1, 1))
                .build();
    }

    private Space createTestSpace() {
        User owner = createTestUser();
        return Space.builder()
                .name("테스트 공간")
                .description("테스트용 공간입니다")
                .latitude(37.5665)
                .longitude(126.9780)
                .address("서울특별시 중구")
                .imageUrl("https://example.com/image.jpg")
                .owner(owner)
                .availableStartDate(LocalDate.of(2025, 9, 20))
                .availableEndDate(LocalDate.of(2025, 12, 31))
                .boxCapacityXs(5)
                .boxCapacityS(10)
                .boxCapacityM(8)
                .boxCapacityL(3)
                .boxCapacityXl(1)
                .build();
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
                .ownerId(1L)
                .build();
    }

    @Test
    @DisplayName("공간 등록 - 성공")
    void registerSpace_Success() throws Exception {
        // Given
        SpaceRegistrationRequest request = createValidRequest();
        Space space = createTestSpace();
        
        when(spaceService.registerSpace(any(SpaceRegistrationRequest.class))).thenReturn(space);

        // When & Then
        mockMvc.perform(post("/api/spaces")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"));
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
                .ownerId(1L)
                .build();

        when(spaceService.registerSpace(any(SpaceRegistrationRequest.class)))
                .thenThrow(new InvalidBoxCapacityException("박스 용량은 음수가 될 수 없습니다. 0 이상의 값을 입력해주세요."));

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
                .ownerId(1L)
                .build();

        when(spaceService.registerSpace(any(SpaceRegistrationRequest.class)))
                .thenThrow(new InvalidBoxCapacityException("공간의 총 박스 용량은 0개일 수 없습니다. 최소 1개 이상의 박스를 설정해주세요."));

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
        Space space = createTestSpace();
        when(spaceService.findById(1L)).thenReturn(space);

        // When & Then
        mockMvc.perform(get("/api/spaces/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"));
    }

    @Test
    @DisplayName("공간 상세 조회 - 존재하지 않는 공간으로 실패")
    void getSpace_FailWithNotFound() throws Exception {
        // Given
        when(spaceService.findById(999L)).thenThrow(new SpaceNotFoundException(999L));

        // When & Then
        mockMvc.perform(get("/api/spaces/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("위치 기반 공간 검색 - 성공")
    void searchSpacesByLocation_Success() throws Exception {
        // Given
        Object[] spaceWithDistance = {createTestSpace(), 2.5};
        Page<Object[]> page = new PageImpl<Object[]>(Collections.singletonList(spaceWithDistance), PageRequest.of(0, 20), 1);
        
        when(spaceService.findSpacesNearLocation(eq(37.5665), eq(126.9780), eq(5.0), any()))
                .thenReturn(page);

        // When & Then
        mockMvc.perform(get("/api/spaces/search/location")
                .param("latitude", "37.5665")
                .param("longitude", "126.9780")
                .param("radiusKm", "5.0")
                .param("page", "0")
                .param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.totalElements").value(1));
    }

    @Test
    @DisplayName("위치 기반 공간 검색 - 잘못된 위도로 실패")
    void searchSpacesByLocation_FailWithInvalidLatitude() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/spaces/search/location")
                .param("latitude", "invalid")
                .param("longitude", "126.9780")
                .param("radiusKm", "5.0"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("날짜별 이용 가능한 공간 검색 - 성공")
    void searchSpacesByDate_Success() throws Exception {
        // Given
        List<Space> spaces = Collections.singletonList(createTestSpace());
        when(spaceService.findAvailableSpacesOnDate(LocalDate.of(2025, 9, 24)))
                .thenReturn(spaces);

        // When & Then
        mockMvc.perform(get("/api/spaces/search/date")
                .param("date", "2025-09-24"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].name").value("테스트 공간"));
    }

    @Test
    @DisplayName("날짜별 이용 가능한 공간 검색 - 잘못된 날짜 형식으로 실패")
    void searchSpacesByDate_FailWithInvalidDateFormat() throws Exception {
        // When & Then
        mockMvc.perform(get("/api/spaces/search/date")
                .param("date", "invalid-date"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("위치와 날짜 조건으로 공간 검색 - 성공")
    void searchSpacesByLocationAndDate_Success() throws Exception {
        // Given
        Object[] spaceWithDistance = {createTestSpace(), 2.5};
        Page<Object[]> page = new PageImpl<Object[]>(Collections.singletonList(spaceWithDistance), PageRequest.of(0, 20), 1);
        
        when(spaceService.findSpacesNearLocationOnDate(eq(37.5665), eq(126.9780), eq(5.0), 
                eq(LocalDate.of(2025, 9, 24)), any()))
                .thenReturn(page);

        // When & Then
        mockMvc.perform(get("/api/spaces/search/location-and-date")
                .param("latitude", "37.5665")
                .param("longitude", "126.9780")
                .param("radiusKm", "5.0")
                .param("date", "2025-09-24")
                .param("page", "0")
                .param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("평점 높은 공간 조회 - 성공")
    void getTopRatedSpaces_Success() throws Exception {
        // Given
        Page<Space> page = new PageImpl<>(Collections.singletonList(createTestSpace()), PageRequest.of(0, 20), 1);
        when(spaceService.findTopRatedSpaces(any())).thenReturn(page);

        // When & Then
        mockMvc.perform(get("/api/spaces/top-rated")
                .param("page", "0")
                .param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content[0].name").value("테스트 공간"));
    }

    @Test
    @DisplayName("내 공간 목록 조회 - 성공")
    void getMySpaces_Success() throws Exception {
        // Given
        Page<Space> page = new PageImpl<>(Collections.singletonList(createTestSpace()), PageRequest.of(0, 20), 1);
        when(spaceService.findByOwner(anyLong(), any())).thenReturn(page);

        // When & Then
        mockMvc.perform(get("/api/spaces/my")
                .param("page", "0")
                .param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("공간 이미지 업데이트 - 성공")
    void updateSpaceImage_Success() throws Exception {
        // Given
        Space space = createTestSpace();
        MockMultipartFile imageFile = new MockMultipartFile(
                "image", "test.jpg", "image/jpeg", "test image content".getBytes());
        
        when(spaceService.updateSpaceImage(eq(1L), anyString())).thenReturn(space);

        // When & Then
        mockMvc.perform(multipart("/api/spaces/1/image")
                .file(imageFile)
                .with(request -> {
                    request.setMethod("PATCH");
                    return request;
                }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"));
    }

    @Test
    @DisplayName("공간 이미지 업데이트 - 존재하지 않는 공간으로 실패")
    void updateSpaceImage_FailWithNotFound() throws Exception {
        // Given
        MockMultipartFile imageFile = new MockMultipartFile(
                "image", "test.jpg", "image/jpeg", "test image content".getBytes());
        
        when(spaceService.updateSpaceImage(eq(999L), anyString()))
                .thenThrow(new SpaceNotFoundException(999L));

        // When & Then
        mockMvc.perform(multipart("/api/spaces/999/image")
                .file(imageFile)
                .with(request -> {
                    request.setMethod("PATCH");
                    return request;
                }))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test
    @DisplayName("공간 이용 가능 기간 업데이트 - 성공")
    void updateAvailabilityPeriod_Success() throws Exception {
        // Given
        Space space = createTestSpace();
        when(spaceService.updateAvailabilityPeriod(eq(1L), any(LocalDate.class), any(LocalDate.class)))
                .thenReturn(space);

        // When & Then
        mockMvc.perform(patch("/api/spaces/1/availability")
                .param("startDate", "2025-09-24")
                .param("endDate", "2025-12-31"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"));
    }

    @Test
    @DisplayName("공간 박스 용량 업데이트 - 성공")
    void updateBoxCapacities_Success() throws Exception {
        // Given
        Space space = createTestSpace();
        when(spaceService.updateBoxCapacities(eq(1L), eq(5), eq(10), eq(8), eq(3), eq(1)))
                .thenReturn(space);

        // When & Then
        mockMvc.perform(patch("/api/spaces/1/capacity")
                .param("xs", "5")
                .param("s", "10")
                .param("m", "8")
                .param("l", "3")
                .param("xl", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("테스트 공간"));
    }

    @Test
    @DisplayName("공간 박스 용량 업데이트 - 음수 값으로 실패")
    void updateBoxCapacities_FailWithNegativeValues() throws Exception {
        // Given
        when(spaceService.updateBoxCapacities(eq(1L), eq(-1), eq(10), eq(8), eq(3), eq(1)))
                .thenThrow(new InvalidBoxCapacityException("박스 용량은 음수가 될 수 없습니다. 0 이상의 값을 입력해주세요."));

        // When & Then
        mockMvc.perform(patch("/api/spaces/1/capacity")
                .param("xs", "-1")
                .param("s", "10")
                .param("m", "8")
                .param("l", "3")
                .param("xl", "1"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("Bad Request"));
    }

    @Test
    @DisplayName("특정 날짜 공간 이용 가능 여부 확인 - 성공")
    void checkAvailability_Success() throws Exception {
        // Given
        when(spaceService.isSpaceAvailableOnDate(1L, LocalDate.of(2025, 9, 24))).thenReturn(true);

        // When & Then
        mockMvc.perform(get("/api/spaces/1/availability/2025-09-24"))
                .andExpect(status().isOk())
                .andExpect(content().string("true"));
    }

    @Test
    @DisplayName("특정 날짜 공간 이용 가능 여부 확인 - 존재하지 않는 공간으로 실패")
    void checkAvailability_FailWithNotFound() throws Exception {
        // Given
        when(spaceService.isSpaceAvailableOnDate(999L, LocalDate.of(2025, 9, 24)))
                .thenThrow(new SpaceNotFoundException(999L));

        // When & Then
        mockMvc.perform(get("/api/spaces/999/availability/2025-09-24"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test
    @DisplayName("공간 박스 용량 상세 조회 - 성공")
    void getBoxCapacityDetails_Success() throws Exception {
        // Given
        User savedUser = userRepository.save(createTestUser());
        Space testSpace = createTestSpace();
        // Update the space with the saved user
        Space spaceWithSavedUser = Space.builder()
                .name(testSpace.getName())
                .description(testSpace.getDescription())
                .latitude(testSpace.getLatitude())
                .longitude(testSpace.getLongitude())
                .address(testSpace.getAddress())
                .imageUrl(testSpace.getImageUrl())
                .owner(savedUser)
                .availableStartDate(testSpace.getAvailableStartDate())
                .availableEndDate(testSpace.getAvailableEndDate())
                .boxCapacityXs(testSpace.getBoxCapacityXs())
                .boxCapacityS(testSpace.getBoxCapacityS())
                .boxCapacityM(testSpace.getBoxCapacityM())
                .boxCapacityL(testSpace.getBoxCapacityL())
                .boxCapacityXl(testSpace.getBoxCapacityXl())
                .build();
        Space savedSpace = spaceRepository.save(spaceWithSavedUser);

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
        // Given
        when(spaceService.findById(999L)).thenThrow(new SpaceNotFoundException(999L));

        // When & Then
        mockMvc.perform(get("/api/spaces/999/capacity"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999"));
    }
}