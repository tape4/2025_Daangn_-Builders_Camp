# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is a Spring Boot backend application (Java 17) called "hankan" located in the `be/` directory. The project follows standard Spring Boot conventions with packages organized under `daangn.builders.hankan`.

Key components:
- **Main Application**: `be/src/main/java/daangn/builders/hankan/hankanApplication.java`
- **Configuration**: Security config and Swagger setup in `config/` package
- **Controllers**: Debug controller in `common/controller/` package

## Development Commands

### Building and Running
```bash
# Build the application
cd be && ./gradlew build

# Run tests
cd be && ./gradlew test

# Run the application
cd be && ./gradlew bootRun
```

### Database Setup
```bash
# Start database and monitoring services
cd be && docker-compose up -d

# The database will be initialized with init.sql creating HANKAN and TESTDB databases
```

### Testing
```bash
# Run all tests
cd be && ./gradlew test

# Run tests with specific profile
cd be && ./gradlew test -Dspring.profiles.active=test
```

## Infrastructure

The application uses Docker Compose for local development with:
- **MySQL**: Database on port 3306 (hankan/hankan credentials)
- **Redis**: Cache on port 6379
- **Prometheus**: Metrics collection on port 9090
- **Loki**: Log aggregation on port 3100
- **Grafana**: Monitoring dashboard on port 3000

## Dependencies

Key Spring Boot dependencies:
- Spring Boot Starter Web
- Spring Boot Starter Data JPA
- Spring Boot Starter Security
- SpringDoc OpenAPI (Swagger)
- Spring Boot Actuator with Prometheus metrics
- Loki logback appender for centralized logging
- MySQL connector
- Lombok for boilerplate reduction

## Development Notes

- Java 17 is required
- The application logs active profiles on startup
- Test profile is automatically set during test execution
- Security configuration is present but implementation details need exploration
- Swagger UI is available for API documentation


###

Project Overview

hankan is a Spring Boot (Java 17) backend service hosted in the be/ directory. It follows standard layered architecture under the base package daangn.builders.hankan and ships with a complete local infra stack (MySQL, Redis, Prometheus, Loki, Grafana) for development and observability.

Goals
•	Provide a clean, conventional HTTP API foundation that is easy to extend.
•	Use MySQL + Spring Data JPA for persistence and Redis for caching/ephemeral data.
•	Offer first-class observability: Prometheus metrics via Actuator, centralized logs via Loki, dashboards in Grafana.
•	Keep security explicit and minimal: separate Swagger access and application endpoints via Spring Security.

Current Capabilities (baseline)
•	Bootable Spring application with profiles and startup logging.
•	Swagger/OpenAPI UI available for interactive API docs.
•	Local infra via Docker Compose:
•	MySQL (port 3306, user/pass: hankan/hankan), initialized by init.sql (creates HANKAN, TESTDB)
•	Redis (6379)
•	Prometheus (9090), Loki (3100), Grafana (3000)
•	Basic controller(s) under common/controller/ (e.g., Debug endpoints).
•	Security configuration scaffold in config/ package.

Architectural Conventions
•	Packages
•	...config – security, Swagger/OpenAPI, infra configs
•	...common – shared utilities, constants, error handling
•	...domain/* – entities (JPA), repositories, services
•	...api/* – controllers, request/response DTOs, mappers
•	Persistence
•	JPA entities live in domain with Repository interfaces.
•	Keep entity relations explicit; prefer DTOs at API boundaries.
•	API Design
•	RESTful endpoints; annotate with SpringDoc for OpenAPI.
•	Validate inputs with jakarta.validation annotations; centralize errors with @RestControllerAdvice (if/when added).
•	Security
•	Keep Swagger/health endpoints accessible per config.
•	Guard application routes; prefer method-level annotations for fine-grained rules.
•	Observability
•	Expose Actuator metrics; scrape with Prometheus.
•	Send structured logs to Loki; build dashboards in Grafana.

How to Contribute (for Claude Code)
•	Use Java 17, Gradle wrapper, and existing dependency versions.
•	Place new code under the appropriate package (see conventions above).
•	When adding an endpoint:
1.	Define request/response DTOs (no entity leakage).
2.	Add OpenAPI annotations and sample payloads.
3.	Add validation and negative tests.
•	When adding persistence:
•	Create an Entity, Repository, and a service; include migration/init SQL if needed.
•	Keep configuration profile-aware (application-*.yml) and avoid hard-coding credentials/ports.
•	Ensure ./gradlew build and ./gradlew test pass; if the infra is required, run docker-compose up -d in be/.

Non-Goals (for now)
•	Reactive stack (WebFlux), multi-module split, or cloud-specific IaC are out of scope unless explicitly needed.

## Critical Development Rules

### 코드 변경 시 필수 체크리스트
모든 코드 변경 후 반드시 다음 3가지를 확인해야 합니다:

1. **컴파일 성공**: 코드가 정상적으로 컴파일되는지 확인
   ```bash
   cd be && ./gradlew build
   ```

2. **모든 테스트 통과**: 전체 테스트 스위트가 성공하는지 확인
   ```bash
   cd be && ./gradlew test
   ```

3. **애플리케이션 실행**: 애플리케이션이 정상적으로 실행되는지 확인
   ```bash
   cd be && ./gradlew bootRun
   ```

### 테스트 리팩토링 원칙

테스트 실패 시 다음 순서로 문제를 해결합니다:

1. **테스트 목적 검증**: 해당 테스트가 올바른 것을 검증하고 있는지 확인
   - 테스트 이름과 실제 테스트 내용이 일치하는지
   - 테스트가 비즈니스 요구사항을 정확히 반영하는지

2. **구현 로직 분석**: 테스트가 올바르다면 실제 구현 코드를 분석
   - 컨트롤러, 서비스, 리포지토리 계층별 로직 검토
   - 예외 처리 및 validation 로직 확인
   - 의존성 주입 및 설정 문제 확인

3. **근본 원인 해결**: 문제의 근본 원인을 찾아 수정
   - 단순히 @Disabled로 처리하지 말 것
   - 테스트 환경 설정 문제인 경우 설정 수정
   - 실제 버그인 경우 구현 코드 수정

### 테스트 작성 시 고려사항

- **Spring Boot 3.x 변경사항**: @MockBean → @MockitoBean 사용
- **통합 테스트**: @SpringBootTest 사용 시 실제 애플리케이션 컨텍스트 로드
- **단위 테스트**: @WebMvcTest, @DataJpaTest 등 슬라이스 테스트 활용
- **테스트 격리**: 각 테스트는 독립적으로 실행 가능해야 함

### 일반적인 문제 해결 방법

1. **Validation 오류**: 
   - @AutoConfigureMockMvc(addFilters = false)로 필터 비활성화 가능
   - 테스트용 validation 설정 별도 구성

2. **LoginArgumentResolver 문제**:
   - @MockitoBean으로 resolver mock 생성
   - resolveArgument 메서드 적절히 stubbing

3. **Multipart 테스트**:
   - MockMultipartFile 사용
   - Content-Type을 MediaType.MULTIPART_FORM_DATA로 설정

4. **트랜잭션 롤백**:
   - @Transactional 어노테이션으로 테스트 후 자동 롤백
   - 필요시 @Rollback(false)로 커밋 가능