#!/usr/bin/env bash

mkdir -p "$HOME/.config/nvim"

if [ -e "$HOME/.config/nvim/init.vim" ]; then
	rm -f "$HOME/.config/nvim/init.vim"
fi

repo_location=$(dirname "$(readlink -f "$0")")
init_vim_path="$repo_location/dot_config/nvim/init.vim"

ln -s "$init_vim_path" "$HOME/.config/nvim/init.vim"
