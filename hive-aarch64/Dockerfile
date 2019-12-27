FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

######
# Install common dependencies from packages. Versions here are either
# sufficient or irrelevant.
# WARNING: DO NOT PUT JAVA APPS HERE! Otherwise they will install default
# Ubuntu Java.  See Java section below!
######
#RUN apt-get -q update \
#    && apt-get -q install -y --no-install-recommends \
#        build-essential \
#        autoconf \
#        automake \
#        libtool \
#        cmake \
#        zlib1g-dev \
#        pkg-config \
#        libssl-dev \
#        libssl1.0.0 \
#        libsasl2-dev \
#        bats \
#        curl \
#        sudo \
#        git \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*

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

# Use pre-compiled protobuf to save time
RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-3.7.1.tar.gz | tar zx -C /opt/
RUN echo "/opt/protobuf-3.7.1/lib/" > /etc/ld.so.conf.d/protobuf-3.7.1.conf && ldconfig
ENV PROTOBUF_HOME /opt/protobuf-3.7.1
ENV PATH "${PATH}:/opt/protobuf-3.7.1/bin"


RUN useradd -m -d /home/hive -s /bin/bash hive && echo hive:hive | chpasswd && adduser hive sudo
RUN echo "hive ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hive
WORKDIR /home/hive

###
ENV MAVEN_OPTS -Xms256m -Xmx1536m -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss

RUN mkdir -p ~/hive-results/

ARG prebuild=false
RUN if [ "$prebuild" = "true" ]; then git clone https://github.com/apache/hive \
    && cd hive \
    && mvn clean install -e -B -Pdist,native -Dtar -DskipTests -Dmaven.javadoc.skip 2>&1 | sudo tee ~/hive-results/hive_build.log \
    && export PATH=${PATH}:$(realpath ~/hive/hive-dist/target/hive-*-SNAPSHOT/bin); fi

CMD if [ ! -d hive ]; then git clone https://github.com/apache/hive; fi \
    && cd hive \
    && mvn clean install -e -B -Pdist,native -Dtar -DskipTests -Dmaven.javadoc.skip 2>&1 | sudo tee ~/hive-results/hive_build.log \
    && export PATH=$PATH:$(realpath hive-dist/target/hive-*-SNAPSHOT/bin/) \
    && mvn test -B -e -fn | sudo tee ~/hive-results/hive_all_test.log
