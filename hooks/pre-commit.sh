#!/bin/bash

# get current version
version=$(grep "version: " pubspec.yaml | cut -d' ' -f2)

# increment version
major=$(echo $version | cut -d'.' -f1)
minor=$(echo $version | cut -d'.' -f2)
patch=$(echo $version | cut -d'.' -f3)
patch=$((patch+1))
new_version="$major.$minor.$patch+$(date +%s)"

# replace version in pubspec.yaml
sed -i "s/version: $version/version: $new_version/" pubspec.yaml

# commit
git add pubspec.yaml
