#!/bin/bash
# pre-commit.sh

# get the current version number from pubspec.yaml
version=$(grep 'version' pubspec.yaml | awk '{print $2}' | sed -e 's/^"//' -e 's/"$//')

# increment the version number
new_version=$(echo $version | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')

# replace the old version number with the new one in pubspec.yaml
sed -i "s/version: $version/version: $new_version/g" pubspec.yaml

# add the modified pubspec.yaml file to the commit
git add pubspec.yaml
