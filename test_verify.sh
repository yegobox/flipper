#!/bin/bash

# Mock SED_INPLACE
SED_INPLACE() {
  sed -i .bak "$1" "$2" && rm -f "$2.bak"
}

# Create dummy pubspec.yaml
echo "msix_version: 1.170.5052.0" > test_pubspec.yaml

echo "Before:"
cat test_pubspec.yaml

# Logic from pre-commit
msix_version=$(awk '/msix_version:/ {print $2}' test_pubspec.yaml)
if [[ -n "$msix_version" ]]; then
  if [[ "$msix_version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
    build="${BASH_REMATCH[3]}"
    revision="${BASH_REMATCH[4]}"
    
    # Increment the revision number
    new_revision=$((revision + 1))
    new_msix_version="$major.$minor.$build.$new_revision"

    SED_INPLACE "s/msix_version: $msix_version/msix_version: $new_msix_version/" test_pubspec.yaml
  fi
fi

echo "After increment 1:"
cat test_pubspec.yaml

# Run again
msix_version=$(awk '/msix_version:/ {print $2}' test_pubspec.yaml)
if [[ -n "$msix_version" ]]; then
  if [[ "$msix_version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
    build="${BASH_REMATCH[3]}"
    revision="${BASH_REMATCH[4]}"
    
    new_revision=$((revision + 1))
    new_msix_version="$major.$minor.$build.$new_revision"

    SED_INPLACE "s/msix_version: $msix_version/msix_version: $new_msix_version/" test_pubspec.yaml
  fi
fi

echo "After increment 2:"
cat test_pubspec.yaml

rm test_pubspec.yaml
rm test_verify.sh
