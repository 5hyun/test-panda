# ⚪ Shared Layer

## 역할
프로젝트 전역에서 재사용 가능한 공통 모듈을 관리하는 레이어입니다.

## 포함 내용
- `ui/` - 공통 UI 컴포넌트 (Button, Input 등)
- `api/` - API 클라이언트 설정
- `lib/` - 유틸리티 함수
- `config/` - 환경 설정
- `types/` - 공통 타입 정의
- `hooks/` - 공통 React Hooks
- `assets/` - 이미지, 폰트 등

## 예시
```
shared/
├── ui/
│   ├── button/
│   ├── input/
│   └── card/
├── api/
│   ├── client.ts
│   └── interceptors.ts
├── lib/
│   ├── format.ts
│   └── validation.ts
├── config/
│   └── constants.ts
├── types/
│   └── common.ts
├── hooks/
│   └── useDebounce.ts
└── assets/
    └── images/
```

## 의존성 규칙
- 어떤 레이어에도 의존하지 않음
- 모든 레이어에서 접근 가능
