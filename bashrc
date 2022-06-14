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
alias vi=nvim
alias vim=nvim
alias init.vim="nvim ~/.config/nvim/init.vim"
alias jy="yq -P '.' "
alias yj="yq -o=json '.' "
alias genpass="openssl rand -base64 "

if [[ -f /usr/share/fzf/shell/key-bindings.bash ]]; then
	source /usr/share/fzf/shell/key-bindings.bash
else
	echo "fzf keybinding file has moved"
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

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
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
bind '"\C-p": "git log --oneline\r git rebase -i HEAD~"'
bind '"\C-n": "git add -A && git commit -m Squash\r"'
bind '"\C-n": "git add -A && git commit -m Squash\r"'
bind '"\C-f": "export AWS_DEFAULT_REGION=$(printf \"af-south-1\nap-east-1\nap-northeast-1\nap-northeast-2\nap-northeast-3\nap-south-1\nap-southeast-1\nap-southeast-2\nap-southeast-3\nca-central-1\neu-central-1\neu-north-1\neu-south-1\neu-west-1\neu-west-2\neu-west-3\nme-south-1\nsa-east-1\nus-east-1\nus-east-2\nus-west-1\nus-west-2\" | fzf)\r"'
bind '"\C-b": "export CLOUDSDK_CORE_PROJECT=$(gcloud projects list --format=yaml | grep projectId | colrm | sed \"s|projectId: ||\" | fzf)\r"'
#bind '"\C-i": "git push origin "'

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# $PATH
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if ! [[ -e "$HOME/.local/bin" ]]; then mkdir -p "$HOME/.local/bin"; fi

if [[ -e $HOME/.tfenv/bin ]]; then
	PATH="$HOME/.tfenv/bin:$PATH"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# NodeJS/npm
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# npm -g installs to .local rather than /usr/local/
if command -v npm &>/dev/null; then
	export npm_config_prefix="$HOME/.local"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Command completion
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if command -v kubectl &>/dev/null; then
	source <(kubectl completion bash)
fi

# Terraform
if command -v terraform &>/dev/null; then
	# Generated via: terraform -install-autocomplete
	complete -C /usr/bin/terraform terraform
fi

# Packer
if command -v packer &>/dev/null; then
	# Generated via: packer -autocomplete-install
	complete -C /usr/bin/packer packer
fi

# Vagrant
# Generated via: vagrant autocomplete install --bash
if [[ -f /opt/vagrant/embedded/gems/2.2.19/gems/vagrant-2.2.19/contrib/bash/completion.sh ]]; then
	. /opt/vagrant/embedded/gems/2.2.19/gems/vagrant-2.2.19/contrib/bash/completion.sh
else
	echo "Vagrant completion has moved"
fi

# enable bash completion
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if [[ -f "$HOME/.linuxbrew/yq" ]]; then
	source "$HOME/.linuxbrew/yq"
fi

if [[ -f "$HOME/.linuxbrew/brew" ]]; then
	source "$HOME/.linuxbrew/brew"
fi

if [[ -f "$HOME/.linuxbrew/kustomize" ]]; then
	source "$HOME/.linuxbrew/kustomize"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# AWS SAM - turn off telemetry and add completion
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Stop SAM sending telemetry to AWS
if command -v sam &>/dev/null; then
	export SAM_CLI_TELEMETRY=0
	if [ -e "/home/james/Git/dotfiles/aws-sam-bash-completion.sh" ]; then
		source /home/james/Git/dotfiles/aws-sam-bash-completion.sh
	else
		echo "AWS SAM is installed by the autocomplete is not in the expected location."
	fi
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Editor setup
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [[ -f /usr/bin/nvim ]]; then
	export VISUAL=nvim
	export EDITOR="$VISUAL"
fi

YABP_DIRECTORY="$HOME/.config/yabp"
source "$YABP_DIRECTORY/core.sh" "$YABP_DIRECTORY"

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

export GO111MODULE=on
export GOPATH="$HOME/Go"
export GOBIN="$GOPATH/bin"
export GOROOT=/usr/lib/golang
PATH="$HOME/.local/bin:$GOPATH:$GOBIN:$PATH"

# Temporary
PATH="/home/james/Workspaces/tm352/tools/bin:/home/james/Workspaces/tm352/gradle/gradle-4.3.1/bin:$PATH"
PATH="/home/james/Workspaces/tm352/platform-tools:/home/james/Workspaces/tm352/emulator:$PATH"

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Homebrew
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [[ -d "$HOME/.linuxbrew" ]]; then
	export HOMEBREW_PREFIX="$HOME/.linuxbrew"
	export MANPATH="$HOME/.linuxbrew/share/man:"
	export INFOPATH="$HOME/.linuxbrew/share/info:"
	export HOMEBREW_CELLAR="$HOME/.linuxbrew/Cellar"
	export HOMEBREW_REPOSITORY="$HOME/.linuxbrew"
	PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
fi

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

main() {
	ruby_config
	nix_config
}

main "$@"
