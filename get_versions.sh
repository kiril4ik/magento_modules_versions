#!/bin/bash

if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing now..."
    sudo apt update
    sudo apt install -y jq
fi
find app/code -mindepth 2 -maxdepth 2 -type d -exec sh -c '
  for dir; do
  composer_json="$dir/composer.json"
  if [ -f "$composer_json" ]; then
    name=$(jq -r ".name // empty" "$composer_json" 2>/dev/null)
    version=$(jq -r ".version // empty" "$composer_json" 2>/dev/null)
    if [ -n "$name" ] && [ -n "$version" ]; then
      echo "$name@$version"
    elif [ -n "$name" ]; then
      echo "$name@missing_version"
    else
      echo "Missing name or version in: $composer_json"
    fi
  fi
done
' sh {} +
