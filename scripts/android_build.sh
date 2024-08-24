#!/bin/bash

# Step 0: Get the directory of the current script

SCRIPT_DIR=$(dirname "$0")

# Step 1: Update the 'forced' value in the main.dart file
MAIN_DART_PATH="$SCRIPT_DIR/../lib/main.dart"
# Use sed to find and replace the 'forced' value
sed -i '' 's/forced: true/forced: false/g' "$MAIN_DART_PATH"

PROJECT_ROOT=$(realpath "$SCRIPT_DIR/..")

# Step 2: Remove the build folder, Symbols.zip file, and release_build folder
rm -rf "$PROJECT_ROOT/build"
rm -f "$PROJECT_ROOT/Symbols.zip"
rm -rf "$PROJECT_ROOT/release_build"

# Step 3: Execute the build_increment.sh script from the same directory
"$SCRIPT_DIR/build_increment.sh"

# Step 4: Build the Flutter APK with obfuscation and split debug info
flutter build apk --release --obfuscate --split-debug-info="$PROJECT_ROOT/release_build"

# Step 5: Navigate to the folder containing the merged native libraries
cd build/app/intermediates/merged_native_libs/release/out/lib || exit

# Step 6: Compress all 3 folders into a single zip file named "Symbols.zip"
zip -r Symbols.zip ./*

# Step 7: Remove any "__MACOSX" directories from the zip file if they exist
if zipinfo -1 Symbols.zip | grep -q "__MACOSX"; then
  zip -d Symbols.zip "__MACOSX*"
else
  echo "__MACOSX directories not found in Symbols.zip"
fi

# Step 8: Check if the target directory exists and move the resulting "Symbols.zip" file to the main app folder
if [ -d "$PROJECT_ROOT" ]; then
  mv Symbols.zip "$PROJECT_ROOT/Symbols.zip"
  echo "Process completed. Symbols.zip is now located next to your pubspec.yaml file."
else
  echo "Error: Target directory $PROJECT_ROOT does not exist."
fi
