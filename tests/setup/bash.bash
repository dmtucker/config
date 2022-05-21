for name in .bashrc .bash_profile .profile
do
    path="$HOME/$name"
    target="/tmp/$name"
    touch "$path"
    mv -v "$path" "$target"
    ln -vs "$target" "$path"
done
