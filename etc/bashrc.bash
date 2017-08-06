[[ $- = *i* ]] || return  # Require an interactive shell.

############################################################################ env

export PATH=".:$PATH:/usr/games"

# text
export TXT_RESET="$(tput sgr0)"
export TXT_BLACK_FG="$(tput setaf 0)"
export TXT_BLACK_BG="$(tput setab 0)"
export TXT_RED_FG="$(tput setaf 1)"
export TXT_RED_BG="$(tput setab 1)"
export TXT_GREEN_FG="$(tput setaf 2)"
export TXT_GREEN_BG="$(tput setab 2)"
export TXT_YELLOW_FG="$(tput setaf 3)"
export TXT_YELLOW_BG="$(tput setab 3)"
export TXT_BLUE_FG="$(tput setaf 4)"
export TXT_BLUE_BG="$(tput setab 4)"
export TXT_MAGENTA_FG="$(tput setaf 5)"
export TXT_MAGENTA_BG="$(tput setab 5)"
export TXT_CYAN_FG="$(tput setaf 6)"
export TXT_CYAN_BG="$(tput setab 6)"
export TXT_WHITE_FG="$(tput setaf 7)"
export TXT_WHITE_BG="$(tput setab 7)"
export TXT_DEFAULT_FG="$(tput setaf 9)"
export TXT_DEFAULT_BG="$(tput setab 9)"
export TXT_DEFAULT="$TXT_DEFAULT_FG$TXT_DEFAULT_BG"
export TXT_BLINK="$(tput blink)"
export TXT_BOLD_FG="$(tput bold)"
export TXT_BOLD_BG="$(tput smso)"
export TXT_BOLD_BG_END="$(tput rmso)"
export TXT_DIM="$(tput dim)"
export TXT_HIDE="$(tput invis)"
export TXT_ITALIC="$(tput sitm)"
export TXT_ITALIC_END="$(tput ritm)"
export TXT_REVERSE="$(tput rev)"
export TXT_UNDERLINE="$(tput smul)"
export TXT_UNDERLINE_END="$(tput rmul)"

# cursor
export CUR_HOME="$(tput home)"
export CUR_SAVE="$(tput sc)"
export CUR_RESTORE="$(tput rc)"
export CUR_HIDE="$(tput civis)"
export CUR_SHOW="$(tput cvvis)"
export CUR_LEFT="$(tput cub1)"
export CUR_DOWN="$(tput cud1)"
export CUR_RIGHT="$(tput cuf1)"
export CUR_UP="$(tput cuu1)"

# terminal
export TERM_CLEAR="$(tput clear)"
export TERM_FLASH="$(tput flash)"
export TERM_CUR_TITLE='\033]0'
export TERM_CUR_TITLE_END='\007'

# system-specific
case "$(uname -s)" in
    Darwin)
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
    Linux)
        eval "$(dircolors --sh)"  # Set LS_COLORS.
        alias ls='ls --color=auto'
        ;;
    *) echo 'This OS is not recognized.'
esac

alias grep='grep --color=auto'
alias watch='watch --color'

# other
alias ll='ls -h -l'
alias r='clear && ls -h -l'

export PROJECTS="$HOME/Projects" && mkdir -p "$PROJECTS"
export PIP_REQUIRE_VIRTUALENV=true

############################################################################ CLI

export PS1='\[$TXT_CYAN_FG\]\u@\h:\w \\$\[$TXT_YELLOW_FG\] '
TITLE=''
case $TERM in
    xterm*) TITLE="\[$TERM_CUR_TITLE;\u@\h$TERM_CUR_TITLE_END\]";;
esac
export PS1="$TITLE$PS1"
trap 'printf "$TXT_RESET"' DEBUG  # Make output the default color.
trap 'status="$?"; echo "$TXT_RED_FG[$(date)] $status"' ERR

###################################################################### functions

address () {
    # Get the public IPv6 and/or IPv4 address of localhost.
    local usage="usage: $FUNCNAME"
    if (( $# != 0 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    local ipv4="$(curl -s 'http://v4.ipv6-test.com/api/myip.php')"
    local ipv6="$(curl -s 'http://v6.ipv6-test.com/api/myip.php')"
    local pref="$(curl -s 'http://v4v6.ipv6-test.com/api/myip.php')"
    if [[ "$pref" = "$ipv4" ]]
    then
        echo "IPv4: $ipv4"
        echo "IPv6: $ipv6"
    else
        echo "IPv6: $ipv6"
        echo "IPv4: $ipv4"
    fi
}

calculate () {
    # Do basic math.
    bc -l <<< "$@"
}

capture () {
    # Redirect output to unique files.
    local unique="$(date -u "+%Y%m%dT%H%M%SZ").$(hostname -s).$$"
    local stdcmd="$unique.stdcmd.bash"
    local stderr="$unique.stderr.log"
    local stdout="$unique.stdout.log"
    echo "#!/usr/bin/env bash" >> "$stdcmd"
    echo "$@" >> "$stdcmd"
    local tmperr="$(mktemp)"
    local tmpout="$(mktemp)"
    $@ 1> "$tmpout" 2> "$tmperr"
    [[ -s "$tmperr" ]] && mv "$tmperr" "$stderr"
    [[ -s "$tmpout" ]] && mv "$tmpout" "$stdout"
}

countdown () {
    # Sleep verbosely.
    # Example: Reboot in 10min.
    #   $ countdown 600 && reboot
    local usage="usage: $FUNCNAME <seconds>"
    if (( $# != 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    local from="$1"
    shift 1
    local prompt='countdown: '
    printf "$prompt"
    for i in $(seq -f "%0${#from}g" $(($from)) -1 1)
    do
        printf "$i"
        sleep 1
        for j in $(seq "${#from}"); do printf '\b \b'; done
    done
    for i in $(seq "${#prompt}"); do printf '\b \b'; done
}

l () {
    local paths="$@"
    [ "$paths" = '' ] && paths="$PWD"
    for path in $paths
    do
        [ -d "$path" ] && ls -h -l "$path" && continue
        [ -f "$path" ] && vim "$path" && continue
        [ ! -e "$path" ] && echo "$path does not exist." 1>&2 && continue
        echo "$path could not be shown." 1>&2
    done
}

multiping () {
    for host in "$@"
    do
        printf "Pinging $host..."
        ping -qc1 "$host" 1>'/dev/null' 2>&1
        case $? in
            0) printf ' IPv4 up';;
            1) printf ' IPv4 down';;
            2) printf ' no IPv4';;
            *) printf "\nAn exit code is not recognized: $?\n" && return 1;;
        esac
        printf ','
        ping6 -qc1 "$host" 1>'/dev/null' 2>&1
        case $? in
            0) printf ' IPv6 up';;
            1) printf ' IPv6 down';;
            2) printf ' no IPv6';;
            *) printf "\nAn exit code is not recognized: $?\n" && return 1;;
        esac
        echo
    done
}

project_path () {
    # Get the path to a project by name.
    local usage="usage: $FUNCNAME project"
    if (( $# != 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    local path="$1"
    [ -d "$path" ] || path="$PROJECTS/$1"
    [ -d "$path" ] || return 1
    echo "$(realpath "$path")"
}

projects () {
    # Show info about projects.
    local projects_="$@"
    [ "$projects_" = '' ] && projects_="$PROJECTS/*"
    for project in $projects_
    do
        local path="$(project_path "$project")"
        [ "$path" = '' ] && continue
        echo "$TXT_BOLD_FG$TXT_BLUE_FG$(basename "$path")$TXT_RESET"
        cd "$path"
        git fetch --quiet --tags --prune --all
        git status --branch --short
        cd - > /dev/null
    done
}

weather () {
    # Get the weather.
    local usage="usage: $FUNCNAME [city]"
    if (( $# > 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    curl -s "http://wttr.in/$1"
}

########################################################################## intro

intro () {
    if command -v fortune &>/dev/null
    then
        if command -v lolcat &>/dev/null
        then fortune | lolcat -F 0.2
        else fortune
        fi
    fi
}
intro
