package daangn.builders.hankan.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import daangn.builders.hankan.api.dto.ItemRegistrationRequest;
import daangn.builders.hankan.api.dto.ItemResponse;
import daangn.builders.hankan.common.auth.LoginArgumentResolver;
import daangn.builders.hankan.common.service.S3Service;
import daangn.builders.hankan.domain.item.Item;
import daangn.builders.hankan.domain.item.ItemRepository;
import daangn.builders.hankan.domain.item.ItemService;
import daangn.builders.hankan.domain.user.Gender;
import daangn.builders.hankan.domain.user.User;
import daangn.builders.hankan.domain.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class ItemControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private ItemService itemService;

    @MockitoBean
    private LoginArgumentResolver loginArgumentResolver;

    @MockitoBean
    private S3Service s3Service;

    private User testUser;
    private Item testItem;

    @BeforeEach
    void setUp() throws Exception {
        // 테스트 사용자 생성
        testUser = User.builder()
                .phoneNumber("01012345678")
                .nickname("테스트유저")
                .birthDate(LocalDate.of(1990, 1, 1))
                .gender(Gender.MALE)
                .build();
        testUser = userRepository.save(testUser);

        // 테스트 아이템 생성
        testItem = Item.builder()
                .title("겨울 옷 보관")
                .description("겨울 패딩과 코트를 보관하고자 합니다")
                .width(50.0)
                .height(40.0)
                .depth(30.0)
                .startDate(LocalDate.now().plusDays(1))
                .endDate(LocalDate.now().plusMonths(3))
                .minPrice(new BigDecimal("30000"))
                .maxPrice(new BigDecimal("50000"))
                .owner(testUser)
                .status(Item.ItemStatus.ACTIVE)
                .build();
        testItem = itemRepository.save(testItem);

        // LoginArgumentResolver Mock 설정
        when(loginArgumentResolver.supportsParameter(any()))
                .thenReturn(true);
        when(loginArgumentResolver.resolveArgument(any(), any(), any(), any()))
                .thenReturn(testUser.getId());

        // S3Service Mock 설정
        doNothing().when(s3Service).validateFileSize(any(), anyLong());
        when(s3Service.uploadImage(any(), any())).thenReturn("https://s3-bucket/items/test-image.jpg");
    }

    @Test
    @DisplayName("물품 등록 - 성공")
    void registerItem_Success() throws Exception {
        MockMultipartFile imageFile = new MockMultipartFile(
                "image",
                "test.jpg",
                MediaType.IMAGE_JPEG_VALUE,
                "test image content".getBytes()
        );

        mockMvc.perform(multipart("/api/items")
                .file(imageFile)
                .param("title", "여름 옷 보관")
                .param("description", "여름 옷들을 보관하고자 합니다")
                .param("width", "40.0")
                .param("height", "30.0")
                .param("depth", "20.0")
                .param("startDate", LocalDate.now().plusDays(1).toString())
                .param("endDate", LocalDate.now().plusMonths(2).toString())
                .param("minPrice", "20000")
                .param("maxPrice", "40000")
                .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value("여름 옷 보관"))
                .andExpect(jsonPath("$.imageUrl").value("https://s3-bucket/items/test-image.jpg"))
                .andExpect(jsonPath("$.volume").value(24000.0))
                .andExpect(jsonPath("$.sizeCategory").value("M"));
    }

    @Test
    @DisplayName("물품 등록 - 이미지 없이 성공")
    void registerItem_WithoutImage_Success() throws Exception {
        mockMvc.perform(multipart("/api/items")
                .param("title", "책 보관")
                .param("description", "책들을 보관하고자 합니다")
                .param("width", "30.0")
                .param("height", "20.0")
                .param("depth", "15.0")
                .param("startDate", LocalDate.now().plusDays(1).toString())
                .param("endDate", LocalDate.now().plusMonths(1).toString())
                .param("minPrice", "10000")
                .param("maxPrice", "20000")
                .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.title").value("책 보관"))
                .andExpect(jsonPath("$.imageUrl").doesNotExist());
    }

    @Test
    @DisplayName("물품 등록 - 잘못된 날짜 범위")
    void registerItem_InvalidDateRange() throws Exception {
        mockMvc.perform(multipart("/api/items")
                .param("title", "테스트 물품")
                .param("width", "30.0")
                .param("height", "20.0")
                .param("depth", "15.0")
                .param("startDate", LocalDate.now().plusDays(5).toString())
                .param("endDate", LocalDate.now().plusDays(1).toString()) // 종료일이 시작일보다 이전
                .param("minPrice", "10000")
                .param("maxPrice", "20000")
                .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("물품 등록 - 잘못된 가격 범위")
    void registerItem_InvalidPriceRange() throws Exception {
        mockMvc.perform(multipart("/api/items")
                .param("title", "테스트 물품")
                .param("width", "30.0")
                .param("height", "20.0")
                .param("depth", "15.0")
                .param("startDate", LocalDate.now().plusDays(1).toString())
                .param("endDate", LocalDate.now().plusDays(10).toString())
                .param("minPrice", "50000")
                .param("maxPrice", "30000") // 최대 가격이 최소 가격보다 작음
                .contentType(MediaType.MULTIPART_FORM_DATA))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("물품 상세 조회 - 성공")
    void getItem_Success() throws Exception {
        mockMvc.perform(get("/api/items/{itemId}", testItem.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testItem.getId()))
                .andExpect(jsonPath("$.title").value("겨울 옷 보관"))
                .andExpect(jsonPath("$.owner.nickname").value("테스트유저"));
    }

    @Test
    @DisplayName("물품 상세 조회 - 존재하지 않는 물품")
    void getItem_NotFound() throws Exception {
        mockMvc.perform(get("/api/items/99999"))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("물품 삭제 - 성공")
    void deleteItem_Success() throws Exception {
        mockMvc.perform(delete("/api/items/{itemId}", testItem.getId()))
                .andExpect(status().isNoContent());
    }

    @Test
    @DisplayName("물품 삭제 - 다른 사용자의 물품")
    void deleteItem_Unauthorized() throws Exception {
        // 다른 사용자 생성
        User otherUser = User.builder()
                .phoneNumber("01087654321")
                .nickname("다른유저")
                .birthDate(LocalDate.of(1995, 5, 5))
                .build();
        otherUser = userRepository.save(otherUser);

        // 다른 사용자의 물품 생성
        Item otherItem = Item.builder()
                .title("다른 사용자 물품")
                .width(30.0)
                .height(30.0)
                .depth(30.0)
                .startDate(LocalDate.now().plusDays(1))
                .endDate(LocalDate.now().plusDays(10))
                .minPrice(new BigDecimal("10000"))
                .maxPrice(new BigDecimal("20000"))
                .owner(otherUser)
                .build();
        otherItem = itemRepository.save(otherItem);

        mockMvc.perform(delete("/api/items/{itemId}", otherItem.getId()))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("물품 이미지 업데이트 - 성공")
    void updateItemImage_Success() throws Exception {
        MockMultipartFile newImageFile = new MockMultipartFile(
                "image",
                "new-image.jpg",
                MediaType.IMAGE_JPEG_VALUE,
                "new image content".getBytes()
        );

        mockMvc.perform(multipart("/api/items/{itemId}/image", testItem.getId())
                .file(newImageFile)
                .with(request -> {
                    request.setMethod("PATCH");
                    return request;
                }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.imageUrl").value("https://s3-bucket/items/test-image.jpg"));
    }

    @Test
    @DisplayName("물품 상태 변경 - 성공")
    void updateItemStatus_Success() throws Exception {
        mockMvc.perform(patch("/api/items/{itemId}/status", testItem.getId())
                .param("status", "MATCHED"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("MATCHED"));
    }

    @Test
    @DisplayName("내 물품 목록 조회 - 성공")
    void getMyItems_Success() throws Exception {
        // 추가 물품 생성
        Item item2 = Item.builder()
                .title("전자기기 보관")
                .width(20.0)
                .height(20.0)
                .depth(20.0)
                .startDate(LocalDate.now().plusDays(2))
                .endDate(LocalDate.now().plusDays(20))
                .minPrice(new BigDecimal("15000"))
                .maxPrice(new BigDecimal("25000"))
                .owner(testUser)
                .build();
        itemRepository.save(item2);

        mockMvc.perform(get("/api/items/my"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(2)))
                .andExpect(jsonPath("$.content[0].title").exists());
    }

    @Test
    @DisplayName("날짜별 물품 검색 - 성공")
    void searchByDate_Success() throws Exception {
        LocalDate searchDate = LocalDate.now().plusDays(5);

        mockMvc.perform(get("/api/items/search/date")
                .param("date", searchDate.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("가격 범위로 물품 검색 - 성공")
    void searchByPriceRange_Success() throws Exception {
        mockMvc.perform(get("/api/items/search/price")
                .param("minBudget", "25000")
                .param("maxBudget", "55000"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("가격 범위로 물품 검색 - 잘못된 범위")
    void searchByPriceRange_InvalidRange() throws Exception {
        mockMvc.perform(get("/api/items/search/price")
                .param("minBudget", "50000")
                .param("maxBudget", "30000")) // 최소가 최대보다 큼
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("사이즈로 물품 검색 - 성공")
    void searchBySize_Success() throws Exception {
        mockMvc.perform(get("/api/items/search/size")
                .param("maxVolume", "100000"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("키워드로 물품 검색 - 성공")
    void searchByKeyword_Success() throws Exception {
        mockMvc.perform(get("/api/items/search/keyword")
                .param("keyword", "겨울"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("키워드로 물품 검색 - 빈 키워드")
    void searchByKeyword_EmptyKeyword() throws Exception {
        mockMvc.perform(get("/api/items/search/keyword")
                .param("keyword", ""))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("최근 등록 물품 조회 - 성공")
    void getRecentItems_Success() throws Exception {
        mockMvc.perform(get("/api/items/recent"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("곧 시작될 물품 조회 - 성공")
    void getUpcomingItems_Success() throws Exception {
        mockMvc.perform(get("/api/items/upcoming")
                .param("daysAhead", "7"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("물품 통계 조회 - 성공")
    void getItemStatistics_Success() throws Exception {
        mockMvc.perform(get("/api/items/stats"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.total").exists())
                .andExpect(jsonPath("$.active").exists())
                .andExpect(jsonPath("$.matched").exists())
                .andExpect(jsonPath("$.completed").exists());
    }
}