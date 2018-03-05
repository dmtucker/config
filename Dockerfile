FROM debian:latest
MAINTAINER david@tucker.name
RUN apt-get update && apt-get install -y sudo
WORKDIR /root
COPY . Projects/config
RUN Projects/config/deploy.sh
CMD bash
