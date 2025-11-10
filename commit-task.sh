하#!/bin/bash

# 사용법: ./commit-task.sh "완료한 태스크 설명"
# 예시: ./commit-task.sh "Next.js 16 프로젝트 생성"

if [ -z "$1" ]; then
  echo "❌ 에러: 태스크 설명을 입력해주세요."
  echo "사용법: ./commit-task.sh \"태스크 설명\""
  exit 1
fi

TASK_NAME="$1"

echo "📝 변경사항 스테이징 중..."
git add .

echo "💾 커밋 생성 중..."
git commit -m "✅ 완료: $TASK_NAME" -m "태스크 체크리스트 업데이트"

if [ $? -eq 0 ]; then
  echo "✨ 커밋 성공!"
  echo "📋 커밋 메시지: ✅ 완료: $TASK_NAME"
else
  echo "❌ 커밋 실패"
  exit 1
fi
