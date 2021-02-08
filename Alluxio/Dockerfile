FROM ubuntu:focal

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    && git maven openjdk-11-jdk
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64