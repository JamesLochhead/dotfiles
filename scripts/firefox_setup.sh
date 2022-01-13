#!/usr/bin/env bash

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Set variables
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

is_laptop=false
if [ -d "/proc/acpi/button/lid" ]; then
    is_laptop=true
fi

repo_location="$1"
userchrome_file="$repo_location/mozilla/firefox/profile/chrome/userChrome.css"

userjs_file="$repo_location/mozilla/firefox/profile/user.js.desktop"
if [ "$is_laptop" = true ]; then
	userjs_file="$repo_location/mozilla/firefox/profile/user.js.laptop"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Create profiles
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

firefox -CreateProfile james
firefox -CreateProfile production-1
firefox -CreateProfile production-2
firefox -CreateProfile production-3
firefox -CreateProfile staging-1
firefox -CreateProfile staging-2
firefox -CreateProfile staging-3
firefox -CreateProfile work-sites
echo "Sleeping for 10s to let all the Firefox profiles be created..."
sleep 10

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Get profile (absolute) paths
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

profile_james=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*james*")
profile_production1=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*production-1*")
profile_production2=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*production-2*")
profile_production3=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*production-3*")
profile_staging1=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*staging-1*")
profile_staging2=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*staging-2*")
profile_staging3=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*staging-3*")
profile_worksites=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -iname "*work-sites*")

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Symlink user.js in profile directories
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ln -sf "$userjs_file" "$profile_james/user.js"
ln -sf "$userjs_file" "$profile_production1/user.js"
ln -sf "$userjs_file" "$profile_production2/user.js"
ln -sf "$userjs_file" "$profile_production3/user.js"
ln -sf "$userjs_file" "$profile_staging1/user.js"
ln -sf "$userjs_file" "$profile_staging2/user.js"
ln -sf "$userjs_file" "$profile_staging3/user.js"
ln -sf "$userjs_file" "$profile_worksites/user.js"

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Symlink userChrome.css in profile directories
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

mkdir -p "$profile_james/chrome"
mkdir -p "$profile_production1/chrome"
mkdir -p "$profile_production2/chrome"
mkdir -p "$profile_production3/chrome"
mkdir -p "$profile_staging1/chrome"
mkdir -p "$profile_staging2/chrome"
mkdir -p "$profile_staging3/chrome"
mkdir -p "$profile_worksites/chrome"
ln -sf "$userchrome_file" "$profile_james/chrome/userChrome.css"
ln -sf "$userchrome_file" "$profile_production1/chrome/userChrome.css"
ln -sf "$userchrome_file" "$profile_production2/chrome/userChrome.css"
ln -sf "$userchrome_file" "$profile_production3/chrome/userChrome.css"
ln -sf "$userchrome_file" "$profile_staging1/chrome/userChrome.css"
ln -sf "$userchrome_file" "$profile_staging2/chrome/userChrome.css"
ln -sf "$userchrome_file" "$profile_worksites/chrome/userChrome.css"

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Enable Firefox Wayland mode in GNOME environment variables
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

mkdir -p "$HOME/.config/environment.d/"
touch "$HOME/.config/environment.d/envvars.conf"
if ! (grep -q "MOZ_ENABLE_WAYLAND=1" "$HOME/.config/environment.d/envvars.conf"); then
	echo "MOZ_ENABLE_WAYLAND=1" >> "$HOME/.config/environment.d/envvars.conf"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Copy the .desktop files into the profile-specific applications directory
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

mkdir -p "$HOME/.local/share/applications/"
cp -a "$repo_location/local/share/applications/." "$HOME/.local/share/applications/"
