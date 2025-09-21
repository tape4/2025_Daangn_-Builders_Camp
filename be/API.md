# Hankan API 명세서

## API 기본 정보

### Base URL
- Development: `http://localhost:8080`
- Production: `https://api.hankan.io` (예정)

### 인증
- JWT Bearer Token 사용
- Header: `Authorization: Bearer {access_token}`
- Access Token 유효기간: 1시간
- Refresh Token 유효기간: 7일

### 날짜/시간 포맷
- 날짜: ISO 8601 형식 (`yyyy-MM-dd`)
- 날짜/시간: ISO 8601 형식 (`yyyy-MM-dd'T'HH:mm:ss`)
- 예: `2025-01-21`, `2025-01-21T10:30:00`

### 파일 업로드 제한
- 최대 파일 크기: 10MB
- 허용 파일 형식: JPEG, PNG, WebP
- 각 도메인별 이미지 개수:
  - 공간 이미지: 1개
  - 물품 이미지: 1개
  - 프로필 이미지: 1개

### 응답 형식
모든 응답은 JSON 형식이며, 성공/실패 시 다음과 같은 구조를 따릅니다:

**성공 응답**
```json
{
  "success": true,
  "data": { ... },
  "message": "성공 메시지"
}
```

**에러 응답**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "에러 메시지"
  }
}
```

## 1. 인증 관련 API

### 1.1 인증번호 전송 (회원가입용)
**POST** `/api/auth/send-verification`

#### 요청 데이터
```json
{
  "phoneNumber": "010-1234-5678"
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "인증번호가 전송되었습니다.",
  "expiresAt": "2024-01-01T10:03:00Z"
}
```

### 1.2 전화번호 인증 확인
**POST** `/api/auth/verify-phone`

#### 요청 데이터
```json
{
  "phoneNumber": "010-1234-5678",
  "verificationCode": "123456"
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "인증이 완료되었습니다.",
  "verificationToken": "temp_token_for_registration"
}
```

### 1.3 회원가입
**POST** `/api/auth/register`

#### 요청 데이터 (multipart/form-data)
```
verificationToken: "temp_token_from_verification"
nickname: "닉네임"
birthDate: "1990-01-01"
gender: "MALE"  // MALE, FEMALE, OTHER
profileImage: [File] (선택사항, 최대 10MB, JPEG/PNG/WebP, 1개만)
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "회원가입이 완료되었습니다.",
  "user": {
    "id": 1,
    "phoneNumber": "010-1234-5678",
    "nickname": "닉네임",
    "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1.jpg"
  },
  "accessToken": "jwt_access_token",
  "refreshToken": "jwt_refresh_token"
}
```

### 1.4 로그인용 인증번호 전송
**POST** `/api/auth/send-login-verification`

#### 요청 데이터
```json
{
  "phoneNumber": "010-1234-5678"
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "인증번호가 전송되었습니다.",
  "expiresAt": "2024-01-01T10:03:00Z"
}
```

### 1.5 로그인
**POST** `/api/auth/login`

#### 요청 데이터
```json
{
  "phoneNumber": "010-1234-5678",
  "verificationCode": "123456"
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "로그인 성공",
  "user": {
    "id": 1,
    "nickname": "닉네임",
    "phoneNumber": "010-1234-5678",
    "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1.jpg"
  },
  "accessToken": "jwt_access_token",
  "refreshToken": "jwt_refresh_token"
}
```

### 1.6 토큰 갱신
**POST** `/api/auth/refresh`

#### 요청 데이터
```json
{
  "refreshToken": "jwt_refresh_token"
}
```

#### 응답 데이터
```json
{
  "success": true,
  "accessToken": "new_jwt_access_token",
  "refreshToken": "new_jwt_refresh_token"
}
```

## 2. 공간 관련 API

### 2.1 공간 등록
**POST** `/api/spaces`

#### 요청 데이터 (multipart/form-data)
```
name: "강남역 보관함"
description: "접근성이 좋은 보관함입니다."
latitude: 37.5665
longitude: 126.9780
address: "서울시 강남구 역삼동 110"
availableDates: ["2024-01-01", "2024-01-02"]  // JSON 문자열
boxCapacity: {"XS": 10, "S": 8, "M": 5, "L": 3, "XL": 1}  // JSON 문자열
image: [File]  // 1개, 최대 10MB (JPEG, PNG, WebP)
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "공간이 등록되었습니다.",
  "space": {
    "id": 1,
    "name": "강남역 보관함",
    "description": "접근성이 좋은 보관함입니다.",
    "latitude": 37.5665,
    "longitude": 126.9780,
    "address": "서울시 강남구 역삼동 110",
    "imageUrl": "https://s3.amazonaws.com/bucket/spaces/space_1_1.jpg",
    "boxCapacity": {
      "XS": 10,
      "S": 8,
      "M": 5,
      "L": 3,
      "XL": 1
    },
    "ownerId": 1
  }
}
```

### 2.2 공간 이미지 수정
**PUT** `/api/spaces/{spaceId}/image`

#### 요청 데이터 (multipart/form-data)
```
image: [File]
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "이미지가 업데이트되었습니다.",
  "imageUrl": "https://s3.amazonaws.com/bucket/spaces/space_1_updated.jpg"
}
```

### 2.3 위치 기반 공간 검색
**GET** `/api/spaces/search`

#### 쿼리 파라미터
```
lat: 37.5665 (위도)
lng: 126.9780 (경도)
radius: 1000 (검색 반경, 미터 단위)
page: 0 (페이지 번호, 기본값 0)
size: 20 (페이지 크기, 기본값 20)
```

#### 응답 데이터
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "name": "강남역 보관함",
        "description": "접근성이 좋은 보관함입니다.",
        "latitude": 37.5665,
        "longitude": 126.9780,
        "address": "서울시 강남구 역삼동 110",
        "distance": 250.5,
        "imageUrl": "https://s3.amazonaws.com/bucket/spaces/space_1_1.jpg",
        "availableBoxes": {
          "XS": 8,
          "S": 5,
          "M": 3,
          "L": 2,
          "XL": 1
        },
        "rating": 4.5,
        "reviewCount": 23
      }
    ],
    "totalElements": 50,
    "totalPages": 3,
    "size": 20,
    "number": 0
  }
}
```

### 2.4 날짜 범위로 공간 검색
**GET** `/api/spaces/search/date`

#### 쿼리 파라미터
```
startDate: 2025-01-20 (시작 날짜)
endDate: 2025-01-25 (종료 날짜)
```

#### 응답 데이터
```json
[
  {
    "id": 1,
    "name": "강남역 보관함",
    "description": "접근성이 좋은 보관함입니다.",
    "latitude": 37.5665,
    "longitude": 126.9780,
    "address": "서울시 강남구 역삼동 110",
    "imageUrl": "https://s3.amazonaws.com/bucket/spaces/space_1.jpg",
    "availableStartDate": "2025-01-15",
    "availableEndDate": "2025-02-28",
    "boxCapacityXs": 10,
    "boxCapacityS": 8,
    "boxCapacityM": 5,
    "boxCapacityL": 3,
    "boxCapacityXl": 1,
    "rating": 4.5,
    "reviewCount": 23,
    "createdAt": "2025-01-10T10:00:00",
    "updatedAt": "2025-01-20T15:30:00"
  }
]
```

### 2.5 평점 높은 공간 조회
**GET** `/api/spaces/top-rated`

#### 쿼리 파라미터
```
limit: 10 (기본값 10, 최대 50)
```

#### 응답 데이터
```json
[
  {
    "id": 1,
    "name": "강남역 보관함",
    "imageUrl": "https://s3.amazonaws.com/bucket/spaces/space_1.jpg",
    "address": "서울시 강남구 역삼동 110",
    "rating": 4.9,
    "reviewCount": 150
  }
]
```

### 2.6 공간 상세 조회
**GET** `/api/spaces/{spaceId}`

#### 응답 데이터
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "강남역 보관함",
    "description": "접근성이 좋은 보관함입니다.",
    "latitude": 37.5665,
    "longitude": 126.9780,
    "address": "서울시 강남구 역삼동 110",
    "imageUrl": "https://s3.amazonaws.com/bucket/spaces/space_1_1.jpg",
    "boxCapacity": {
      "XS": 10,
      "S": 8,
      "M": 5,
      "L": 3,
      "XL": 1
    },
    "owner": {
      "id": 1,
      "nickname": "공간주인",
      "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1.jpg",
      "rating": 4.8
    },
    "rating": 4.5,
    "reviewCount": 23
  }
}
```

## 3. 예약 관련 API

### 3.1 공간 예약
**POST** `/api/reservations`

#### 요청 데이터
```json
{
  "spaceId": 1,
  "startDate": "2024-01-01",
  "endDate": "2024-01-02",
  "boxRequirements": {
    "XS": 2,
    "S": 1,
    "M": 0,
    "L": 0,
    "XL": 0
  }
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "예약이 완료되었습니다.",
  "reservation": {
    "id": 1,
    "spaceId": 1,
    "spaceName": "강남역 보관함",
    "startDate": "2024-01-01",
    "endDate": "2024-01-02",
    "status": "CONFIRMED",
    "boxRequirements": {
      "XS": 2,
      "S": 1,
      "M": 0,
      "L": 0,
      "XL": 0
    },
    "totalPrice": 15000,
    "createdAt": "2024-01-01T09:00:00Z"
  }
}
```

### 3.2 예약 목록 조회
**GET** `/api/reservations`

#### 쿼리 파라미터
```
status: CONFIRMED (선택사항: PENDING, CONFIRMED, CHECKED_IN, COMPLETED, CANCELLED)
page: 0
size: 20
```

#### 응답 데이터
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "spaceId": 1,
        "spaceName": "강남역 보관함",
        "startDate": "2024-01-01",
        "endDate": "2024-01-02",
        "status": "CONFIRMED",
        "totalPrice": 15000,
        "createdAt": "2024-01-01T09:00:00Z"
      }
    ],
    "totalElements": 10,
    "totalPages": 1,
    "size": 20,
    "number": 0
  }
}
```

### 3.3 체크인
**POST** `/api/reservations/{reservationId}/checkin`

#### 요청 데이터 (multipart/form-data)
```
itemDescription: "노트북, 가방, 운동화"
checkInTime: "2024-01-01T10:00:00Z"
itemImage: [File]  // 물건 사진 1개
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "체크인이 완료되었습니다.",
  "reservation": {
    "id": 1,
    "status": "CHECKED_IN",
    "itemDescription": "노트북, 가방, 운동화",
    "checkInTime": "2024-01-01T10:00:00Z",
    "itemImageUrl": "https://s3.amazonaws.com/bucket/items/reservation_1_1.jpg"
  }
}
```

### 3.4 체크아웃
**POST** `/api/reservations/{reservationId}/checkout`

#### 요청 데이터
```json
{
  "checkOutTime": "2024-01-02T16:00:00Z",
  "itemCondition": "GOOD"
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "체크아웃이 완료되었습니다.",
  "reservation": {
    "id": 1,
    "status": "COMPLETED",
    "checkOutTime": "2024-01-02T16:00:00Z",
    "itemCondition": "GOOD"
  }
}
```

## 4. 리뷰 관련 API

### 4.1 공간 리뷰 작성
**POST** `/api/reviews/space`

#### 요청 데이터
```json
{
  "reservationId": 1,
  "rating": 5,
  "comment": "접근성이 좋고 깔끔했습니다."
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "리뷰가 작성되었습니다.",
  "review": {
    "id": 1,
    "reservationId": 1,
    "reviewType": "SPACE",
    "rating": 5,
    "comment": "접근성이 좋고 깔끔했습니다.",
    "createdAt": "2024-01-03T10:00:00Z"
  }
}
```

### 4.2 사용자 리뷰 작성
**POST** `/api/reviews/user`

#### 요청 데이터
```json
{
  "reservationId": 1,
  "rating": 4,
  "comment": "친절하고 신뢰할 수 있는 분이었습니다."
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "리뷰가 작성되었습니다.",
  "review": {
    "id": 2,
    "reservationId": 1,
    "reviewType": "USER",
    "rating": 4,
    "comment": "친절하고 신뢰할 수 있는 분이었습니다.",
    "createdAt": "2024-01-03T10:05:00Z"
  }
}
```

### 4.3 공간 리뷰 목록 조회
**GET** `/api/reviews/space/{spaceId}`

#### 쿼리 파라미터
```
page: 0
size: 20
```

#### 응답 데이터
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 1,
        "reviewer": {
          "id": 2,
          "nickname": "리뷰어",
          "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_2.jpg"
        },
        "rating": 5,
        "comment": "접근성이 좋고 깔끔했습니다.",
        "createdAt": "2024-01-03T10:00:00Z"
      }
    ],
    "totalElements": 23,
    "totalPages": 2,
    "size": 20,
    "number": 0,
    "averageRating": 4.5
  }
}
```

### 4.4 사용자 리뷰 목록 조회
**GET** `/api/reviews/user/{userId}`

#### 쿼리 파라미터
```
page: 0
size: 20
```

#### 응답 데이터
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 2,
        "reviewer": {
          "id": 1,
          "nickname": "리뷰어",
          "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1.jpg"
        },
        "rating": 4,
        "comment": "친절하고 신뢰할 수 있는 분이었습니다.",
        "createdAt": "2024-01-03T10:05:00Z"
      }
    ],
    "totalElements": 12,
    "totalPages": 1,
    "size": 20,
    "number": 0,
    "averageRating": 4.8
  }
}
```

## 5. 채팅 관련 API

### 5.1 채팅방 생성
**POST** `/api/chat/create`

#### 요청 데이터
```json
{
  "reservationId": 1
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "채팅방이 생성되었습니다.",
  "chatRoom": {
    "id": "channel_url_from_sendbird",
    "reservationId": 1,
    "participants": [
      {
        "id": 1,
        "nickname": "공간주인",
        "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1.jpg"
      },
      {
        "id": 2,
        "nickname": "이용자",
        "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_2.jpg"
      }
    ]
  }
}
```

## 6. 물품 관련 API

### 6.1 물품 등록
**POST** `/api/items`

#### 요청 데이터 (multipart/form-data)
```
spaceId: 1
name: "겨울 코트"
description: "두꺼운 겨울 코트입니다"
boxSize: "L"  // XS, S, M, L, XL
storageStartDate: "2025-01-20"
storageEndDate: "2025-02-20"
image: [File]  // 1개, 최대 10MB (JPEG, PNG, WebP), 최대 10MB (JPEG, PNG, WebP)
```

#### 응답 데이터
```json
{
  "id": 1,
  "name": "겨울 코트",
  "description": "두꺼운 겨울 코트입니다",
  "imageUrl": "https://s3.amazonaws.com/bucket/items/item_1.jpg",
  "boxSize": "L",
  "storageStartDate": "2025-01-20",
  "storageEndDate": "2025-02-20",
  "status": "PENDING",
  "spaceId": 1,
  "ownerId": 123,
  "createdAt": "2025-01-21T10:30:00",
  "updatedAt": "2025-01-21T10:30:00"
}
```

### 6.2 물품 조회
**GET** `/api/items/{itemId}`

#### 응답 데이터
```json
{
  "id": 1,
  "name": "겨울 코트",
  "description": "두꺼운 겨울 코트입니다",
  "imageUrl": "https://s3.amazonaws.com/bucket/items/item_1.jpg",
  "boxSize": "L",
  "storageStartDate": "2025-01-20",
  "storageEndDate": "2025-02-20",
  "status": "STORED",
  "space": {
    "id": 1,
    "name": "강남역 보관함",
    "address": "서울시 강남구 역삼동 110"
  },
  "owner": {
    "id": 123,
    "nickname": "사용자1",
    "profileImageUrl": "https://s3.amazonaws.com/bucket/profiles/user_123.jpg"
  },
  "createdAt": "2025-01-21T10:30:00",
  "updatedAt": "2025-01-21T10:30:00"
}
```

### 6.3 내 물품 목록 조회
**GET** `/api/items/my`

#### 쿼리 파라미터
```
status: PENDING  // PENDING, STORED, RETRIEVED (선택사항)
page: 0
size: 20
```

#### 응답 데이터
```json
{
  "content": [
    {
      "id": 1,
      "name": "겨울 코트",
      "imageUrl": "https://s3.amazonaws.com/bucket/items/item_1.jpg",
      "boxSize": "L",
      "status": "STORED",
      "spaceName": "강남역 보관함",
      "storageStartDate": "2025-01-20",
      "storageEndDate": "2025-02-20"
    }
  ],
  "totalElements": 10,
  "totalPages": 1,
  "size": 20,
  "number": 0
}
```

### 6.4 물품 상태 업데이트
**PUT** `/api/items/{itemId}/status`

#### 요청 데이터
```json
{
  "status": "STORED"  // PENDING, STORED, RETRIEVED
}
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "물품 상태가 업데이트되었습니다.",
  "item": {
    "id": 1,
    "status": "STORED",
    "updatedAt": "2025-01-21T11:00:00"
  }
}
```

### 6.5 물품 삭제
**DELETE** `/api/items/{itemId}`

#### 응답 데이터
```json
{
  "success": true,
  "message": "물품이 삭제되었습니다."
}
```

## 7. 사용자 관련 API

### 7.1 프로필 조회
**GET** `/api/users/profile`

#### 응답 데이터
```json
{
  "success": true,
  "data": {
    "id": 1,
    "phoneNumber": "010-1234-5678",
    "nickname": "닉네임",
    "birthDate": "1990-01-01",
    "gender": "MALE",
    "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1.jpg",
    "rating": 4.8,
    "reviewCount": 12,
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

### 7.2 프로필 수정
**PUT** `/api/users/profile`

#### 요청 데이터 (multipart/form-data)
```
nickname: "새닉네임" (선택사항)
profileImage: [File] (선택사항, 최대 10MB, JPEG/PNG/WebP, 1개만)
```

#### 응답 데이터
```json
{
  "success": true,
  "message": "프로필이 수정되었습니다.",
  "user": {
    "id": 1,
    "nickname": "새닉네임",
    "profileImageUrl": "https://s3.amazonaws.com/bucket/profile/user_1_new.jpg"
  }
}
```

## 공통 응답 형식

### 성공 응답
```json
{
  "success": true,
  "message": "성공 메시지",
  "data": { /* 응답 데이터 */ }
}
```

### 에러 응답
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "에러 메시지",
    "details": "상세 에러 정보"
  }
}
```

### 유효성 검증 에러
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "입력값이 올바르지 않습니다.",
    "fieldErrors": [
      {
        "field": "nickname",
        "message": "닉네임은 2-10자 사이여야 합니다."
      }
    ]
  }
}
```

## 인증 헤더

API 호출 시 다음 헤더를 포함해야 합니다:
```
Authorization: Bearer {access_token}
```

## 파일 업로드 제한사항

- **이미지 파일**: JPG, PNG, WebP 형식만 허용
- **최대 파일 크기**: 10MB
- **프로필 이미지**: 1개
- **공간 이미지**: 1개
- **물건 이미지**: 1개