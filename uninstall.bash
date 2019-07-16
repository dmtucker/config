#!/usr/bin/env bash

set -o errexit;   # Stop the script if any command fails.
set -o pipefail;  # "The pipeline's return status is the value of the last
                  # (rightmost) command to exit with a non-zero status,
                  # or zero if all commands exit success fully."
set -o xtrace;    # Show commands as they execute.

# This should be set by install.bash.
config_home=
[ "$config_home" = '' ] && {
    echo 'This script was not installed correctly.'
    exit 1
}

# As install.bash runs, commands to uninstall configs are appended to this file.
# Since later things (e.g. `rm "$config_home/some.config"`)
# may build on earlier things (e.g. `rmdir "$config_home"`),
# the commands should be executed in reverse order to uninstall.
# shellcheck disable=SC2120
command -v tac &>/dev/null || tac () { tail -r "$@"; }
# shellcheck disable=SC2119
tail -n "+$((LINENO + 2))" "${BASH_SOURCE[0]}" | tac | "$BASH" -o errexit -o pipefail -o xtrace 2>&1 | sed 's/^/  /'
exit 0  # Do not execute commands that get appended.
