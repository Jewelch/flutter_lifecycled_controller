#!/bin/bash

clear

# Ensure the correct Flutter version is used
fvm flutter --version

# Build APKs
fvm flutter build apk --release -t lib/main.dart --target-platform android-arm,android-arm64,android-x64 --split-per-abi

# Define the path to the output folder and the new APK directory
OUTPUT_DIR="build/app/outputs/flutter-apk"
APK_DIR="apk"  # Change this to your desired APK directory

# Create the APK directory if it does not exist
mkdir -p "$APK_DIR"

# Define the root directory for moving APKs
ROOT_DIR="$APK_DIR"

# Function to get the project name from pubspec.yaml
get_project_name() {
  # Path to pubspec.yaml
  PUBSPEC_FILE="pubspec.yaml"
  
  # Extract the project name from pubspec.yaml
  if [ -f "$PUBSPEC_FILE" ]; then
    # Use grep and awk to extract the value of the name field
    PROJECT_NAME=$(grep '^name:' "$PUBSPEC_FILE" | awk '{print $2}')
  else
    echo "pubspec.yaml not found in the current directory"
    exit 1
  fi
}

# Get the project name
get_project_name

# Move APK files to the APK directory and rename them
for apk in "$OUTPUT_DIR"/app-*-release.apk; do
  # Extract the architecture part from the APK filename
  ARCHITECTURE=$(basename "$apk" | sed -e 's/app-\(.*\)-release.apk/\1/')
  
  # Define the new APK filename
  NEW_NAME="${PROJECT_NAME}-${ARCHITECTURE}.apk"
  
  # Move and rename the APK file
  mv "$apk" "$ROOT_DIR/$NEW_NAME"
  
  # Remove the associated SHA file
  SHA_FILE="${apk}.sha"
  if [ -f "$SHA_FILE" ]; then
    rm "$SHA_FILE"
  fi
done

# Launch scrcpy
echo "Launching scrcpy..."
scrcpy &

# Wait for scrcpy to start
sleep 5

# Define the list of APKs to attempt to install based on architecture preference
APK_LIST=(
  "*-arm64.apk"
  "*-armeabi-v7a.apk"
)

# Attempt to install each APK in the list
for apk_pattern in "${APK_LIST[@]}"; do
  APK_TO_INSTALL=$(ls "$ROOT_DIR"/$apk_pattern 2>/dev/null)
  if [ -n "$APK_TO_INSTALL" ]; then
    echo "Installing APK onto the connected Android device: $APK_TO_INSTALL"
    adb install -r "$APK_TO_INSTALL"
    if [ $? -eq 0 ]; then
      echo "APK installed successfully: $APK_TO_INSTALL"
      break
    else
      echo "Failed to install APK: $APK_TO_INSTALL"
    fi
  else
    echo "No APK found for pattern: $apk_pattern"
  fi
done

echo "APK files have been moved to $APK_DIR, renamed, SHA files removed, scrcpy launched, and APK installed if available."
