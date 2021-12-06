#!/usr/bin/env bash

repo_location="$1"

inputrc_path_repo="$repo_location/bashrc"
inputrc_path_app="$HOME/.bashrc"

ln -fs "$inputrc_path_repo" "$inputrc_path_app"
