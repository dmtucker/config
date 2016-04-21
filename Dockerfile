FROM debian:latest
MAINTAINER david.michael.tucker@gmail.com
RUN apt-get update && apt-get install -y lsb-release sudo
WORKDIR /root
COPY . projects/config/
RUN projects/config/deploy.sh
ENTRYPOINT ["bash"]
