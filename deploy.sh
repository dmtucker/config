#!/usr/bin/env sh
get () 
{ 
    for prog in $@;
    do
        os="$(uname -s)";
        case "$os" in 
            Linux)
                if ! command -v lsb_release > /dev/null 2>&1; then
                    echo 'Please install lsb_release and rerun.';
                    exit 1;
                fi;
                dist="$(lsb_release -is)";
                case "$dist" in 
                    Debian)
                        sudo apt-get update;
                        sudo apt-get -y install "$(basename "$prog")"
                    ;;
                    *)
                        echo "Your distribution ($dist) is not supported." 1>&2;
                        exit 1
                    ;;
                esac
            ;;
            *)
                echo "Your operating system ($os) is not supported." 1>&2;
                exit 1
            ;;
        esac;
    done
};
deploy () 
{ 
    [ "$PROJECTS" = '' ] && export PROJECTS="$HOME/projects";
    if [ ! -e "$PROJECTS" ]; then
        printf 'Creating a directory for projects... ';
        mkdir -p "$PROJECTS";
        echo "$PROJECTS";
    fi;
    if [ ! -e "$PROJECTS/config" ]; then
        if ! command -v git > /dev/null 2>&1; then
            echo 'Installing git...';
            get git;
        fi;
        printf 'Cloning the config repository... ';
        git clone 'https://github.com/dmtucker/config.git' "$PROJECTS/config";
        echo "$PROJECTS/config";
    fi;
    if ! command -v make > /dev/null 2>&1; then
        echo 'Installing make...';
        get make;
    fi;
    echo 'Configuring...';
    cd "$PROJECTS/config";
    make all
};
if [ "$#" -gt '0' ]; then
    get "$@";
else
    deploy;
fi
