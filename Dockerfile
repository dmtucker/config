FROM debian:latest
RUN apt-get update && apt-get -y install \
  curl \
  lsb-release \
  make \
  openssh-client \
  sudo
COPY . $HOME/projects/config
WORKDIR $HOME/projects/config
RUN make cli
ENTRYPOINT ["bash"]
