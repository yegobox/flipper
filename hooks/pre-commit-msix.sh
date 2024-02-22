#!/bin/bash

# Get current msix_version
## first go to then to apps/main directory
cd apps/main_app
msix_version=$(awk '/msix_version:/ {print $2}' apps/main_app/pubspec.yaml)

# Increment the third number
IFS='.' read -ra version_parts <<< "$msix_version"
version_parts[2]=$((version_parts[2]+1))
version_parts[3]=0  # Set the last number to zero
new_msix_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}.${version_parts[3]}"

# Replace msix_version in pubspec.yaml
sed -i "s/msix_version: $msix_version/msix_version: $new_msix_version/" apps/main_app/pubspec.yaml

# Commit
git add pubspec.yaml
