FROM ubuntu:22.04
RUN apt update -y && apt install -y sudo
RUN mkdir -p /opt/tools/bin/
WORKDIR /opt/tools/
COPY ./init.sh /opt/tools/init.sh
RUN bash /opt/tools/init.sh
