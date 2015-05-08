#!/usr/bin/env sh

if [ "$(id -un)" != '0' ]
then
    echo 'You must be root.' 1>&2
    exit "$LINENO"
fi

case "$$(uname -s)" in
    Linux)
        case "$$(lsb_release -is)" in
            Debian)
                apt-get -y -qq install \
                    git \
                    make \
                    ssh openssh-server
                ;;
            *)
                echo "Your distribution ($$(lsb_release -is)) is not supported." 1>&2
                exit "$LINENO"
        esac;;
    *)
        echo "Your operating system ($$(uname -s)) is not supported." 1>&2
        exit "$LINENO"
esac

printf 'Generating an SSH key... '
key="$HOME/.ssh/id_ecdsa"
ssh-keygen -q -t ecdsa -f "$key" -N ''
less "$key.pub"
echo "$key.pub"

printf 'Cloning projects... '
mkdir -p "$HOME/projects"
cd "$HOME/projects"
git clone git@github.com:dmtucker/config.git
cd -
echo 'done'

echo 'Configuring... '
cd "$HOME/projects/config"
make workstation
cd -