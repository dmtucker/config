#!/usr/bin/env bash
[ "$#" -ne 3 ] && {
    echo "usage: '${BASH_SOURCE[0]}' config-repo config-home config-undo" 1>&2
    exit 1
}
config_repo="$1"
config_home="$2"
config_undo="$3"

# Deploy configuration for Git.
command -v git &>/dev/null || {
    echo 'Git is not installed. Skipping configuration...'
    exit 0
}
config_gitconfig="$config_home/gitconfig.ini"
cp "$config_repo/config/$(basename "$config_gitconfig")" "$config_gitconfig"
echo "rm '$config_gitconfig'" >> "$config_undo"
git config --global --get include.path "$config_gitconfig" || {
    git config --global --type path include.path "$config_gitconfig"
    echo "git config --global --unset include.path '$config_gitconfig'" >> "$config_undo"
}
echo 'Git configuration succeeded.'
