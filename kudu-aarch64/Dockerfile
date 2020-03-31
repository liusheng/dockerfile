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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64
ENV JAVA8_HOME /usr/lib/jvm/java-8-openjdk-arm64

# use non-root  user
RUN useradd -m -d /home/kudu -s /bin/bash kudu && echo kudu:kudu | chpasswd && adduser kudu sudo
RUN echo "kudu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER kudu
WORKDIR /home/kudu

ARG build3rddeps=true
RUN if [ "$build3rddeps" = "true" ]; then git clone https://github.com/apache/kudu \
    && cd kudu \
    && git config --global user.email "nobody@example.com" \
    && git config --global user.name "nobody" \
    && git checkout -b aarch64-support \
    && curl -sL https://patch-diff.githubusercontent.com/raw/liusheng/kudu/pull/7.patch -o aarch64-support.patch \
    && git am aarch64-support.patch \
    && bash -ex thirdparty/build-if-necessary.sh 2>&1 |tee -a ~/kudu-build3rd.log; fi

COPY entrypoint.sh /home/kudu/
RUN chmod +x /home/kudu/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

