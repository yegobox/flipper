#!/bin/bash

# Get the list of changed files
changed_files=$(git diff --cached --name-only --diff-filter=ACM)

# Define the pattern you want to search for in the commented lines
comment_pattern="# *ProxyService.sync.push()"

# Loop through the changed files
for file in $changed_files; do
    if grep -q "$comment_pattern" "$file"; then
        echo "Error: Commented line found in '$file'. Please uncomment it before committing."
        exit 1
    fi
done

# If no commented lines were found, allow the commit
exit 0
