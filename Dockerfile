FROM debian:latest
MAINTAINER david@tucker.name
RUN apt-get update && apt-get install -y sudo
WORKDIR /root
COPY deploy.sh .
RUN ./deploy.sh
ENTRYPOINT ["bash"]
