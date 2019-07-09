#!/usr/bin/env bash

set -o errexit;   # Stop the script if any command fails.
set -o pipefail;  # "The pipeline's return status is the value of the last
                  # (rightmost) command to exit with a non-zero status,
                  # or zero if all commands exit success fully."
set -o xtrace;    # Show commands as they execute.

shellcheck --shell bash {.,deploy}/*.bash
vim -u NONE -c 'try | source vimrc.vim | catch | silent exec "! echo" shellescape(v:exception) | cquit | endtry | quit'
