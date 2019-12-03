FROM ubuntu:xenial

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
        libsnappy-dev \
        bats \
        curl \
        sudo \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#######
# OpenJDK 7
#######
RUN apt-get -q update \
    && apt-get install -f \
    && apt-get -q install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa -y \
    && apt-get -q update \
    && apt-get -q install -y --no-install-recommends openjdk-7-jre \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-arm64

RUN curl -sL https://www.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar zx -C /opt/
ENV PATH "${PATH}:/opt/apache-maven-3.5.4/bin/"

########## For Hbase building ###################
RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-3.5.1.1.tar.gz | tar zx -C /opt/
RUN echo /opt/protobuf-3.5.1.1/lib/ > /etc/ld.so.conf.d/protobuf-3.5.1.1.conf
RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-2.5.0.tar.gz | tar zx -C /opt/
RUN echo /opt/protobuf-2.5.0/lib/ > /etc/ld.so.conf.d/protobuf-2.5.0.conf \
    && ldconfig
RUN curl -sL https://www.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar zx -C /opt/

ENV PATH "${PATH}:/opt/protobuf-2.5.0/bin/"
########## For Hbase building ###################

RUN useradd -m -d /home/hbase -s /bin/bash hbase && echo hbase:hbase | chpasswd && adduser hbase sudo
RUN echo "hbase ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hbase
WORKDIR /home/hbase

###
# Avoid out of memory errors in builds
###
ENV MAVEN_OPTS -Xms256m -Xmx1536m -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss

RUN mkdir -p ~/hbase-logs/

CMD git clone https://github.com/apache/hbase \
    && cd hbase \
    && git checkout rel/1.4.8 \
    && mvn clean package -Prelease -DskipTests 2>&1 | tee ~/hadoop-logs/hadoop_build.log
