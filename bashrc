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

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Prompt and history
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set_text_foreground_color() {
	if [[ $5 == true ]]; then
		printf "\[\e[0;1;%s;%s;%sm\]$_BOLD%s\[\e[0m\]" "$2" "$3" "$4" "$1"
	else
		printf "\[\e[0;1;%s;%s;%sm\]%s\[\e[0m\]" "$2" "$3" "$4" "$1"
	fi
}

create_user_tmp_directory() {
	USER="$(whoami)"
	PRIMARY_GROUP=$(id -gn "$USER")
	PERSONAL_TMP_DIR="/tmp/$USER"

	if [[ ! -d "$PERSONAL_TMP_DIR" ]]; then
		mkdir -p "$PERSONAL_TMP_DIR"
	fi
	chmod 700 "$PERSONAL_TMP_DIR"
	chown -R "$USER:$PRIMARY_GROUP" "$PERSONAL_TMP_DIR"
}

if [[ -f /tmp/james/base_dir ]]; then
	cd "$(cat /tmp/james/base_dir)"
elif [[ -f /tmp/james/recent_dirs ]]; then
	a
fi

# Executed every time  a new prompt appears
prompt_command() {

	ORIGINAL_RETURN_CODE=$? # must be first
	RETURN_CODE=""
	if [[ -d /tmp/james ]]; then
		echo "$(pwd)" >/tmp/james/last_dir
		TMP_FILE="$(mktemp)"
		cat /tmp/james/recent_dirs >"$TMP_FILE"
		echo "$(pwd)" >>"$TMP_FILE"
		echo "$HOME" >>"$TMP_FILE"
		sort "$TMP_FILE" | uniq >/tmp/james/recent_dirs
	fi
	if ((ORIGINAL_RETURN_CODE != 0)); then
		RETURN_CODE=" $ORIGINAL_RETURN_CODE"
	fi
	history -a # store history
	_BOLD=$(tput bold)
	CWD_BASENAME="$(basename $(pwd))"
	CWD=$(set_text_foreground_color "$CWD_BASENAME" "38" "5" "33" true)
	GIT_CHECKED_OUT=""
	GIT_REPOSITORY=""
	CURRENT_GCLOUD_IDENTITY=""
	CURRENT_GCLOUD_PROJECT=""
	AWS_REGION=""
	GIT_STATUS=""

	if command -v gcloud &>/dev/null; then
		if [ -n "${CLOUDSDK_CORE_PROJECT:-}" ]; then
			CURRENT_GCLOUD_PROJECT=" $CLOUDSDK_CORE_PROJECT"
		elif [[ -f "$HOME/.config/gcloud/configurations/config_default" ]]; then
			CURRENT_GCLOUD_PROJECT=" $(grep "project" <"$HOME/.config/gcloud/configurations/config_default" | sed 's/project = //' | colrm)"
		fi
		if [[ $CURRENT_GCLOUD_PROJECT != "" ]] && [[ $CURRENT_GCLOUD_PROJECT != " " ]]; then
			CURRENT_GCLOUD_IDENTITY=" $(grep "account" <"$HOME/.config/gcloud/configurations/config_default" | sed 's/account = //' | colrm)"
		fi
	fi

	if [ -n "${AWS_DEFAULT_REGION:-}" ]; then
		AWS_REGION=" $AWS_DEFAULT_REGION"
	fi

	if command -v git &>/dev/null && [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
		#GIT_DETACHED=$(git rev-parse --abbrev-ref --symbolic-full-name HEAD 2> /dev/null)
		if git status | grep -q detached >/dev/null 2>&1; then
			GIT_STATUS=" D "
			GIT_CHECKED_OUT=$(git status | grep detached | sed 's|HEAD detached at ||' 2>/dev/null)
		else
			GIT_CHECKED_OUT="$(git branch --show-current | colrm)"
			if git status --short | grep -q " M " >/dev/null 2>&1 || git status --short | grep -q "?? " >/dev/null 2>&1; then
				GIT_STATUS=" M "
			fi
		fi
		#GIT_ROOT=$(git rev-parse --show-toplevel)
		GIT_REPOSITORY="$(basename -s .git "$(git config --get remote.origin.url)")"
		GIT_OWNER=$(git config --get remote.origin.url | sed 's|/.*||' | sed 's|^.*:||')
		echo -en "\033]0;G $GIT_REPOSITORY:$GIT_OWNER\a"
		GIT_REPOSITORY=" $GIT_REPOSITORY:"
	else

		echo -en "\033]0;D $CWD_BASENAME\a"
	fi
	#echo -en "\033]0;D $current_command\a"
	# echo "${BASH_COMMAND}"
	# CURRENT_PID=$$
	# CHILD_PROCESS_PID=$(pgrep -P $CURRENT_PID | head -n1)
	# if ps -p $CHILD_PROCESS_PID >/dev/null; then
	# 	process_name=$(ps -p "$CHILD_PROCESS_PID" -o comm=)
	# 	echo -en "\033]0;D $process_name\a"
	# fi
	PS1="\n$CWD$GIT_REPOSITORY$GIT_CHECKED_OUT$GIT_STATUS$CURRENT_GCLOUD_IDENTITY$CURRENT_GCLOUD_PROJECT$AWS_REGION$RETURN_CODE\n> "
	export PS1
}

# append to the history file, don't overwrite it
shopt -s histappend

PROMPT_COMMAND=prompt_command

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
main() {
	create_user_tmp_directory
}

main "$@"
