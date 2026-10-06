#!/bin/bash
set -e

# Set JAVA_HOME if invalid or not set
if [ -d "/usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home" ]; then
  export JAVA_HOME="/usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

export GRADLE_OPTS="-Xmx4g -XX:MaxMetaspaceSize=1g"

FLUTTER_BIN="flutter"
if command -v fvm &> /dev/null && fvm flutter --version &> /dev/null; then
  FLUTTER_BIN="fvm flutter"
fi

APP_NAME="Seawala"
BUILD_DIR="build/app/outputs/flutter-apk"

echo "🧹 Cleaning previous build..."
$FLUTTER_BIN clean

echo "🚀 Building $APP_NAME User App APKs using $FLUTTER_BIN..."
$FLUTTER_BIN build apk --split-per-abi "$@"

echo ""
echo "📦 Renaming APKs to $APP_NAME convention..."

if [ -d "$BUILD_DIR" ]; then
  # Extract versionName from pubspec.yaml
  VERSION_NAME=$(grep '^version:' pubspec.yaml | sed 's/version: //;s/+.*//' | tr -d '"' | tr -d "'")

  for apk in "$BUILD_DIR"/app-*-release.apk; do
    if [ -f "$apk" ]; then
      BASENAME=$(basename "$apk")
      # Extract ABI: app-arm64-v8a-release.apk -> arm64-v8a
      ABI=$(echo "$BASENAME" | sed 's/^app-//;s/-release\.apk$//')
      NEW_NAME="${BUILD_DIR}/${APP_NAME}-${VERSION_NAME}-${ABI}.apk"
      mv "$apk" "$NEW_NAME"
      echo "  ✅ $BASENAME → $(basename "$NEW_NAME")"
    fi
  done

  echo ""
  echo "📁 Output APKs:"
  ls -lh "$BUILD_DIR"/*.apk 2>/dev/null || echo "  No APKs found"
else
  echo "⚠️  Build output directory not found: $BUILD_DIR"
fi
