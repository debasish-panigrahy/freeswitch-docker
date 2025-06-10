FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install FreeSWITCH runtime dependencies
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
    yasm unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your already compiled FreeSWITCH server
COPY freeswitch /usr/local/freeswitch

WORKDIR /usr/local/freeswitch

# Expose SIP and RTP ports
EXPOSE 5060/udp 5060/tcp 5080/tcp 5066 7443 16384-32768/udp

# Start FreeSWITCH
CMD ["bin/freeswitch", "-nonat", "-nc"]
