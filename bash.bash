set -o errexit;   # Stop the script if any command fails.
set -o pipefail;  # "The pipeline's return status is the value of the last
                  # (rightmost) command to exit with a non-zero status,
                  # or zero if all commands exit success fully."
set -o xtrace;    # Show commands as they execute.

path="$HOME/.dmtucker.bash"
pathdir="$(dirname "$path")"
[ -e "$pathdir" ] || mkdir -p "$pathdir"
url='https://raw.githubusercontent.com/dmtucker/config/master/etc/bashrc.bash'
if command -v curl 1>/dev/null 2>&1
then curl -sSL "$url" > "$path"
elif command -v wget 1>/dev/null 2>&1
then wget -qO- "$url" > "$path"
fi

source_path="source '$path'"
bashrc="$HOME/.bashrc"
grep -q "$source_path" "$bashrc" || echo "$source_path" >> "$bashrc"

# You should therefore always have source ~/.bashrc at the end of your .bash_profile
# in order to force it to be read by a login shell.
# http://mywiki.wooledge.org/DotFiles
source_bashrc="source '$bashrc'"
bash_profile="$HOME/.bash_profile"
grep -q "$source_bashrc" "$bash_profile" || echo "$source_bashrc" >> "$bash_profile"
