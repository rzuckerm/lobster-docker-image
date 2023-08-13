FROM ubuntu:22.04

COPY LOBSTER_* /tmp/
RUN apt-get update && \
    apt-get install -y git cmake build-essential mesa-common-dev libasound2-dev libxext-dev && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/aardappel/lobster.git -b v$(cat /tmp/LOBSTER_VERSION) && \
    cd lobster/dev && \
    cmake -DCMAKE_BUILD_TYPE=Release && \
    make -j8 && \
    cd / && \
    cp /opt/lobster/bin/lobster /usr/local/bin && \
    cp -r /opt/lobster/modules /usr/local/ && \
    rm -rf /opt/lobster && \
    apt-get remove -y git cmake build-essential libasound2-dev libxext-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
