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


# Get current msix_version
- name: Increment MSIX version
  shell: bash
  run: |
    # Get current msix_version
    msix_version=$(awk '/msix_version:/ {print $2}' pubspec.yaml)

    # Increment the third number
    IFS='.' read -ra version_parts <<< "$msix_version"
    version_parts[2]=$((version_parts[2]+1))
    version_parts[3]=0

    # Set the new msix_version
    new_msix_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}.${version_parts[3]}"

    # Replace msix_version in pubspec.yaml
    if [ "$RUNNER_OS" == "macOS" ]; then
      sed -i.bak "s/msix_version: $msix_version/msix_version: $new_msix_version/" pubspec.yaml
      rm pubspec.yaml.bak
    elif [ "$RUNNER_OS" == "Linux" ]; then
      sed -i "s/msix_version: $msix_version/msix_version: $new_msix_version/" pubspec.yaml
    else
      echo "::warning::Unsupported operating system: $RUNNER_OS. Skipping version increment."
      exit 0
    fi

    # Commit
    git add pubspec.yaml
    git commit -m "Increment MSIX version to $new_msix_version"

- name: Increment MSIX version (Windows)
  shell: pwsh
  run: |
    # Get current msix_version
    $msix_version = (Get-Content pubspec.yaml -Raw) -match 'msix_version:\s*(.+?)(?=\s)' | ForEach-Object { $_.Captures.Groups[1].Value }

    # Increment the third number
    $version_parts = $msix_version.Split('.')
    $version_parts[2] = [int]$version_parts[2] + 1
    $version_parts[3] = 0

    # Set the new msix_version
    $new_msix_version = $version_parts -join '.'

    # Replace msix_version in pubspec.yaml
    $pubspec_content = Get-Content pubspec.yaml -Raw
    $pubspec_content = $pubspec_content -replace "msix_version:\s*$msix_version", "msix_version: $new_msix_version"
    Set-Content pubspec.yaml $pubspec_content

    # Commit
    git add pubspec.yaml
    git commit -m "Increment MSIX version to $new_msix_version"

  # Run this step only on Windows
  if: runner.os == 'Windows'
