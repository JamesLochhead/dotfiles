#!/usr/bin/env bash
current_dir="$(dirname "$(readlink -f "$0")")"
cd "$current_dir/scripts/" && chmod 700 ./*.sh
cd "$current_dir/scripts/" && ./inputrc_setup.sh "$current_dir"
cd "$current_dir/scripts/" && ./bashrc_setup.sh "$current_dir"
cd "$current_dir/scripts/" && ./nvim_setup.sh "$current_dir"
cd "$current_dir/scripts/" && ./firefox_setup.sh "$current_dir"
cd "$current_dir/scripts/" && ./byobu_setup.sh "$current_dir"
