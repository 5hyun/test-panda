# 🔴 App Layer (Application Layer)

## 역할
애플리케이션의 전역 설정과 초기화를 담당하는 최상위 레이어입니다.

## 포함 내용
- 전역 상태 관리 (Zustand stores)
- 애플리케이션 프로바이더 설정
- 전역 에러 처리
- 전역 스타일 설정

## 예시
```
app/
├── providers/      # Context Providers
├── store/         # Zustand global stores
└── styles/        # Global styles
```

## 의존성 규칙
- 모든 레이어에 접근 가능
- 다른 레이어에서 접근 불가
