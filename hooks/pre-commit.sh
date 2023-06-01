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


# Get the current version of the msix_version property
# current_version=$(grep -oP '(?<=msix_version: )\d+\.\d+\.\d+\.\d+' pubspec.yaml)

# Split the version into its components
# major_version=$(echo "$current_version" | cut -d '.' -f 1)
# minor_version=$(echo "$current_version" | cut -d '.' -f 2)
# patch_version=$(echo "$current_version" | cut -d '.' -f 3)
# pre_last_version=$(echo "$current_version" | cut -d '.' -f 4)

# # Increment the pre-last version number
# new_pre_last_version=$((pre_last_version + 1))

# # Construct the new version string
# new_version="$major_version.$minor_version.$patch_version.$new_pre_last_version.0"

# # Update the msix_version property to the new version
# sed -i "s/$current_version/$new_version/g" pubspec.yaml

# echo "msix_version updated to $new_version"


# commit
git add pubspec.yaml
