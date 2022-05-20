vimrc="$HOME/.vimrc"
[ -L "$vimrc" ] || {
    echo "$vimrc is no longer a symlink!"
    exit 1
}
