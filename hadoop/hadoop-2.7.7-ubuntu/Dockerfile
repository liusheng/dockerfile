FROM ubuntu:trusty

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

######
# Install common dependencies from packages. Versions here are either
# sufficient or irrelevant.
# WARNING: DO NOT PUT JAVA APPS HERE! Otherwise they will install default
# Ubuntu Java.  See Java section below!
######
RUN apt-get update && apt-get install --no-install-recommends -y \
    git curl ant make maven \
    cmake gcc g++ \
    protobuf-compiler libprotoc-dev \
    protobuf-c-compiler libprotobuf-dev \
    build-essential libtool \
    zlib1g-dev pkg-config libssl-dev \
    snappy libsnappy-dev \
    bzip2 libbz2-dev \
    libjansson-dev \
    fuse libfuse-dev \
    libcurl4-openssl-dev \
    python python2.7 pylint \
    openjdk-7-jdk doxygen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Building patched protobuf-2.5.0
RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz | tar zx -C /opt/ \
&& cd /opt/protobuf-2.5.0 \
&& curl -L -O https://gist.githubusercontent.com/liusheng/64aee1b27de037f8b9ccf1873b82c413/raw/118c2fce733a9a62a03281753572a45b6efb8639/protobuf-2.5.0-arm64.patch \
&& patch -p1 < protobuf-2.5.0-arm64.patch \
&& ./configure --prefix=/opt/protobuf \
&& make install
RUN echo "/opt/protobuf/lib/" > /etc/ld.so.conf.d/protobuf-2.5.0.conf && ldconfig
ENV PROTOBUF_HOME /opt/protobuf
ENV PATH "${PATH}:/opt/protobuf/bin"

RUN useradd -m -d /home/hadoop -s /bin/bash hadoop && echo hadoop:hadoop | chpasswd && adduser hadoop sudo
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hadoop
WORKDIR /home/hadoop

RUN git clone https://github.com/kunpengcompute/hadoop -b release-2.7.7-aarch64