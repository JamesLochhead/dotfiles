#!/usr/bin/env bash

mkdir -p "$HOME/.config"
repo_location="$1"

starship_toml_repo="$repo_location/config/starship.toml"
starship_toml_app="$HOME/.config/starship.toml"

ln -sf "$starship_toml_repo" "$starship_toml_app"
