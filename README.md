# 온라인 시험 플랫폼 (Test Panda 🐼)

온라인 시험 출제 및 응시 플랫폼

## 기술 스택

### Frontend
- **Next.js 16** (App Router + Turbopack ⚡)
- **React 19**
- **TypeScript**
- **pnpm** (고속 패키지 매니저)
- **FSD Architecture** (Feature-Sliced Design)
- **Tailwind CSS** + **shadcn/ui**
- **Zustand** (상태 관리)
- **TanStack Query** (서버 상태)

### Backend
- **Spring Boot 3.x** (MSA)
- **PostgreSQL** (Core Service)
- **MySQL** (Auth Service)
- **Redis** (캐싱)
- **RabbitMQ** (메시지 큐)

## 프로젝트 구조

```
.
├── app/                  # Next.js 16 App Router
├── src/                  # FSD Architecture
│   ├── app/             # Application Layer
│   ├── processes/       # Processes Layer
│   ├── pages/           # Pages Layer
│   ├── widgets/         # Widgets Layer
│   ├── features/        # Features Layer
│   ├── entities/        # Entities Layer
│   └── shared/          # Shared Layer
└── backend/             # Spring Boot MSA
    ├── api-gateway/
    ├── auth-service/
    └── core-service/
```

## 태스크 관리

이 프로젝트는 `.speckit/tasks.md` 파일로 개발 태스크를 관리합니다.

### 태스크 완료 시 커밋하기

태스크를 하나 완료했을 때 자동으로 커밋하는 방법:

#### 방법 1: 스크립트 사용 (추천)

```bash
# tasks.md에서 체크박스를 체크한 후
./commit-task.sh "Next.js 16 프로젝트 생성"
```

#### 방법 2: npm 스크립트 사용

```bash
# tasks.md에서 체크박스를 체크한 후
npm run task:done "Next.js 16 프로젝트 생성"
```

#### 방법 3: 수동 커밋

```bash
git add .
git commit -m "✅ 완료: [태스크 이름]"
```

### 태스크 목록 확인

```bash
# 전체 태스크 목록 보기
npm run task:list

# 미완료 태스크 10개 보기
npm run task:pending
```

## 커밋 메시지 규칙 (Conventional Commits)

```bash
<타입>: <설명 (50자 이내)>

<상세 설명 (선택)>
```

### 커밋 타입

| 타입 | 의미 | 예시 |
|------|------|------|
| `feat` | 새로운 기능 | `feat: 사용자 로그인 기능 추가` |
| `fix` | 버그 수정 | `fix: 시험 제출 오류 수정` |
| `docs` | 문서 | `docs: README 설치 가이드 추가` |
| `chore` | 자질구레한 작업 | `chore: pnpm 워크스페이스 설정` |
| `style` | 코드 스타일 | `style: 들여쓰기 수정` |
| `refactor` | 리팩토링 | `refactor: API 호출 로직 개선` |
| `test` | 테스트 | `test: 로그인 테스트 추가` |
| `perf` | 성능 개선 | `perf: 이미지 로딩 최적화` |
| `ci` | CI/CD | `ci: GitHub Actions 워크플로우 추가` |
| `revert` | 되돌리기 | `revert: 이전 커밋 되돌림` |

## 개발 시작하기

### Prerequisites

- Node.js 18+
- **pnpm 9+** (필수)
  ```bash
  npm install -g pnpm
  # 또는
  brew install pnpm
  ```
- Java 17+
- Docker & Docker Compose
- PostgreSQL 15+
- MySQL 8+

### 설치 및 실행

#### Frontend

```bash
cd frontend
pnpm install
pnpm dev  # Turbopack으로 초고속 HMR ⚡
```

#### Backend (로컬 개발 환경)

```bash
cd backend
docker-compose up -d
```

## 문서

### 프로젝트 문서
- [📋 프로젝트 명세서](.speckit/spec.md)
- [📝 개발 계획서](.speckit/plan.md)
- [✅ 태스크 목록](.speckit/tasks.md)
- [🏛️ 프로젝트 원칙](.speckit/constitution.md)

### AI Assistant 문서
- [🤖 Claude 작업 지침서](.claude/instructions.md) - Claude AI가 따라야 할 규칙

## 라이센스

MIT
