#!/usr/bin/env bash

[ "$#" -gt 1 ] && {
    echo "usage: [CONFIG_HOME=path] '${BASH_SOURCE[0]}' [config-repo]" 1>&2
    exit 1
}

set -o errexit;   # Stop the script if any command fails.
set -o pipefail;  # "The pipeline's return status is the value of the last
                  # (rightmost) command to exit with a non-zero status,
                  # or zero if all commands exit success fully."
set -o xtrace;    # Show commands as they execute.

# Get the path of the directory to install.
config_repo="$1"
[ -d "$config_repo" ] || {
    config_archive="$config_repo"
    [ -e "$config_archive" ] || {
        [ "$#" = 1 ] && {
            echo "'$config_archive' does not exist." 1>&2
            exit 1
        }
        config_archive="$(mktemp)"
        wget --output-document "$config_archive" 'https://github.com/dmtucker/config/archive/master.tar.gz'
    }
    config_repo="$(mktemp -d)"
    tar -vxzf "$config_archive" -C "$config_repo" --strip-components=1
}

# Get the path of the directory to install to.
[ -n "$CONFIG_HOME" ] || CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}/dmtucker"

# Remove the existing installation, if there is one.
config_uninstall="$CONFIG_HOME/uninstall.bash"
[ -e "$config_uninstall" ] && "$BASH" -u "$config_uninstall" 2>&1 | sed 's/^/  /'

# Initialize $CONFIG_HOME and $config_uninstall.
tmp_uninstall="$(mktemp)"
sed -e "s#^config_home=\$#&'$CONFIG_HOME'#" "$config_repo/$(basename "$config_uninstall")" > "$tmp_uninstall"
[ -e "$CONFIG_HOME" ] || {
    mkdir -p "$CONFIG_HOME"
    echo "rmdir '$CONFIG_HOME'" >> "$tmp_uninstall"
}
mv "$tmp_uninstall" "$config_uninstall"
echo "rm '$config_uninstall'" >> "$config_uninstall"

# Install configs.
install_scripts="$config_repo/install"
for script in "$install_scripts"/*.bash
do "$BASH" -u -o errexit -o pipefail -o xtrace "$script" "$config_repo" "$CONFIG_HOME" "$config_uninstall" 2>&1 | sed 's/^/  /'
done
echo 'Installation succeeded.'
