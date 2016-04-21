#!/usr/bin/env sh
os="$(uname -s)";
case "$os" in 
    Darwin)
        echo "Use System Preferences.";
        exit 1
    ;;
    Linux)
        if ! command -v lsb_release > /dev/null 2>&1; then
            echo 'lsb_release is required.';
            exit 1;
        fi;
        dist="$(lsb_release -is)";
        case "$dist" in 
            Debian | Ubuntu)
                apt-get install cups || exit 1;
                adduser "$(id -un)" lpadmin || exit 1;
                echo 'http://localhost:631/admin'
            ;;
            *)
                echo "Your distribution ($dist) is not supported.";
                exit 1
            ;;
        esac
    ;;
    *)
        echo "Your operating system ($os) is not supported.";
        exit 1
    ;;
esac
