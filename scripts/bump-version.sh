#!/bin/bash
usage="
USAGE: ./version-bump.sh <repo name>
"

if [[ -z $1 ]]; then
  echo "Missing repository name"
  echo $usage
  exit 1;
fi

missing_dasel=$(which dasel | grep "dasel not found")
if [[ -n $missing_dasel ]]; then
  echo "Missing dependency 'dasel'. Install with 'sudo apt-get install dasel'"
  usage $usage
  exit 1
fi

if [[ ! -e "./addons/$repo/addons.jsonc" && ! -e "./addons/$repo/plugin.cfg" ]]; then
  echo "This repository has no versioning system!"
  exit 1;
fi

repo=$1
next_version=''
if [[ -e "./addons/$repo/addons.jsonc" ]]; then
  addons_path="./addons/$repo/addons.jsonc"
  addons=$(cat $addons_path)
  addons_version=$(echo $addons | jq ".version" | tr -d '"')
  next_version=$(echo $addons_version | awk -F. '{$NF = $NF + 1;} 1' OFS=.)
  addons=$(echo $addons | jq --arg v $next_version '.version = $v')
  echo $addons | jq . > $addons_path
  echo "Bumped addons.json version: ${addons_version} -> ${next_version}"
fi

if [[ -e "./addons/$repo/plugin.cfg" ]]; then
  plugin_path="./addons/$repo/plugin"
  mv "$plugin_path.cfg" "$plugin_path.toml"
  plugin_version=$(dasel select -f $file.toml -r toml -s "plugin.version" | tr -d "'")
  
  if [[ -z $next_version ]]; then
    next_version=$(echo $plugin_version | awk -F. '{$NF = $NF + 1;} 1' OFS=.)    
  fi

  dasel put -t string -v $next_version -f "$file.toml" -r toml "plugin.version" 
  mv "$plugin_path.toml" "$plugin_path.cfg"
  echo "Bumped plugin.cfg version: ${plugin_version} -> ${next_version}
fi

echo "next_version=${next_version}" >> $GITHUB_OUTPUT
