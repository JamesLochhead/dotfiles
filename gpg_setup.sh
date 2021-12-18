#!/usr/bin/env bash

repo_location=$(dirname "$(readlink -f "$0")")

gpg_agent_path_repo="$repo_location/gnupg/gpg-agent.conf"
gpg_agent_path_app="$HOME/.gnupg/gpg-agent.conf"
gpg_agent_path_app_dir="$HOME/.gnupg/"

mkdir -p "$gpg_agent_path_app_dir"
if [ ! -h "$gpg_agent_path_app" ]; then
	rm -f "$gpg_agent_path_app"
fi
ln -sf "$gpg_agent_path_repo" "$gpg_agent_path_app"
