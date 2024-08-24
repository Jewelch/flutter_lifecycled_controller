#!/bin/bash

# Function to get current date components
get_current_date_components() {
    year=$(date +"%Y")
    day=$(date +"%d")
    month=$(date +"%m")
}

# Step 1: Parse the pubspec.yaml to get the current version and its components
current_version=$(grep 'version: ' pubspec.yaml | cut -d ' ' -f 2)
version_number=$(echo $current_version | cut -d '+' -f 1)
build_metadata=$(echo $current_version | cut -d '+' -f 2)

current_year=${build_metadata:0:4}
current_month=${build_metadata:4:2}
current_day=${build_metadata:6:2}
current_build_number=${build_metadata:8:2}

# Step 2: Get current date components
get_current_date_components

# Step 3: Determine new build number or reset it if date has changed
if [ "$current_year" == "$year" ] && [ "$current_day" == "$day" ] && [ "$current_month" == "$month" ]; then
    new_build_number=$(printf "%02d" $((10#$current_build_number + 1)))
else
    current_day=$day
    current_month=$month
    new_build_number="01"
fi

# Step 4: Form the new version string with reversed month and day format
new_build_metadata="${year}${current_month}${current_day}${new_build_number}"
new_version="${version_number}+${new_build_metadata}"

# Step 5: Update the pubspec.yaml with the new version
sed -i '' "s/version: .*/version: $new_version/" pubspec.yaml
echo "Version updated to $new_version"