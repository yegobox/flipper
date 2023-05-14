#!/bin/bash

# Get the current build number
build_number=$(grep -Po "(?<=version:\s)\d+" pubspec.yaml)

# Increment the build number
build_number=$(($build_number + 1))

# Update the build number in pubspec.yaml
sed -i "s/(?<=version:\s)\d+/$build_number/g" pubspec.yaml

# Commit the changes
git commit -m "Incremented build number"
