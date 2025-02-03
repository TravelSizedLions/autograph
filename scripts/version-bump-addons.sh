#!/bin/bash

file=./addons/$1/addons.jsonc

addons=$(cat $file)
version=$(echo $addons | jq ".version" | tr -d '"')
patch_bump=$(echo $version | awk -F. '{$NF = $NF + 1;} 1' OFS=.)
addons=$(echo $addons | jq --arg v $patch_bump '.version = $v')
echo $addons | jq . > $file

if [[ -n $GITHUB_ENV ]]; then
  echo "NEXT_VERSION=$bumped" >> $GITHUB_ENV
fi

echo "Bumped from $version to $patch_bump"
