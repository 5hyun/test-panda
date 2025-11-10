# 🟠 Processes Layer

## 역할
여러 페이지에 걸친 복잡한 비즈니스 프로세스를 관리하는 레이어입니다.

## 포함 내용
- `exam-flow/` - 시험 출제부터 배포까지의 전체 프로세스
- `grading-flow/` - 채점 및 성적 처리 프로세스

## 예시
```
processes/
├── exam-flow/
│   ├── model/     # 프로세스 상태 관리
│   ├── ui/        # 프로세스 전용 UI
│   └── lib/       # 프로세스 로직
└── grading-flow/
    └── ...
```

## 의존성 규칙
- pages, widgets, features, entities, shared에 접근 가능
- app에서만 접근 가능
