FROM dmtucker/config:latest AS test
WORKDIR /tmp/config
COPY . .
RUN bash install.bash .
RUN bash ~/.config/dmtucker/uninstall.bash

FROM koalaman/shellcheck-alpine:v0.6.0
RUN apk add vim
WORKDIR /tmp/config
COPY --from=test /tmp/config .
RUN shellcheck --shell bash *.bash config/*.bash install/*.bash
RUN vim -u NONE -c 'try | source config/vimrc.vim | catch | silent exec "! echo" shellescape(v:exception) | cquit | endtry | quit'

FROM bash:4.4
MAINTAINER david@tucker.name
RUN apk add coreutils grep ncurses
RUN apk add git vim
USER root
WORKDIR /root/config
COPY --from=test /tmp/config .
RUN bash install.bash .
