#!/bin/bash

# get current version
cd apps/main_app

version=$(grep "version: " pubspec.yaml | cut -d' ' -f2)

# increment version
major=$(echo $version | cut -d'.' -f1)
minor=$(echo $version | cut -d'.' -f2)
patch=$(echo $version | cut -d'.' -f3)
patch=$((patch+1))
new_version="$major.$minor.$patch+$(date +%s)"

# replace version in pubspec.yaml
sed -i "" "s/version: $version/version: $new_version/" pubspec.yaml

# commit
git add pubspec.yaml
#git commit -m "Bump version to $new_version"


# Get current operating system

OS=$(uname)

if [ "$OS" == "Darwin" ] || [ "$OS" == "Linux" ]; then
  # Get current msix_version
  msix_version=$(awk '/msix_version:/ {print $2}' pubspec.yaml)

  # Increment the third number
  IFS='.' read -ra version_parts <<< "$msix_version"
  version_parts[2]=$((version_parts[2]+1))
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
  version_parts[2]=$((version_parts[2]+1))
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
