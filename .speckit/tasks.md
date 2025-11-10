# 온라인 시험 플랫폼 개발 태스크

## 태스크 관리 방식

이 문서는 개발 계획서(`plan.md`)의 각 Phase를 실행 가능한 태스크로 세분화한 것입니다.
각 태스크는 체크박스로 관리하며, 완료 시 체크 표시를 합니다.

**태스크 우선순위**:
- 🔴 **P0 (Critical)**: 프로젝트의 핵심 기능, 반드시 완료 필요
- 🟡 **P1 (High)**: 중요한 기능, 우선적으로 완료
- 🟢 **P2 (Medium)**: 보조 기능, 시간이 허락하면 완료
- 🔵 **P3 (Low)**: Nice to have, 추후 추가 가능

---

## Phase 1: 기반 인프라 구축 (1-2주)

### 1.1 프로젝트 초기 설정

#### Frontend 설정 🔴 P0
- [x] pnpm 설치 (글로벌)
  ```bash
  npm install -g pnpm
  # 또는 Homebrew (macOS)
  brew install pnpm
  ```
- [x] Next.js 16 프로젝트 생성 (pnpm + Turbopack)
  ```bash
  pnpm create next-app@latest frontend --typescript --tailwind --app --turbo
  cd frontend
  ```
- [x] shadcn/ui 초기화
  ```bash
  pnpm dlx shadcn@latest init
  ```
- [x] Tailwind CSS 커스텀 설정 (`tailwind.config.js`)
  - 디자인 시스템 컬러 팔레트 적용 (핑크/코랄/노랑)
  - 커스텀 border-radius (1rem) 적용
- [x] TypeScript 설정 (`tsconfig.json`)
  - Path alias 설정 (`@/`, `@app/`, `@processes/`, `@pages/`, `@widgets/`, `@features/`, `@entities/`, `@shared/`)
  - Strict 모드 활성화
- [x] ESLint 설정 (`.eslintrc.json`)
- [x] Prettier 설정 (`.prettierrc`)
- [x] `.env.local` 파일 생성 (환경 변수 템플릿)
- [x] FSD 폴더 구조 생성
  - `src/app/` (Application Layer)
  - `src/processes/` (Processes Layer)
  - `src/pages/` (Pages Layer)
  - `src/widgets/` (Widgets Layer)
  - `src/features/` (Features Layer)
  - `src/entities/` (Entities Layer)
  - `src/shared/` (Shared Layer)

#### Backend 설정 🔴 P0
- [ ] API Gateway 프로젝트 생성 (Spring Initializr)
  - Dependencies: Spring Cloud Gateway, Spring Boot Actuator
- [ ] Auth Service 프로젝트 생성 (Spring Initializr)
  - Dependencies: Spring Web, Spring Data JPA, MySQL Driver, Spring Security, Lombok
- [ ] Core Service 프로젝트 생성 (Spring Initializr)
  - Dependencies: Spring Web, Spring Data JPA, PostgreSQL Driver, Spring Security, Lombok
- [ ] 각 서비스 `application.yml` 기본 설정
  - 서버 포트 설정 (Gateway: 8080, Auth: 8081, Core: 8082)
  - 데이터베이스 연결 정보 (환경 변수 사용)
- [ ] Lombok 설정 확인 (IDE 플러그인 설치)

#### Git 저장소 설정 🔴 P0
- [ ] Git 저장소 초기화
  ```bash
  git init
  ```
- [ ] `.gitignore` 파일 작성 (Node, Java, IDE 파일 제외)
- [ ] 브랜치 전략 수립
  - `main`: 프로덕션
  - `develop`: 개발
  - `feature/*`: 기능 개발
  - `hotfix/*`: 긴급 수정
- [ ] 초기 커밋 및 원격 저장소 푸시

---

### 1.2 Docker 환경 구성

#### Docker Compose 작성 🔴 P0
- [ ] `docker-compose.yml` 작성
  - MySQL 컨테이너 (Auth Service용)
  - PostgreSQL 컨테이너 (Core Service용)
  - Redis 컨테이너 (캐싱, 세션)
  - RabbitMQ 컨테이너 (메시지 큐)
  - API Gateway 컨테이너
  - Auth Service 컨테이너
  - Core Service 컨테이너
- [ ] 네트워크 설정 (모든 서비스가 같은 네트워크에 속하도록)
- [ ] 볼륨 설정 (데이터 영속성)
- [ ] 환경 변수 설정 (`.env` 파일)

#### Dockerfile 작성 🔴 P0
- [ ] API Gateway `Dockerfile`
  - Multi-stage build (Maven + OpenJDK)
- [ ] Auth Service `Dockerfile`
- [ ] Core Service `Dockerfile`
- [ ] Frontend `Dockerfile` (프로덕션용, 선택 사항)

#### 로컬 테스트 🔴 P0
- [ ] `docker-compose up` 실행 테스트
- [ ] MySQL 연결 확인 (MySQL Workbench 또는 CLI)
- [ ] PostgreSQL 연결 확인 (pgAdmin 또는 CLI)
- [ ] Redis 연결 확인 (Redis CLI)
- [ ] RabbitMQ 관리 콘솔 접속 확인 (http://localhost:15672)
- [ ] 각 Spring Boot 서비스 Health Check 확인 (Actuator)

---

### 1.3 API 명세 정의 (Springdoc OpenAPI)

#### Auth Service API 명세 🔴 P0
- [ ] Springdoc OpenAPI 의존성 추가 (`pom.xml`)
- [ ] API 명세 작성 (Controller에 어노테이션)
  - `POST /api/auth/register`: 회원가입
  - `POST /api/auth/verify-email`: 이메일 인증
  - `POST /api/auth/login`: 로그인
  - `POST /api/auth/refresh`: 토큰 갱신
  - `GET /api/auth/me`: 내 정보 조회
  - `PUT /api/auth/profile`: 프로필 수정
  - `POST /api/auth/password/reset`: 비밀번호 재설정
- [ ] Swagger UI 접속 확인 (http://localhost:8081/swagger-ui.html)
- [ ] OpenAPI Spec JSON 내보내기

#### Core Service API 명세 🔴 P0
- [ ] Springdoc OpenAPI 의존성 추가
- [ ] 그룹 관리 API 명세
  - `GET /api/groups`: 그룹 목록 조회
  - `POST /api/groups`: 그룹 생성
  - `GET /api/groups/{id}`: 그룹 상세 조회
  - `PUT /api/groups/{id}`: 그룹 수정
  - `DELETE /api/groups/{id}`: 그룹 삭제
  - `GET /api/groups/{id}/members`: 멤버 목록
  - `POST /api/groups/join`: 그룹 가입
  - `POST /api/groups/{id}/members`: 멤버 추가
  - `DELETE /api/groups/{id}/members/{userId}`: 멤버 강제 퇴장
  - `DELETE /api/groups/{id}/leave`: 그룹 탈퇴
  - `POST /api/groups/{id}/invite-code/regenerate`: 초대 코드 재발급
- [ ] 시험지 관리 API 명세
  - `GET /api/exams`: 시험지 목록
  - `POST /api/exams`: 시험지 생성
  - `GET /api/exams/{id}`: 시험지 상세
  - `PUT /api/exams/{id}`: 시험지 수정
  - `DELETE /api/exams/{id}`: 시험지 삭제
  - `POST /api/exams/{id}/copy`: 시험지 복사
- [ ] 문제 관리 API 명세
- [ ] 시험 응시 API 명세
- [ ] 성적 및 통계 API 명세
- [ ] Swagger UI 접속 확인 (http://localhost:8082/swagger-ui.html)

#### API 명세 공유 🟡 P1
- [ ] OpenAPI Spec JSON을 프론트엔드 팀과 공유
- [ ] API 명세 문서화 (README 또는 Notion)

---

### 1.4 데이터베이스 스키마 설계 및 마이그레이션

#### Auth Service (MySQL) 스키마 설계 🔴 P0
- [ ] ERD 작성 (draw.io, dbdiagram.io 등)
  - `users` 테이블
  - `auth_tokens` 테이블
  - `email_verifications` 테이블
- [ ] Flyway 의존성 추가 (`pom.xml`)
- [ ] Flyway 설정 (`application.yml`)
- [ ] V1 마이그레이션 스크립트 작성
  - `src/main/resources/db/migration/V1__init_auth_schema.sql`
  ```sql
  CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    role ENUM('TEACHER', 'STUDENT') NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE,
    provider ENUM('LOCAL', 'GOOGLE', 'NAVER') DEFAULT 'LOCAL',
    provider_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_provider_id (provider, provider_id)
  );

  CREATE TABLE auth_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    refresh_token VARCHAR(500) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_refresh_token (refresh_token)
  );

  CREATE TABLE email_verifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_user_id (user_id)
  );
  ```
- [ ] 마이그레이션 실행 확인
- [ ] 더미 데이터 삽입 (개발용, V2 마이그레이션)

#### Core Service (PostgreSQL) 스키마 설계 🔴 P0
- [ ] ERD 작성
  - `groups`, `group_members`, `exams`, `exam_groups`, `questions`, `submissions`, `answers`, `custom_columns`, `custom_scores` 테이블
- [ ] Flyway 의존성 추가
- [ ] Flyway 설정
- [ ] V1 마이그레이션 스크립트 작성
  - `src/main/resources/db/migration/V1__init_core_schema.sql`
  - `groups` 테이블 생성
  - `group_members` 테이블 생성 (FK 설정)
  - `exams` 테이블 생성
  - `exam_groups` 테이블 생성 (다대다)
  - `questions` 테이블 생성 (JSONB 필드 포함)
  - `submissions` 테이블 생성
  - `answers` 테이블 생성 (JSONB 필드 포함)
  - `custom_columns` 테이블 생성
  - `custom_scores` 테이블 생성
- [ ] 마이그레이션 실행 확인
- [ ] 더미 데이터 삽입 (개발용, V2 마이그레이션)

---

## Phase 2: 인증 및 사용자 관리 (2주)

### 2.1 Backend - Auth Service 구현

#### 엔티티 및 Repository 🔴 P0
- [ ] `User` 엔티티 작성
  - JPA 어노테이션 (`@Entity`, `@Table`, `@Id`, `@GeneratedValue`)
  - Lombok (`@Data`, `@NoArgsConstructor`, `@AllArgsConstructor`)
  - 필드: `id`, `email`, `password`, `name`, `role`, `emailVerified`, `provider`, `providerId`, `createdAt`, `updatedAt`
- [ ] `Role` enum 작성 (`TEACHER`, `STUDENT`)
- [ ] `AuthToken` 엔티티 작성
- [ ] `EmailVerification` 엔티티 작성
- [ ] `UserRepository` 인터페이스 작성 (JpaRepository 상속)
  - 커스텀 메서드: `findByEmail()`, `existsByEmail()`
- [ ] `AuthTokenRepository` 작성
- [ ] `EmailVerificationRepository` 작성

#### JWT 토큰 생성 및 검증 🔴 P0
- [ ] JWT 의존성 추가 (`pom.xml`: `io.jsonwebtoken:jjwt`)
- [ ] `JwtTokenProvider` 클래스 작성
  - `generateAccessToken(userId, role)`: Access Token 생성 (유효기간 15분)
  - `generateRefreshToken(userId)`: Refresh Token 생성 (유효기간 7일)
  - `validateToken(token)`: 토큰 유효성 검증
  - `getUserIdFromToken(token)`: 토큰에서 사용자 ID 추출
  - `getRoleFromToken(token)`: 토큰에서 역할 추출
- [ ] JWT Secret Key 설정 (`application.yml`, 환경 변수)

#### 회원가입 API 🔴 P0
- [ ] `RegisterRequest` DTO 작성
  - 필드: `email`, `password`, `passwordConfirm`, `name`, `role`
  - Validation 어노테이션 (`@Email`, `@NotBlank`, `@Size`)
- [ ] `AuthService.register()` 메서드 구현
  - 이메일 중복 확인
  - 비밀번호 해싱 (BCryptPasswordEncoder)
  - User 엔티티 저장
  - 이메일 인증 토큰 생성 및 저장
  - 이메일 인증 메일 발송 (비동기)
- [ ] `AuthController.register()` 엔드포인트 구현
  - `POST /api/auth/register`
  - 응답: `{ message: "회원가입 성공. 이메일을 확인해주세요." }`
- [ ] 에러 처리 (중복 이메일, 유효성 검증 실패)

#### 이메일 인증 🟡 P1
- [ ] `EmailService` 작성
  - SMTP 설정 (`application.yml`: Gmail 또는 SendGrid)
  - `sendVerificationEmail(email, token)` 메서드
  - 이메일 템플릿 (HTML)
- [ ] `AuthService.verifyEmail(token)` 메서드 구현
  - 토큰 유효성 확인 (만료 시간 체크)
  - User의 `emailVerified` 필드 업데이트
- [ ] `AuthController.verifyEmail()` 엔드포인트 구현
  - `POST /api/auth/verify-email`
  - 요청: `{ token: "..." }`
  - 응답: `{ message: "이메일 인증 완료" }`

#### 로그인 API 🔴 P0
- [ ] `LoginRequest` DTO 작성
  - 필드: `email`, `password`
- [ ] `LoginResponse` DTO 작성
  - 필드: `accessToken`, `refreshToken`, `user` (UserDto)
- [ ] `UserDto` 작성 (비밀번호 제외)
- [ ] `AuthService.login()` 메서드 구현
  - 이메일로 사용자 조회
  - 비밀번호 검증 (BCrypt)
  - 이메일 인증 여부 확인
  - Access Token + Refresh Token 생성
  - Refresh Token DB에 저장 (`auth_tokens` 테이블)
- [ ] `AuthController.login()` 엔드포인트 구현
  - `POST /api/auth/login`
  - 응답: `LoginResponse`
- [ ] 에러 처리 (이메일 없음, 비밀번호 틀림, 이메일 미인증)

#### SNS 로그인 (구글, 네이버) 🟡 P1
- [ ] Spring Security OAuth2 의존성 추가
- [ ] OAuth2 설정 (`application.yml`)
  - 구글 Client ID, Client Secret
  - 네이버 Client ID, Client Secret
- [ ] `CustomOAuth2UserService` 작성
  - OAuth2 사용자 정보 처리
  - 신규 사용자 자동 회원가입 (역할 선택 단계는 프론트엔드에서 처리)
- [ ] OAuth2 로그인 성공 핸들러
  - JWT 토큰 생성 및 응답
- [ ] `GET /api/auth/oauth2/google` 엔드포인트
- [ ] `GET /api/auth/oauth2/naver` 엔드포인트

#### 토큰 갱신 API 🔴 P0
- [ ] `RefreshRequest` DTO 작성
  - 필드: `refreshToken`
- [ ] `AuthService.refreshToken()` 메서드 구현
  - Refresh Token 유효성 검증
  - DB에서 Refresh Token 조회
  - 새 Access Token 생성
  - (선택) 새 Refresh Token 생성 및 기존 토큰 삭제
- [ ] `AuthController.refreshToken()` 엔드포인트 구현
  - `POST /api/auth/refresh`
  - 응답: `{ accessToken, refreshToken }`

#### 내 정보 조회/수정 API 🟡 P1
- [ ] `AuthService.getMe(userId)` 메서드 구현
- [ ] `AuthController.getMe()` 엔드포인트 구현
  - `GET /api/auth/me`
  - 인증 필요 (JWT)
  - 응답: `UserDto`
- [ ] `UpdateProfileRequest` DTO 작성
- [ ] `AuthService.updateProfile(userId, request)` 메서드 구현
- [ ] `AuthController.updateProfile()` 엔드포인트 구현
  - `PUT /api/auth/profile`

#### 비밀번호 찾기/재설정 API 🟢 P2
- [ ] `AuthService.requestPasswordReset(email)` 메서드 구현
  - 비밀번호 재설정 토큰 생성
  - 이메일 발송 (재설정 링크)
- [ ] `AuthController.requestPasswordReset()` 엔드포인트
  - `POST /api/auth/password/reset-request`
- [ ] `AuthService.resetPassword(token, newPassword)` 메서드 구현
- [ ] `AuthController.resetPassword()` 엔드포인트
  - `POST /api/auth/password/reset`

---

### 2.2 Backend - API Gateway JWT 검증

#### Spring Cloud Gateway 라우팅 설정 🔴 P0
- [ ] `application.yml`에 라우팅 규칙 작성
  ```yaml
  spring:
    cloud:
      gateway:
        routes:
          - id: auth-service
            uri: http://auth-service:8081
            predicates:
              - Path=/api/auth/**
          - id: core-service
            uri: http://core-service:8082
            predicates:
              - Path=/api/**
  ```
- [ ] 라우팅 테스트 (Postman 또는 curl)

#### JWT 검증 필터 🔴 P0
- [ ] `JwtAuthenticationFilter` 작성 (GatewayFilter)
  - Authorization 헤더에서 JWT 추출
  - JWT 유효성 검증 (`JwtTokenProvider` 재사용)
  - 유효하지 않으면 401 Unauthorized 응답
  - 유효하면 요청 헤더에 `X-User-Id`, `X-User-Role` 추가 (하위 서비스에서 사용)
- [ ] 공개 엔드포인트 예외 처리
  - `/api/auth/register`, `/api/auth/login`, `/api/auth/verify-email`, `/api/auth/refresh`는 JWT 검증 스킵
- [ ] 필터 적용 (GatewayFilterFactory 등록)

#### CORS 설정 🔴 P0
- [ ] `CorsConfig` 작성
  - Frontend 도메인 허용 (로컬: `http://localhost:3000`, 프로덕션: Vercel 도메인)
  - 허용 메서드: `GET, POST, PUT, DELETE, OPTIONS`
  - 허용 헤더: `Authorization, Content-Type`

#### Rate Limiting 🟢 P2
- [ ] Rate Limiting 필터 작성 (선택 사항)
  - IP 기반 요청 제한 (예: 100 req/min)
  - Redis 사용 (Token Bucket 알고리즘)

---

### 2.3 Frontend - 인증 UI 구현 (MSW)

#### MSW 설정 🔴 P0
- [ ] MSW 의존성 설치
  ```bash
  npm install msw --save-dev
  ```
- [ ] MSW 초기화
  ```bash
  npx msw init public/ --save
  ```
- [ ] `mocks/handlers.ts` 작성
  - `POST /api/auth/register` 핸들러
  - `POST /api/auth/login` 핸들러
  - `POST /api/auth/refresh` 핸들러
  - `GET /api/auth/me` 핸들러
- [ ] `mocks/browser.ts` 작성 (setupWorker)
- [ ] `app/layout.tsx`에서 MSW 활성화 (개발 모드만)

#### 회원가입 페이지 🔴 P0
- [ ] `app/(auth)/register/page.tsx` 작성
- [ ] 역할 선택 UI (Teacher/Student 라디오 버튼)
- [ ] 회원가입 폼 컴포넌트 (`components/auth/register-form.tsx`)
  - React Hook Form + Zod 스키마
  - 필드: 이메일, 비밀번호, 비밀번호 확인, 이름
  - 유효성 검증 에러 표시
- [ ] SNS 로그인 버튼 (UI만, 기능은 Phase 2 후반)
  - 구글 로그인 버튼 (구글 로고 + "구글로 시작하기")
  - 네이버 로그인 버튼 (네이버 로고 + "네이버로 시작하기")
- [ ] 회원가입 API 호출 (MSW)
- [ ] 성공 시 "이메일을 확인해주세요" 메시지 표시
- [ ] 에러 처리 (중복 이메일, 유효성 검증 실패)

#### 로그인 페이지 (모달) 🔴 P0
- [ ] `components/auth/login-modal.tsx` 작성
  - shadcn/ui Dialog 컴포넌트 사용
- [ ] 로그인 폼 (`components/auth/login-form.tsx`)
  - React Hook Form
  - 필드: 이메일, 비밀번호
  - 자동 로그인 체크박스 (선택 사항)
- [ ] SNS 로그인 버튼 (UI만)
- [ ] 비밀번호 찾기 링크
- [ ] 로그인 API 호출 (MSW)
- [ ] 성공 시 JWT 토큰 저장 (localStorage 또는 쿠키)
- [ ] 에러 처리 (이메일 없음, 비밀번호 틀림, 이메일 미인증)

#### 인증 상태 관리 (Zustand) 🔴 P0
- [ ] `stores/auth-store.ts` 작성
  ```typescript
  interface AuthState {
    user: User | null;
    isAuthenticated: boolean;
    login: (email: string, password: string) => Promise<void>;
    logout: () => void;
    refreshToken: () => Promise<void>;
  }
  ```
- [ ] 로그인 시 상태 업데이트
- [ ] 로그아웃 시 상태 초기화 및 토큰 삭제

#### JWT 토큰 관리 🔴 P0
- [ ] `lib/auth.ts` 작성
  - `getAccessToken()`: localStorage에서 Access Token 가져오기
  - `setAccessToken(token)`: Access Token 저장
  - `getRefreshToken()`: Refresh Token 가져오기
  - `setRefreshToken(token)`: Refresh Token 저장
  - `clearTokens()`: 모든 토큰 삭제
- [ ] Access Token 만료 시 자동 갱신 로직 (Axios Interceptor 또는 React Query)
  - 401 Unauthorized 응답 시 Refresh Token으로 갱신 시도
  - 갱신 실패 시 로그아웃

#### 보호된 라우트 🔴 P0
- [ ] `components/auth/protected-route.tsx` 작성
  - 인증되지 않은 사용자는 로그인 페이지로 리다이렉트
- [ ] Teacher/Student 전용 라우트 분리
  - `app/(dashboard)/teacher/*`: Teacher만 접근
  - `app/(dashboard)/student/*`: Student만 접근
- [ ] 역할 확인 미들웨어 (Next.js middleware 또는 클라이언트 체크)

#### API 클라이언트 설정 🔴 P0
- [ ] Axios 또는 Fetch API 래퍼 작성 (`lib/api.ts`)
  - Base URL 설정 (환경 변수)
  - Authorization 헤더 자동 추가 (Access Token)
  - 에러 처리 (401, 403, 500)
- [ ] TanStack Query 설정 (`app/providers.tsx`)
  - QueryClient 생성
  - QueryClientProvider 래핑

---

### 2.4 통합 테스트

#### Frontend → Backend 연동 🔴 P0
- [ ] MSW 비활성화 (실제 API 호출로 전환)
- [ ] 환경 변수 설정 (`.env.local`)
  ```
  NEXT_PUBLIC_API_URL=http://localhost:8080
  ```
- [ ] 회원가입 테스트
  - 폼 입력 → API 호출 → DB 저장 확인
  - 이메일 인증 메일 수신 확인 (MailHog 또는 Gmail)
- [ ] 이메일 인증 테스트
  - 이메일 링크 클릭 → 인증 완료
- [ ] 로그인 테스트
  - 로그인 → JWT 토큰 발급 → localStorage 저장
  - 인증된 상태로 `/api/auth/me` 호출 → 사용자 정보 반환
- [ ] 토큰 갱신 테스트
  - Access Token 만료 시뮬레이션 → Refresh Token으로 갱신
- [ ] 보호된 라우트 테스트
  - 미인증 사용자 → 로그인 페이지로 리다이렉트
  - Teacher가 Student 페이지 접근 시도 → 403 에러

#### 에러 시나리오 테스트 🟡 P1
- [ ] 이메일 중복 회원가입 시도
- [ ] 잘못된 비밀번호로 로그인 시도
- [ ] 이메일 미인증 사용자 로그인 시도
- [ ] 만료된 Refresh Token으로 갱신 시도

---

## Phase 3: 그룹 관리 (Teacher + Student) (2주)

### 3.1 Backend - Core Service 그룹 API

#### 엔티티 및 Repository 🔴 P0
- [ ] `Group` 엔티티 작성
  - 필드: `id`, `name`, `description`, `inviteCode`, `inviteCodeActive`, `ownerId`, `createdAt`, `updatedAt`
- [ ] `GroupMember` 엔티티 작성
  - 필드: `id`, `groupId`, `userId`, `role`, `joinedAt`
  - `role`: OWNER, TEACHER, STUDENT
- [ ] `GroupRepository` 작성
  - 커스텀 메서드: `findByInviteCode()`, `findByOwnerId()`
- [ ] `GroupMemberRepository` 작성
  - 커스텀 메서드: `findByGroupIdAndUserId()`, `findByGroupId()`, `existsByGroupIdAndUserId()`

#### 그룹 생성 API 🔴 P0
- [ ] `CreateGroupRequest` DTO 작성
- [ ] `GroupResponse` DTO 작성
- [ ] `GroupService.createGroup()` 메서드 구현
  - 초대 코드 자동 생성 (8자리 랜덤 영문/숫자)
  - 중복 확인 (루프)
  - Group 엔티티 저장
  - GroupMember 엔티티 저장 (role: OWNER)
- [ ] `GroupController.createGroup()` 엔드포인트
  - `POST /api/groups`
  - 인증 필요 (Teacher만)

#### 그룹 목록 조회 API 🔴 P0
- [ ] `GroupService.getMyGroups(userId)` 메서드 구현
  - GroupMember에서 userId로 그룹 목록 조회
- [ ] `GroupController.getMyGroups()` 엔드포인트
  - `GET /api/groups`

#### 그룹 상세 조회 API 🔴 P0
- [ ] `GroupService.getGroupDetail(groupId, userId)` 메서드 구현
  - 권한 확인 (멤버인지 체크)
- [ ] `GroupController.getGroupDetail()` 엔드포인트
  - `GET /api/groups/{id}`

#### 그룹 수정 API 🟡 P1
- [ ] `UpdateGroupRequest` DTO 작성
- [ ] `GroupService.updateGroup(groupId, userId, request)` 메서드 구현
  - 권한 확인 (Teacher 또는 Owner)
- [ ] `GroupController.updateGroup()` 엔드포인트
  - `PUT /api/groups/{id}`

#### 그룹 삭제 API 🟡 P1
- [ ] `GroupService.deleteGroup(groupId, userId)` 메서드 구현
  - 권한 확인 (Owner만)
  - Cascade 삭제 (GroupMember, Exam 등)
- [ ] `GroupController.deleteGroup()` 엔드포인트
  - `DELETE /api/groups/{id}`
  - 확인 모달 필요 (프론트엔드)

#### 그룹 멤버 목록 조회 API 🔴 P0
- [ ] `GroupMemberResponse` DTO 작성
- [ ] `GroupService.getGroupMembers(groupId, userId)` 메서드 구현
- [ ] `GroupController.getGroupMembers()` 엔드포인트
  - `GET /api/groups/{id}/members`

#### 그룹 가입 API (초대 코드) 🔴 P0
- [ ] `JoinGroupRequest` DTO 작성
  - 필드: `inviteCode`
- [ ] `GroupService.joinGroup(userId, inviteCode)` 메서드 구현
  - 초대 코드 유효성 검증
  - 이미 가입 여부 확인
  - GroupMember 엔티티 저장 (role: STUDENT)
- [ ] `GroupController.joinGroup()` 엔드포인트
  - `POST /api/groups/join`

#### 멤버 권한 변경 API 🟡 P1
- [ ] `ChangeMemberRoleRequest` DTO 작성
- [ ] `GroupService.changeMemberRole(groupId, targetUserId, newRole, requestUserId)` 메서드 구현
  - 권한 확인 (Teacher 또는 Owner)
  - Student → Teacher 승격만 허용
- [ ] `GroupController.changeMemberRole()` 엔드포인트
  - `POST /api/groups/{id}/members`

#### 멤버 강제 퇴장 API 🟡 P1
- [ ] `GroupService.removeMember(groupId, targetUserId, requestUserId)` 메서드 구현
  - 권한 확인 (Teacher 또는 Owner)
  - Owner는 삭제 불가
- [ ] `GroupController.removeMember()` 엔드포인트
  - `DELETE /api/groups/{id}/members/{userId}`

#### 그룹 탈퇴 API 🟡 P1
- [ ] `GroupService.leaveGroup(groupId, userId)` 메서드 구현
  - Owner는 탈퇴 불가 (그룹 삭제 필요)
- [ ] `GroupController.leaveGroup()` 엔드포인트
  - `DELETE /api/groups/{id}/leave`

#### 초대 코드 재발급 API 🟢 P2
- [ ] `GroupService.regenerateInviteCode(groupId, userId)` 메서드 구현
  - 권한 확인 (Owner만)
  - 새 초대 코드 생성 및 저장
- [ ] `GroupController.regenerateInviteCode()` 엔드포인트
  - `POST /api/groups/{id}/invite-code/regenerate`

---

### 3.2 Frontend - Teacher 그룹 관리 UI

#### 그룹 생성 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/groups/new/page.tsx` 작성
- [ ] 그룹 생성 폼 컴포넌트
  - 필드: 그룹 이름, 설명
  - React Hook Form
- [ ] 생성 API 호출
- [ ] 성공 시 자동 생성된 초대 코드 표시
- [ ] 그룹 목록으로 리다이렉트

#### 그룹 목록 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/groups/page.tsx` 작성
- [ ] 그룹 카드 컴포넌트 (`components/group/group-card.tsx`)
  - 그룹 이름, 멤버 수, 생성일 표시
  - 귀여운 일러스트 (올빼미 캐릭터)
- [ ] 그룹 목록 조회 API 호출 (TanStack Query)
- [ ] 검색 기능 (로컬 필터링)
- [ ] 정렬 기능 (최신순, 이름순, 멤버 수순)
- [ ] 빈 상태 UI (그룹이 없을 때)
  - "아직 그룹이 없어요! 첫 그룹을 만들어볼까요?" 메시지
  - "그룹 만들기" 버튼

#### 그룹 상세 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/groups/[id]/page.tsx` 작성
- [ ] 그룹 정보 표시
  - 그룹 이름, 설명, 멤버 수
- [ ] 그룹 수정 폼 (인라인 또는 모달)
- [ ] 초대 코드 섹션
  - 초대 코드 표시
  - 복사 버튼
  - 초대 링크 복사 버튼
  - 재발급 버튼
  - 비활성화 토글
- [ ] 그룹 삭제 버튼
  - 확인 모달 ("정말 삭제하시겠습니까? 되돌릴 수 없습니다.")
  - 삭제 API 호출

#### 그룹 멤버 관리 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/groups/[id]/members/page.tsx` 작성
- [ ] 멤버 테이블 컴포넌트 (shadcn/ui Table)
  - 컬럼: 이름, 이메일, 역할, 가입일, 작업
  - 검색 기능 (이름, 이메일)
  - 역할별 필터링
  - 정렬 (이름순, 가입일순)
- [ ] 권한 변경 드롭다운
  - Student → Teacher 승격 버튼
- [ ] 강제 퇴장 버튼
  - 확인 모달
  - 삭제 API 호출

---

### 3.3 Frontend - Student 그룹 관리 UI

#### 그룹 가입 페이지 🔴 P0
- [ ] `app/(dashboard)/student/groups/join/page.tsx` 작성
- [ ] 초대 코드 입력 폼
  - 큰 입력란 (8자리)
  - 자동 포커스
- [ ] 가입 API 호출
- [ ] 성공 시 그룹 목록으로 리다이렉트
- [ ] 에러 처리
  - "유효하지 않은 초대 코드입니다"
  - "이미 가입한 그룹입니다"
  - "이 그룹은 현재 신규 가입을 받지 않습니다"

#### 그룹 목록 페이지 🔴 P0
- [ ] `app/(dashboard)/student/groups/page.tsx` 작성
- [ ] 그룹 카드 리스트
  - 그룹 이름, 멤버 수, 활성 시험 수
  - 토끼 캐릭터 일러스트
- [ ] 그룹 목록 조회 API 호출
- [ ] 빈 상태 UI
  - "아직 가입한 그룹이 없어요! 초대 코드를 입력해볼까요?"
  - "그룹 가입하기" 버튼

#### 그룹 상세 페이지 🟡 P1
- [ ] `app/(dashboard)/student/groups/[id]/page.tsx` 작성
- [ ] 그룹 정보 조회 (읽기 전용)
  - 그룹 이름, 설명, 멤버 수
- [ ] 그룹 탈퇴 버튼
  - 확인 모달
  - 탈퇴 API 호출

---

### 3.4 통합 테스트

#### Teacher 플로우 테스트 🔴 P0
- [ ] 그룹 생성 → 초대 코드 확인
- [ ] 그룹 목록 조회 → 생성한 그룹 표시
- [ ] 그룹 상세 → 정보 수정 → 저장 → 변경 확인
- [ ] 초대 코드 복사 → 클립보드 확인
- [ ] 초대 코드 재발급 → 새 코드 생성 확인

#### Student 플로우 테스트 🔴 P0
- [ ] 초대 코드 입력 → 그룹 가입 → 그룹 목록에 표시
- [ ] 그룹 상세 조회
- [ ] 그룹 탈퇴 → 그룹 목록에서 제거

#### Teacher - Student 통합 테스트 🔴 P0
- [ ] Teacher: 멤버 목록 조회 → Student가 표시됨
- [ ] Teacher: Student → Teacher 권한 변경 → 변경 확인
- [ ] Teacher: Student 강제 퇴장 → Student의 그룹 목록에서 제거
- [ ] Teacher: 그룹 삭제 → Student의 그룹 목록에서 제거

---

## Phase 4: 시험지 및 문제 관리 (Teacher) (3주)

### 4.1 Backend - 시험지 API

#### 엔티티 및 Repository 🔴 P0
- [ ] `Exam` 엔티티 작성
  - 필드: `id`, `name`, `description`, `creatorId`, `startDate`, `endDate`, `timeLimit`, `shuffleQuestions`, `scoreReleaseType`, `allowRetake`, `retakeScoreType`, `createdAt`, `updatedAt`
- [ ] `ExamGroup` 엔티티 작성 (다대다 매핑)
- [ ] `ExamRepository` 작성
- [ ] `ExamGroupRepository` 작성

#### 시험지 생성 API 🔴 P0
- [ ] `CreateExamRequest` DTO 작성
- [ ] `ExamResponse` DTO 작성
- [ ] `ExamService.createExam()` 메서드 구현
  - 유효성 검증 (종료일 > 시작일)
  - Exam 엔티티 저장
  - ExamGroup 매핑 저장
- [ ] `ExamController.createExam()` 엔드포인트
  - `POST /api/exams`

#### 시험지 목록 조회 API 🔴 P0
- [ ] `ExamService.getMyExams(userId)` 메서드 구현
- [ ] `ExamController.getMyExams()` 엔드포인트
  - `GET /api/exams`

#### 시험지 상세 조회 API 🔴 P0
- [ ] `ExamService.getExamDetail(examId, userId)` 메서드 구현
- [ ] `ExamController.getExamDetail()` 엔드포인트
  - `GET /api/exams/{id}`

#### 시험지 수정 API 🟡 P1
- [ ] `UpdateExamRequest` DTO 작성
- [ ] `ExamService.updateExam()` 메서드 구현
- [ ] `ExamController.updateExam()` 엔드포인트
  - `PUT /api/exams/{id}`

#### 시험지 삭제 API 🟡 P1
- [ ] `ExamService.deleteExam()` 메서드 구현
  - 응시 기록 확인 (응시 기록이 있으면 삭제 제한)
- [ ] `ExamController.deleteExam()` 엔드포인트
  - `DELETE /api/exams/{id}`

#### 시험지 복사 API 🟢 P2
- [ ] `ExamService.copyExam()` 메서드 구현
  - 시험지 + 문제 전체 복사
- [ ] `ExamController.copyExam()` 엔드포인트
  - `POST /api/exams/{id}/copy`

---

### 4.2 Backend - 문제 API (8가지 유형)

#### 엔티티 및 Repository 🔴 P0
- [ ] `Question` 엔티티 작성
  - 필드: `id`, `examId`, `type`, `orderNum`, `content`, `mediaUrls` (JSONB), `points`, `answerData` (JSONB), `createdAt`, `updatedAt`
- [ ] `QuestionType` enum 작성
  - `MULTIPLE_CHOICE`, `OX`, `SHORT_ANSWER`, `ESSAY`, `ORDERING`, `MATCHING`, `FILL_BLANK`, `TABLE_COMPLETION`
- [ ] `QuestionRepository` 작성

#### 문제 DTO 설계 🔴 P0
- [ ] `CreateQuestionRequest` DTO 작성 (공통 필드)
  - 필드: `type`, `content`, `mediaUrls`, `points`
- [ ] 문제 유형별 DTO 작성
  - `MultipleChoiceData`: `{ choices: [...], correctAnswers: [...], allowMultiple: boolean, partialScore: boolean }`
  - `OXData`: `{ correctAnswer: "O" | "X" }`
  - `ShortAnswerData`: `{ correctAnswers: [...], caseSensitive: boolean, ignoreSpaces: boolean }`
  - `EssayData`: `{ modelAnswer: string, gradingCriteria: string }`
  - `OrderingData`: `{ items: [...], correctOrder: [...], partialScore: boolean }`
  - `MatchingData`: `{ leftItems: [...], rightItems: [...], correctPairs: [...], partialScore: boolean }`
  - `FillBlankData`: `{ template: string, blanks: [{ index, correctAnswers, points }] }`
  - `TableCompletionData`: `{ rows, cols, cells: [{ row, col, value, isBlank, correctAnswer, points }] }`

#### 문제 생성 API 🔴 P0
- [ ] `QuestionService.createQuestion()` 메서드 구현
  - 유형별 answerData JSON 저장
  - 유효성 검증 (유형별 데이터 검증)
- [ ] `QuestionController.createQuestion()` 엔드포인트
  - `POST /api/exams/{examId}/questions`

#### 문제 목록 조회 API 🔴 P0
- [ ] `QuestionService.getQuestionsByExam(examId)` 메서드 구현
- [ ] `QuestionController.getQuestionsByExam()` 엔드포인트
  - `GET /api/exams/{examId}/questions`

#### 문제 상세 조회 API 🔴 P0
- [ ] `QuestionService.getQuestionDetail(questionId)` 메서드 구현
- [ ] `QuestionController.getQuestionDetail()` 엔드포인트
  - `GET /api/questions/{id}`

#### 문제 수정 API 🟡 P1
- [ ] `UpdateQuestionRequest` DTO 작성
- [ ] `QuestionService.updateQuestion()` 메서드 구현
- [ ] `QuestionController.updateQuestion()` 엔드포인트
  - `PUT /api/questions/{id}`

#### 문제 삭제 API 🟡 P1
- [ ] `QuestionService.deleteQuestion()` 메서드 구현
- [ ] `QuestionController.deleteQuestion()` 엔드포인트
  - `DELETE /api/questions/{id}`

#### 문제 순서 변경 API 🟡 P1
- [ ] `ReorderQuestionsRequest` DTO 작성
  - 필드: `questionIds` (순서대로 배열)
- [ ] `QuestionService.reorderQuestions()` 메서드 구현
- [ ] `QuestionController.reorderQuestions()` 엔드포인트
  - `PUT /api/exams/{examId}/questions/reorder`

---

### 4.3 Backend - 파일 저장소 (AWS S3)

#### AWS S3 설정 🟡 P1
- [ ] AWS S3 버킷 생성
- [ ] IAM 사용자 생성 및 권한 부여 (S3 PutObject, GetObject)
- [ ] Access Key, Secret Key 발급
- [ ] 환경 변수 설정 (`application.yml`)

#### FileStorageService 구현 🟡 P1
- [ ] AWS SDK 의존성 추가 (`pom.xml`: `software.amazon.awssdk:s3`)
- [ ] `FileStorageService` 클래스 작성
  - `uploadImage(MultipartFile file)`: 이미지 업로드 → URL 반환
  - `uploadAudio(MultipartFile file)`: 음성 파일 업로드 → URL 반환
  - 파일 유효성 검증 (MIME 타입, 크기)
  - 파일명 생성 (UUID + 확장자)
- [ ] `FileController` 엔드포인트 작성
  - `POST /api/files/upload/image`
  - `POST /api/files/upload/audio`

---

### 4.4 Frontend - 시험지 생성 UI

#### 시험지 생성 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/exams/new/page.tsx` 작성
- [ ] 시험지 기본 정보 폼
  - 필드: 이름, 설명, 대상 그룹 (다중 선택)
  - React Hook Form
- [ ] 응시 설정 폼
  - 응시 기간 (DatePicker)
  - 제한 시간 (숫자 입력)
  - 문제 순서 섞기 (체크박스)
  - 성적 공개 시점 (라디오 버튼)
  - 재응시 허용 (체크박스)
- [ ] 생성 API 호출
- [ ] 성공 시 문제 추가 페이지로 리다이렉트

#### 시험지 목록 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/exams/page.tsx` 작성
- [ ] 시험지 카드 컴포넌트
  - 시험지 이름, 대상 그룹, 응시 기간, 문제 수, 총 배점, 응시 인원, 상태
  - 상태별 색상 코딩 (예정: 파란색, 진행 중: 초록색, 종료: 회색)
- [ ] 시험지 목록 조회 API 호출
- [ ] 검색, 필터링 (상태별), 정렬
- [ ] 빈 상태 UI

#### 시험지 상세 페이지 🔴 P0
- [ ] `app/(dashboard)/teacher/exams/[id]/page.tsx` 작성
- [ ] 시험지 정보 표시 및 수정 폼
- [ ] 문제 목록 섹션
  - 추가된 문제 카드 리스트
  - 순서, 유형, 본문 미리보기, 배점 표시
  - 전체 배점 합계 표시
- [ ] "문제 추가" 버튼 → 문제 에디터로 이동

---

### 4.5 Frontend - 문제 에디터 (8가지 유형)

#### 문제 유형 선택 UI 🔴 P0
- [ ] `app/(dashboard)/teacher/exams/[id]/questions/new/page.tsx` 작성
- [ ] 문제 유형 선택 UI
  - 8가지 유형 버튼 (아이콘 + 이름)
  - 호버 시 설명 툴팁

#### 공통 에디터 컴포넌트 🔴 P0
- [ ] `components/exam/question-editor.tsx` 작성
- [ ] 리치 텍스트 에디터 (Tiptap)
  - 툴바: 볼드, 이탤릭, 밑줄, 정렬, 링크
  - 이미지 업로드 (Drag & Drop)
  - 동영상 URL 삽입
  - 음성 파일 업로드
- [ ] 배점 입력 필드
- [ ] 미디어 첨부 섹션
  - 이미지 업로드 버튼 → S3 업로드 → URL 저장
  - 동영상 URL 입력란
  - 음성 파일 업로드 버튼

#### 문제 유형별 에디터 🔴 P0
- [ ] **객관식** (`components/exam/question-types/multiple-choice.tsx`)
  - 선택지 추가/삭제 버튼
  - 선택지 입력란 (텍스트 또는 이미지)
  - 정답 선택 (체크박스)
  - 복수 정답 설정 토글
  - 부분 점수 설정 토글
- [ ] **O/X** (`components/exam/question-types/ox-question.tsx`)
  - 정답 선택 (라디오 버튼: O, X)
- [ ] **주관식(단답)** (`components/exam/question-types/short-answer.tsx`)
  - 정답 입력란 (여러 개 추가 가능)
  - 대소문자 구분 체크박스
  - 공백 무시 체크박스
- [ ] **서술형** (`components/exam/question-types/essay.tsx`)
  - 모범 답안 입력 (텍스트 영역)
  - 채점 기준 입력 (텍스트 영역)
- [ ] **순서 배열** (`components/exam/question-types/ordering.tsx`)
  - 보기 추가 버튼 (텍스트 또는 이미지)
  - 드래그 앤 드롭으로 정답 순서 설정 (@dnd-kit)
  - 부분 점수 설정 토글
- [ ] **짝짓기** (`components/exam/question-types/matching.tsx`)
  - 왼쪽 보기 추가
  - 오른쪽 보기 추가
  - 짝 연결 UI (선 그리기 또는 드롭다운)
  - 부분 점수 설정 토글
- [ ] **빈칸 채우기** (`components/exam/question-types/fill-blank.tsx`)
  - 본문에 빈칸 삽입 버튼 (`{{빈칸1}}`)
  - 각 빈칸별 정답 입력
  - 빈칸별 배점 입력
- [ ] **표 완성** (`components/exam/question-types/table-completion.tsx`)
  - 표 크기 설정 (행 × 열)
  - 표 생성 및 편집 UI
  - 빈칸 셀 지정 (클릭)
  - 각 빈칸 셀 정답 입력
  - 셀별 배점 입력

#### 문제 미리보기 🟡 P1
- [ ] 미리보기 모달 컴포넌트
  - 학생이 보는 화면과 동일하게 표시
  - 정답은 숨김

#### 문제 저장/수정/삭제 🔴 P0
- [ ] 저장 버튼 → API 호출 → 문제 목록으로 리다이렉트
- [ ] 수정 모드 (기존 문제 로드)
- [ ] 삭제 버튼 (확인 모달)

---

### 4.6 Frontend - 문제 목록 관리

#### 문제 목록 컴포넌트 🔴 P0
- [ ] `components/exam/question-list.tsx` 작성
- [ ] 문제 카드 표시
  - 순서, 유형 아이콘, 본문 미리보기 (첫 100자), 배점
- [ ] 드래그 앤 드롭으로 순서 변경 (@dnd-kit)
  - 순서 변경 API 호출
- [ ] 문제 수정 버튼 (문제 에디터로 이동)
- [ ] 문제 삭제 버튼 (확인 모달)
- [ ] 전체 배점 합계 표시
- [ ] 문제 검색 (본문 키워드)
- [ ] 문제 필터링 (유형별)

---

### 4.7 통합 테스트

#### 시험지 생성 플로우 🔴 P0
- [ ] 시험지 생성 → 기본 정보 입력 → 응시 설정 → 저장 → 문제 추가 페이지로 이동
- [ ] 8가지 유형의 문제 각각 추가 → 저장 → 문제 목록에 표시

#### 파일 업로드 테스트 🟡 P1
- [ ] 이미지 업로드 → S3 업로드 → URL 반환 → 문제에 첨부
- [ ] 음성 파일 업로드 → S3 업로드 → URL 반환 → 문제에 첨부

#### 문제 순서 변경 테스트 🟡 P1
- [ ] 드래그 앤 드롭으로 문제 순서 변경 → API 호출 → 순서 업데이트 확인

---

## Phase 5: 시험 응시 (Student) (2주)

### 5.1 Backend - 시험 응시 API

#### 응시 가능 시험 목록 API 🔴 P0
- [ ] `ExamService.getAvailableExams(userId)` 메서드 구현
  - 내가 속한 그룹의 진행 중인 시험 조회
  - 응시 여부 확인 (Submission 테이블)
  - 재응시 허용 여부 확인
- [ ] `ExamController.getAvailableExams()` 엔드포인트
  - `GET /api/exams/available`

#### 시험 시작 API 🔴 P0
- [ ] `Submission` 엔티티 작성
- [ ] `SubmissionService.startExam(examId, userId)` 메서드 구현
  - 응시 가능 여부 확인 (기간, 재응시)
  - Submission 생성 (status: `IN_PROGRESS`)
  - 시작 시간 기록
  - 문제 순서 셔플 (설정 시) → Submission에 순서 저장 (JSON)
- [ ] `SubmissionController.startExam()` 엔드포인트
  - `POST /api/exams/{examId}/start`
  - 응답: `{ submissionId, questions: [...] }`

#### 문제 조회 API (응시 중) 🔴 P0
- [ ] `SubmissionService.getSubmissionQuestions(submissionId, userId)` 메서드 구현
  - 권한 확인 (본인만)
  - 문제 본문 + 선택지 반환 (정답은 숨김)
  - 셔플된 순서대로 반환
- [ ] `SubmissionController.getSubmissionQuestions()` 엔드포인트
  - `GET /api/submissions/{submissionId}/questions`

#### 임시 저장 API 🔴 P0
- [ ] `Answer` 엔티티 작성
- [ ] `AnswerService.saveAnswer(submissionId, questionId, answerData)` 메서드 구현
  - Answer 엔티티 생성 또는 업데이트 (Upsert)
  - `score`, `isCorrect`는 null (채점 전)
- [ ] `AnswerController.saveAnswer()` 엔드포인트
  - `POST /api/submissions/{submissionId}/answers`
  - 요청: `{ questionId, answerData }`

#### 시험 제출 API 🔴 P0
- [ ] `SubmissionService.submitExam(submissionId, userId)` 메서드 구현
  - Submission 상태 변경: `SUBMITTED`
  - 제출 시간 기록
  - 소요 시간 계산 (submitted_at - started_at)
  - 자동 채점 트리거 (비동기, RabbitMQ 이벤트 발행)
- [ ] `SubmissionController.submitExam()` 엔드포인트
  - `POST /api/submissions/{submissionId}/submit`

---

### 5.2 Backend - 자동 채점 로직

#### GradingService 구현 🔴 P0
- [ ] `GradingService` 클래스 작성
  - `gradeSubmission(submissionId)`: 제출된 시험 전체 채점
  - 각 문제 유형별로 `AutoGrader` 호출
  - Answer 엔티티 업데이트 (`score`, `isCorrect`, `gradedAt`)
  - 서술형 문제는 스킵 (수동 채점 대기)

#### AutoGrader 인터페이스 및 구현체 🔴 P0
- [ ] `AutoGrader` 인터페이스 작성
  ```java
  public interface AutoGrader {
    GradingResult grade(Question question, Answer answer);
  }
  ```
- [ ] `MultipleChoiceGrader` 구현
  - 학생 답안과 정답 비교
  - 복수 정답 시 부분 점수 계산
- [ ] `OXGrader` 구현 (MultipleChoice와 유사)
- [ ] `ShortAnswerGrader` 구현
  - 복수 정답 목록과 비교
  - 대소문자/공백 처리
- [ ] `OrderingGrader` 구현
  - 정답 순서와 비교
  - 부분 점수 계산 (올바른 위치 개수 / 전체)
- [ ] `MatchingGrader` 구현
  - 정답 짝과 비교
  - 부분 점수 계산 (올바른 짝 개수 / 전체)
- [ ] `FillBlankGrader` 구현
  - 각 빈칸별로 채점
  - 부분 점수 합산
- [ ] `TableCompletionGrader` 구현
  - 각 셀별로 채점
  - 부분 점수 합산

#### RabbitMQ 이벤트 처리 🟡 P1
- [ ] `ExamSubmittedEvent` 작성
- [ ] `ExamGradedEvent` 작성
- [ ] RabbitMQ 메시지 발행 (시험 제출 시)
- [ ] RabbitMQ 메시지 수신 (채점 완료 시)
  - 이메일 알림 발송 (선택 사항)

---

### 5.3 Frontend - 시험 응시 UI

#### 응시 가능 시험 목록 페이지 🔴 P0
- [ ] `app/(dashboard)/student/exams/page.tsx` 작성
- [ ] 시험지 카드 리스트
  - 시험지 이름, 대상 그룹, 응시 기간, 문제 수, 총 배점, 남은 시간
  - 응시 상태별 색상 (미응시: 초록색, 응시 완료: 회색)
- [ ] 필터링 (전체, 응시 가능, 응시 완료)
- [ ] 정렬 (종료 임박순, 최신순)
- [ ] "시험 시작" 버튼

#### 시험 시작 페이지 🔴 P0
- [ ] `app/(dashboard)/student/exams/[id]/start/page.tsx` 작성
- [ ] 시험 정보 표시
  - 시험지 이름, 제한 시간, 총 문제 수, 배점
- [ ] 주의사항 표시
  - "시험 중 페이지를 나가면 경고가 표시됩니다"
  - "제출 후 수정할 수 없습니다"
  - "답안은 자동으로 저장됩니다"
- [ ] "시험 시작" 버튼 → 시험 진행 페이지로 이동

#### 시험 진행 페이지 🔴 P0
- [ ] `app/(dashboard)/student/exams/[id]/take/page.tsx` 작성
- [ ] **상단 헤더**:
  - 타이머 (실시간 카운트다운, `exam-timer.tsx` 컴포넌트)
    - 남은 시간 5분 미만 시 빨간색 + 깜빡임
  - 현재 문제 번호 / 전체 문제 수
  - 임시 저장 버튼
  - 제출 버튼
- [ ] **좌측 사이드바** (선택 사항):
  - 문제 번호 네비게이션 (1, 2, 3, ...)
  - 답안 작성 여부 표시 (작성됨: 파란색, 미작성: 회색)
- [ ] **메인 영역**:
  - 문제 본문 (이미지, 동영상, 음성 포함)
  - 답안 입력 UI (유형별)
- [ ] **하단**:
  - "이전 문제" / "다음 문제" 버튼

#### 문제 유형별 답안 입력 UI 🔴 P0
- [ ] **객관식**: 라디오 버튼 (단일) 또는 체크박스 (복수)
- [ ] **O/X**: 'O' / 'X' 큰 버튼
- [ ] **주관식(단답)**: 텍스트 입력란 (한 줄)
- [ ] **서술형**: 텍스트 영역 (여러 줄, 최소 10줄)
- [ ] **순서 배열**: 드래그 앤 드롭 (@dnd-kit)
- [ ] **짝짓기**: 선으로 연결 또는 드래그 앤 드롭
- [ ] **빈칸 채우기**: 본문 내 입력란 (각 빈칸)
- [ ] **표 완성**: 표 형태, 빈칸 셀에 입력란

#### 답안 자동 임시 저장 🔴 P0
- [ ] Zustand 스토어 (`stores/exam-store.ts`) 작성
  - 답안 데이터 저장
- [ ] 3분마다 자동 임시 저장 (API 호출)
- [ ] 문제 이동 시 임시 저장
- [ ] localStorage 백업 (페이지 새로고침 대비)

#### 페이지 이탈 경고 🔴 P0
- [ ] `beforeunload` 이벤트 리스너 등록
  - "정말로 나가시겠습니까? 작성 중인 답안이 있습니다."

#### 제한 시간 종료 시 자동 제출 🔴 P0
- [ ] 타이머 0초 도달 시 자동 제출 API 호출

---

### 5.4 Frontend - 시험 제출

#### 제출 확인 모달 🔴 P0
- [ ] 모달 컴포넌트 작성
- [ ] 미작성 문제 개수 표시
- [ ] "정말로 제출하시겠습니까?" 메시지
- [ ] 귀여운 캐릭터 일러스트
- [ ] "취소" / "제출" 버튼

#### 제출 완료 페이지 🔴 P0
- [ ] `app/(dashboard)/student/exams/[id]/submitted/page.tsx` 작성
- [ ] "제출이 완료되었습니다!" 메시지
- [ ] 별 캐릭터가 박수치는 애니메이션
- [ ] 제출 일시 표시
- [ ] 성적 공개 시점 안내
- [ ] "내 성적 보기" 버튼 (공개 시) 또는 "시험 목록으로 돌아가기" 버튼

---

### 5.5 통합 테스트

#### 시험 응시 플로우 🔴 P0
- [ ] 시험 목록 조회 → 시험 시작 → 문제 풀이 → 임시 저장 → 제출
- [ ] 8가지 유형 답안 입력 테스트
- [ ] 타이머 종료 시 자동 제출 테스트
- [ ] 페이지 이탈 경고 테스트

#### 자동 채점 테스트 🔴 P0
- [ ] 제출 후 Backend 로그에서 채점 결과 확인
- [ ] 객관식: 정답/오답 채점 확인
- [ ] 순서 배열: 부분 점수 계산 확인
- [ ] 빈칸 채우기: 각 빈칸별 채점 확인

---

## Phase 6: 성적 및 통계 (Teacher + Student) (3주)

*(생략 - 너무 길어지므로 요약)*

### 주요 태스크
- [ ] Backend: 성적 조회 API, 통계 API, 커스텀 컬럼 API
- [ ] Frontend: Teacher 대시보드, 성적 테이블, 차트 (Recharts)
- [ ] Frontend: Student 내 성적, 상세 리포트, 개인 통계

---

## Phase 7: 서술형 채점 관리 (Teacher) (1주)

- [ ] Backend: 채점 대기 목록 API, 서술형 채점 API
- [ ] Frontend: 채점 관리 페이지, 채점 화면

---

## Phase 8: 최적화 및 고도화 (2주)

- [ ] Frontend: 코드 스플리팅, 이미지 최적화, React Query 캐싱
- [ ] Backend: 데이터베이스 쿼리 최적화, Redis 캐싱
- [ ] 보안: XSS, CSRF, SQL Injection 방지
- [ ] UX: 로딩 스켈레톤, 에러 바운더리, 토스트 알림
- [ ] 테스트: E2E 테스트 (Playwright), 유닛 테스트 (JUnit)

---

## Phase 9: 배포 및 모니터링 (1주)

- [ ] Frontend: Vercel 배포
- [ ] Backend: AWS EC2/ECS 배포
- [ ] CI/CD: GitHub Actions 파이프라인
- [ ] 모니터링: Sentry, CloudWatch

---

*태스크 최종 업데이트: 2025-11-05*
