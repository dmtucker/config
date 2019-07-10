FROM dmtucker/config:latest AS test
WORKDIR /tmp/config
COPY . .
RUN bash deploy.bash .
RUN bash deploy.bash .

FROM bash:4.4
MAINTAINER david@tucker.name
RUN apk add coreutils grep ncurses
RUN apk add git vim
USER root
WORKDIR /root/config
COPY --from=test /tmp/config .
RUN bash deploy.bash .
