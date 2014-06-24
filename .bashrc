# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

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
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color supportmes tomcat does not recognize, but a surefire way of recognizing that tomcat is to define the file paths inside "catalina.sh; assume it's compliant with Ecma-48
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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias dl=del.sh
alias slp='sudo pm-suspend'
alias g=git
alias h1='history 10'
alias sgit='smartgithg &> /dev/null &'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# autocompletion for git
source /usr/share/bash-completion/completions/git
complete -o default -o nospace -F _git g
# complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null \
#     || complete -o default -o nospace -F _git g

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# exports for oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
export ORACLE_SID=XE
export NLS_LANG=`$ORACLE_HOME/bin/nls_lang.sh`
export ORACLE_BASE=/u01/app/oracle
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME/bin:$PATH
export CDPATH=$PATH:~/Sources/

# colorful prompt
COLOR_PINK="\033[35m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_PURPLE="\e[0;35m"
COLOR_RESET="\033[0m"

function s3ls() {
	local bucket="image-res-test/"
	local path=$1
	local args

	if [[ $2 == "irp" ]]; then
		bucket="image-res-platform/"
	else if [[ -n $2 ]]; then
		bucket=$2"/"
	fi fi

	if [[ -n $1 ]]; then
		if [[ $path == "/" ]]; then
			path=""
		fi
		args="s3://"$bucket$path
	fi

	echo -e "~/Apps/s3cmd-master/s3cmd ls "$args"\n"
	~/Apps/s3cmd-master/s3cmd ls $args | tee >(echo -e "\n=== "$(wc -l)" results ===") | egrep --color "\b(DIR)\b|$"
}

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_PINK
  else if [[ $git_status =~ "Your branch is behind" ]]; then
  	echo -e $COLOR_PURPLE
  else if [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  else if [[ $git_status =~ "diverged" ]]; then
  	echo -e $COLOR_BLUE
  else if [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi fi fi fi fi
}

function git_diff {
	local git_status="$(git status 2> /dev/null)"
	local arr=$(echo $git_status | grep -o ' [0-9]\+ ' | tr -s ' \n' '\n')

	local ARRAY=()
	for x in $arr
		do
			ARRAY+=($x)
		done
	if [ ${#ARRAY[@]} -eq 0 ]; then
		ret=''
	else
		ret='['
		if [[ $git_status =~ "diverged" ]]; then
			ret=$ret'↑'${ARRAY[0]}'↓'${ARRAY[1]}
		else if [[ $git_status =~ "ahead" ]]; then
			ret=$ret'↑'${ARRAY[0]}
		else if [[ $git_status =~ "behind" ]]; then
			ret=$ret${ARRAY[0]}'↓'
		fi fi fi
		ret=$ret']'
	fi
	echo -e $ret
}

PS1='`if [ $? = 0 ]; then echo "\[\033[01;32m\]✔"; else echo "\[\033[01;31m\]✘";fi` \[\033[01;30m\]\h\[\033[01;34m\] \w$(git_color)$(__git_ps1 " %s")\[\033[01;30m\] $(git_diff)\n>\[\033[00m\] '
export PS1
