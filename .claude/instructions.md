# Claude AI Assistant 작업 지침서

> 이 문서는 Claude AI Assistant가 프로젝트 작업 시 따라야 할 핵심 규칙과 가이드라인을 정의합니다.

---

## 🎯 핵심 원칙

### 1. 자동 커밋 규칙 (가장 중요!)

**작고 자주 커밋하라!**

#### 커밋 타이밍 (즉시 커밋!)
- ✅ **파일 하나 생성** → 즉시 커밋
- ✅ **설정 하나 추가/수정** → 즉시 커밋
- ✅ **함수 하나 완성** → 즉시 커밋
- ✅ **컴포넌트 하나 완성** → 즉시 커밋
- ✅ **버그 하나 수정** → 즉시 커밋
- ✅ **문서 섹션 하나 작성** → 즉시 커밋
- ✅ **테스트 하나 추가** → 즉시 커밋

#### 커밋 금지 패턴 (하지 마!)
- ❌ 여러 파일을 한 번에 커밋
- ❌ 작업이 끝날 때까지 기다렸다가 커밋
- ❌ 사용자가 "커밋해줘"라고 할 때까지 기다리기

#### 커밋 명령어
```bash
git add [변경된 파일] && git commit -m "<타입>: <설명>" -m "<상세 내용>"
```

#### 커밋 메시지 타입 (Conventional Commits)

| 타입 | 언제 사용? |
|------|-----------|
| `feat` | 새로운 기능 추가 (가장 중요) |
| `fix` | 버그 수정 (가장 중요) |
| `chore` | 빌드 스크립트, 패키지 설정, .gitignore 수정 등 |
| `docs` | README.md, 주석 등 문서 수정 |
| `style` | 세미콜론, 들여쓰기 등 스타일 수정 |
| `refactor` | 기능 변경 없이 코드 개선 |
| `test` | 테스트 코드 추가/수정 |
| `ci` | CI/CD 설정 파일 수정 |
| `perf` | 성능 개선 |
| `revert` | 이전 커밋 되돌리기 |

#### 커밋 예시
```bash
feat: 사용자 로그인 기능 추가
fix: 시험 제출 시 타이머 오류 수정
docs: README에 설치 가이드 추가
chore: pnpm 워크스페이스 설정
```

---

## 📋 태스크 관리

### 세션 시작 시 (필수!)
1. **`.speckit/tasks.md` 파일 확인**
   - 어떤 작업이 완료되었는지 확인
   - 다음에 할 작업 파악
   - 진행 상황 파악 후 작업 시작

### TodoWrite 도구 사용
- 복잡한 작업 시작 시 TodoWrite로 태스크 리스트 생성
- 태스크 상태 실시간 업데이트
- 태스크 완료 시 즉시 completed로 변경

### .speckit/tasks.md 체크박스 업데이트 (중요!)
- ✅ **작업 완료 시 즉시 체크박스 업데이트**
  ```markdown
  - [ ] 작업 항목  →  - [x] 작업 항목
  ```
- ✅ **체크박스 업데이트 후 즉시 커밋**
  ```bash
  git add .speckit/tasks.md && git commit -m "docs: [작업명] 완료 체크"
  ```
- ✅ **세션 재연결 대비**: tasks.md가 진행 상황의 단일 진실 공급원(Single Source of Truth)

---

## 🗂️ 프로젝트 구조 (FSD)

### Feature-Sliced Design 레이어
```
src/
├── app/         # 🔴 Application Layer (전역 설정)
├── processes/   # 🟠 Processes Layer (사용자 시나리오)
├── pages/       # 🟡 Pages Layer (페이지 컴포지션)
├── widgets/     # 🟢 Widgets Layer (독립 UI 블록)
├── features/    # 🔵 Features Layer (사용자 인터랙션)
├── entities/    # 🟣 Entities Layer (비즈니스 엔티티)
└── shared/      # ⚪ Shared Layer (공유 리소스)
```

### 슬라이스 구조 (각 레이어 내부)
```
feature-name/
├── ui/          # React 컴포넌트
├── model/       # 비즈니스 로직, 상태, 훅
├── api/         # API 호출
├── lib/         # 유틸리티
├── config/      # 설정
└── index.ts     # Public API
```

---

## 💻 기술 스택

### Frontend
- **Next.js 16** (App Router + Turbopack)
- **pnpm** (패키지 매니저)
- **TypeScript**
- **Tailwind CSS + shadcn/ui**
- **Zustand** (상태 관리)
- **TanStack Query** (서버 상태)

### Backend
- **Spring Boot 3.x** (MSA)
- **PostgreSQL** (Core Service)
- **MySQL** (Auth Service)

---

## 🎨 코딩 스타일

### 한국어 주석 필수
```typescript
// 사용자 인증 토큰을 검증하고 갱신합니다
// 만료 시간이 5분 이내로 남은 경우 자동으로 갱신됩니다
async function validateAndRefreshToken(token: string) {
  // ...
}
```

### 명명 규칙
- **컴포넌트**: PascalCase (`UserProfile.tsx`)
- **훅**: camelCase with "use" prefix (`useAuth.ts`)
- **유틸리티**: camelCase (`formatDate.ts`)
- **상수**: UPPER_SNAKE_CASE (`API_ENDPOINT`)

---

## 📁 파일 생성 패턴

### 새 기능 추가 시
1. **entities** 레이어에 엔티티 타입 정의
2. **features** 레이어에 기능 구현
3. **widgets** 또는 **pages**에서 조합
4. 각 파일 생성마다 즉시 커밋!

### 예시: 로그인 기능 추가
```bash
# 1. 엔티티 타입 정의
src/entities/user/model/types.ts → 커밋

# 2. 로그인 기능 구현
src/features/auth/login/ui/login-form.tsx → 커밋
src/features/auth/login/model/use-login.ts → 커밋
src/features/auth/login/index.ts → 커밋

# 3. 페이지에 추가
src/pages/auth/login/ui/login-page.tsx → 커밋
```

---

## 🚫 금지 사항

- ❌ 큰 변경사항을 한 번에 커밋
- ❌ 여러 파일을 한꺼번에 커밋
- ❌ 커밋 없이 다음 작업 진행
- ❌ 영어 커밋 메시지
- ❌ 설명 없는 커밋 메시지
- ❌ FSD 구조 무시하고 파일 생성

---

## ✅ 체크리스트 (매 작업마다 확인)

세션 시작 시:
- [ ] `.speckit/tasks.md` 확인 (어디까지 했는지 파악)
- [ ] git log로 최근 커밋 확인
- [ ] constitution.md의 Git 규칙 확인

작업 시작 전:
- [ ] FSD 구조에 맞는 위치 파악
- [ ] 작업을 작은 단위로 나눔
- [ ] TodoWrite로 태스크 리스트 생성 (복잡한 작업 시)

작업 중:
- [ ] 파일 하나 작성 완료 시 즉시 커밋
- [ ] 한국어 주석 작성
- [ ] TypeScript 타입 정의

작업 완료:
- [ ] 모든 변경사항 커밋 완료 확인
- [ ] git status로 unstaged 파일 없는지 확인
- [ ] **.speckit/tasks.md 체크박스 업데이트 + 커밋** (매우 중요!)

---

## 📝 참고 문서

- `.speckit/constitution.md` - 프로젝트 헌법 (Git 규칙 포함)
- `.speckit/spec.md` - 프로젝트 명세서
- `.speckit/plan.md` - 개발 계획서
- `.speckit/tasks.md` - 태스크 체크리스트

---

**중요: 이 지침은 세션이 바뀌어도 항상 적용됩니다!**

*최종 업데이트: 2025-11-10*
