# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Aliases
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

alias g="cd ~/Git"
alias r='cd $(git rev-parse --show-toplevel)'
alias gl="git log --oneline"
alias gpg-lock="gpgconf --reload gpg-agent"
alias vi=nvim
alias vim=nvim
alias init.vim="nvim ~/.config/nvim/init.vim"

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

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Binds
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

bind '"\C-o": "git status\r"'
#bind '"\C-p": "git add -A && git commit -m \"Latest\" && git push origin main\r"'
bind '"\C-p": "git log --oneline\r git rebase -i HEAD~"'

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# $PATH
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if ! [[ -e "$HOME/.local/bin" ]]; then mkdir -p "$HOME/.local/bin"; fi

export GOPATH="$HOME/.go"
export GOBIN="$HOME/.go"
PATH="$HOME/.local/bin:$GOPATH:$GOBIN:$PATH"

if [[ -e $HOME/.tfenv/bin ]]; then
	PATH="$HOME/.tfenv/bin:$PATH"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# NodeJS/npm
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# npm -g installs to .local rather than /usr/local/
if command -v npm &> /dev/null; then
	export npm_config_prefix="$HOME/.local"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Command completion
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Terraform
if command -v terraform &> /dev/null; then
	# Generated via: terraform -install-autocomplete
	complete -C /usr/bin/terraform terraform
fi

# Packer
if command -v packer &> /dev/null; then
	# Generated via: packer -autocomplete-install
	complete -C /usr/bin/packer packer
fi

# Vagrant
# Generated via: vagrant autocomplete install --bash
. /opt/vagrant/embedded/gems/2.2.19/gems/vagrant-2.2.19/contrib/bash/completion.sh

# enable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# AWS SAM - turn off telemetry and add completion
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Stop SAM sending telemetry to AWS
if command -v sam &> /dev/null; then
	export SAM_CLI_TELEMETRY=0
	if [ -e "/home/james/Git/dotfiles/aws-sam-bash-completion.sh" ]; then
		source /home/james/Git/dotfiles/aws-sam-bash-completion.sh
	else
		echo "AWS SAM is installed by the autocomplete is not in the expected location."
	fi
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Prompt
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

source /etc/profile.d/vte.sh # fix for gnome-terminal opening in pwd; above starship
eval "$(starship init bash)"

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Editor setup
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [[ -f /usr/bin/nvim ]]; then
	export VISUAL=nvim
	export EDITOR="$VISUAL"
fi

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# History
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# append to the history file, don't overwrite it
shopt -s histappend

# store the history in the persistent file every time a new prompt appears
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# the maximum number of commands to remember
HISTSIZE=10000

# the maximum number of lines in the history file
HISTFILESIZE=10000

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
