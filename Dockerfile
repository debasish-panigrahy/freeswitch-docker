# Base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
  libncurses5 \
  libssl3 \
  libedit2 \
  libcurl4 \
  libsndfile1 \
  libopus0 \
  libspeexdsp1 \
  libavformat59 \
  libswscale6 \
  libvpx7 \
  yasm \
  unzip && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Create FreeSWITCH directory
WORKDIR /usr/local/freeswitch

# Copy your prebuilt FreeSWITCH directory from your repo
COPY freeswitch/ /usr/local/freeswitch/

# Expose ports
EXPOSE 5060/udp 5060/tcp \
       5080/udp 5080/tcp \
       5066/tcp \
       7443/tcp \
       8021/tcp \
       16384-32768/udp

# Start FreeSWITCH
CMD ["/usr/local/freeswitch/bin/freeswitch", "-nonat", "-nf"]
