FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisite packages
RUN apt-get update && apt-get install -y \
  git wget curl gnupg2 lsb-release ca-certificates \
  build-essential autoconf automake libtool pkg-config \
  libncurses5-dev libssl-dev libedit-dev \
  libcurl4-openssl-dev libspeexdsp-dev libopus-dev \
  libsndfile1-dev libavformat-dev libswscale-dev \
  libvpx-dev libyuv-dev yasm unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Step: Clone FreeSWITCH repo
WORKDIR /usr/local/src
RUN git clone https://github.com/signalwire/freeswitch.git

WORKDIR /usr/local/src/freeswitch

# Remove problematic modules BEFORE build (optional but avoids build failure)
RUN sed -i '/mod_signalwire/d' modules.conf && \
    sed -i '/mod_java/d' modules.conf && \
    sed -i '/mod_avmd/d' modules.conf && \
    sed -i '/mod_unimrcp/d' modules.conf && \
    sed -i '/mod_flite/d' modules.conf

# Build steps
RUN ./bootstrap.sh && \
    ./configure && \
    make && \
    make all install cd-sounds-install cd-moh-install

# Ports commonly used by FreeSWITCH
EXPOSE 5060/udp 5060/tcp \
       5080/udp 5080/tcp \
       5066/tcp \
       7443/tcp \
       8021/tcp \
       16384-32768/udp

# Working directory and command to run FreeSWITCH
WORKDIR /usr/local/freeswitch
CMD ["/usr/local/freeswitch/bin/freeswitch", "-nonat", "-nf"]
