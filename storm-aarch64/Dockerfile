FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

######
# Install common dependencies from packages. Versions here are either
# sufficient or irrelevant.
# WARNING: DO NOT PUT JAVA APPS HERE! Otherwise they will install default
# Ubuntu Java.  See Java section below!
######
RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
        build-essential \
        autoconf \
        automake \
        libtool \
        cmake \
        zlib1g-dev \
        pkg-config \
        libssl-dev \
        libssl1.0.0 \
        libsasl2-dev \
        bats \
        curl \
        sudo \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#######
# OpenJDK 8
#######
RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64

RUN apt-get -q update \
    &&	apt-get -q install -y maven \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/storm -s /bin/bash storm && echo storm:storm | chpasswd && adduser storm sudo
RUN echo "storm ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER storm
WORKDIR /home/storm

# docker build . -t liusheng2048/storm-aarch64:pre-build --build-arg prebuild=true
ARG prebuild=false
RUN if [ "$prebuild" = "true" ]; then git clone https://github.com/apache/storm \
    && cd storm \
    && mvn clean install -e -B -Pdist,native -Dtar -DskipTests -Dmaven.javadoc.skip 2>&1 | sudo tee ~/storm-results/storm_build.log \
    && export PATH=${PATH}:$(realpath ~/storm/storm-dist/target/storm-*-SNAPSHOT/bin); fi
