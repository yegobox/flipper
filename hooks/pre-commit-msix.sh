#!/bin/bash

# Get current msix_version
msix_version=$(awk '/msix_version:/ {print $2}' pubspec.yaml)

# Increment the third number
IFS='.' read -ra version_parts <<< "$msix_version"
version_parts[2]=$((version_parts[2]+1))
version_parts[3]=0  # Set the last number to zero
new_msix_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}.${version_parts[3]}"

# Replace msix_version in pubspec.yaml
sed -i "s/msix_version: $msix_version/msix_version: $new_msix_version/" pubspec.yaml

# Commit
git add pubspec.yaml
