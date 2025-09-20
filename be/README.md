# 한칸 (Hankan) - Backend API Server

## 📋 프로젝트 개요

한칸은 개인 간 보관 공간 공유 서비스를 제공하는 플랫폼입니다. 사용자는 여유 공간을 등록하여 다른 사용자에게 대여할 수 있으며, 필요한 사용자는 근처의 보관 공간을 검색하고 예약할 수 있습니다.

## 🏗 시스템 아키텍처

### 전체 구조
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Frontend      │────▶│   Backend API   │────▶│    Database     │
│   (Firebase)    │     │  (Spring Boot)  │     │    (MySQL)      │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                               │                         │
                               ▼                         ▼
                        ┌─────────────────┐     ┌─────────────────┐
                        │   AWS S3        │     │     Redis       │
                        │ (Image Storage) │     │    (Cache)      │
                        └─────────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌─────────────────┐
                        │   CoolSMS API   │
                        │ (SMS Auth)      │
                        └─────────────────┘
```

### 기술 스택

- **Framework**: Spring Boot 3.3.7
- **Language**: Java 17
- **Database**: MySQL 8.0
- **Cache**: Redis
- **Storage**: AWS S3
- **Build Tool**: Gradle
- **Documentation**: SpringDoc OpenAPI (Swagger)
- **Monitoring**: Prometheus + Grafana + Loki
- **SMS Service**: CoolSMS API

## 📦 주요 패키지 구조

```
src/main/java/daangn/builders/hankan/
├── api/                      # API 레이어
│   ├── controller/          # REST 컨트롤러
│   │   ├── UserController.java
│   │   ├── SpaceController.java
│   │   ├── ReservationController.java
│   │   └── ReviewController.java
│   ├── dto/                 # Request/Response DTO
│   └── auth/                # 인증 관련 API
│       └── controller/      
│           ├── SignupController.java
│           └── AuthController.java
├── domain/                   # 도메인 레이어
│   ├── user/                # 사용자 도메인
│   ├── space/               # 공간 도메인
│   ├── reservation/         # 예약 도메인
│   ├── review/              # 리뷰 도메인
│   └── auth/                # 인증 도메인
│       └── jwt/             # JWT 토큰 관리
├── common/                   # 공통 모듈
│   ├── auth/                # 인증 인터셉터/리졸버
│   │   ├── Login.java       # @Login 어노테이션
│   │   └── LoginArgumentResolver.java
│   ├── exception/           # 예외 처리
│   ├── service/             # 공통 서비스
│   │   └── S3Service.java  # AWS S3 서비스
│   └── controller/          # 공통 컨트롤러
└── config/                   # 설정 클래스
    ├── SecurityConfig.java  # 보안 설정
    ├── SwaggerConfig.java   # API 문서 설정
    ├── CorsConfig.java      # CORS 설정
    ├── WebConfig.java       # Web MVC 설정
    └── S3Config.java        # AWS S3 설정
```

## 🔑 주요 기능

### 1. 사용자 관리
- **회원가입/로그인**: 전화번호 기반 SMS 인증
- **프로필 관리**: 프로필 이미지 업로드 (AWS S3)
- **사용자 검색**: 닉네임 기반 검색
- **평점 관리**: 사용자별 평점 집계

### 2. 공간 관리
- **공간 등록**: 위치, 박스 용량(XS/S/M/L/XL), 이용 가능 기간 설정
- **위치 기반 검색**: Haversine 공식을 이용한 좌표 기반 반경 내 공간 검색
- **날짜별 검색**: 특정 날짜에 이용 가능한 공간 조회
- **복합 검색**: 위치 + 날짜 조건 동시 검색
- **이미지 관리**: 공간 이미지 S3 업로드/업데이트

### 3. 예약 시스템
- **예약 생성**: 공간 예약 및 박스 타입/수량 지정
- **예약 조회**: 사용자별 예약 내역 (페이징 지원)
- **예약 상태 관리**: PENDING → CONFIRMED → COMPLETED
- **예약 취소**: 소프트 삭제 방식

### 4. 리뷰 시스템
- **리뷰 작성**: 예약 완료 후 리뷰 작성 (1회만)
- **평점 관리**: 5점 만점 평점 시스템
- **리뷰 조회**: 공간별/사용자별 리뷰 목록

## 🔐 보안 및 인증

### JWT 기반 인증
```java
// 토큰 설정
Access Token: 1시간 유효 (3600000ms)
Refresh Token: 7일 유효 (604800000ms)

// 헤더 형식
Authorization: Bearer {accessToken}
```

### 인증 플로우
1. SMS 코드 발송 → 2. 코드 검증 → 3. JWT 토큰 발급 → 4. API 호출 시 토큰 검증

### CORS 설정
허용된 Origin:
- `http://localhost:3000` (개발 환경)
- `http://localhost:3001` (개발 환경)
- `http://localhost:8080` (개발 환경)
- `https://hankan-9423.web.app` (프로덕션 - Firebase)

## 🗄 데이터베이스 스키마

### 주요 테이블
```sql
-- 사용자
users (
    id, phone_number, nickname, birth_date, 
    gender, profile_image_url, rating, 
    created_at, updated_at
)

-- 공간
spaces (
    id, name, description, latitude, longitude,
    address, image_url, owner_id, rating,
    available_start_date, available_end_date,
    box_capacity_xs, box_capacity_s, box_capacity_m,
    box_capacity_l, box_capacity_xl,
    created_at, updated_at
)

-- 예약
reservations (
    id, user_id, space_id, box_type,
    box_count, total_price, status,
    reservation_date, created_at, updated_at
)

-- 리뷰
reviews (
    id, reservation_id, reviewer_id,
    reviewee_id, space_id, rating, comment,
    created_at, updated_at
)
```

### 관계
- User ↔ Space: 1:N (소유자)
- User ↔ Reservation: 1:N
- Space ↔ Reservation: 1:N
- Reservation ↔ Review: 1:1
- User ↔ Review: 1:N (작성자/대상자)

## 🚀 실행 방법

### 사전 요구사항
- Java 17+
- Docker & Docker Compose
- AWS 계정 (S3 사용)
- CoolSMS 계정 (SMS 인증)

### 1. 인프라 실행
```bash
docker-compose up -d
```
실행되는 서비스:
- MySQL (3306)
- Redis (6379)
- Prometheus (9090)
- Loki (3100)
- Grafana (3000)

### 2. 환경 변수 설정
`src/main/resources/application-infrastructure.properties` 파일 생성:
```properties
# AWS S3
aws.access-key-id=YOUR_ACCESS_KEY
aws.secret-access-key=YOUR_SECRET_KEY
aws.s3.region=ap-northeast-2
aws.s3.bucket-name=YOUR_BUCKET_NAME
aws.s3.profile-image-path=profiles/
aws.s3.space-image-path=spaces/
aws.s3.item-image-path=items/

# JWT
jwt.access-secret-key=YOUR_ACCESS_SECRET_KEY
jwt.refresh-secret-key=YOUR_REFRESH_SECRET_KEY
jwt.access-token-expiration=3600000
jwt.refresh-token-expiration=604800000

# CoolSMS
coolsms.api-key=YOUR_API_KEY
coolsms.api-secret=YOUR_API_SECRET
coolsms.phone-number=YOUR_PHONE_NUMBER
coolsms.base-url=https://api.coolsms.co.kr
```

### 3. 애플리케이션 실행
```bash
# 빌드
./gradlew build

# 테스트
./gradlew test

# 실행
./gradlew bootRun
```

## 📝 API 문서

애플리케이션 실행 후 Swagger UI 접속:
```
http://localhost:8080/swagger-ui/index.html
```

### 주요 API 엔드포인트

#### 인증 (`/api/auth`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/signup` | 회원가입 (Multipart) |
| GET | `/signup/check-phone` | 전화번호 중복 체크 |
| POST | `/send-code` | SMS 인증 코드 발송 |
| POST | `/verify` | 인증 코드 확인 및 로그인 |
| POST | `/refresh` | 토큰 갱신 |
| POST | `/logout` | 로그아웃 |

#### 사용자 (`/api/users`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/me` | 내 정보 조회 🔒 |
| PATCH | `/me` | 프로필 수정 (Multipart) 🔒 |
| GET | `/{userId}` | 사용자 정보 조회 |
| GET | `/phone/{phoneNumber}` | 전화번호로 사용자 조회 |
| GET | `/search` | 닉네임 검색 |
| GET | `/top-rated` | 평점 상위 사용자 |
| GET | `/check-phone` | 전화번호 중복 확인 |
| GET | `/stats` | 사용자 통계 |

#### 공간 (`/api/spaces`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | 공간 등록 (Multipart) 🔒 |
| GET | `/{spaceId}` | 공간 상세 조회 |
| GET | `/search/location` | 위치 기반 검색 |
| GET | `/search/date` | 날짜별 검색 |
| GET | `/search/location-and-date` | 위치+날짜 검색 |
| GET | `/top-rated` | 평점 높은 공간 |
| GET | `/my` | 내 공간 목록 🔒 |
| PATCH | `/{spaceId}/image` | 공간 이미지 업데이트 🔒 |
| PATCH | `/{spaceId}/availability` | 이용 기간 업데이트 🔒 |
| PATCH | `/{spaceId}/capacity` | 박스 용량 업데이트 🔒 |
| GET | `/{spaceId}/availability/{date}` | 특정 날짜 이용 가능 여부 |
| GET | `/{spaceId}/capacity` | 박스 용량 상세 조회 |

#### 예약 (`/api/reservations`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | 예약 생성 🔒 |
| GET | `/` | 내 예약 목록 🔒 |
| GET | `/{id}` | 예약 상세 조회 🔒 |
| DELETE | `/{id}` | 예약 취소 🔒 |
| PATCH | `/{id}/status` | 예약 상태 변경 🔒 |
| GET | `/space/{spaceId}` | 공간별 예약 조회 🔒 |

#### 리뷰 (`/api/reviews`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/` | 리뷰 작성 🔒 |
| GET | `/{id}` | 리뷰 상세 조회 |
| GET | `/space/{spaceId}` | 공간별 리뷰 |
| GET | `/user/{userId}` | 사용자가 받은 리뷰 |
| GET | `/my` | 내가 작성한 리뷰 🔒 |
| DELETE | `/{id}` | 리뷰 삭제 🔒 |

> 🔒 표시는 인증이 필요한 엔드포인트

## 📊 모니터링

### Grafana 대시보드
- URL: `http://localhost:3000`
- 기본 계정: admin/admin

### 수집 메트릭
- JVM 메모리 사용량
- HTTP 요청 수 및 응답 시간
- 데이터베이스 커넥션 풀 상태
- 캐시 히트율
- API 엔드포인트별 성능

### Loki 로그 수집
- 애플리케이션 로그 중앙화
- 에러 추적 및 분석
- 실시간 로그 모니터링

## 🧪 테스트

### 테스트 실행
```bash
# 전체 테스트
./gradlew test

# 특정 테스트 클래스
./gradlew test --tests UserControllerTest

# 테스트 리포트
open build/reports/tests/test/index.html
```

### 테스트 구성
- **Controller Tests**: MockMvc를 이용한 API 엔드포인트 테스트
- **Service Tests**: 비즈니스 로직 단위 테스트
- **Repository Tests**: JPA 쿼리 메서드 테스트
- **Integration Tests**: 전체 플로우 통합 테스트

### 테스트 데이터
- H2 인메모리 데이터베이스 사용 (테스트 환경)
- @Sql 어노테이션으로 테스트 데이터 초기화

## 🔄 CI/CD

### GitHub Actions Workflow
`.github/workflows/be-cicd.yml`:
1. 코드 체크아웃
2. JDK 17 설정
3. Gradle 캐싱
4. 테스트 실행
5. 빌드
6. Docker 이미지 빌드 & 푸시 (선택적)

### 필요한 GitHub Secrets
```yaml
# AWS
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_S3_BUCKET_NAME
AWS_S3_REGION

# JWT
JWT_ACCESS_SECRET_KEY
JWT_REFRESH_SECRET_KEY

# CoolSMS
COOLSMS_API_KEY
COOLSMS_API_SECRET
COOLSMS_PHONE_NUMBER

# Database (Production)
DATABASE_URL
DATABASE_USERNAME
DATABASE_PASSWORD
```

## 🛠 트러블슈팅

### 일반적인 문제 해결

#### 1. 데이터베이스 연결 실패
```bash
# Docker 컨테이너 확인
docker ps

# MySQL 로그 확인
docker logs hankan_mysql

# 포트 확인
lsof -i :3306
```

#### 2. S3 업로드 실패
- AWS 자격 증명 확인
- S3 버킷 권한 정책 확인
- 버킷 리전 설정 확인

#### 3. JWT 토큰 오류
- 시크릿 키 길이 확인 (최소 256비트)
- 토큰 만료 시간 확인
- 헤더 형식 확인 (`Bearer ` prefix)

#### 4. SMS 발송 실패
- CoolSMS 잔액 확인
- API 키/시크릿 확인
- 발신 번호 등록 확인

## 📱 프론트엔드 연동 가이드

### API 호출 예시
```javascript
// 로그인
const login = async (phoneNumber, verificationCode) => {
  const response = await fetch('http://localhost:8080/api/auth/verify', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ phoneNumber, code: verificationCode })
  });
  const data = await response.json();
  localStorage.setItem('accessToken', data.accessToken);
  localStorage.setItem('refreshToken', data.refreshToken);
};

// API 호출 (인증 필요)
const getMyInfo = async () => {
  const response = await fetch('http://localhost:8080/api/users/me', {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('accessToken')}`
    }
  });
  return response.json();
};

// 파일 업로드
const updateProfile = async (nickname, profileImage) => {
  const formData = new FormData();
  formData.append('nickname', nickname);
  formData.append('profileImage', profileImage);
  
  const response = await fetch('http://localhost:8080/api/users/me', {
    method: 'PATCH',
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('accessToken')}`
    },
    body: formData
  });
  return response.json();
};
```

## 🔒 보안 고려사항

1. **환경 변수**: 민감한 정보는 절대 코드에 하드코딩하지 않음
2. **HTTPS**: 프로덕션 환경에서는 반드시 HTTPS 사용
3. **Rate Limiting**: SMS 발송 등에 Rate Limiting 적용
4. **Input Validation**: 모든 입력값 검증 (@Valid, @Validated)
5. **SQL Injection**: JPA/Hibernate 사용으로 방지
6. **XSS**: 출력값 이스케이프 처리

## 📄 라이센스

이 프로젝트는 비공개 프로젝트입니다.

## 👥 팀원

빌더스 캠프 Team 14

---

**Last Updated**: 2025-09-21