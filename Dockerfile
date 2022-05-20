FROM koalaman/shellcheck-alpine:v0.8.0 AS static
RUN apk add vim
WORKDIR /tmp/config
COPY . .
RUN find . -name '*.bash' -exec shellcheck --shell bash {} +
RUN vim -u NONE -c 'try | source config/vimrc.vim | catch | silent exec "! echo" shellescape(v:exception) | cquit | endtry | quit'

FROM dmtucker/config:latest AS upgrade
WORKDIR /tmp/config
COPY --from=static /tmp/config .
RUN bash install.bash .

FROM bash:4.4 AS build
RUN apk add coreutils grep ncurses
RUN apk add git vim
USER root
WORKDIR /root/config
COPY --from=static /tmp/config .

FROM build AS tests
ENV SHELLOPTS=errexit:xtrace
RUN for module in tests/setup/*.bash; do bash "$module" || exit 1; done
RUN SHELLOPTS= bash install.bash .
RUN for module in tests/installed/*.bash; do bash "$module" || exit 1; done
RUN SHELLOPTS= bash ~/.config/dmtucker/uninstall.bash
RUN for module in tests/uninstalled/*.bash; do bash "$module" || exit 1; done

FROM build
MAINTAINER david@tucker.name
RUN bash install.bash .
WORKDIR /root
