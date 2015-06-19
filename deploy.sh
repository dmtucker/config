#!/usr/bin/env sh

echo 'Installing tools...'
case "$(uname -s)" in
    Linux)
        case "$(lsb_release -is)" in
            Debian|Ubuntu)
                sudo apt-get update
                sudo apt-get -y -qq install ssh openssh-server git make
                ;;
            *)
                echo "Your distro ($(lsb_release -is)) is not supported." 1>&2
                exit "$LINENO"
                ;;
        esac;;
    *)
        echo "Your operating system ($(uname -s)) is not supported." 1>&2
        exit "$LINENO"
esac

printf 'Generating an SSH key... '
algorithm='ecdsa'
key="$HOME/.ssh/id_$algorithm"
ssh-keygen -q -t "$algorithm" -f "$key" -N ''
echo "$key.pub"

printf 'Creating a directory for projects... '
[ "$PROJECTS" = '' ] && export PROJECTS="$HOME/projects"
mkdir -p "$PROJECTS"
echo "$PROJECTS"

printf 'Cloning the config repository... '
git clone 'https://github.com/dmtucker/config.git' "$PROJECTS/config"
echo "$PROJECTS/config"

echo 'Configuring...'
cd "$PROJECTS/config"
git remote set-url origin 'git@github.com:dmtucker/config.git'
make workstation
cd - 1>/dev/null 2>&1
