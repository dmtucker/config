vimrc="$HOME/.vimrc"
target=/tmp/vimrc
touch "$vimrc"
mv -v "$vimrc" "$target"
ln -vs "$target" "$vimrc"
