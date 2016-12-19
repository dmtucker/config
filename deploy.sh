#!/usr/bin/env sh
sudo apt-get update;
[ "$PROJECTS" = '' ] && export PROJECTS="$HOME/projects";
if [ ! -e "$PROJECTS" ]; then
    printf 'Creating a directory for projects... ';
    mkdir -p "$PROJECTS";
    echo "$PROJECTS";
fi;
if [ ! -e "$PROJECTS/config" ]; then
    if ! command -v git > /dev/null 2>&1; then
        echo 'Installing git...';
        sudo apt-get install -y git;
    fi;
    printf 'Cloning the config repository... ';
    git clone 'https://github.com/dmtucker/config.git' "$PROJECTS/config";
    echo "$PROJECTS/config";
fi;
if ! command -v make > /dev/null 2>&1; then
    echo 'Installing make...';
    sudo apt-get install -y make;
fi;
echo 'Configuring...';
cd "$PROJECTS/config";
make all
