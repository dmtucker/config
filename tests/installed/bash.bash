for name in .bashrc .bash_profile .profile
do
    path="$HOME/$name"
    [ -L "$path" ] || {
        echo "$path is no longer a symlink!"
        exit 1
    }
done
