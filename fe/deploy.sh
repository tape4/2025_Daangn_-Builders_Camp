#!/bin/bash

# 스크립트가 실행되는 디렉토리 확인 및 fe 폴더로 이동
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Flutter 웹 빌드
echo "Building Flutter web app..."
flutter build web

# .env 파일이 빌드된 assets 폴더에 포함되는지 확인
echo "Checking if .env file is in build..."
if [ -f ".env" ]; then
    echo "Copying .env file to build folder..."
    cp .env build/web/assets/.env
else
    echo "Warning: .env file not found!"
fi

# Firebase 배포
echo "Deploying to Firebase..."
firebase deploy --only hosting

echo "Deployment complete!"