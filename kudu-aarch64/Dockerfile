FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
        libsasl2-dev \
        libsasl2-modules \
        libsasl2-modules-gssapi-mit \
        libssl-dev \
        libtool \
        lsb-release \
        ntp \
        openssl \
        krb5-admin-server \
        krb5-kdc \
        krb5-user \
        libkrb5-dev \
        doxygen \
        gem \
        graphviz \
        ruby-dev \
        xsltproc \
        zlib1g-dev \
        openjdk-11-jdk \
        patch \
        pkg-config \
        python \
        rsync \
        unzip \
        vim-common \
        make \
        cmake \
        g++ \
        autoconf \
        automake \
        curl \
        flex \
        gdb \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64
WORKDIR /opt

ARG prebuild=false
RUN if [ "$prebuild" = "true" ]; then git clone https://github.com/apache/kudu \
    && cd kudu \
    && curl -O -L https://gist.githubusercontent.com/liusheng/58c39f4f4c84a5a238e49a086eaea664/raw/58216b3f0c4a496e37de652a59005409b616bdcb/patch-patch-kudu-support-aarch64.patch \
    && patch -p0 < patch-patch-kudu-support-aarch64.patch \
    && mkdir -p build/debug \
    && cd build/debug \
    && cmake ../..; fi

CMD git clone https://github.com/apache/kudu \
    && cd kudu \
    && curl -O -L https://gist.githubusercontent.com/liusheng/58c39f4f4c84a5a238e49a086eaea664/raw/58216b3f0c4a496e37de652a59005409b616bdcb/patch-patch-kudu-support-aarch64.patch \
    && patch -p0 < patch-patch-kudu-support-aarch64.patch \
    && mkdir -p build/debug \
    && cd build/debug \
    && cmake ../.. \
    && make -j4

