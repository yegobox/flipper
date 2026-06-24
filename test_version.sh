#!/bin/bash
version="1.180.4252223234901+1756528905"
echo "Starting test with version: $version"
if [[ "$version" =~ ^([0-9]+\.[0-9]+\.[0-9]+)(\+([0-9]+))?$ ]]; then
  echo "Main regex matched"
  base_version="${BASH_REMATCH[1]}"
  build_number="${BASH_REMATCH[3]}"
  echo "Base version: $base_version"
  echo "Build number: $build_number"
  
  if [[ -z "$build_number" ]]; then
    build_number=1
  else
    build_number=$((build_number + 1))
  fi
  
  if [[ "$base_version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "Base regex matched"
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
    patch="${BASH_REMATCH[3]}"
    echo "Major=$major, Minor=$minor, Patch=$patch"
    new_patch=$((patch + 1))
    base_version="$major.$minor.$new_patch"
  fi
  
  new_version="$base_version+$build_number"
  echo "Old: $version"
  echo "New: $new_version"
else
  echo "Main regex failed to match: $version"
fi
