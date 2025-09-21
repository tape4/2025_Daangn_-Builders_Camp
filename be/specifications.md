# Hankan - 공간 대여 서비스 MVP 명세서

> 상세한 API 명세는 [API.md](./API.md) 파일을 참조하세요.

## 프로젝트 개요

Hankan은 개인의 여유 공간을 활용한 단기 물품 보관 서비스입니다. 공간을 가진 사람과 물건을 보관하고 싶은 사람을 연결하여 Win-Win 서비스를 제공합니다.

## 주요 기능

### 1. 회원 인증 시스템
- 전화번호 기반 SMS 인증을 통한 회원가입/로그인
- 프로필 사진 업로드 지원 (multipart/form-data)
- JWT 토큰 기반 인증 시스템

### 2. 공간 관리
- 보관 공간 등록 및 관리
- 위치 정보 (위도/경도) 기반 공간 등록
- 보관함 크기별 수용량 설정 (XS, S, M, L, XL)
- 공간 이미지 업로드 (최대 1개)
- 이용 가능 기간 설정 (시작일/종료일)

### 3. 예약 시스템
- 위치 기반 공간 검색 (반경 검색)
- 날짜 범위로 예약 가능한 공간 검색
- 평점 높은 공간 추천 (Top 10)
- 실시간 예약 및 상태 관리

### 4. 물품 관리
- 보관 물품 등록 및 관리
- 물품 사진 업로드 (최대 1개)
- 물품 설명 및 상태 기록
- 보관 시작/종료 날짜 설정
- 물품별 고유 식별자 관리

### 5. 체크인/체크아웃
- 물품 보관 시 체크인 처리
- 물품 사진 업로드로 상태 기록
- 체크아웃 시 물품 상태 확인

### 6. 리뷰 시스템
- 공간 이용자와 제공자 간 상호 평가
- 5점 척도 평점 및 댓글 시스템

### 7. 실시간 채팅
- SendBird 연동을 통한 1:1 채팅
- 예약 성사 후 당사자 간 소통 지원

## 데이터베이스 스키마

### Users 테이블
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  phone_number VARCHAR(20) UNIQUE NOT NULL,
  nickname VARCHAR(50) NOT NULL,
  birth_date DATE,
  gender ENUM('MALE', 'FEMALE', 'OTHER'),
  profile_image_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Spaces 테이블
```sql
CREATE TABLE spaces (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  owner_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  address VARCHAR(255) NOT NULL,
  image_url VARCHAR(500),
  xs_capacity INT DEFAULT 0,
  s_capacity INT DEFAULT 0,
  m_capacity INT DEFAULT 0,
  l_capacity INT DEFAULT 0,
  xl_capacity INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);
```

### Reservations 테이블
```sql
CREATE TABLE reservations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  space_id BIGINT NOT NULL,
  own_user_id BIGINT NOT NULL,
  rent_user_id BIGINT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  xs_count INT DEFAULT 0,
  s_count INT DEFAULT 0,
  m_count INT DEFAULT 0,
  l_count INT DEFAULT 0,
  xl_count INT DEFAULT 0,
  status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED'),
  item_description TEXT,
  check_in_time TIMESTAMP NULL,
  check_out_time TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (space_id) REFERENCES spaces(id),
  FOREIGN KEY (own_user_id) REFERENCES users(id),
  FOREIGN KEY (rent_user_id) REFERENCES users(id)
);
```

### Items 테이블
```sql
CREATE TABLE items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  owner_id BIGINT NOT NULL,
  space_id BIGINT NOT NULL,
  reservation_id BIGINT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  image_url VARCHAR(500),
  box_size ENUM('XS', 'S', 'M', 'L', 'XL') NOT NULL,
  status ENUM('PENDING', 'STORED', 'RETRIEVED') DEFAULT 'PENDING',
  storage_start_date DATE,
  storage_end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id),
  FOREIGN KEY (space_id) REFERENCES spaces(id),
  FOREIGN KEY (reservation_id) REFERENCES reservations(id)
);
```

### Reviews 테이블
```sql
CREATE TABLE reviews (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  reservation_id BIGINT NOT NULL,
  reviewer_id BIGINT NOT NULL,
  reviewee_id BIGINT NOT NULL,
  review_type ENUM('SPACE', 'USER') NOT NULL,
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reservation_id) REFERENCES reservations(id),
  FOREIGN KEY (reviewer_id) REFERENCES users(id),
  FOREIGN KEY (reviewee_id) REFERENCES users(id)
);
```

## 외부 서비스 연동

### SMS 인증
- CoolSMS 서비스 연동
- 인증번호는 6자리 숫자, 3분간 유효
- 모든 인증번호는 Redis에서 관리 (TTL 3분)

### 채팅 서비스
- SendBird SDK 연동
- 예약 성사 후 당사자간 대화 시작
- 공간 제공자와 이용자 간 1:1 채팅

### 이미지 저장
- AWS S3 연동 구현 완료
- 공간 사진, 물품 사진, 프로필 사진 저장
- 파일 크기 제한: 최대 10MB
- 허용 포맷: JPEG, PNG, WebP
- 각 도메인별 이미지 개수 제한 (공간/물품/프로필: 각 1개)

## 보안 고려사항

- JWT 토큰 기반 인증 시스템 (Access Token: 1시간, Refresh Token: 7일)
- 전화번호 및 인증 정보 암호화 저장
- API Rate Limiting 적용
- 이미지 업로드 시 파일 타입 및 크기 제한 (10MB, JPEG/PNG/WebP)
- Spring Security를 통한 엔드포인트 보호
- 공개 엔드포인트: 검색, 인증, 헬스체크, Swagger UI

## 모니터링 및 관측성

### 메트릭 수집
- Prometheus를 통한 애플리케이션 메트릭 수집
- Spring Boot Actuator 엔드포인트 활성화
- JVM 메트릭, HTTP 요청 메트릭 모니터링

### 로그 수집
- Loki를 통한 중앙화된 로그 수집
- 구조화된 JSON 로그 포맷
- 로그 레벨별 필터링 지원

### 대시보드
- Grafana를 통한 시각화 대시보드
- 실시간 트래픽, 에러율, 응답시간 모니터링
- 알림 설정 및 임계값 관리

## 배포 전략

### Blue-Green 배포
- Nginx를 활용한 무중단 배포
- 자동 롤백 메커니즘
- 헬스체크를 통한 배포 검증

### CI/CD 파이프라인
- GitHub Actions를 통한 자동화
- 자동 테스트 실행 (현재 155개 테스트, 100% 성공률)
- Docker 이미지 빌드 및 레지스트리 푸시
- AWS EC2 자동 배포

## 트래픽 대응 전략

### 캐싱 전략
- Redis를 활용한 응답 캐싱
- 인증 토큰 및 세션 관리
- 자주 조회되는 공간 정보 캐싱

### 데이터베이스 최적화
- 인덱싱 전략 (위치 기반 검색, 날짜 범위 검색)
- 쿼리 최적화 및 N+1 문제 해결
- 읽기 전용 쿼리 분리