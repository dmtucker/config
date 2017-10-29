#!/usr/bin/env bash
set -e;  # Stop the script if any command fails.
set -o pipefail;  # "The pipeline's return status is the value of the last
                  # (rightmost) command to exit with a non-zero status,
                  # or zero if all commands exit success fully."
sudo apt-get update;
[ "$PROJECTS" = '' ] && export PROJECTS="$HOME/Projects";
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
logscript="deploy.$(date +%s.%N).sh"
make all | tee "$logscript"
chmod +x "$logscript"
