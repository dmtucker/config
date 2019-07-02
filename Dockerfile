FROM bash:4
MAINTAINER david@tucker.name
USER root
WORKDIR /root
RUN apk add coreutils ncurses
COPY . .
RUN bash deploy.bash
