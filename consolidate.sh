#!/bin/bash

# Ensure yq is installed
if ! command -v yq &> /dev/null
then
    echo "yq could not be found, please install it using 'brew install yq'"
    exit
fi

# Debugging: print found YAML files excluding 'build' and 'example' directories
echo "Finding YAML files excluding 'build' and 'example' directories..."
yaml_files=$(find . \( -path ./build -o -path ./example \) -prune -o -name '*.yaml' -print)
echo "Found YAML files:"
echo "$yaml_files"

# Check for 'dependencies:' key and merge those files
echo "Merging dependencies from YAML files..."
dependencies_files=$(echo "$yaml_files" | xargs grep -l 'dependencies:')
echo "YAML files with dependencies:"
echo "$dependencies_files"
echo "$dependencies_files" | xargs yq eval-all '. as $item ireduce ({}; . *+ $item) | .dependencies' > dependencies.yaml

# Check for 'dev_dependencies:' key and merge those files
echo "Merging dev_dependencies from YAML files..."
dev_dependencies_files=$(echo "$yaml_files" | xargs grep -l 'dev_dependencies:')
echo "YAML files with dev_dependencies:"
echo "$dev_dependencies_files"
echo "$dev_dependencies_files" | xargs yq eval-all '. as $item ireduce ({}; . *+ $item) | .dev_dependencies' > dev_dependencies.yaml

# Debugging: print contents of intermediate files
echo "Contents of dependencies.yaml:"
cat dependencies.yaml
echo "Contents of dev_dependencies.yaml:"
cat dev_dependencies.yaml

# Create the final pubspec.yaml
cat <<EOF > pubspec_merged.yaml
name: your_project_name
description: A new Flutter project.
version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
$(cat dependencies.yaml | sed 's/^/  /')

dev_dependencies:
$(cat dev_dependencies.yaml | sed 's/^/  /')
EOF

# Clean up
rm dependencies.yaml dev_dependencies.yaml

echo "Merged dependencies into pubspec_merged.yaml"
