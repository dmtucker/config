# shellcheck disable=SC2034
if ! command -v tput &>/dev/null
then tput
elif [[ "$TERM" == '' ]]
then echo "\$TERM is not set."
elif [[ $- == *i* ]]
then
    [[ "$TERM" == *'256'* ]] || echo "\$TERM ($TERM) does not appear to support 256 colors." 1>&2

    # text
    TXT_RESET="$(tput sgr0)"
    TXT_BLACK_FG="$(tput setaf 0)"
    TXT_BLACK_BG="$(tput setab 0)"
    TXT_RED_FG="$(tput setaf 1)"
    TXT_RED_BG="$(tput setab 1)"
    TXT_GREEN_FG="$(tput setaf 2)"
    TXT_GREEN_BG="$(tput setab 2)"
    TXT_YELLOW_FG="$(tput setaf 3)"
    TXT_YELLOW_BG="$(tput setab 3)"
    TXT_BLUE_FG="$(tput setaf 4)"
    TXT_BLUE_BG="$(tput setab 4)"
    TXT_MAGENTA_FG="$(tput setaf 5)"
    TXT_MAGENTA_BG="$(tput setab 5)"
    TXT_CYAN_FG="$(tput setaf 6)"
    TXT_CYAN_BG="$(tput setab 6)"
    TXT_WHITE_FG="$(tput setaf 7)"
    TXT_WHITE_BG="$(tput setab 7)"
    TXT_BRIGHT_BLACK_FG="$(tput setaf 8)"
    TXT_BRIGHT_BLACK_BG="$(tput setab 8)"
    TXT_BRIGHT_RED_FG="$(tput setaf 9)"
    TXT_BRIGHT_RED_BG="$(tput setab 9)"
    TXT_BRIGHT_GREEN_FG="$(tput setaf 10)"
    TXT_BRIGHT_GREEN_BG="$(tput setab 10)"
    TXT_BRIGHT_YELLOW_FG="$(tput setaf 11)"
    TXT_BRIGHT_YELLOW_BG="$(tput setab 11)"
    TXT_BRIGHT_BLUE_FG="$(tput setaf 12)"
    TXT_BRIGHT_BLUE_BG="$(tput setab 12)"
    TXT_BRIGHT_MAGENTA_FG="$(tput setaf 13)"
    TXT_BRIGHT_MAGENTA_BG="$(tput setab 13)"
    TXT_BRIGHT_CYAN_FG="$(tput setaf 14)"
    TXT_BRIGHT_CYAN_BG="$(tput setab 14)"
    TXT_BRIGHT_WHITE_FG="$(tput setaf 15)"
    TXT_BRIGHT_WHITE_BG="$(tput setab 15)"
    TXT_BLINK="$(tput blink)"
    TXT_BOLD_FG="$(tput bold)"
    TXT_BOLD_BG="$(tput smso)"
    TXT_BOLD_BG_END="$(tput rmso)"
    TXT_DIM="$(tput dim)"
    TXT_HIDE="$(tput invis)"
    TXT_ITALIC="$(tput sitm)"
    TXT_ITALIC_END="$(tput ritm)"
    TXT_REVERSE="$(tput rev)"
    TXT_UNDERLINE="$(tput smul)"
    TXT_UNDERLINE_END="$(tput rmul)"

    # cursor
    CUR_HOME="$(tput home)"
    CUR_SAVE="$(tput sc)"
    CUR_RESTORE="$(tput rc)"
    CUR_HIDE="$(tput civis)"
    CUR_SHOW="$(tput cvvis)"
    CUR_LEFT="$(tput cub1)"
    CUR_DOWN="$(tput cud1)"
    CUR_RIGHT="$(tput cuf1)"
    CUR_UP="$(tput cuu1)"

    # terminal
    TERM_CLEAR="$(tput clear)"
    TERM_FLASH="$(tput flash)"
fi
export PS0="\[$TXT_RESET\]"
export PS1="\[$TXT_RESET\][\#] \[$TXT_CYAN_FG\]\u\[$TXT_RESET\]@\[$TXT_GREEN_FG\]\h\[$TXT_RESET\]:\[$TXT_YELLOW_FG\]\w\[$TXT_RESET\] \$ \[$TXT_RED_FG\]"
export PS1="\[$TXT_RESET$TXT_BRIGHT_BLACK_FG\]\D{%FT%T%z} exit \$?\n$PS1"
case $TERM in
    xterm*) export PS1="\[\033]0;\u@\h \l\007\]$PS1";;
esac

[[ ":$PATH:" == *':.:'* ]] || export PATH=".:$PATH"
export PIP_REQUIRE_VIRTUALENV=true

alias cdtmp='cd "$(mktemp -d)"'
alias grep='grep --color=auto'
alias less='less -r'
alias ll='ls -h -l'
alias watch='watch --color'

# system-specific
case "$(uname -s)" in
    Darwin)
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
    Linux)
        eval "$(dircolors --sh)"  # Set LS_COLORS.
        alias ls='ls --color=auto'
        alias crontab='crontab -i'
        ;;
    *) echo 'This OS is not recognized.' 1>&2
esac

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
        [[ -z "$ipv4" ]] || echo "IPv4: $ipv4"
        [[ -z "$ipv6" ]] || echo "IPv6: $ipv6"
    else
        [[ -z "$ipv6" ]] || echo "IPv6: $ipv6"
        [[ -z "$ipv4" ]] || echo "IPv4: $ipv4"
    fi
}

capture () {
    # Redirect output to unique files.
    local unique && unique="$(date -u "+%Y%m%dT%H%M%SZ").$(hostname -s).$$"
    local stdcmd && stdcmd="$unique.stdcmd.bash"
    local stderr && stderr="$unique.stderr.log"
    local stdout && stdout="$unique.stdout.log"
    echo "#!$BASH" >> "$stdcmd"
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
    for i in $(seq $((from)) -1 1)
    do
        printf '%d' "$i"
        sleep 1
        for _ in $(seq "${#i}"); do printf '\b \b'; done
    done
    for _ in $(seq "${#prompt}"); do printf '\b \b'; done
}

projects () {
    # Show info about projects.
    # shellcheck disable=SC2068
    for path_ in ${@:-"${PROJECTS:-"$HOME/projects"}/"*}
    do
        echo
        echo "$TXT_BOLD_FG$TXT_BLUE_FG$(basename "$path_")$TXT_RESET"
        git -C "$path_" show-ref --abbrev --head --heads 2>/dev/null
        git -C "$path_" stash list 2>/dev/null
        git -C "$path_" status --branch --short
    done
}

refresh_config () {
    # Install the latest dmtucker/config.
    local usage="usage: ${FUNCNAME[0]}"
    if (( $# > 0 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    url='https://raw.githubusercontent.com/dmtucker/config/main/install.bash'
    wget -O- "$url" | "$BASH"
}

weather () {
    # Get the weather.
    local usage="usage: ${FUNCNAME[0]} [city]"
    if (( $# > 1 ))
    then
        echo "$usage" 1>&2
        return 1
    fi
    wget -qO- "https://wttr.in/$1"
}
