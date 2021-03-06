# If not running interactively, don't do anything
[[ $- == *i* ]] || return 0

# update terminal size
shopt -s checkwinsize

# ** matches all files and zero or more directories and subdirectories
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Aliases
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#alias g='cd "$(echo "$(realpath "$HOME"/Git/"$(ls "$HOME/Git" | fzf --tiebreak=end)")")" 2> /dev/null'
#alias q='cd "$(echo $(find . -type d ! -path "*/.*" | fzf --tiebreak=end))" 2> /dev/null'
alias a='cd "$(echo "$(cat "/tmp/james/recent_dirs" | fzf --tiebreak=end)")" 2> /dev/null'
alias b='exclude=$(mktemp); grep -v "$(echo "$(cat "/tmp/james/recent_dirs" | fzf --tiebreak=end)")" /tmp/james/recent_dirs > $exclude; cat $exclude > /tmp/james/recent_dirs'
alias d='echo "$(pwd)" > /tmp/james/base_dir'
alias r='cd $(git rev-parse --show-toplevel)'
alias gl="git log --oneline"
alias gpg-lock="gpgconf --reload gpg-agent"
alias t='cd $(mktemp -d); export TMP_DIR=$(pwd)'
if command -v nvim &>/dev/null; then
	alias vi=nvim
	alias vim=nvim
fi
alias init.vim="nvim ~/.config/nvim/init.vim"
alias jy="yq -P '.' "
alias yj="yq -o=json '.' "
alias genpass="openssl rand -base64"
alias arnsets='yq ".arnsets[] | select(.name==\"AssumeRoleJamesLochhead\").arnsets" "$HOME/Work.Git/sf-sso-data/arnsets.yaml"'

if command -v fzf &>/dev/null; then
	if [[ -f "$HOME/Personal.Git/dotfiles/bash_completion/fzf-key-bindings.bash" ]]; then
		source "$HOME/Personal.Git/dotfiles/bash_completion/fzf-key-bindings.bash"
	else
		echo "fzf keybinding file has moved"
	fi
fi

function sts_decode() {
	aws sts decode-authorization-message --encoded-message "$1" 2>&1 | jq ".DecodedMessage | fromjson" | fx
}

export -f sts_decode

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

if [ -f "$HOME/.bash_aliases" ]; then
	source "$HOME/.bash_aliases"
fi

h() {
	cat <<-EOF | less
		alias ll='ls -alF'
		alias la='ls -A'
		alias l='ls -CF'
		alias rm='rm -i'
	EOF
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Binds
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

bind '"\C-o": "git status\r"'
#bind '"\C-p": "git add -A && git commit -m \"Latest\" && git push origin main\r"'
#bind '"\C-p": "git log --oneline\r git rebase -i HEAD~"'
#bind '"\C-n": "git add -A && git commit -m Squash\r"'
#bind '"\C-n": "git add -A && git commit -m Squash\r"'
#bind '"\C-f": "export AWS_DEFAULT_REGION=$(printf \"af-south-1\nap-east-1\nap-northeast-1\nap-northeast-2\nap-northeast-3\nap-south-1\nap-southeast-1\nap-southeast-2\nap-southeast-3\nca-central-1\neu-central-1\neu-north-1\neu-south-1\neu-west-1\neu-west-2\neu-west-3\nme-south-1\nsa-east-1\nus-east-1\nus-east-2\nus-west-1\nus-west-2\" | fzf)\r"'
#bind '"\C-b": "export CLOUDSDK_CORE_PROJECT=$(gcloud projects list --format=yaml | grep projectId | colrm | sed \"s|projectId: ||\" | fzf)\r"'
#bind '"\C-i": "git push origin "'

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# NodeJS/npm
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# npm -g installs to .local rather than /usr/local/
if command -v npm &>/dev/null; then
	export npm_config_prefix="$HOME/.local"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Bash completion
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# kubectl

if command -v kubectl &>/dev/null; then
	source <(kubectl completion bash)
fi

# Terraform
if command -v terraform &>/dev/null; then
	# Generated via: terraform -install-autocomplete
	complete -C terraform terraform
fi

# Packer
if command -v packer &>/dev/null; then
	# Generated via: packer -autocomplete-install
	complete -C packer packer
fi

if command -v vagrant &>/dev/null; then
	if [[ -f "$HOME/Personal.Git/dotfiles/bash_completion/vagrant-bash-completion.sh" ]]; then
		source "$HOME/Personal.Git/dotfiles/bash_completion/vagrant-bash-completion.sh"
	else
		echo "Vagrant completion is not installed"
	fi
fi

# Bash

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# AWS SAM

if command -v sam &>/dev/null; then
	export SAM_CLI_TELEMETRY=0 # turn off telemetry
	if [ -f "$HOME/Personal.Git/dotfiles/bash_completion/aws-sam-bash-completion.sh" ]; then
		source "$HOME/Personal.Git/dotfiles/bash_completion/aws-sam-bash-completion.sh"
	else
		echo "AWS SAM is installed by the autocomplete is not in the expected location."
	fi
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Editor setup
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if command -v nvim &>/dev/null; then
	export VISUAL=nvim
	export EDITOR="$VISUAL"
fi

# append to the history file, don't overwrite it
shopt -s histappend

# the maximum number of commands to remember
HISTSIZE=10000

# the maximum number of lines in the history file
HISTFILESIZE=10000

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Go
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

go_config() {
	export GO111MODULE=on
	export GOPATH="$HOME/.go"
	export GOBIN="$GOPATH/bin"
	export GOROOT="/nix/store/bsjw31rkqjc820jlpdyn0c3jv9xxk6pl-user-environment/share/go"
}

nix_config() {
	if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
		source "$HOME/.nix-profile/etc/profile.d/nix.sh"
	fi
}

ruby_config() {
	if command -v ruby &>/dev/null; then
		export GEM_HOME="$HOME/.gems"
		export PATH="$HOME/.gems/bin:$PATH"
		if [[ ! -d "$HOME/.gems/bin" ]]; then
			mkdir -p "$HOME/.gems/bin"
		fi
	fi
}


yabp_config() {

	YABP_DIRECTORY="$HOME/Personal.Git/Yet-Another-Bash-Prompt"

	if [[ -d "$YABP_DIRECTORY" ]] && [[ -f "$YABP_DIRECTORY/core.sh" ]]; then
		source "$YABP_DIRECTORY/core.sh" "$YABP_DIRECTORY"
	fi
}

path_additions() {

	if [[ -d "/opt/homebrew-$(whoami)/bin" ]]; then
		export PATH="/opt/homebrew-$(whoami)/bin:$PATH"
	fi

	if [[ -L "$HOME/.nix-profile" ]]; then
		export PATH=$HOME/.nix-profile/bin:$PATH
	fi

	export PATH=$HOME/.bin:$GOBIN:$HOME/.local/bin:$PATH
}

create_local_bin() {
	if ! [[ -d "$HOME/.local/bin" ]]; then
		mkdir -p "$HOME/.local/bin"
	fi
}

sf_sso_completion() {
	if command -v sf-sso &>/dev/null; then
		source <(sf-sso completion bash)
	fi
}

homebrew_config() {

	if [[ -d "/opt/homebrew-$(whoami)/bin" ]]; then
		eval "$(/opt/homebrew-$(whoami)/bin/brew shellenv)"
	fi

	if type brew &>/dev/null; then
		HOMEBREW_PREFIX="$(brew --prefix)"
		if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
		  source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
		else
		  for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
		  do
		    [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
		  done
		fi
	fi

	export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
}

lima_config() {

	export DEV_ENVIRONMENTS_DIR="/Users/sf-james/Personal.Git/lima_dev-environments"

	# Bash completion
	if command -v limactl &>/dev/null; then
		source <(limactl completion bash)
	fi

	if [[ -f "$DEV_ENVIRONMENTS_DIR/bash_commands" ]]; then
		source "$DEV_ENVIRONMENTS_DIR/bash_commands"
	fi
}

main() {
	ruby_config
	nix_config
	create_local_bin
	yabp_config
	sf_sso_completion
	go_config
	homebrew_config
	lima_config
	path_additions # make it last
}

main "$@"
