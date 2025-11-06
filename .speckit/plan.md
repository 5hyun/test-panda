# 온라인 시험 플랫폼 개발 계획서

## 목차
1. [기술 스택](#1-기술-스택)
2. [아키텍처](#2-아키텍처)
3. [프로젝트 구조](#3-프로젝트-구조)
4. [개발 단계별 계획](#4-개발-단계별-계획)
5. [API 설계](#5-api-설계)
6. [데이터베이스 스키마](#6-데이터베이스-스키마)
7. [보안 전략](#7-보안-전략)
8. [배포 전략](#8-배포-전략)
9. [마일스톤](#9-마일스톤)

---

## 1. 기술 스택

### 1.1 Frontend

| 기술 | 버전 | 용도 |
|-----|------|------|
| **Next.js** | 15 (App Router) | React 프레임워크, SSR/SSG |
| **React** | 19 | UI 라이브러리 |
| **TypeScript** | 5.x | 타입 안전성 |
| **Tailwind CSS** | 3.x | 유틸리티 우선 CSS 프레임워크 |
| **shadcn/ui** | latest | UI 컴포넌트 라이브러리 |
| **Zustand** | 4.x | 가벼운 글로벌 상태 관리 |
| **TanStack Query** | 5.x | 서버 상태 및 캐시 관리 |
| **React Hook Form** | 7.x | 폼 관리 및 유효성 검사 |
| **Zod** | 3.x | 스키마 기반 유효성 검증 |
| **MSW** | 2.x | API 모킹 (개발 단계) |
| **Recharts** | 2.x | 차트 라이브러리 (성적 시각화) |
| **@dnd-kit** | latest | 드래그 앤 드롭 (순서 배열, 짝짓기 문제) |
| **Tiptap** | 2.x | 리치 텍스트 에디터 (문제 출제) |

### 1.2 Backend (MSA)

| 기술 | 버전 | 용도 |
|-----|------|------|
| **Java** | 17 | 프로그래밍 언어 |
| **Spring Boot** | 3.x | 백엔드 프레임워크 |
| **Spring Data JPA** | 3.x | ORM |
| **Spring Security** | 6.x | 인증/인가 |
| **JWT** | - | 토큰 기반 인증 |
| **Spring Cloud Gateway** | 4.x | API 게이트웨이 |
| **RabbitMQ** | 3.x | 메시지 브로커 (비동기 통신) |
| **MySQL** | 8.x | 인증 서비스 DB |
| **PostgreSQL** | 15.x | 핵심 서비스 DB |
| **Redis** | 7.x | 캐싱, 세션 관리 |
| **Springdoc OpenAPI** | 2.x | API 문서 자동화 |
| **Lombok** | 1.18.x | 보일러플레이트 코드 감소 |

### 1.3 DevOps

| 기술 | 버전 | 용도 |
|-----|------|------|
| **Docker** | latest | 컨테이너화 |
| **Docker Compose** | latest | 로컬 개발 환경 |
| **GitHub Actions** | - | CI/CD 파이프라인 |
| **AWS S3** | - | 파일 저장소 (이미지, 음성) |
| **Nginx** | latest | 리버스 프록시 (선택 사항) |

---

## 2. 아키텍처

### 2.1 전체 아키텍처 개요

```
┌─────────────────────────────────────────────────────────┐
│                     Frontend Layer                      │
│                  Next.js 15 (App Router)                │
│              (단일 애플리케이션, Vercel 배포)              │
└─────────────────────────────────────────────────────────┘
                            │
                            │ HTTPS
                            ▼
┌─────────────────────────────────────────────────────────┐
│                   API Gateway Layer                     │
│             Spring Cloud Gateway (Port 8080)            │
│         (라우팅, 로드밸런싱, JWT 검증, Rate Limiting)       │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┴───────────────────┐
        ▼                                       ▼
┌──────────────────┐                   ┌──────────────────┐
│  Auth Service    │                   │  Core Service    │
│  (Spring Boot)   │◄─────RabbitMQ────►│  (Spring Boot)   │
│   Port: 8081     │                   │   Port: 8082     │
│                  │                   │                  │
│  - 회원가입/로그인  │                   │  - 그룹 관리       │
│  - JWT 발급/검증   │                   │  - 시험지 관리     │
│  - 이메일 인증     │                   │  - 문제 관리       │
│  - 사용자 프로필   │                   │  - 응시 관리       │
│                  │                   │  - 성적/통계       │
└──────────────────┘                   └──────────────────┘
        │                                       │
        ▼                                       ▼
┌──────────────────┐                   ┌──────────────────┐
│      MySQL       │                   │   PostgreSQL     │
│   (Port 3306)    │                   │   (Port 5432)    │
│                  │                   │                  │
│  - users         │                   │  - groups        │
│  - roles         │                   │  - exams         │
│  - auth_tokens   │                   │  - questions     │
│                  │                   │  - submissions   │
│                  │                   │  - answers       │
└──────────────────┘                   └──────────────────┘

┌─────────────────────────────────────────────────────────┐
│                  Shared Infrastructure                  │
│                                                         │
│  - Redis (캐싱, 세션): Port 6379                         │
│  - RabbitMQ (메시지 큐): Port 5672                       │
│  - AWS S3 (파일 저장소)                                  │
└─────────────────────────────────────────────────────────┘
```

### 2.2 MSA 서비스 분리 전략

#### 2.2.1 Auth Service (인증 서비스)
**책임**:
- 사용자 회원가입 (로컬, SNS)
- 이메일 인증
- 로그인 (JWT 발급)
- JWT 토큰 검증 및 갱신
- 사용자 프로필 관리
- 비밀번호 찾기/재설정

**데이터베이스**: MySQL
- `users`: 사용자 기본 정보
- `roles`: 사용자 역할 (Teacher, Student)
- `auth_tokens`: Refresh Token 관리
- `email_verifications`: 이메일 인증 토큰

**API 엔드포인트**:
- `POST /api/auth/register`: 회원가입
- `POST /api/auth/login`: 로그인
- `POST /api/auth/verify-email`: 이메일 인증
- `POST /api/auth/refresh`: 토큰 갱신
- `GET /api/auth/me`: 내 정보 조회
- `PUT /api/auth/profile`: 프로필 수정
- `POST /api/auth/password/reset`: 비밀번호 재설정

#### 2.2.2 Core Service (핵심 서비스)
**책임**:
- 그룹 생성/관리
- 그룹 멤버 관리
- 시험지 생성/관리
- 문제 생성/수정/삭제 (8가지 유형)
- 시험 응시 관리
- 답안 제출 및 자동 채점
- 서술형 수동 채점
- 성적 조회 및 통계
- 커스텀 컬럼 관리

**데이터베이스**: PostgreSQL
- `groups`: 그룹 정보
- `group_members`: 그룹 멤버 (다대다)
- `exams`: 시험지 정보
- `exam_groups`: 시험-그룹 매핑 (다대다)
- `questions`: 문제 정보
- `submissions`: 시험 제출 정보
- `answers`: 답안 정보
- `custom_columns`: 커스텀 컬럼 (출결, 수행평가 등)
- `custom_scores`: 커스텀 점수

**API 엔드포인트**:
- **그룹**: `GET/POST/PUT/DELETE /api/groups`
- **그룹 멤버**: `GET/POST/DELETE /api/groups/{id}/members`
- **시험**: `GET/POST/PUT/DELETE /api/exams`
- **문제**: `GET/POST/PUT/DELETE /api/exams/{id}/questions`
- **응시**: `POST /api/exams/{id}/start`, `POST /api/submissions/{id}/submit`
- **답안**: `POST /api/submissions/{id}/answers`, `PUT /api/answers/{id}/grade`
- **성적**: `GET /api/exams/{id}/scores`, `GET /api/users/{id}/scores`
- **통계**: `GET /api/exams/{id}/statistics`, `GET /api/questions/{id}/statistics`

#### 2.2.3 서비스 간 통신

**동기 통신 (REST API)**:
- API Gateway를 통한 라우팅
- Core Service가 Auth Service의 사용자 정보 조회 필요 시 REST API 호출

**비동기 통신 (RabbitMQ)**:
- **이벤트 예시**:
  - `UserRegistered`: 회원가입 완료 시 Auth → Core (사용자 프로필 동기화)
  - `ExamSubmitted`: 시험 제출 시 Core → Auth (사용자 활동 로그)
  - `ExamGraded`: 채점 완료 시 Core → Auth (이메일 알림 발송)

**메시지 큐 패턴**:
- **Publish/Subscribe**: 이벤트 기반 통신
- **Work Queue**: 대용량 채점 작업 분산 처리 (향후 확장)

### 2.3 API Gateway 역할

**Spring Cloud Gateway 기능**:
1. **라우팅**:
   - `/api/auth/**` → Auth Service (8081)
   - `/api/**` → Core Service (8082)

2. **JWT 검증**:
   - 모든 요청의 JWT 토큰 검증 (공개 엔드포인트 제외)
   - Auth Service와 공유된 JWT Secret으로 검증

3. **Rate Limiting**:
   - IP 기반 요청 제한 (DDoS 방지)
   - 사용자별 API 호출 제한

4. **CORS 처리**:
   - Frontend 도메인만 허용

5. **로깅 및 모니터링**:
   - 모든 요청/응답 로그 기록
   - 응답 시간 메트릭 수집

---

## 3. 프로젝트 구조

### 3.1 Frontend 구조 (Next.js 15 App Router)

```
frontend/
├── app/                          # App Router (Next.js 15)
│   ├── (auth)/                   # 인증 관련 레이아웃 그룹
│   │   ├── login/
│   │   │   └── page.tsx          # 로그인 페이지
│   │   └── register/
│   │       └── page.tsx          # 회원가입 페이지
│   ├── (dashboard)/              # 대시보드 레이아웃 그룹
│   │   ├── teacher/              # Teacher 대시보드
│   │   │   ├── groups/           # 그룹 관리
│   │   │   │   ├── page.tsx
│   │   │   │   ├── [id]/
│   │   │   │   │   └── page.tsx  # 그룹 상세
│   │   │   ├── exams/            # 시험지 관리
│   │   │   │   ├── page.tsx
│   │   │   │   ├── [id]/
│   │   │   │   │   ├── page.tsx  # 시험지 상세
│   │   │   │   │   ├── edit/
│   │   │   │   │   │   └── page.tsx # 문제 추가/수정
│   │   │   │   │   └── scores/
│   │   │   │   │       └── page.tsx # 성적 관리
│   │   │   ├── grading/          # 채점 관리
│   │   │   │   └── page.tsx
│   │   │   └── dashboard/
│   │   │       └── page.tsx      # Teacher 대시보드 홈
│   │   └── student/              # Student 대시보드
│   │       ├── groups/           # 그룹 관리
│   │       │   └── page.tsx
│   │       ├── exams/            # 시험 응시
│   │       │   ├── page.tsx
│   │       │   └── [id]/
│   │       │       ├── start/
│   │       │       │   └── page.tsx # 시험 시작
│   │       │       └── take/
│   │       │           └── page.tsx # 시험 진행
│   │       ├── scores/           # 내 성적
│   │       │   └── page.tsx
│   │       └── dashboard/
│   │           └── page.tsx      # Student 대시보드 홈
│   ├── layout.tsx                # 루트 레이아웃
│   ├── page.tsx                  # 홈 (랜딩 페이지)
│   └── api/                      # API 라우트 (선택 사항, BFF 패턴)
├── components/                   # 재사용 가능한 컴포넌트
│   ├── ui/                       # shadcn/ui 컴포넌트
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── modal.tsx
│   │   ├── table.tsx
│   │   └── ...
│   ├── auth/                     # 인증 관련 컴포넌트
│   │   ├── login-form.tsx
│   │   └── register-form.tsx
│   ├── exam/                     # 시험 관련 컴포넌트
│   │   ├── question-editor.tsx   # 문제 에디터
│   │   ├── question-types/       # 문제 유형별 컴포넌트
│   │   │   ├── multiple-choice.tsx
│   │   │   ├── ox-question.tsx
│   │   │   ├── short-answer.tsx
│   │   │   ├── essay.tsx
│   │   │   ├── ordering.tsx
│   │   │   ├── matching.tsx
│   │   │   ├── fill-blank.tsx
│   │   │   └── table-completion.tsx
│   │   └── exam-timer.tsx        # 시험 타이머
│   ├── charts/                   # 차트 컴포넌트
│   │   ├── score-histogram.tsx
│   │   ├── question-stats.tsx
│   │   └── student-radar.tsx
│   └── layout/                   # 레이아웃 컴포넌트
│       ├── header.tsx
│       ├── sidebar.tsx
│       └── footer.tsx
├── lib/                          # 유틸리티 및 설정
│   ├── api.ts                    # API 클라이언트 (Axios 또는 Fetch)
│   ├── auth.ts                   # 인증 유틸리티
│   ├── utils.ts                  # 공통 유틸리티
│   └── constants.ts              # 상수 정의
├── hooks/                        # 커스텀 훅
│   ├── use-auth.ts               # 인증 관련 훅
│   ├── use-exam.ts               # 시험 관련 훅
│   └── use-debounce.ts           # 디바운스 훅
├── stores/                       # Zustand 스토어
│   ├── auth-store.ts             # 인증 상태
│   ├── exam-store.ts             # 시험 상태 (응시 중 임시 저장)
│   └── ui-store.ts               # UI 상태 (모달, 사이드바)
├── types/                        # TypeScript 타입 정의
│   ├── user.ts
│   ├── group.ts
│   ├── exam.ts
│   ├── question.ts
│   └── api.ts
├── mocks/                        # MSW 모킹 (개발 단계)
│   ├── handlers.ts               # API 핸들러
│   └── browser.ts                # MSW 브라우저 설정
├── public/                       # 정적 파일
│   ├── images/
│   └── icons/
├── styles/                       # 전역 스타일
│   └── globals.css               # Tailwind CSS + 커스텀 스타일
├── .env.local                    # 환경 변수 (로컬)
├── .env.production               # 환경 변수 (프로덕션)
├── next.config.js                # Next.js 설정
├── tailwind.config.js            # Tailwind CSS 설정
├── tsconfig.json                 # TypeScript 설정
└── package.json
```

### 3.2 Backend 구조 (MSA)

```
backend/
├── api-gateway/                  # Spring Cloud Gateway
│   ├── src/main/java/com/exam/gateway/
│   │   ├── config/
│   │   │   ├── GatewayConfig.java       # 라우팅 설정
│   │   │   ├── SecurityConfig.java      # JWT 검증 설정
│   │   │   └── CorsConfig.java          # CORS 설정
│   │   ├── filter/
│   │   │   ├── JwtAuthenticationFilter.java # JWT 필터
│   │   │   └── RateLimitFilter.java     # Rate Limiting 필터
│   │   └── GatewayApplication.java
│   ├── src/main/resources/
│   │   ├── application.yml               # Gateway 설정
│   │   └── application-dev.yml           # 개발 환경 설정
│   ├── Dockerfile
│   └── pom.xml
│
├── auth-service/                 # 인증 서비스 (MySQL)
│   ├── src/main/java/com/exam/auth/
│   │   ├── controller/
│   │   │   └── AuthController.java       # 인증 API
│   │   ├── service/
│   │   │   ├── AuthService.java
│   │   │   ├── UserService.java
│   │   │   └── EmailService.java         # 이메일 발송
│   │   ├── repository/
│   │   │   ├── UserRepository.java
│   │   │   └── AuthTokenRepository.java
│   │   ├── entity/
│   │   │   ├── User.java
│   │   │   ├── Role.java
│   │   │   ├── AuthToken.java
│   │   │   └── EmailVerification.java
│   │   ├── dto/
│   │   │   ├── LoginRequest.java
│   │   │   ├── RegisterRequest.java
│   │   │   ├── LoginResponse.java
│   │   │   └── UserDto.java
│   │   ├── security/
│   │   │   ├── JwtTokenProvider.java     # JWT 생성/검증
│   │   │   ├── CustomUserDetailsService.java
│   │   │   └── SecurityConfig.java
│   │   ├── event/
│   │   │   └── UserRegisteredEvent.java  # RabbitMQ 이벤트
│   │   ├── exception/
│   │   │   └── GlobalExceptionHandler.java
│   │   └── AuthServiceApplication.java
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   ├── application-dev.yml
│   │   └── db/migration/                 # Flyway 마이그레이션
│   │       └── V1__init_auth_schema.sql
│   ├── Dockerfile
│   └── pom.xml
│
├── core-service/                 # 핵심 서비스 (PostgreSQL)
│   ├── src/main/java/com/exam/core/
│   │   ├── controller/
│   │   │   ├── GroupController.java
│   │   │   ├── ExamController.java
│   │   │   ├── QuestionController.java
│   │   │   ├── SubmissionController.java
│   │   │   └── ScoreController.java
│   │   ├── service/
│   │   │   ├── GroupService.java
│   │   │   ├── ExamService.java
│   │   │   ├── QuestionService.java
│   │   │   ├── SubmissionService.java
│   │   │   ├── GradingService.java       # 자동 채점
│   │   │   ├── StatisticsService.java    # 통계 계산
│   │   │   └── FileStorageService.java   # S3 파일 업로드
│   │   ├── repository/
│   │   │   ├── GroupRepository.java
│   │   │   ├── GroupMemberRepository.java
│   │   │   ├── ExamRepository.java
│   │   │   ├── QuestionRepository.java
│   │   │   ├── SubmissionRepository.java
│   │   │   ├── AnswerRepository.java
│   │   │   └── CustomColumnRepository.java
│   │   ├── entity/
│   │   │   ├── Group.java
│   │   │   ├── GroupMember.java
│   │   │   ├── Exam.java
│   │   │   ├── ExamGroup.java
│   │   │   ├── Question.java
│   │   │   ├── Submission.java
│   │   │   ├── Answer.java
│   │   │   ├── CustomColumn.java
│   │   │   └── CustomScore.java
│   │   ├── dto/
│   │   │   ├── request/
│   │   │   │   ├── CreateGroupRequest.java
│   │   │   │   ├── CreateExamRequest.java
│   │   │   │   ├── CreateQuestionRequest.java
│   │   │   │   └── SubmitAnswerRequest.java
│   │   │   ├── response/
│   │   │   │   ├── GroupResponse.java
│   │   │   │   ├── ExamResponse.java
│   │   │   │   ├── QuestionResponse.java
│   │   │   │   ├── ScoreResponse.java
│   │   │   │   └── StatisticsResponse.java
│   │   │   └── QuestionTypeDto.java      # 문제 유형별 DTO
│   │   ├── grading/
│   │   │   ├── AutoGrader.java           # 자동 채점 인터페이스
│   │   │   ├── MultipleChoiceGrader.java
│   │   │   ├── ShortAnswerGrader.java
│   │   │   ├── OrderingGrader.java
│   │   │   ├── MatchingGrader.java
│   │   │   ├── FillBlankGrader.java
│   │   │   └── TableCompletionGrader.java
│   │   ├── event/
│   │   │   ├── ExamSubmittedEvent.java
│   │   │   └── ExamGradedEvent.java
│   │   ├── exception/
│   │   │   └── GlobalExceptionHandler.java
│   │   └── CoreServiceApplication.java
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   ├── application-dev.yml
│   │   └── db/migration/                 # Flyway 마이그레이션
│   │       └── V1__init_core_schema.sql
│   ├── Dockerfile
│   └── pom.xml
│
└── docker-compose.yml            # 로컬 개발 환경 (전체 서비스)
```

---

## 4. 개발 단계별 계획

### Phase 1: 기반 인프라 구축 (1-2주)

#### 목표
- 개발 환경 설정 및 프로젝트 초기 구조 생성
- API 명세 정의
- Docker Compose로 로컬 개발 환경 구축

#### 작업 목록

**1.1 프로젝트 초기 설정**
- [ ] Frontend: Next.js 15 프로젝트 생성
  - shadcn/ui 초기화
  - Tailwind CSS 설정
  - TypeScript 설정
  - ESLint, Prettier 설정
- [ ] Backend: Spring Boot 프로젝트 생성 (3개 서비스)
  - API Gateway 프로젝트
  - Auth Service 프로젝트
  - Core Service 프로젝트
- [ ] Git 저장소 초기화 및 브랜치 전략 수립
  - `main`, `develop`, `feature/*` 브랜치

**1.2 Docker 환경 구성**
- [ ] `docker-compose.yml` 작성
  - MySQL 컨테이너
  - PostgreSQL 컨테이너
  - Redis 컨테이너
  - RabbitMQ 컨테이너
  - API Gateway 컨테이너
  - Auth Service 컨테이너
  - Core Service 컨테이너
- [ ] 각 서비스별 `Dockerfile` 작성
- [ ] 로컬에서 `docker-compose up` 테스트

**1.3 API 명세 정의 (Springdoc OpenAPI)**
- [ ] Auth Service API 명세 작성
  - `/api/auth/register`, `/api/auth/login` 등
- [ ] Core Service API 명세 작성
  - 그룹, 시험, 문제, 응시, 성적 API
- [ ] Swagger UI로 API 문서 확인
- [ ] OpenAPI Spec을 Frontend 개발자와 공유

**1.4 데이터베이스 스키마 설계 및 마이그레이션**
- [ ] MySQL 스키마 설계 (Auth Service)
  - `users`, `roles`, `auth_tokens`, `email_verifications` 테이블
- [ ] PostgreSQL 스키마 설계 (Core Service)
  - `groups`, `exams`, `questions`, `submissions`, `answers` 등 테이블
- [ ] Flyway 마이그레이션 스크립트 작성
- [ ] 초기 더미 데이터 삽입 (개발용)

---

### Phase 2: 인증 및 사용자 관리 (2주)

#### 목표
- Auth Service 구현 (회원가입, 로그인, JWT)
- Frontend 인증 UI 구현 (MSW 활용)
- API Gateway JWT 검증 구현

#### 작업 목록

**2.1 Backend - Auth Service 구현**
- [ ] 사용자 엔티티 및 Repository 구현
  - `User`, `Role`, `AuthToken` 엔티티
- [ ] JWT 토큰 생성 및 검증 로직 구현
  - `JwtTokenProvider` 클래스
- [ ] 회원가입 API 구현
  - 로컬 회원가입 (이메일, 비밀번호, 역할 선택)
  - 이메일 인증 메일 발송
- [ ] 로그인 API 구현
  - Access Token + Refresh Token 발급
- [ ] 이메일 인증 API 구현
  - 인증 링크 클릭 시 계정 활성화
- [ ] SNS 로그인 구현 (구글, 네이버 OAuth)
- [ ] 비밀번호 찾기/재설정 API 구현
- [ ] 내 정보 조회/수정 API 구현

**2.2 Backend - API Gateway JWT 검증**
- [ ] Spring Cloud Gateway 라우팅 설정
  - `/api/auth/**` → Auth Service
  - `/api/**` → Core Service
- [ ] JWT 검증 필터 구현
  - `JwtAuthenticationFilter`
  - 공개 엔드포인트 제외 (회원가입, 로그인)
- [ ] CORS 설정
- [ ] Rate Limiting 설정 (선택 사항)

**2.3 Frontend - 인증 UI 구현 (MSW)**
- [ ] MSW 핸들러 작성
  - `/api/auth/register`, `/api/auth/login` 모킹
- [ ] 회원가입 페이지 구현
  - 역할 선택 (Teacher/Student)
  - 로컬 회원가입 폼 (React Hook Form + Zod)
  - SNS 로그인 버튼 (UI만)
- [ ] 로그인 페이지 (모달) 구현
  - 로컬 로그인 폼
  - SNS 로그인 버튼 (UI만)
  - 비밀번호 찾기 링크
- [ ] 인증 상태 관리 (Zustand)
  - `auth-store.ts`: 로그인 상태, 사용자 정보
- [ ] JWT 토큰 저장 및 자동 갱신 로직
  - `lib/auth.ts`: localStorage 또는 HttpOnly 쿠키
- [ ] 보호된 라우트 구현
  - 미인증 사용자 접근 시 로그인 페이지로 리다이렉트

**2.4 통합 테스트**
- [ ] Frontend에서 MSW를 실제 Backend API로 전환
- [ ] 회원가입 → 이메일 인증 → 로그인 → 내 정보 조회 플로우 테스트
- [ ] JWT 토큰 검증 및 갱신 테스트

---

### Phase 3: 그룹 관리 (Teacher + Student) (2주)

#### 목표
- Core Service의 그룹 관련 API 구현
- Frontend 그룹 관리 UI 구현 (Teacher/Student)

#### 작업 목록

**3.1 Backend - Core Service 그룹 API**
- [ ] 그룹 엔티티 및 Repository 구현
  - `Group`, `GroupMember` 엔티티
- [ ] 그룹 생성 API (Teacher)
  - 초대 코드 자동 생성
- [ ] 그룹 목록 조회 API (Teacher/Student 공통)
- [ ] 그룹 상세 조회 API
- [ ] 그룹 수정 API (Teacher)
- [ ] 그룹 삭제 API (Teacher, Owner만)
- [ ] 그룹 멤버 목록 조회 API
- [ ] 그룹 멤버 추가 (초대 코드 입력, Student)
- [ ] 그룹 멤버 권한 변경 API (Teacher → Co-Teacher)
- [ ] 그룹 멤버 강제 퇴장 API (Teacher)
- [ ] 그룹 탈퇴 API (Student)
- [ ] 초대 코드 재발급 API (Teacher)
- [ ] 초대 코드 비활성화 API (Teacher)

**3.2 Frontend - Teacher 그룹 관리 UI**
- [ ] 그룹 생성 페이지
  - 그룹 이름, 설명 입력 폼
  - 자동 생성된 초대 코드 표시
- [ ] 그룹 목록 페이지
  - 그룹 카드 리스트
  - 검색, 정렬 기능
- [ ] 그룹 상세 페이지
  - 그룹 정보 수정 폼
  - 초대 코드 복사/재발급/비활성화 버튼
  - 그룹 삭제 버튼 (확인 모달)
- [ ] 그룹 멤버 관리 페이지
  - 멤버 테이블 (이름, 이메일, 역할, 가입일)
  - 권한 변경 드롭다운
  - 강제 퇴장 버튼 (확인 모달)

**3.3 Frontend - Student 그룹 관리 UI**
- [ ] 그룹 가입 페이지
  - 초대 코드 입력 폼
  - 유효성 검증 및 에러 메시지
- [ ] 그룹 목록 페이지
  - 내가 속한 그룹 카드 리스트
- [ ] 그룹 상세 페이지
  - 그룹 정보 조회 (읽기 전용)
  - 그룹 탈퇴 버튼 (확인 모달)

**3.4 통합 테스트**
- [ ] Teacher: 그룹 생성 → 초대 코드 공유 → 멤버 관리
- [ ] Student: 초대 코드로 가입 → 그룹 목록 확인 → 탈퇴

---

### Phase 4: 시험지 및 문제 관리 (Teacher) (3주)

#### 목표
- Core Service의 시험지 및 문제 API 구현 (8가지 문제 유형)
- Frontend 시험지 생성 및 문제 에디터 구현

#### 작업 목록

**4.1 Backend - 시험지 API**
- [ ] 시험지 엔티티 및 Repository 구현
  - `Exam`, `ExamGroup` 엔티티
- [ ] 시험지 생성 API
  - 응시 기간, 제한 시간, 셔플, 성적 공개 설정
- [ ] 시험지 목록 조회 API (Teacher)
- [ ] 시험지 상세 조회 API
- [ ] 시험지 수정 API
- [ ] 시험지 삭제 API (응시 기록 없을 때만)
- [ ] 시험지 복사 API

**4.2 Backend - 문제 API (8가지 유형)**
- [ ] 문제 엔티티 및 Repository 구현
  - `Question` 엔티티
  - `answerData` JSON 필드 (유형별 정답 데이터)
- [ ] 문제 생성 API
  - 문제 유형별 DTO 설계
  - 파일 업로드 (이미지, 음성) → S3 연동
- [ ] 문제 목록 조회 API (시험지별)
- [ ] 문제 상세 조회 API
- [ ] 문제 수정 API
- [ ] 문제 삭제 API
- [ ] 문제 순서 변경 API (드래그 앤 드롭)
- [ ] 문제 유형별 정답 데이터 검증 로직
  - 객관식: 선택지 2-10개, 정답 1개 이상
  - 주관식(단답): 복수 정답, 대소문자/공백 설정
  - 서술형: 모범 답안, 채점 기준
  - 순서 배열: 보기 2개 이상, 정답 순서
  - 짝짓기: 왼쪽/오른쪽 보기, 짝 매핑
  - 빈칸 채우기: 빈칸 위치, 각 빈칸 정답
  - 표 완성: 표 크기, 빈칸 셀, 각 셀 정답

**4.3 Backend - 파일 저장소 (AWS S3)**
- [ ] S3 버킷 생성 및 IAM 설정
- [ ] `FileStorageService` 구현
  - 이미지 업로드 (presigned URL 또는 직접 업로드)
  - 음성 파일 업로드
  - 파일 URL 반환

**4.4 Frontend - 시험지 생성 UI**
- [ ] 시험지 생성 페이지
  - 기본 정보 입력 폼 (이름, 설명, 대상 그룹)
  - 응시 설정 폼 (기간, 제한 시간, 셔플, 성적 공개)
- [ ] 시험지 목록 페이지
  - 시험지 카드 리스트 (상태별 색상 코딩)
  - 검색, 필터링, 정렬 기능
- [ ] 시험지 상세 페이지
  - 시험지 정보 수정 폼
  - 문제 목록 표시
  - 문제 추가 버튼 → 문제 에디터로 이동

**4.5 Frontend - 문제 에디터 (8가지 유형)**
- [ ] 문제 유형 선택 UI (드롭다운 또는 버튼)
- [ ] 공통 에디터 컴포넌트
  - 리치 텍스트 에디터 (Tiptap)
  - 이미지 업로드 (Drag & Drop)
  - 동영상 URL 삽입
  - 음성 파일 업로드
  - 배점 입력
- [ ] 문제 유형별 에디터 컴포넌트
  - **객관식**: 선택지 추가/삭제, 정답 선택 (체크박스), 복수 정답 설정
  - **O/X**: 정답 선택 (라디오 버튼)
  - **주관식(단답)**: 정답 입력 (여러 개), 대소문자/공백 설정
  - **서술형**: 모범 답안 입력, 채점 기준 입력
  - **순서 배열**: 보기 추가 (텍스트/이미지), 정답 순서 드래그 앤 드롭, 부분 점수 설정
  - **짝짓기**: 왼쪽/오른쪽 보기 추가, 짝 연결 UI, 부분 점수 설정
  - **빈칸 채우기**: 본문에 빈칸 삽입 (`{{빈칸1}}`), 각 빈칸 정답 입력, 빈칸별 배점
  - **표 완성**: 표 크기 설정, 빈칸 셀 지정, 각 셀 정답 입력, 셀별 배점
- [ ] 문제 미리보기 기능
- [ ] 문제 저장/수정/삭제 버튼

**4.6 Frontend - 문제 목록 관리**
- [ ] 문제 목록 컴포넌트
  - 문제 순서, 유형, 본문 미리보기, 배점 표시
  - 드래그 앤 드롭으로 순서 변경 (@dnd-kit)
  - 문제 수정/삭제 버튼
- [ ] 전체 배점 합계 표시
- [ ] 문제 검색/필터링 (유형별)

**4.7 통합 테스트**
- [ ] Teacher: 시험지 생성 → 8가지 유형의 문제 추가 → 저장 → 미리보기
- [ ] 파일 업로드 (이미지, 음성) 테스트
- [ ] 문제 순서 변경 테스트

---

### Phase 5: 시험 응시 (Student) (2주)

#### 목표
- Core Service의 시험 응시 및 답안 제출 API 구현
- Frontend 시험 응시 UI 구현 (8가지 문제 유형 답안 입력)

#### 작업 목록

**5.1 Backend - 시험 응시 API**
- [ ] 응시 가능 시험 목록 조회 API (Student)
  - 내가 속한 그룹의 진행 중인 시험
  - 응시 여부, 재응시 허용 여부 확인
- [ ] 시험 시작 API
  - `Submission` 생성 (상태: `in_progress`)
  - 시작 시간 기록
  - 문제 순서 셔플 (설정 시)
- [ ] 문제 조회 API (응시 중)
  - 학생에게 문제 본문 및 선택지 제공
  - 정답은 숨김
- [ ] 임시 저장 API
  - 답안 데이터 JSON으로 저장 (`Answer` 엔티티)
  - 3분마다 자동 호출 (Frontend)
- [ ] 시험 제출 API
  - `Submission` 상태 변경: `submitted`
  - 제출 시간 기록
  - 자동 채점 트리거 (비동기)

**5.2 Backend - 자동 채점 로직**
- [ ] `GradingService` 구현
  - 제출된 답안을 문제 유형별로 채점
- [ ] 문제 유형별 채점 로직 (`AutoGrader` 인터페이스)
  - **객관식**: 정답 선택지와 비교
  - **O/X**: 정답과 비교
  - **주관식(단답)**: 복수 정답 목록과 비교 (대소문자/공백 처리)
  - **순서 배열**: 정답 순서와 비교, 부분 점수 계산
  - **짝짓기**: 정답 짝과 비교, 부분 점수 계산
  - **빈칸 채우기**: 각 빈칸 정답과 비교, 부분 점수 합산
  - **표 완성**: 각 셀 정답과 비교, 부분 점수 합산
  - **서술형**: 채점 대기 큐에 추가 (수동 채점)
- [ ] 채점 완료 후 `Answer` 엔티티 업데이트
  - `score`, `isCorrect`, `gradedAt` 저장
- [ ] RabbitMQ 이벤트 발행: `ExamGradedEvent` (선택 사항, 알림용)

**5.3 Frontend - 시험 응시 UI**
- [ ] 응시 가능 시험 목록 페이지
  - 시험지 카드 리스트 (응시 상태별)
  - 필터링 (전체, 응시 가능, 응시 완료)
- [ ] 시험 시작 페이지
  - 시험 정보 및 주의사항 표시
  - "시험 시작" 버튼 클릭 → 타이머 시작
- [ ] 시험 진행 페이지
  - **상단**: 타이머 (실시간 카운트다운), 문제 번호, 임시 저장/제출 버튼
  - **좌측 사이드바**: 문제 번호 네비게이션 (답안 작성 여부 색상 표시)
  - **메인 영역**: 문제 본문 + 답안 입력 UI
  - **하단**: 이전/다음 문제 버튼
- [ ] 문제 유형별 답안 입력 UI
  - **객관식**: 라디오 버튼 (단일) 또는 체크박스 (복수)
  - **O/X**: 'O' / 'X' 버튼
  - **주관식(단답)**: 텍스트 입력란 (한 줄)
  - **서술형**: 텍스트 영역 (여러 줄)
  - **순서 배열**: 드래그 앤 드롭으로 보기 순서 변경 (@dnd-kit)
  - **짝짓기**: 선으로 연결 또는 드래그 앤 드롭
  - **빈칸 채우기**: 본문 내 입력란 (각 빈칸)
  - **표 완성**: 표 형태, 빈칸 셀에 입력란
- [ ] 답안 자동 임시 저장 (3분마다 또는 문제 이동 시)
  - `exam-store.ts`: 답안 데이터 저장
  - localStorage 백업 (페이지 새로고침 대비)
- [ ] 페이지 이탈 경고 팝업 (`beforeunload` 이벤트)
- [ ] 제한 시간 종료 시 자동 제출

**5.4 Frontend - 시험 제출**
- [ ] 제출 확인 모달
  - 미작성 문제 개수 표시
  - "취소" / "제출" 버튼
- [ ] 제출 완료 페이지
  - 제출 일시 표시
  - 성적 공개 시점 안내
  - "내 성적 보기" 버튼 (공개 시)

**5.5 통합 테스트**
- [ ] Student: 시험 목록 → 시험 시작 → 8가지 유형 답안 입력 → 임시 저장 → 제출
- [ ] 타이머 종료 시 자동 제출 테스트
- [ ] 페이지 이탈 경고 테스트
- [ ] 자동 채점 결과 확인 (Backend 로그)

---

### Phase 6: 성적 및 통계 (Teacher + Student) (3주)

#### 목표
- Core Service의 성적 조회 및 통계 API 구현
- Frontend 성적 테이블, 차트 시각화 구현

#### 작업 목록

**6.1 Backend - 성적 조회 API**
- [ ] 시험별 성적 목록 조회 API (Teacher)
  - 학생 이름, 점수, 응시 일시, 소요 시간
  - 커스텀 컬럼 점수 포함
- [ ] 학생 개인 성적 조회 API (Student)
  - 내가 응시한 시험 목록 및 점수
- [ ] 시험 상세 리포트 API (Student)
  - 문제별 내 답안, 정답, 정오답 표시
  - 선생님 피드백 (서술형)

**6.2 Backend - 통계 API**
- [ ] 시험별 통계 API (Teacher)
  - 기술 통계: 평균, 중앙값, 최솟값, 최댓값, 표준편차, 분산
  - 점수 분포 데이터 (히스토그램용)
- [ ] 문제별 통계 API (Teacher)
  - 각 문제의 정답률 (%)
  - 객관식 선택지별 선택 비율
- [ ] 학생 개인 통계 API (Teacher + Student)
  - 누적 성적 데이터 (시간순)
  - 문제 유형별 정답률
  - 그룹 내 랭킹 (공개 설정 시)

**6.3 Backend - 커스텀 컬럼 API (Teacher)**
- [ ] 커스텀 컬럼 생성 API
  - 시험에 최대 5개 컬럼 추가
- [ ] 커스텀 컬럼 수정/삭제 API
- [ ] 커스텀 점수 입력 API
  - 학생별로 커스텀 컬럼 점수 입력
- [ ] 합산 점수 계산 로직
  - 시험 점수 + 커스텀 컬럼 점수들

**6.4 Frontend - Teacher 성적 관리 UI**
- [ ] 대시보드 페이지
  - 전체 통계 카드 (그룹 수, 학생 수, 시험 수, 응시 건수)
  - 그룹별/시험별 요약 테이블
  - 월별 응시 추이 차트 (라인 차트, Recharts)
- [ ] 시험별 성적 테이블 페이지
  - 기본 컬럼 + 커스텀 컬럼
  - 정렬 (모든 컬럼)
  - 필터링 (점수 범위, 제출 상태)
  - 검색 (학생 이름, 이메일)
  - CSV/Excel 내보내기 (라이브러리: `xlsx`)
- [ ] 커스텀 컬럼 추가 모달
  - 컬럼 이름, 만점 입력
  - 컬럼별 점수 입력 (인라인 편집)
- [ ] 시험별 통계 페이지
  - 기술 통계 표시 (평균, 중앙값 등)
  - 점수 분포 히스토그램 (Recharts)
  - 박스 플롯 (선택 사항)
- [ ] 문제별 통계 페이지
  - 문제별 정답률 바 차트
  - 객관식 선택지별 선택 비율 파이 차트
  - 난이도 분류 (색상 코딩)
- [ ] 학생 개인 통계 페이지
  - 누적 성적 라인 차트
  - 문제 유형별 정답률 레이더 차트
  - 강점/약점 분석 (색상 코딩)
  - PDF 내보내기 (라이브러리: `jspdf`)

**6.5 Frontend - Student 성적 UI**
- [ ] 내 성적 목록 페이지
  - 응시한 시험 목록 (점수, 응시 일시)
  - 필터링 (그룹별, 성적 공개 여부)
  - 정렬 (최근 응시순, 점수 순)
- [ ] 시험 상세 리포트 페이지
  - 시험 요약 (내 점수, 정답 수, 소요 시간)
  - 문제별 상세 (내 답안, 정답, 정오답 표시, 피드백)
  - 정오답 필터링 (전체, 정답만, 오답만)
  - PDF 내보내기
- [ ] 개인 통계 페이지
  - 전체 요약 (총 응시 수, 평균 점수, 최고/최저 점수)
  - 누적 성적 라인 차트
  - 문제 유형별 정답률 레이더 차트
  - 그룹 내 랭킹 (공개 시)

**6.6 통합 테스트**
- [ ] Teacher: 성적 테이블 조회 → 커스텀 컬럼 추가 → 점수 입력 → CSV 내보내기
- [ ] Teacher: 통계 차트 확인 (히스토그램, 바 차트, 레이더 차트)
- [ ] Student: 내 성적 조회 → 상세 리포트 확인 → PDF 내보내기

---

### Phase 7: 서술형 채점 관리 (Teacher) (1주)

#### 목표
- Core Service의 서술형 채점 API 구현
- Frontend 채점 관리 UI 구현

#### 작업 목록

**7.1 Backend - 채점 관리 API**
- [ ] 채점 대기 목록 조회 API
  - 서술형 답안 중 `gradedAt`이 null인 것만 조회
  - 시험지별, 학생별, 제출일 순 정렬
- [ ] 서술형 채점 API
  - 점수 입력 (0 ~ 문제 배점)
  - 피드백 입력 (선택)
  - `Answer` 엔티티 업데이트: `score`, `feedback`, `gradedAt`, `gradedBy`
- [ ] 일괄 채점 API (선택 사항)
  - 여러 답안에 동일 점수 부여

**7.2 Frontend - 채점 관리 UI**
- [ ] 채점 대기 목록 페이지
  - 테이블 형태 (시험지, 문제, 학생, 제출일, 배점, 상태)
  - 필터링 (시험지별, 학생별, 채점 상태)
  - 정렬 (제출일, 학생 이름)
- [ ] 채점 화면
  - 문제 본문 표시
  - 모범 답안 표시
  - 학생 답안 표시
  - 점수 입력 필드 (숫자)
  - 피드백 입력 필드 (텍스트 영역)
  - "저장" 버튼
  - "저장 및 다음" 버튼 (다음 답안으로 자동 이동)
- [ ] 일괄 채점 모달 (선택 사항)
  - 여러 답안 체크박스 선택
  - 동일 점수 일괄 입력

**7.3 통합 테스트**
- [ ] Teacher: 채점 대기 목록 확인 → 답안 읽기 → 점수 및 피드백 입력 → 저장
- [ ] Student: 성적 조회 → 피드백 확인

---

### Phase 8: 최적화 및 고도화 (2주)

#### 목표
- 성능 최적화
- 보안 강화
- UX 개선

#### 작업 목록

**8.1 성능 최적화**
- [ ] Frontend: 코드 스플리팅 (Next.js Dynamic Import)
- [ ] Frontend: 이미지 최적화 (Next.js Image 컴포넌트)
- [ ] Frontend: React Query 캐싱 전략 최적화
- [ ] Backend: 데이터베이스 쿼리 최적화 (N+1 문제 해결)
- [ ] Backend: Redis 캐싱 적용 (자주 조회되는 데이터)
- [ ] Backend: API 응답 압축 (Gzip)

**8.2 보안 강화**
- [ ] Frontend: XSS 방지 (DOMPurify로 사용자 입력 Sanitize)
- [ ] Backend: CSRF 토큰 적용 (Spring Security)
- [ ] Backend: SQL Injection 방지 (JPA Parameterized Query)
- [ ] Backend: 파일 업로드 검증 (MIME 타입, 파일 크기)
- [ ] Backend: Rate Limiting 강화 (Bucket4j 라이브러리)
- [ ] Backend: 민감 정보 로그 마스킹

**8.3 UX 개선**
- [ ] Frontend: 로딩 스켈레톤 UI 추가 (모든 페이지)
- [ ] Frontend: 에러 바운더리 구현 (React Error Boundary)
- [ ] Frontend: 토스트 알림 시스템 (성공/에러 메시지)
- [ ] Frontend: 다크 모드 지원 (선택 사항)
- [ ] Frontend: 반응형 디자인 최적화 (모바일)

**8.4 테스트**
- [ ] Frontend: E2E 테스트 (Playwright 또는 Cypress)
  - 주요 사용자 플로우 (회원가입, 로그인, 시험 응시)
- [ ] Backend: 유닛 테스트 (JUnit, Mockito)
  - 채점 로직, 통계 계산 로직
- [ ] Backend: 통합 테스트 (Spring Boot Test)
  - API 엔드포인트 테스트

---

### Phase 9: 배포 및 모니터링 (1주)

#### 목표
- 프로덕션 환경 배포
- CI/CD 파이프라인 구축
- 모니터링 및 로깅 설정

#### 작업 목록

**9.1 배포 환경 설정**
- [ ] Frontend: Vercel 배포
  - 환경 변수 설정 (API URL)
  - 도메인 연결
- [ ] Backend: AWS EC2 또는 ECS 배포
  - Docker 이미지 빌드 및 푸시 (Docker Hub 또는 ECR)
  - Docker Compose 또는 Kubernetes 배포
- [ ] 데이터베이스: AWS RDS (MySQL, PostgreSQL)
- [ ] Redis: AWS ElastiCache
- [ ] RabbitMQ: AWS MQ 또는 EC2 설치

**9.2 CI/CD 파이프라인 (GitHub Actions)**
- [ ] Frontend CI/CD
  - `main` 브랜치 푸시 시 Vercel 자동 배포
  - `develop` 브랜치는 스테이징 환경 배포
- [ ] Backend CI/CD
  - `main` 브랜치 푸시 시 Docker 이미지 빌드 → ECR 푸시 → ECS 배포
  - 테스트 실패 시 배포 중단

**9.3 모니터링 및 로깅**
- [ ] Frontend: Sentry 연동 (에러 추적)
- [ ] Backend: Sentry 또는 Elastic APM (에러 추적, 성능 모니터링)
- [ ] Backend: 로그 수집 (AWS CloudWatch 또는 ELK Stack)
- [ ] Backend: 메트릭 수집 (Prometheus + Grafana, 선택 사항)

**9.4 최종 테스트**
- [ ] 프로덕션 환경에서 전체 플로우 테스트
- [ ] 성능 테스트 (부하 테스트, JMeter 또는 k6)
- [ ] 보안 테스트 (OWASP ZAP, 선택 사항)

---

## 5. API 설계

### 5.1 Auth Service API

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| POST | `/api/auth/register` | 회원가입 | Public |
| POST | `/api/auth/verify-email` | 이메일 인증 | Public |
| POST | `/api/auth/login` | 로그인 | Public |
| POST | `/api/auth/refresh` | 토큰 갱신 | Public |
| GET | `/api/auth/me` | 내 정보 조회 | Authenticated |
| PUT | `/api/auth/profile` | 프로필 수정 | Authenticated |
| POST | `/api/auth/password/reset` | 비밀번호 재설정 | Public |

### 5.2 Core Service API

#### 그룹 관리

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| GET | `/api/groups` | 그룹 목록 조회 | Authenticated |
| POST | `/api/groups` | 그룹 생성 | Teacher |
| GET | `/api/groups/{id}` | 그룹 상세 조회 | Member |
| PUT | `/api/groups/{id}` | 그룹 수정 | Teacher (Owner) |
| DELETE | `/api/groups/{id}` | 그룹 삭제 | Teacher (Owner) |
| GET | `/api/groups/{id}/members` | 멤버 목록 조회 | Member |
| POST | `/api/groups/join` | 그룹 가입 (초대 코드) | Student |
| POST | `/api/groups/{id}/members` | 멤버 추가 (권한 변경) | Teacher |
| DELETE | `/api/groups/{id}/members/{userId}` | 멤버 강제 퇴장 | Teacher |
| DELETE | `/api/groups/{id}/leave` | 그룹 탈퇴 | Student |
| POST | `/api/groups/{id}/invite-code/regenerate` | 초대 코드 재발급 | Teacher (Owner) |

#### 시험지 관리

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| GET | `/api/exams` | 시험지 목록 조회 | Teacher |
| POST | `/api/exams` | 시험지 생성 | Teacher |
| GET | `/api/exams/{id}` | 시험지 상세 조회 | Teacher |
| PUT | `/api/exams/{id}` | 시험지 수정 | Teacher |
| DELETE | `/api/exams/{id}` | 시험지 삭제 | Teacher |
| POST | `/api/exams/{id}/copy` | 시험지 복사 | Teacher |

#### 문제 관리

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| GET | `/api/exams/{examId}/questions` | 문제 목록 조회 | Teacher |
| POST | `/api/exams/{examId}/questions` | 문제 생성 | Teacher |
| GET | `/api/questions/{id}` | 문제 상세 조회 | Teacher |
| PUT | `/api/questions/{id}` | 문제 수정 | Teacher |
| DELETE | `/api/questions/{id}` | 문제 삭제 | Teacher |
| PUT | `/api/exams/{examId}/questions/reorder` | 문제 순서 변경 | Teacher |

#### 시험 응시

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| GET | `/api/exams/available` | 응시 가능 시험 목록 | Student |
| POST | `/api/exams/{examId}/start` | 시험 시작 | Student |
| GET | `/api/submissions/{submissionId}/questions` | 문제 조회 (응시 중) | Student |
| POST | `/api/submissions/{submissionId}/answers` | 답안 임시 저장 | Student |
| POST | `/api/submissions/{submissionId}/submit` | 시험 제출 | Student |

#### 성적 및 통계

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| GET | `/api/exams/{examId}/scores` | 시험별 성적 목록 | Teacher |
| GET | `/api/users/{userId}/scores` | 학생 개인 성적 | Teacher, Student (본인만) |
| GET | `/api/submissions/{submissionId}/report` | 시험 상세 리포트 | Student (본인만) |
| GET | `/api/exams/{examId}/statistics` | 시험별 통계 | Teacher |
| GET | `/api/questions/{questionId}/statistics` | 문제별 통계 | Teacher |
| GET | `/api/users/{userId}/statistics` | 학생 개인 통계 | Teacher, Student (본인만) |

#### 커스텀 컬럼 및 채점

| Method | Endpoint | 설명 | 권한 |
|--------|----------|------|------|
| POST | `/api/exams/{examId}/custom-columns` | 커스텀 컬럼 생성 | Teacher |
| PUT | `/api/custom-columns/{columnId}` | 커스텀 컬럼 수정 | Teacher |
| DELETE | `/api/custom-columns/{columnId}` | 커스텀 컬럼 삭제 | Teacher |
| POST | `/api/custom-columns/{columnId}/scores` | 커스텀 점수 입력 | Teacher |
| GET | `/api/exams/{examId}/grading-queue` | 채점 대기 목록 | Teacher |
| POST | `/api/answers/{answerId}/grade` | 서술형 채점 | Teacher |

---

## 6. 데이터베이스 스키마

### 6.1 Auth Service (MySQL)

#### users
```sql
CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255),  -- 해시된 비밀번호 (SNS 로그인 시 null)
  name VARCHAR(100) NOT NULL,
  role ENUM('TEACHER', 'STUDENT') NOT NULL,
  email_verified BOOLEAN DEFAULT FALSE,
  provider ENUM('LOCAL', 'GOOGLE', 'NAVER') DEFAULT 'LOCAL',
  provider_id VARCHAR(255),  -- SNS 고유 ID
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_email (email),
  INDEX idx_provider_id (provider, provider_id)
);
```

#### auth_tokens
```sql
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
```

#### email_verifications
```sql
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

### 6.2 Core Service (PostgreSQL)

#### groups
```sql
CREATE TABLE groups (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  invite_code VARCHAR(8) UNIQUE NOT NULL,
  invite_code_active BOOLEAN DEFAULT TRUE,
  owner_id BIGINT NOT NULL,  -- Auth Service의 users.id
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_invite_code ON groups(invite_code);
CREATE INDEX idx_owner_id ON groups(owner_id);
```

#### group_members
```sql
CREATE TABLE group_members (
  id BIGSERIAL PRIMARY KEY,
  group_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,  -- Auth Service의 users.id
  role VARCHAR(20) NOT NULL,  -- 'OWNER', 'TEACHER', 'STUDENT'
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
  UNIQUE (group_id, user_id)
);

CREATE INDEX idx_group_id ON group_members(group_id);
CREATE INDEX idx_user_id ON group_members(user_id);
```

#### exams
```sql
CREATE TABLE exams (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  creator_id BIGINT NOT NULL,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  time_limit INT,  -- 분 단위 (null이면 제한 없음)
  shuffle_questions BOOLEAN DEFAULT FALSE,
  score_release_type VARCHAR(20) NOT NULL,  -- 'IMMEDIATE', 'AFTER_END', 'MANUAL'
  allow_retake BOOLEAN DEFAULT FALSE,
  retake_score_type VARCHAR(20),  -- 'HIGHEST', 'LATEST'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_creator_id ON exams(creator_id);
```

#### exam_groups
```sql
CREATE TABLE exam_groups (
  id BIGSERIAL PRIMARY KEY,
  exam_id BIGINT NOT NULL,
  group_id BIGINT NOT NULL,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
  FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
  UNIQUE (exam_id, group_id)
);

CREATE INDEX idx_exam_id ON exam_groups(exam_id);
CREATE INDEX idx_group_id ON exam_groups(group_id);
```

#### questions
```sql
CREATE TABLE questions (
  id BIGSERIAL PRIMARY KEY,
  exam_id BIGINT NOT NULL,
  type VARCHAR(50) NOT NULL,  -- 'MULTIPLE_CHOICE', 'OX', 'SHORT_ANSWER', 'ESSAY', 'ORDERING', 'MATCHING', 'FILL_BLANK', 'TABLE_COMPLETION'
  order_num INT NOT NULL,
  content TEXT NOT NULL,  -- 문제 본문 (HTML)
  media_urls JSONB,  -- [{type: 'image', url: '...'}, {type: 'video', url: '...'}, ...]
  points NUMERIC(5, 2) NOT NULL,  -- 배점
  answer_data JSONB NOT NULL,  -- 유형별 정답 데이터
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE INDEX idx_exam_id ON questions(exam_id);
```

#### submissions
```sql
CREATE TABLE submissions (
  id BIGSERIAL PRIMARY KEY,
  exam_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  started_at TIMESTAMP NOT NULL,
  submitted_at TIMESTAMP,
  time_spent INT,  -- 초 단위
  status VARCHAR(20) NOT NULL,  -- 'IN_PROGRESS', 'SUBMITTED', 'TIMEOUT'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE INDEX idx_exam_id ON submissions(exam_id);
CREATE INDEX idx_user_id ON submissions(user_id);
```

#### answers
```sql
CREATE TABLE answers (
  id BIGSERIAL PRIMARY KEY,
  submission_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  answer_data JSONB NOT NULL,  -- 학생 답안 데이터
  score NUMERIC(5, 2),  -- 획득 점수
  is_correct BOOLEAN,
  feedback TEXT,  -- 서술형 피드백
  graded_at TIMESTAMP,
  graded_by BIGINT,  -- 채점한 선생님 ID
  FOREIGN KEY (submission_id) REFERENCES submissions(id) ON DELETE CASCADE,
  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE INDEX idx_submission_id ON answers(submission_id);
CREATE INDEX idx_question_id ON answers(question_id);
```

#### custom_columns
```sql
CREATE TABLE custom_columns (
  id BIGSERIAL PRIMARY KEY,
  exam_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,  -- '출결', '수행평가 1'
  max_score NUMERIC(5, 2) NOT NULL,
  order_num INT NOT NULL,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE INDEX idx_exam_id ON custom_columns(exam_id);
```

#### custom_scores
```sql
CREATE TABLE custom_scores (
  id BIGSERIAL PRIMARY KEY,
  custom_column_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  score NUMERIC(5, 2) NOT NULL,
  FOREIGN KEY (custom_column_id) REFERENCES custom_columns(id) ON DELETE CASCADE,
  UNIQUE (custom_column_id, user_id)
);

CREATE INDEX idx_custom_column_id ON custom_scores(custom_column_id);
CREATE INDEX idx_user_id ON custom_scores(user_id);
```

---

## 7. 보안 전략

### 7.1 인증 및 인가
- **JWT 기반 인증**:
  - Access Token (유효기간: 15분)
  - Refresh Token (유효기간: 7일)
  - HttpOnly 쿠키로 저장 (XSS 방지)
- **역할 기반 접근 제어 (RBAC)**:
  - Teacher: 그룹 생성, 시험 출제, 성적 조회
  - Student: 시험 응시, 성적 조회 (본인만)
- **API Gateway에서 JWT 검증**:
  - 모든 요청의 토큰 검증
  - 공개 엔드포인트 제외 (`/api/auth/login`, `/api/auth/register`)

### 7.2 데이터 보호
- **비밀번호 해싱**: bcrypt (cost factor: 10)
- **민감 정보 암호화**: AES-256 (필요 시)
- **HTTPS 강제**: 모든 통신은 HTTPS
- **CORS 설정**: Frontend 도메인만 허용

### 7.3 부정행위 방지
- **페이지 이탈 감지**: 시험 중 다른 탭 이동 시 경고 및 로그 기록
- **문제 순서 랜덤화**: 설정 시 학생마다 문제 순서 다르게
- **시간 제한 엄격 적용**: 서버 시간 기준으로 타임아웃
- **IP 로깅**: 제출 시 IP 주소 기록 (선택 사항)

### 7.4 기타
- **Rate Limiting**: API 요청 제한 (DDoS 방지)
- **Input Validation**: 모든 사용자 입력 검증 (Zod, JSR-303)
- **SQL Injection 방지**: JPA Parameterized Query
- **XSS 방지**: DOMPurify로 사용자 입력 Sanitize

---

## 8. 배포 전략

### 8.1 로컬 개발 환경
- **Docker Compose**로 모든 서비스 실행
  - MySQL, PostgreSQL, Redis, RabbitMQ
  - API Gateway, Auth Service, Core Service
- `.env` 파일로 환경 변수 관리

### 8.2 프로덕션 환경
- **Frontend**: Vercel
  - 자동 배포 (GitHub 연동)
  - 환경 변수: `NEXT_PUBLIC_API_URL`
- **Backend**: AWS EC2 또는 ECS
  - Docker 이미지로 배포
  - 로드 밸런서 (ALB)
- **데이터베이스**: AWS RDS (MySQL, PostgreSQL)
- **캐시**: AWS ElastiCache (Redis)
- **메시지 큐**: AWS MQ (RabbitMQ)
- **파일 저장소**: AWS S3

### 8.3 CI/CD 파이프라인 (GitHub Actions)
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Vercel
        run: vercel --prod

  backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker Image
        run: docker build -t exam-platform:latest .
      - name: Push to ECR
        run: docker push <ECR_URI>
      - name: Deploy to ECS
        run: aws ecs update-service --cluster exam --service exam-service
```

---

## 9. 마일스톤

| Phase | 기간 | 완료 목표 | 산출물 |
|-------|------|-----------|--------|
| Phase 1 | 1-2주 | 기반 인프라 구축 | Docker Compose, API 명세, DB 스키마 |
| Phase 2 | 2주 | 인증 및 사용자 관리 | 회원가입, 로그인, JWT 검증 |
| Phase 3 | 2주 | 그룹 관리 | Teacher/Student 그룹 관리 UI |
| Phase 4 | 3주 | 시험지 및 문제 관리 | 8가지 유형 문제 에디터 |
| Phase 5 | 2주 | 시험 응시 | 시험 응시 UI, 자동 채점 |
| Phase 6 | 3주 | 성적 및 통계 | 성적 테이블, 차트 시각화 |
| Phase 7 | 1주 | 서술형 채점 관리 | 채점 관리 UI |
| Phase 8 | 2주 | 최적화 및 고도화 | 성능 최적화, 보안 강화 |
| Phase 9 | 1주 | 배포 및 모니터링 | 프로덕션 배포, CI/CD |

**총 기간**: 약 16-19주 (4-5개월)

---

*개발 계획서 최종 업데이트: 2025-11-05*
