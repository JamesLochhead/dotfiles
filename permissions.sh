#!/usr/bin/env bash

repo_location=$(dirname "$(readlink -f "$0")")

cd "$repo_location" && find -type d ! -path "**.git**" -print0 | xargs -0 chmod 700
cd "$repo_location" && find -type f ! -path "**.git**" -print0 | xargs -0 chmod 600
cd "$repo_location" && find -type f ! -path "**.git**" -path "*.sh" -print0 | xargs -0 chmod 700
