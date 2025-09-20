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