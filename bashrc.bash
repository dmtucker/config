[[ $- = *i* ]] || return  # Require an interactive shell.

# TODO Switch from \e to \033 (octal) because of dash.

# foreground
export FG_BLACK=$(tput setaf 0)
export FG_RED=$(tput setaf 1)
export FG_GREEN=$(tput setaf 2)
export FG_YELLOW=$(tput setaf 3)
export FG_BLUE=$(tput setaf 4)
export FG_MAGENTA=$(tput setaf 5)
export FG_CYAN=$(tput setaf 6)
export FG_WHITE=$(tput setaf 7)
export FG_DEFAULT=$(tput setaf 9)

# background
export BG_BLACK=$(tput setab 0)
export BG_RED=$(tput setab 1)
export BG_GREEN=$(tput setab 2)
export BG_YELLOW=$(tput setab 3)
export BG_BLUE=$(tput setab 4)
export BG_MAGENTA=$(tput setab 5)
export BG_CYAN=$(tput setab 6)
export BG_WHITE=$(tput setab 7)
export BG_DEFAULT=$(tput setab 9)

# text
export TG_RESET=$(tput sgr0)
export TG_BOLD=$(tput bold)
export TG_DIM=$(tput dim)
export TG_BLINK=$(tput blink)
export TG_REVERSE=$(tput rev)
export TG_HIDDEN=$(tput invis)

# TODO I am not sure if these are all ANSI.
export UNDERLINE_START=$(tput smul)
export UNDERLINE_STOP=$(tput rmul)
export EMPHASIS_START=$(tput smso)
export EMPHASIS_STOP=$(tput rmso)
export ITALIC_START=$(tput sitm)
export ITALIC_STOP=$(tput ritm)

export PATH="$PATH:."
export PS1='\[\e[0;36m\][\#] \u@\H:\w \$\[\e[0;33m\] '
trap 'printf "\e[0m"' DEBUG                                                     # https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Different_colors_for_text_entry_and_console_output
export PROMPT_COMMAND="printf '\e]0;$USER@$HOSTNAME\a'; $PROMPT_COMMAND"        # http://apple.stackexchange.com/questions/83659/terminal-tab-title-after-ssh-session  # TODO Is this only an OS X thing?

# TODO These are for `gist` on Isilon networks. How do I tell I'm at Isilon?
#export GITHUB_URL='http://github.west.isilon.com/'
export BROWSER='google-chrome'

case "$(uname -s)" in
    Darwin)
        export CLICOLOR=1  # TODO This is a BSD thing, not just OS X.
        toggle_hidden_files () {
            check='defaults read com.apple.Finder AppleShowAllFiles'
            if [ ! $check -o $("$check") = 'NO' ]
            then defaults write com.apple.Finder AppleShowAllFiles YES
            else defaults write com.apple.Finder AppleShowAllFiles NO
            fi
            killall Finder
        }
        alias hidden='toggle_hidden_files'
        alias ls='ls -G'  # TODO This is a BSD thing, not just OS X.
        ;;
    Linux)
        alias ls='ls --color=auto'
        ;;
    *) echo 'This OS is not recognized by dmtucker.bashrc.'
esac

alias ll='ls -lh'
refresh () {
    clear
    ll
}
alias cll='refresh'; alias r='refresh'
fresh () {
    cd "$@"
    refresh
}
alias cdr='fresh'

preview () {
    if [[ "$#" = '0' ]]
    then paths='.'
    else paths="$@"
    fi
    for path in $paths
    do
        if [[ ! -e "$path" ]]
        then
            if [[ "${path:0:1}" == '-' ]]
            then echo "$FUNCNAME cannot handle runtime options yet!" 1>&2
            else echo "$path does not exist." 1>&2
            fi
        elif [[ -d "$path" ]]
        then ls -l "$path"  # TODO -l doesn't belong here.
        elif [[ -f "$path" ]]
        then less "$path"
        else echo "$FUNCNAME cannot handle special files yet!" 1>&2
        fi
    done
}
alias l='preview'

wan_ip () {
    echo "$(curl -s 'http://api.ipify.org?format=txt')"
}
alias wimi='wan_ip'

generate_key () {                                                               # https://gist.github.com/earthgecko/3089509
    cat /dev/urandom |                                                          # http://en.wikipedia.org/?title=/dev/random
    env LC_CTYPE=C tr -dc "a-zA-Z0-9" |
    fold -w "${1:-32}" |
    head -n 1
}
alias keygen='generate_key'

if command -v fortune &> /dev/null; then fortune; fi

