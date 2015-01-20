#!/usr/bin/env sh
screen -dS irc -m irssi --connect=chat.freenode.net --nick="$(hostname -s)"

