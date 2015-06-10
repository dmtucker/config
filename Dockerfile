FROM debian:latest
USER root
ADD . /root/config
RUN apt-get update
RUN apt-get -y -qq install lsb-release make sudo openssh-client
RUN cd /root/config && HOME=/root make cli
