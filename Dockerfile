FROM ubuntu:22.04
RUN apt update -y && apt install -y unzip curl python3 python3-pip
COPY ./init.sh /opt/init.sh
RUN mkdir /opt/tools/
WORKDIR /opt/tools/
RUN bash /opt/tools/init.sh
