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
        openjdk-8-jdk \
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
        lsof \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64
WORKDIR /opt

ARG build3rddeps=true
RUN if [ "$build3rddeps" = "true" ]; then git clone https://github.com/liusheng/kudu -b aarch64-support \
    && cd kudu \
    && bash -ex thirdparty/build-if-necessary.sh; fi

COPY entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

