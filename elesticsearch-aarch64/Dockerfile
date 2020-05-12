FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
        git \
        openjdk-8-jdk \
        openjdk-11-jdk \
        curl \
        xz-utils

    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

RUN curl -L -O https://builds.shipilev.net/openjdk-jdk14/openjdk-jdk14-latest-linux-aarch64-release.tar.xz \
    && tar xf openjdk-jdk14-latest-linux-aarch64-release.tar.xz

ENV JAVA_HOME /opt/jdk-11/jdk
ENV JAVA8_HOME /usr/lib/jvm/java-8-openjdk-arm64
ENV JAVA11_HOME /usr/lib/jvm/java-11-openjdk-arm64

ARG prebuild=false
RUN if [ "$prebuild" = "true" ]; then git clone https://github.com/liusheng/elasticsearch \
    && cd elasticsearch \
    ./gradlew assemble
