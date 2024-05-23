#!/bin/bash

# Define a lock file to prevent concurrent runs
LOCKFILE=/tmp/pre-commit.lock

# Function to clean up the lock file on exit
cleanup() {
  rm -f "$LOCKFILE"
}
trap cleanup EXIT

# Check if the lock file exists
if [ -f "$LOCKFILE" ]; then
  echo "Script is already running. Exiting..."
  exit 1
fi

# Create the lock file
touch "$LOCKFILE"

# Navigate to the correct directory
cd apps/flipper

# Get the current version from pubspec.yaml
version=$(grep "version: " pubspec.yaml | cut -d' ' -f2)

# Increment the version
major=$(echo "$version" | cut -d'.' -f1)
minor=$(echo "$version" | cut -d'.' -f2)
patch=$(echo "$version" | cut -d'.' -f3 | cut -d'+' -f1)
patch=$((patch + 1))
new_version="$major.$minor.$patch+$(date +%s)"

# Replace version in pubspec.yaml
sed -i "" "s/version: $version/version: $new_version/" pubspec.yaml

# Commit the change
git add pubspec.yaml
# Uncomment the next line to enable automatic commits
# git commit -m "Bump version to $new_version"

# Get the current operating system
OS=$(uname)

if [ "$OS" == "Darwin" ] || [ "$OS" == "Linux" ]; then
  # Get current msix_version
  msix_version=$(awk '/msix_version:/ {print $2}' pubspec.yaml)

  # Increment the third number
  IFS='.' read -ra version_parts <<< "$msix_version"
  version_parts[2]=$((version_parts[2] + 1))
  version_parts[3]=0

  # Set the new msix_version
  new_msix_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}.${version_parts[3]}"

  # Replace msix_version in pubspec.yaml
  sed -i.bak "s/msix_version: $msix_version/msix_version: $new_msix_version/" pubspec.yaml && rm pubspec.yaml.bak

  # Commit if the version has changed
  if [ "$msix_version" != "$new_msix_version" ]; then
    git add pubspec.yaml
    git commit -m "Increment MSIX version to $new_msix_version"
  fi

elif [ "$OS" == "Windows" ]; then
  # Get current msix_version
  msix_version=$(awk '/msix_version:/ {print $2}' pubspec.yaml)

  # Increment the third number
  IFS='.' read -ra version_parts <<< "$msix_version"
  version_parts[2]=$((version_parts[2] + 1))
  version_parts[3]=0

  # Set the new msix_version
  new_msix_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}.${version_parts[3]}"

  # Replace msix_version in pubspec.yaml
  sed -i "s/msix_version: $msix_version/msix_version: $new_msix_version/" pubspec.yaml

  # Commit if the version has changed
  if [ "$msix_version" != "$new_msix_version" ]; then
    git add pubspec.yaml
    git commit -m "Increment MSIX version to $new_msix_version"
  fi

else
  echo "::warning::Unsupported operating system: $OS. Skipping version increment."
fi

# Exit with success
exit 0
