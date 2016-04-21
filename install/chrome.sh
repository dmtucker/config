#!/usr/bin/env sh
os="$(uname -s)";
case "$os" in 
    Linux)
        if ! command -v lsb_release 1>/dev/null 2>&1; then
            echo 'lsb_release is required.';
            exit 1;
        fi;
        dist="$(lsb_release -is)";
        case "$dist" in 
            Debian)
                case "$arch" in 
                    x86_64)
                        wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' || exit 1;
                        gdebi ./google-chrome*.deb || exit 1;
                        rm ./google-chrome*.deb || exit 1
                    ;;
                    *)
                        echo "Your architecture $arch is not supported.";
                        exit 1
                    ;;
                esac
            ;;
            Ubuntu)
                case "$arch" in 
                    x86_64)
                        echo 'http://askubuntu.com/questions/79280/how-to-install-chrome-browser-properly-via-command-line';
                        apt-get install libxss1 libappindicator1 libindicator7 || exit 1;
                        wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' || exit 1;
                        dpkg -i ./google-chrome*.deb || exit 1
                    ;;
                    *)
                        echo "Your architecture ($arch) is not supported.";
                        exit 1
                    ;;
                esac
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
