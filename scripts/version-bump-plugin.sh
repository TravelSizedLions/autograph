#!/bin/bash
project=$1
file=./addons/$1/plugin

mv "$file.cfg" "$file.toml"
version=$(dasel select -f $file.toml -r toml -s "plugin.version" | tr -d "'")
bumped=$(echo $version | awk -F. '{$NF = $NF + 1;} 1' OFS=.)

if [[ -n $NEXT_VERSION ]]; then
  bumped=$NEXT_VERSION
fi

dasel put -t string -v $bumped -f "$file.toml" -r toml "plugin.version" 
mv "$file.toml" "$file.cfg"

echo "Bumped plugin from $version to $bumped"
