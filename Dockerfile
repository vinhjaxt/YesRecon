FROM ubuntu:22.04
RUN apt update -y && apt install -y unzip curl python3 python3-pip
RUN mkdir /opt/tools/
WORKDIR /opt/tools/
COPY ./init.sh /opt/tools/init.sh
RUN bash /opt/tools/init.sh
