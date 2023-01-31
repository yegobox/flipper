#!/bin/bash
current_version=$(cat pubspec.yaml | grep version | awk '{print $2}')
current_version=${current_version%.*}
current_build=$(cat pubspec.yaml | grep version | awk '{print $2}')
current_build=${current_build##*.}
current_build=$((current_build+1))
new_version="$current_version.$current_build+1111010165"
sed -i "s/$current_version.*/$new_version/g" pubspec.yaml
