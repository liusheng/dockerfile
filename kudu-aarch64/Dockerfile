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
        python-dev \
        python3 \
        python3-dev \
        python3-pip \
        virtualenv \
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
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64
ENV JAVA8_HOME /usr/lib/jvm/java-8-openjdk-arm64

WORKDIR /opt

ARG build3rddeps=true
ARG 3rdparty_type=''
RUN if [ "$build3rddeps" = "true" ]; then git clone https://github.com/apache/kudu \
    && cd kudu \
    && bash -ex thirdparty/build-if-necessary.sh $3rdparty_type 2>&1 |tee -a /opt/kudu-build3rd.log; fi

COPY entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

ENV PULL_CODE=""

ENTRYPOINT ["/opt/entrypoint.sh"]