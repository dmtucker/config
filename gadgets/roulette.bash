#!/usr/bin/env bash
USAGE="usage: $(basename "$0")"
if [[ "$#" != '0' ]]
then
    echo "$USAGE" 1>&2
    exit 1
fi
if [[ "$EUID" = '0' ]]
then

    [[ $- = *i* ]] || exit 1  # Require an interactive shell.

    echo
    echo 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    echo 'WARNING: PLAY AT YOUR OWN RISK. IRREVERSIBLE DAMAGE MAY ENSUE.'
    echo 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    echo
    echo 'If you lose, the following command will be run:'
    echo '# rm -rf --no-preserve-root /'
    echo 'It will delete your entire filesystem!'
    echo
    
    challenge='I may be about to delete everything on my filesystem.'
    echo "Type \"$challenge\" to proceed."
    read -p '----> ' response
    if [[ "$response" != "$challenge" ]]; then echo 'mismatch' && exit 1; fi
    
    echo -n 'So be it...'
    for i in {10..1}; do echo -n " $i " && sleep 1; done
    
    if [[ "$(( $RANDOM % 6 ))" = '0' ]]
    then echo '*bang*' && rm -rf --no-preserve-root /
    else echo '*click*'
    fi

else [[ "$(( $RANDOM % 6 ))" = '0' ]] && echo '*bang*' || echo '*click*'
fi
