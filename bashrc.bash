#!/usr/bin/env bash

[[ $- = *i* ]] || return  # Require an interactive shell.

umask 0027

############################################################################ env

if command -v tput &>/dev/null
then
    # text
    TXT_RESET="$(tput sgr0)" && export TXT_RESET
    TXT_BLACK_FG="$(tput setaf 0)" && export TXT_BLACK_FG
    TXT_BLACK_BG="$(tput setab 0)" && export TXT_BLACK_BG
    TXT_RED_FG="$(tput setaf 1)" && export TXT_RED_FG
    TXT_RED_BG="$(tput setab 1)" && export TXT_RED_BG
    TXT_GREEN_FG="$(tput setaf 2)" && export TXT_GREEN_FG
    TXT_GREEN_BG="$(tput setab 2)" && export TXT_GREEN_BG
    TXT_YELLOW_FG="$(tput setaf 3)" && export TXT_YELLOW_FG
    TXT_YELLOW_BG="$(tput setab 3)" && export TXT_YELLOW_BG
    TXT_BLUE_FG="$(tput setaf 4)" && export TXT_BLUE_FG
    TXT_BLUE_BG="$(tput setab 4)" && export TXT_BLUE_BG
    TXT_MAGENTA_FG="$(tput setaf 5)" && export TXT_MAGENTA_FG
    TXT_MAGENTA_BG="$(tput setab 5)" && export TXT_MAGENTA_BG
    TXT_CYAN_FG="$(tput setaf 6)" && export TXT_CYAN_FG
    TXT_CYAN_BG="$(tput setab 6)" && export TXT_CYAN_BG
    TXT_WHITE_FG="$(tput setaf 7)" && export TXT_WHITE_FG
    TXT_WHITE_BG="$(tput setab 7)" && export TXT_WHITE_BG
    TXT_DEFAULT_FG="$(tput setaf 9)" && export TXT_DEFAULT_FG
    TXT_DEFAULT_BG="$(tput setab 9)" && export TXT_DEFAULT_BG
    TXT_DEFAULT="$TXT_DEFAULT_FG$TXT_DEFAULT_BG" && export TXT_DEFAULT
    TXT_BLINK="$(tput blink)" && export TXT_BLINK
    TXT_BOLD_FG="$(tput bold)" && export TXT_BOLD_FG
    TXT_BOLD_BG="$(tput smso)" && export TXT_BOLD_BG
    TXT_BOLD_BG_END="$(tput rmso)" && export TXT_BOLD_BG_END
    TXT_DIM="$(tput dim)" && export TXT_DIM
    TXT_HIDE="$(tput invis)" && export TXT_HIDE
    TXT_ITALIC="$(tput sitm)" && export TXT_ITALIC
    TXT_ITALIC_END="$(tput ritm)" && export TXT_ITALIC_END
    TXT_REVERSE="$(tput rev)" && export TXT_REVERSE
    TXT_UNDERLINE="$(tput smul)" && export TXT_UNDERLINE
    TXT_UNDERLINE_END="$(tput rmul)" && export TXT_UNDERLINE_END

    # cursor
    CUR_HOME="$(tput home)" && export CUR_HOME
    CUR_SAVE="$(tput sc)" && export CUR_SAVE
    CUR_RESTORE="$(tput rc)" && export CUR_RESTORE
    CUR_HIDE="$(tput civis)" && export CUR_HIDE
    CUR_SHOW="$(tput cvvis)" && export CUR_SHOW
    CUR_LEFT="$(tput cub1)" && export CUR_LEFT
    CUR_DOWN="$(tput cud1)" && export CUR_DOWN
    CUR_RIGHT="$(tput cuf1)" && export CUR_RIGHT
    CUR_UP="$(tput cuu1)" && export CUR_UP

    # terminal
    TERM_CLEAR="$(tput clear)" && export TERM_CLEAR
    TERM_FLASH="$(tput flash)" && export TERM_FLASH
    TERM_CUR_TITLE='\033]0' && export TERM_CUR_TITLE
    TERM_CUR_TITLE_END='\007' && export TERM_CUR_TITLE_END
else
    tput
fi

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

[[ $PATH == *'.'* ]] || export PATH=".:$PATH"

export PIP_REQUIRE_VIRTUALENV=true

########################################################################### REPL

export PS1='\[$TXT_CYAN_FG\]\u\[$TXT_WHITE_FG\]@\[$TXT_GREEN_FG\]\h\[$TXT_WHITE_FG\]:\[$TXT_YELLOW_FG\]\w\[$TXT_WHITE_FG\] \\$ \[$TXT_RED_FG\]'
TITLE=''
case $TERM in
    xterm*) TITLE="\[$TERM_CUR_TITLE;\u@\h$TERM_CUR_TITLE_END\]";;
esac
export PS1="$TITLE$PS1"
trap 'printf "%s" "$TXT_RESET"' DEBUG  # Make output the default color.
trap 'printf "%s $?\n" "$TXT_RED_FG[$(date)]"' ERR

###################################################################### functions

address () {
    # Get the public IPv6 and/or IPv4 address of localhost.
    local usage && usage="usage: ${FUNCNAME[0]}"
    if (( $# != 0 ))
    then
        echo "$usage" 1>&2
        return 1
    elif ! command -v wget &>/dev/null
    then wget || return 1
    fi
    local ipv4 && ipv4="$(wget -qO- 'http://v4.ipv6-test.com/api/myip.php')"
    local ipv6 && ipv6="$(wget -qO- 'http://v6.ipv6-test.com/api/myip.php')"
    local pref && pref="$(wget -qO- 'http://v4v6.ipv6-test.com/api/myip.php')"
    if [[ "$pref" = "$ipv4" ]]
    then
        echo "IPv4: $ipv4"
        echo "IPv6: $ipv6"
    else
        echo "IPv6: $ipv6"
        echo "IPv4: $ipv4"
    fi
}

capture () {
    # Redirect output to unique files.
    local unique && unique="$(date -u "+%Y%m%dT%H%M%SZ").$(hostname -s).$$"
    local stdcmd && stdcmd="$unique.stdcmd.bash"
    local stderr && stderr="$unique.stderr.log"
    local stdout && stdout="$unique.stdout.log"
    echo "#!/usr/bin/env bash" >> "$stdcmd"
    echo "$@" >> "$stdcmd"
    local tmperr && tmperr="$(mktemp)"
    local tmpout && tmpout="$(mktemp)"
    "$@" 1> "$tmpout" 2> "$tmperr"
    [[ -s "$tmperr" ]] && mv "$tmperr" "$stderr"
    [[ -s "$tmpout" ]] && mv "$tmpout" "$stdout"
}

countdown () {
    # Sleep verbosely.
    # Example: Reboot in 10min.
    #   $ countdown 600 && reboot
    local usage && usage="usage: ${FUNCNAME[0]} <seconds>"
    if (( $# != 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    local from && from="$1"
    shift 1
    local prompt && prompt='countdown: '
    printf '%s' "$prompt"
    for i in $(seq -f "%0${#from}g" $((from)) -1 1)
    do
        printf '%d' "$i"
        sleep 1
        for _ in $(seq "${#from}"); do printf '\b \b'; done
    done
    for _ in $(seq "${#prompt}"); do printf '\b \b'; done
}

multiping () {
    for host in "$@"
    do
        printf 'Pinging %s...' "$host"
        ping -qc1 "$host" 1>'/dev/null' 2>&1
        case $? in
            0) printf ' IPv4 up';;
            1) printf ' IPv4 down';;
            2) printf ' no IPv4';;
            *) printf '\nAn exit code is not recognized: %d\n' "$?" && return 1;;
        esac
        printf ','
        ping6 -qc1 "$host" 1>'/dev/null' 2>&1
        case $? in
            0) printf ' IPv6 up';;
            1) printf ' IPv6 down';;
            2) printf ' no IPv6';;
            *) printf '\nAn exit code is not recognized: %d\n' "$?" && return 1;;
        esac
        echo
    done
}

projects () {
    # Show info about projects.
    # shellcheck disable=SC2068
    for path in ${@:-"${PROJECTS:-"$HOME/projects"}/"*}
    do
        git -C "$path" status > /dev/null || continue
        printf '%s' "$TXT_BOLD_FG$TXT_BLUE_FG"
        basename "$(git -C "$path" rev-parse --show-toplevel)"
        printf '%s' "$TXT_RESET"
        git -C "$path" fetch --quiet --tags --prune --all
        git -C "$path" status --branch --short
    done
}

rebash () {
    # Refresh Bash config.
    local usage="usage: ${FUNCNAME[0]}"
    if (( $# > 0 ))
    then
        echo "$usage" 1>&2
        return 1
    elif ! command -v wget &>/dev/null
    then wget || return 1
    fi
    url='https://raw.githubusercontent.com/dmtucker/config/master/deploy.bash'
    wget -O- "$url" | "$BASH"
}

weather () {
    # Get the weather.
    local usage="usage: ${FUNCNAME[0]} [city]"
    if (( $# > 1 ))
    then
        echo "$usage" 1>&2
        return 1
    elif ! command -v wget &>/dev/null
    then wget || return 1
    fi
    wget -qO- "http://wttr.in/$1"
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
