#!/usr/bin/env sh

[ "$PROJECTS" = '' ] && export PROJECTS="$HOME/projects"

if [ ! -e "$PROJECTS" ]
then
    printf 'Creating a directory for projects... '
    mkdir -p "$PROJECTS"
    echo "$PROJECTS"
fi

if [ ! -e "$PROJECTS/config" ]
then
    echo 'Installing tools...'
    case "$(uname -s)" in
        Linux)
            case "$(lsb_release -is)" in
                Debian|Ubuntu)
                    sudo apt-get update
                    sudo apt-get -y -qq install openssh git
                    ;;
                *)
                    echo "Your distro ($(lsb_release -is)) is not supported." 1>&2
                    exit 1
                    ;;
            esac;;
        *)
            echo "Your operating system ($(uname -s)) is not supported." 1>&2
            exit 1
    esac

    printf 'Generating an SSH key... '
    algorithm='ecdsa'
    key="$HOME/.ssh/id_$algorithm"
    ssh-keygen -q -t "$algorithm" -f "$key" -N ''
    echo "$key.pub"

    printf 'Cloning the config repository... '
    git clone 'https://github.com/dmtucker/config.git' "$PROJECTS/config"
    git remote set-url origin 'git@github.com:dmtucker/config.git'
    echo "$PROJECTS/config"
fi

if ! command -v make 1>/dev/null 2>&1
then
    echo 'Installing make...'
    case "$(uname -s)" in
        Linux)
            case "$(lsb_release -is)" in
                Debian|Ubuntu)
                    sudo apt-get update
                    sudo apt-get -y -qq install make
                    ;;
                *)
                    echo "Your distro ($(lsb_release -is)) is not supported." 1>&2
                    exit 1
                    ;;
            esac;;
        *)
            echo "Your operating system ($(uname -s)) is not supported." 1>&2
            exit 1
    esac
fi

echo 'Configuring...'
cd "$PROJECTS/config"
make cli
