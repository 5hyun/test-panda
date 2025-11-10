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

## 커밋 메시지 규칙

- ✅ 완료: [태스크 이름] - 태스크 완료 시
- 🎨 디자인: [변경 내용] - UI/UX 개선
- ✨ 기능: [기능 이름] - 새 기능 추가
- 🐛 버그: [버그 내용] - 버그 수정
- 📝 문서: [문서 내용] - 문서 수정
- ♻️ 리팩터링: [내용] - 코드 리팩터링
- 🚀 배포: [버전] - 배포 관련

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

- [📋 프로젝트 명세서](.speckit/spec.md)
- [📝 개발 계획서](.speckit/plan.md)
- [✅ 태스크 목록](.speckit/tasks.md)
- [🏛️ 프로젝트 원칙](.speckit/constitution.md)

## 라이센스

MIT
