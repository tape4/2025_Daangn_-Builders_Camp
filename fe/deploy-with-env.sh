#!/bin/bash

# 스크립트가 실행되는 디렉토리 확인 및 fe 폴더로 이동
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# .env 파일 읽기
if [ -f ".env" ]; then
    echo "Loading environment variables from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "Error: .env file not found!"
    exit 1
fi

# Flutter 웹 빌드 with dart-define
echo "Building Flutter web app with environment variables..."
flutter build web \
    --dart-define=API_ADDRESS="$API_ADDRESS" \
    --dart-define=SENDBIRD_APP_ID="$SENDBIRD_APP_ID" \
    --dart-define=KAKAO_REST_API_KEY="$KAKAO_REST_API_KEY"

# .env 파일을 assets 폴더로도 복사 (fallback)
echo "Copying .env file to build folder..."
cp .env build/web/assets/.env

# Firebase 배포
echo "Deploying to Firebase..."
firebase deploy --only hosting

echo "Deployment complete!"
echo "Visit: https://hankan-9423.web.app"