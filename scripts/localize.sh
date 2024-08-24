
#!/bin/bash

# Define the path to the core package and the executor app
CORE_PACKAGE_PATH="../r2u-core"
EXECUTOR_APP_PATH="."

# Define the source and destination paths for the script
SCRIPT_SOURCE_PATH="$CORE_PACKAGE_PATH/lib/localization/script/generate_localizations.dart"
SCRIPT_DESTINATION_PATH="$EXECUTOR_APP_PATH/.dart_tool/generate_localizations.dart"

# Argument for the Dart script
ARGUMENT="$1"

# Ensure the destination directory exists
mkdir -p "$(dirname "$SCRIPT_DESTINATION_PATH")"

# Copy the Dart script from the core package to the executor app
cp "$SCRIPT_SOURCE_PATH" "$SCRIPT_DESTINATION_PATH"

# Run the Dart script with the argument
dart run "$SCRIPT_DESTINATION_PATH" "$ARGUMENT"

# Remove the copied Dart script after execution
rm "$SCRIPT_DESTINATION_PATH"

flutter pub upgrade