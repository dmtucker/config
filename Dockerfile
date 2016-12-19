FROM debian:latest
MAINTAINER david@tucker.name
RUN apt-get update && apt-get install -y sudo
WORKDIR /root
COPY . projects/config/
RUN projects/config/deploy.sh
ENTRYPOINT ["bash"]
