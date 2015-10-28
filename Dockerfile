FROM debian:latest
USER root
ENV HOME /root
ENV USER root
COPY . $HOME/projects/config
RUN apt-get update
RUN apt-get -y -qq install lsb-release make sudo openssh-client curl
RUN cd $HOME/projects/config && make cli
