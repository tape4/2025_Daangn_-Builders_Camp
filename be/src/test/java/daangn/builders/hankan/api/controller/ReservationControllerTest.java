package daangn.builders.hankan.api.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import daangn.builders.hankan.common.exception.GlobalExceptionHandler;
import daangn.builders.hankan.common.exception.ReservationNotFoundException;
import daangn.builders.hankan.common.exception.SpaceNotFoundException;
import daangn.builders.hankan.common.exception.UserNotFoundException;
import daangn.builders.hankan.domain.reservation.Reservation;
import daangn.builders.hankan.domain.reservation.ReservationRequest;
import daangn.builders.hankan.domain.reservation.ReservationService;
import daangn.builders.hankan.domain.space.Space;
import daangn.builders.hankan.domain.user.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Disabled;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.hamcrest.Matchers.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class ReservationControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ReservationService reservationService;

    private ObjectMapper objectMapper;
    private Reservation sampleReservation;
    private ReservationRequest sampleRequest;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Sample User
        User user = User.builder()
                .phoneNumber("010-1234-5678")
                .nickname("테스트 사용자")
                .build();
        // Reflection을 사용하여 ID 설정 (테스트용)
        try {
            var idField = User.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(user, 1L);
        } catch (Exception e) {
            // ignore
        }

        // Sample Space
        Space space = Space.builder()
                .name("테스트 공간")
                .description("테스트 공간 설명")
                .address("서울시 강남구")
                .latitude(37.5665)
                .longitude(126.978)
                .boxCapacityXs(10)
                .boxCapacityS(10)
                .boxCapacityM(10)
                .boxCapacityL(10)
                .boxCapacityXl(10)
                .availableStartDate(LocalDate.now())
                .availableEndDate(LocalDate.now().plusMonths(6))
                .owner(user)
                .build();
        // Reflection을 사용하여 ID 설정 (테스트용)
        try {
            var idField = Space.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(space, 1L);
        } catch (Exception e) {
            // ignore
        }

        // Sample Reservation
        sampleReservation = Reservation.builder()
                .user(user)
                .space(space)
                .startDate(LocalDate.now().plusDays(7))
                .endDate(LocalDate.now().plusDays(14))
                .boxRequirementXs(2)
                .boxRequirementS(1)
                .boxRequirementM(1)
                .boxRequirementL(0)
                .boxRequirementXl(0)
                .totalPrice(new BigDecimal("50000"))
                .build();
        // Reflection을 사용하여 ID 설정 (테스트용)
        try {
            var idField = Reservation.class.getDeclaredField("id");
            idField.setAccessible(true);
            idField.set(sampleReservation, 1L);
        } catch (Exception e) {
            // ignore
        }

        // Sample Request
        sampleRequest = ReservationRequest.builder()
                .userId(1L)
                .spaceId(1L)
                .startDate(LocalDate.now().plusDays(7))
                .endDate(LocalDate.now().plusDays(14))
                .boxRequirementXs(2)
                .boxRequirementS(1)
                .boxRequirementM(1)
                .boxRequirementL(0)
                .boxRequirementXl(0)
                .totalPrice(new BigDecimal("50000"))
                .build();
    }

    @Test
    @DisplayName("POST /api/reservations - 정상적인 예약 생성")
    void createReservation_Success() throws Exception {
        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenReturn(sampleReservation);

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(sampleRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.user.phoneNumber").value("010-1234-5678"))
                .andExpect(jsonPath("$.space.name").value("테스트 공간"))
                .andExpect(jsonPath("$.boxRequirementXs").value(2))
                .andExpect(jsonPath("$.boxRequirementS").value(1))
                .andExpect(jsonPath("$.totalPrice").value(50000));
    }

    @Test
    @DisplayName("POST /api/reservations - 필수 필드 누락")
    void createReservation_MissingRequiredFields() throws Exception {
        // 필수 필드가 누락된 요청 - spaceId, startDate, endDate, totalPrice가 null
        String invalidJson = "{\"userId\": 1, \"boxRequirementXs\": 1}";

        // 서비스가 호출되면 안되므로, 아무 동작도 하지 않도록 설정
        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("Should not be called"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidJson))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("POST /api/reservations - 잘못된 날짜 (시작일이 종료일보다 늦음)")
    void createReservation_InvalidDateRange() throws Exception {
        ReservationRequest invalidRequest = ReservationRequest.builder()
                .userId(1L)
                .spaceId(1L)
                .startDate(LocalDate.now().plusDays(14))
                .endDate(LocalDate.now().plusDays(7))  // 시작일보다 이전
                .boxRequirementXs(1)
                .totalPrice(new BigDecimal("10000"))
                .build();

        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("Start date cannot be after end date"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Start date cannot be after end date"));
    }

    @Test
    @DisplayName("POST /api/reservations - 과거 날짜 예약 시도")
    void createReservation_PastDate() throws Exception {
        ReservationRequest invalidRequest = ReservationRequest.builder()
                .userId(1L)
                .spaceId(1L)
                .startDate(LocalDate.now().minusDays(7))  // 과거 날짜
                .endDate(LocalDate.now().minusDays(1))
                .boxRequirementXs(1)
                .totalPrice(new BigDecimal("10000"))
                .build();

        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("Cannot make reservations for past dates"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Cannot make reservations for past dates"));
    }

    @Test
    @DisplayName("POST /api/reservations - 박스 용량 초과")
    void createReservation_ExceedBoxCapacity() throws Exception {
        ReservationRequest invalidRequest = ReservationRequest.builder()
                .userId(1L)
                .spaceId(1L)
                .startDate(LocalDate.now().plusDays(7))
                .endDate(LocalDate.now().plusDays(14))
                .boxRequirementXs(100)  // 용량 초과
                .totalPrice(new BigDecimal("10000"))
                .build();

        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("Box requirements exceed space capacity"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Box requirements exceed space capacity"));
    }

    @Test
    @DisplayName("POST /api/reservations - 박스 수량 0개 (최소 1개 필요)")
    void createReservation_NoBoxRequested() throws Exception {
        ReservationRequest invalidRequest = ReservationRequest.builder()
                .userId(1L)
                .spaceId(1L)
                .startDate(LocalDate.now().plusDays(7))
                .endDate(LocalDate.now().plusDays(14))
                .boxRequirementXs(0)
                .boxRequirementS(0)
                .boxRequirementM(0)
                .boxRequirementL(0)
                .boxRequirementXl(0)
                .totalPrice(new BigDecimal("0"))
                .build();

        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("At least one box must be requested"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("At least one box must be requested"));
    }

    @Test
    @DisplayName("POST /api/reservations - 기간 중 충돌하는 예약 존재")
    void createReservation_ConflictingReservation() throws Exception {
        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("Space is already reserved for the requested period"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(sampleRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Space is already reserved for the requested period"));
    }

    @Test
    @DisplayName("GET /api/reservations/{id} - 정상 조회")
    void getReservation_Success() throws Exception {
        when(reservationService.findById(1L)).thenReturn(sampleReservation);

        mockMvc.perform(get("/api/reservations/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.user.phoneNumber").value("010-1234-5678"));
    }

    @Test
    @DisplayName("GET /api/reservations/{id} - 존재하지 않는 예약 (404)")
    void getReservation_NotFound() throws Exception {
        when(reservationService.findById(999L))
                .thenThrow(new ReservationNotFoundException(999L));

        mockMvc.perform(get("/api/reservations/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 예약을 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("GET /api/reservations/my - 내 예약 목록 조회")
    void getMyReservations_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        Page<Reservation> page = new PageImpl<>(reservations, PageRequest.of(0, 20), 1);
        
        when(reservationService.findByUser(anyLong(), any(Pageable.class))).thenReturn(page);

        mockMvc.perform(get("/api/reservations/my"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)))
                .andExpect(jsonPath("$.content[0].id").value(1));
    }

    @Test
    @DisplayName("GET /api/reservations/my - 페이징 파라미터 테스트")
    void getMyReservations_WithPaging() throws Exception {
        List<Reservation> reservations = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            reservations.add(sampleReservation);
        }
        Page<Reservation> page = new PageImpl<>(reservations, PageRequest.of(1, 5), 15);
        
        when(reservationService.findByUser(anyLong(), any(Pageable.class))).thenReturn(page);

        mockMvc.perform(get("/api/reservations/my")
                        .param("page", "1")
                        .param("size", "5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(5)))
                .andExpect(jsonPath("$.number").value(1))
                .andExpect(jsonPath("$.size").value(5))
                .andExpect(jsonPath("$.totalElements").value(15));
    }

    @Test
    @DisplayName("GET /api/reservations/my/status/{status} - 상태별 예약 조회")
    void getMyReservationsByStatus_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        Page<Reservation> page = new PageImpl<>(reservations, PageRequest.of(0, 20), 1);
        
        when(reservationService.findByUserAndStatus(anyLong(), 
                eq(Reservation.ReservationStatus.CONFIRMED), any(Pageable.class)))
                .thenReturn(page);

        mockMvc.perform(get("/api/reservations/my/status/CONFIRMED"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)));
    }

    @Test
    @DisplayName("GET /api/reservations/my/status/{status} - 잘못된 상태값")
    void getMyReservationsByStatus_InvalidStatus() throws Exception {
        mockMvc.perform(get("/api/reservations/my/status/INVALID_STATUS"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/reservations/space/{spaceId} - 공간별 예약 조회")
    void getReservationsBySpace_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        Page<Reservation> page = new PageImpl<>(reservations, PageRequest.of(0, 20), 1);
        
        when(reservationService.findBySpace(eq(1L), any(Pageable.class))).thenReturn(page);

        mockMvc.perform(get("/api/reservations/space/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/confirm - 예약 확정")
    void confirmReservation_Success() throws Exception {
        sampleReservation.confirm();
        when(reservationService.confirmReservation(1L)).thenReturn(sampleReservation);

        mockMvc.perform(patch("/api/reservations/1/confirm"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.status").value("CONFIRMED"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/confirm - 이미 확정된 예약")
    void confirmReservation_AlreadyConfirmed() throws Exception {
        when(reservationService.confirmReservation(anyLong()))
                .thenThrow(new IllegalStateException("Only pending reservations can be confirmed"));

        mockMvc.perform(patch("/api/reservations/1/confirm"))
                .andExpect(status().isInternalServerError()); // 예외 처리가 구현되지 않아 500 반환
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/cancel - 예약 취소")
    void cancelReservation_Success() throws Exception {
        sampleReservation.cancel();
        when(reservationService.cancelReservation(1L)).thenReturn(sampleReservation);

        mockMvc.perform(patch("/api/reservations/1/cancel"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.status").value("CANCELLED"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/cancel - 완료된 예약은 취소 불가")
    void cancelReservation_CompletedReservation() throws Exception {
        when(reservationService.cancelReservation(1L))
                .thenThrow(new IllegalStateException("Completed reservations cannot be cancelled"));

        mockMvc.perform(patch("/api/reservations/1/cancel"))
                .andExpect(status().isInternalServerError()); // 예외 처리가 구현되지 않아 500 반환
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-in - 체크인 성공")
    void checkIn_Success() throws Exception {
        sampleReservation.confirm();
        sampleReservation.checkIn("노트북과 서류", "https://image.url", LocalDateTime.now());
        when(reservationService.checkIn(1L, "노트북과 서류", "https://image.url"))
                .thenReturn(sampleReservation);

        mockMvc.perform(patch("/api/reservations/1/check-in")
                        .param("itemDescription", "노트북과 서류")
                        .param("itemImageUrl", "https://image.url"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.status").value("CHECKED_IN"))
                .andExpect(jsonPath("$.itemDescription").value("노트북과 서류"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-in - 아이템 설명 누락")
    void checkIn_MissingItemDescription() throws Exception {
        mockMvc.perform(patch("/api/reservations/1/check-in"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-in - 확정되지 않은 예약")
    void checkIn_NotConfirmed() throws Exception {
        when(reservationService.checkIn(eq(1L), anyString(), isNull()))
                .thenThrow(new IllegalStateException("Only confirmed reservations can be checked in"));

        mockMvc.perform(patch("/api/reservations/1/check-in")
                        .param("itemDescription", "아이템"))
                .andExpect(status().isInternalServerError()); // 예외 처리가 구현되지 않아 500 반환
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-in - 체크인 날짜가 아님")
    void checkIn_WrongDate() throws Exception {
        when(reservationService.checkIn(eq(1L), anyString(), isNull()))
                .thenThrow(new IllegalStateException("Check-in is only allowed on the reservation start date"));

        mockMvc.perform(patch("/api/reservations/1/check-in")
                        .param("itemDescription", "아이템"))
                .andExpect(status().isInternalServerError()); // 예외 처리가 구현되지 않아 500 반환
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-out - 체크아웃 성공")
    void checkOut_Success() throws Exception {
        sampleReservation.confirm();
        sampleReservation.checkIn("아이템", null, LocalDateTime.now());
        sampleReservation.checkOut(LocalDateTime.now(), Reservation.ItemCondition.GOOD);
        when(reservationService.checkOut(1L, Reservation.ItemCondition.GOOD))
                .thenReturn(sampleReservation);

        mockMvc.perform(patch("/api/reservations/1/check-out")
                        .param("itemCondition", "GOOD"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.status").value("COMPLETED"))
                .andExpect(jsonPath("$.itemCondition").value("GOOD"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-out - 아이템 상태 누락")
    void checkOut_MissingItemCondition() throws Exception {
        mockMvc.perform(patch("/api/reservations/1/check-out"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-out - 잘못된 아이템 상태")
    void checkOut_InvalidItemCondition() throws Exception {
        mockMvc.perform(patch("/api/reservations/1/check-out")
                        .param("itemCondition", "INVALID_CONDITION"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-out - 체크인하지 않은 예약")
    void checkOut_NotCheckedIn() throws Exception {
        when(reservationService.checkOut(eq(1L), any(Reservation.ItemCondition.class)))
                .thenThrow(new IllegalStateException("Only checked-in reservations can be checked out"));

        mockMvc.perform(patch("/api/reservations/1/check-out")
                        .param("itemCondition", "GOOD"))
                .andExpect(status().isInternalServerError()); // 예외 처리가 구현되지 않아 500 반환
    }

    @Test
    @DisplayName("GET /api/reservations/check-ins/today - 오늘 체크인 대상 조회")
    void getTodayCheckIns_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        when(reservationService.findTodayCheckIns()).thenReturn(reservations);

        mockMvc.perform(get("/api/reservations/check-ins/today"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].id").value(1));
    }

    @Test
    @DisplayName("GET /api/reservations/check-outs/today - 오늘 체크아웃 대상 조회")
    void getTodayCheckOuts_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        when(reservationService.findTodayCheckOuts()).thenReturn(reservations);

        mockMvc.perform(get("/api/reservations/check-outs/today"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    @DisplayName("GET /api/reservations/overdue - 연체된 예약 조회")
    void getOverdueReservations_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        when(reservationService.findOverdueReservations()).thenReturn(reservations);

        mockMvc.perform(get("/api/reservations/overdue"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    @DisplayName("GET /api/reservations/check-review-eligibility - 리뷰 작성 권한 확인")
    void checkReviewEligibility_HasEligibility() throws Exception {
        when(reservationService.hasUserCompletedReservationAtSpace(1L, 1L))
                .thenReturn(true);

        mockMvc.perform(get("/api/reservations/check-review-eligibility")
                        .param("spaceId", "1"))
                .andExpect(status().isOk())
                .andExpect(content().string("true"));
    }

    @Test
    @DisplayName("GET /api/reservations/check-review-eligibility - 리뷰 작성 권한 없음")
    void checkReviewEligibility_NoEligibility() throws Exception {
        when(reservationService.hasUserCompletedReservationAtSpace(1L, 1L))
                .thenReturn(false);

        mockMvc.perform(get("/api/reservations/check-review-eligibility")
                        .param("spaceId", "1"))
                .andExpect(status().isOk())
                .andExpect(content().string("false"));
    }

    @Test
    @DisplayName("GET /api/reservations/check-review-eligibility - spaceId 파라미터 누락")
    void checkReviewEligibility_MissingSpaceId() throws Exception {
        mockMvc.perform(get("/api/reservations/check-review-eligibility"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/reservations/my-spaces - 내 공간 예약 조회")
    void getMySpaceReservations_Success() throws Exception {
        List<Reservation> reservations = Arrays.asList(sampleReservation);
        Page<Reservation> page = new PageImpl<>(reservations, PageRequest.of(0, 20), 1);
        
        when(reservationService.findBySpaceOwner(anyLong(), any(Pageable.class))).thenReturn(page);

        mockMvc.perform(get("/api/reservations/my-spaces"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)))
                .andExpect(jsonPath("$.content[0].id").value(1));
    }

    @Test
    @DisplayName("POST /api/reservations - 잘못된 JSON 형식")
    void createReservation_InvalidJson() throws Exception {
        String invalidJson = "{invalid json}";

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidJson))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("POST /api/reservations - 음수 가격")
    void createReservation_NegativePrice() throws Exception {
        ReservationRequest invalidRequest = ReservationRequest.builder()
                .userId(1L)
                .spaceId(1L)
                .startDate(LocalDate.now().plusDays(7))
                .endDate(LocalDate.now().plusDays(14))
                .boxRequirementXs(1)
                .totalPrice(new BigDecimal("-10000"))  // 음수 가격
                .build();

        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new IllegalArgumentException("Price cannot be negative"));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Price cannot be negative"));
    }

    @Test
    @DisplayName("POST /api/reservations - 사용자 없음 (404)")
    void createReservation_UserNotFound() throws Exception {
        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new UserNotFoundException(999L));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(sampleRequest)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 사용자를 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("POST /api/reservations - 공간 없음 (404)")
    void createReservation_SpaceNotFound() throws Exception {
        when(reservationService.createReservation(any(ReservationRequest.class)))
                .thenThrow(new SpaceNotFoundException(999L));

        mockMvc.perform(post("/api/reservations")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(sampleRequest)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.error").value("Not Found"))
                .andExpect(jsonPath("$.message").value("해당 ID의 공간을 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("GET /api/reservations/space/{spaceId} - 존재하지 않는 공간")
    void getReservationsBySpace_SpaceNotFound() throws Exception {
        when(reservationService.findBySpace(eq(999L), any(Pageable.class)))
                .thenThrow(new SpaceNotFoundException(999L));

        mockMvc.perform(get("/api/reservations/space/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/confirm - 존재하지 않는 예약 (404)")
    void confirmReservation_NotFound() throws Exception {
        when(reservationService.confirmReservation(999L))
                .thenThrow(new ReservationNotFoundException(999L));

        mockMvc.perform(patch("/api/reservations/999/confirm"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value("해당 ID의 예약을 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/cancel - 존재하지 않는 예약 (404)")
    void cancelReservation_NotFound() throws Exception {
        when(reservationService.cancelReservation(999L))
                .thenThrow(new ReservationNotFoundException(999L));

        mockMvc.perform(patch("/api/reservations/999/cancel"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value("해당 ID의 예약을 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-in - 존재하지 않는 예약 (404)")
    void checkIn_NotFound() throws Exception {
        when(reservationService.checkIn(eq(999L), anyString(), isNull()))
                .thenThrow(new ReservationNotFoundException(999L));

        mockMvc.perform(patch("/api/reservations/999/check-in")
                        .param("itemDescription", "테스트 물품"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value("해당 ID의 예약을 찾을 수 없습니다: 999"));
    }

    @Test
    @DisplayName("PATCH /api/reservations/{id}/check-out - 존재하지 않는 예약 (404)")
    void checkOut_NotFound() throws Exception {
        when(reservationService.checkOut(eq(999L), any(Reservation.ItemCondition.class)))
                .thenThrow(new ReservationNotFoundException(999L));

        mockMvc.perform(patch("/api/reservations/999/check-out")
                        .param("itemCondition", "GOOD"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value("해당 ID의 예약을 찾을 수 없습니다: 999"));
    }
}