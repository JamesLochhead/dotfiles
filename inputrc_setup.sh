#!/usr/bin/env bash

repo_location=$(dirname "$(readlink -f "$0")")

inputrc_path_repo="$repo_location/dot_inputrc"
inputrc_path_app="$HOME/.inputrc"

if [ -e "$inputrc_path_app" ]; then
	rm -f "$inputrc_path_app"
fi
ln -s "$inputrc_path_repo" "$inputrc_path_app"
