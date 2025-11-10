하#!/bin/bash

# 사용법: ./commit-task.sh <타입> "태스크 설명"
# 예시: ./commit-task.sh feat "Next.js 16 프로젝트 생성"
# 예시: ./commit-task.sh docs "README 업데이트"

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "❌ 에러: 타입과 태스크 설명을 모두 입력해주세요."
  echo ""
  echo "사용법: ./commit-task.sh <타입> \"태스크 설명\""
  echo ""
  echo "커밋 타입:"
  echo "  feat     - 새로운 기능"
  echo "  fix      - 버그 수정"
  echo "  docs     - 문서"
  echo "  chore    - 자질구레한 작업"
  echo "  style    - 코드 스타일"
  echo "  refactor - 리팩토링"
  echo "  test     - 테스트"
  echo "  ci       - CI/CD"
  echo "  perf     - 성능 개선"
  echo "  revert   - 되돌리기"
  echo ""
  echo "예시:"
  echo "  ./commit-task.sh feat \"로그인 기능 추가\""
  echo "  ./commit-task.sh fix \"타이머 버그 수정\""
  exit 1
fi

TYPE="$1"
TASK_NAME="$2"

# 타입 검증
VALID_TYPES=("feat" "fix" "docs" "chore" "style" "refactor" "test" "ci" "perf" "revert")
if [[ ! " ${VALID_TYPES[@]} " =~ " ${TYPE} " ]]; then
  echo "❌ 에러: 유효하지 않은 타입입니다: $TYPE"
  echo "유효한 타입: ${VALID_TYPES[@]}"
  exit 1
fi

echo "📝 변경사항 스테이징 중..."
git add .

echo "💾 커밋 생성 중..."
git commit -m "$TYPE: $TASK_NAME" -m "태스크 체크리스트 업데이트"

if [ $? -eq 0 ]; then
  echo "✨ 커밋 성공!"
  echo "📋 커밋 메시지: $TYPE: $TASK_NAME"
else
  echo "❌ 커밋 실패"
  exit 1
fi
