[[ $- = *i* ]] || return  # Require an interactive shell.
if command -v fortune &>/dev/null; then fortune; fi

######################################################################## exports

export PATH="$PATH:."

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

# shortcuts
export BLACK="$TXT_BLACK_FG"
export RED="$TXT_RED_FG"
export GREEN="$TXT_GREEN_FG"
export YELLOW="$TXT_YELLOW_FG"
export BLUE="$TXT_BLUE_FG"
export MAGENTA="$TXT_MAGENTA_FG"
export CYAN="$TXT_CYAN_FG"
export WHITE="$TXT_WHITE_FG"

# other
export CLEAR="$(tput clear)"
export FLASH="$(tput flash)"

# terminal
export TERM_CUR_TITLE='\033]0'
export TERM_CUR_TITLE_END='\007'

######################################################################### prompt

export PS1="\[$TXT_CYAN_FG\][\D{%F}T\t\D{%z}] \u@\H \\$\[$TXT_YELLOW_FG\] "
TITLE=''
case $TERM in
    xterm*) TITLE="\[$TERM_CUR_TITLE;\u@\h$TERM_CUR_TITLE_END\]";;
esac
export PS1="$TITLE$PS1"
trap "printf '$TXT_RESET'" DEBUG  # Make output the default color.

################################################################ system-specific

ISILON_GITHUB='github.west.isilon.com'
if ping -q -w '1' -i '0.2' "$ISILON_GITHUB" &>/dev/null
then
    # These are for `gist` on Isilon networks.
    export GITHUB_URL="https://$ISILON_GITHUB/"
    export BROWSER='google-chrome'
fi

case "$(uname -s)" in
    Darwin)
        export CLICOLOR=1  # TODO This is a BSD thing, not just OS X.
        toggle_hidden_files () {
            check='defaults read com.apple.Finder AppleShowAllFiles'
            if [ ! $check -o $("$check") = 'NO' ]  # TODO Use bash conditional.
            then defaults write com.apple.Finder AppleShowAllFiles YES
            else defaults write com.apple.Finder AppleShowAllFiles NO
            fi
            killall Finder  # TODO Is this a good idea?
        }
        alias ls='ls -G'  # TODO This is a BSD thing, not just OS X.
        ;;
    Linux)
        alias ls='ls --color=auto'
        ;;
    *) echo 'This OS is not recognized.'
esac

###################################################################### utilities


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
    if [[ "$#" != "1" ]]
    then
        echo "$usage" 1>&2
        return "$LINENO"
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


functions () {
    # Retrieve all the currently set shell functions.
    local usage="usage: $FUNCNAME"
    if [[ "$#" != '0' ]]
    then
        echo "$usage" 1>&2
        return "$LINENO"
    fi
    set | grep -Po '^\w*(?=\s\(\))'
}


pretty_bash () {
    # Pretty print a bash script.
    # Example: Style an existing script in-place.
    #   echo "$(pretty_bash < ~/.bashrc)" > ~/.bashrc
    local usage="usage: $FUNCNAME"
    if [[ "$#" != '0' ]]
    then
        echo "$usage" 1>&2
        return "$LINENO"
    fi
    printf 'pretty(){ %s\n }; declare -f pretty' "$(cat)" | bash
}


preview () {
    # View a file or directory with less or ls, respectively.
    local paths='.'
    [[ "$#" = '0' ]] || paths="$@"
    for path in $paths
    do
        if [[ -f "$path" ]]
        then less "$path"
        elif [[ -d "$path" ]]
        then
            local dst="$path"
            [[ -L "$path" ]] && dst="$path/.."
            cd "$dst"
            pwd
            cd - &>/dev/null
            ls -lh "$path"
        elif [[ -e "$path" ]]
        then echo "$FUNCNAME does not support special files." 1>&2
        elif [[ "${path:0:1}" == '-' ]]
        then echo "$FUNCNAME does not support runtime options." 1>&2
        else echo "$path does not exist." 1>&2
        fi
    done
}
alias l='preview'
alias r='clear && preview' # refresh
cdr () { cd $@ && r; }

# Since `preview` (a.k.a `l`) does not support runtime options,
# it cannot be used to show hidden files in a directory listing.
alias ll='ls -lh' # e.g. `ll -a`


projects () {
    # View the status of git repositorys in ~/projects.
    local loc="$HOME/projects"
    [[ -e "$loc" ]] || mkdir -p "$loc"
    if [[ "$#" = '1' ]]
    then
        local repo="$1"
        shift 1
        cd "$loc/$repo"
        ls -lh
        git status
    else
        cd "$loc"
        local repos="$@"
        [[ "$#" = '0' ]] && repos="$(echo * | sort)"
        for repo in $repos
        do
            echo "$(tput setaf 4)$repo$(tput sgr0)"
            cd "$loc/$repo" &&
            for cmd in 'fetch --all -q' 'status -bs'
            do git $cmd
            done
        done
        cd "$loc"
    fi
}


ssh_copy_id () {
    # Emulate ssh-copy-id.
    local usage="usage: $FUNCNAME [<[user@]host> ...]"
    [[ "$#" -lt '1' ]] && echo "$usage"
    for host in "$@"
    do ssh "$host" "echo $(cat $HOME/.ssh/id_*.pub) >> ~/.ssh/authorized_keys"
    done
}


wan_ip () {
    # Get the public IP address of localhost.
    local usage="usage: $FUNCNAME"
    if [[ "$#" != '0' ]]
    then
        echo "$usage" 1>&2
        return "$LINENO"
    fi
    echo "$(curl -s 'http://api.ipify.org?format=txt')"
}
alias wimi='wan_ip'
