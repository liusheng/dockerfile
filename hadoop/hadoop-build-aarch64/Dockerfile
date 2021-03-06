FROM ubuntu:bionic

LABEL org.opencontainers.image.source="https://github.com/liusheng/hadoop-2.7.7-openeuler"
LABEL maintainer="liusheng2048@gmail.com"

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
        pkg-config \
        libssl-dev \
        libssl1.0.0 \
        libsasl2-dev \
        bats \
        curl \
        sudo \
        git \
        zlib1g-dev \
        libsnappy-dev \
        bzip2 \
        libbz2-dev \
        libzstd1-dev \
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


######
# Install Google Protobuf 3.7.1 (2.6.0 ships with Xenial)
######
#RUN mkdir -p /opt/protobuf-src \
#    && curl -L -s -S \
#      https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-java-3.7.1.tar.gz \
#      -o /opt/protobuf.tar.gz \
#    && tar xzf /opt/protobuf.tar.gz --strip-components 1 -C /opt/protobuf-src \
#    && cd /opt/protobuf-src \
#    && ./configure --prefix=/opt/protobuf \
#    && make install \
#    && cd /root \
#    && rm -rf /opt/protobuf-src
#ENV PROTOBUF_HOME /opt/protobuf
#ENV PATH "${PATH}:/opt/protobuf/bin"

# Use pre-compiled protobuf to save time
RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-3.7.1.tar.gz | tar zx -C /opt/
RUN echo "/opt/protobuf-3.7.1/lib/" > /etc/ld.so.conf.d/protobuf-3.7.1.conf && ldconfig
ENV PROTOBUF_HOME /opt/protobuf-3.7.1
ENV PATH "${PATH}:/opt/protobuf-3.7.1/bin"


# phantomjs 2.1.1 require libicu55 which only in ubuntu xenial
RUN echo "deb http://ports.ubuntu.com/ubuntu-ports xenial main universe" >> /etc/apt/sources.list
RUN apt-get -q update \
    &&	apt-get -q install -y libicu55 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://github.com/liusheng/phantomjs/releases/download/2.1.1/phantomjs-2.1.1-linux-aarch64.tar.bz2 | tar xj -C /tmp/ \
    && cp /tmp/phantomjs-2.1.1-linux-aarch64/bin/phantomjs /usr/bin/

# The manaually compiled snappy seems has issues that break the related tests
#org.apache.hadoop.io.compress.TestCompressorDecompressor.testCompressorDecompressor
#org.apache.hadoop.io.compress.TestCompressorDecompressor.testCompressorDecompressorWithExeedBufferLimit
#org.apache.hadoop.io.compress.snappy.TestSnappyCompressorDecompressor.testSnappyCompressDecompressInMultiThreads
#org.apache.hadoop.io.compress.snappy.TestSnappyCompressorDecompressor.testSnappyCompressDecompress
#RUN git clone https://github.com/google/snappy /opt/snappy \
#    && cd /opt/snappy \
#    && mkdir build \
#    && cd build/ && cmake ../ && make \
#    && make install

#RUN apt-get -q update \
#    &&	apt-get -q install -y libsnappy1v5=1.1.3-2 \
#         libsnappy-dev=1.1.3-2 \
#         snappy \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*

# install Bost 1.72
RUN curl -L https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.bz2/download > boost_1_72_0.tar.bz2 \
    && tar --bzip2 -xf boost_1_72_0.tar.bz2 \
    && cd boost_1_72_0 \
    && ./bootstrap.sh --prefix=/usr/ \
    && ./b2 --without-python install

########## For Hbase building ###################
RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-3.5.1.1.tar.gz | tar zx -C /opt/
RUN echo /opt/protobuf-3.5.1.1/lib/ > /etc/ld.so.conf.d/protobuf-3.5.1.1.conf && ldconfig
RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-2.5.0.tar.gz | tar zx -C /opt/
RUN echo /opt/protobuf-2.5.0/lib/ > /etc/ld.so.conf.d/protobuf-2.5.0.conf && ldconfig
RUN curl -sL https://www.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar zx -C /opt/

########## For Hbase building ###################

RUN groupadd hadoop
RUN useradd -m -d /home/hadoop -s /bin/bash hadoop -g hadoop
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hadoop
WORKDIR /home/hadoop

RUN curl -sL https://github.com/liusheng/package/files/3904116/wildfly-openssl-1.0.7.Final.jar.tar.gz | tar zx \
    && mvn install:install-file -DgroupId=org.wildfly.openssl -Dfile=wildfly-openssl-1.0.7.Final.jar -DartifactId=wildfly-openssl -Dversion=1.0.7.Final -Dpackaging=jar \
    && rm wildfly-openssl-1.0.7.Final.jar

RUN curl -sL https://github.com/liusheng/package/releases/download/netty-all/netty-all-4.1.27-linux-aarch64.jar.tar.gz | tar zx \
    && mvn install:install-file -DgroupId=io.netty -Dfile=netty-all-4.1.27-linux-aarch64.jar -DartifactId=netty-all -Dversion=4.1.27.Final -Dpackaging=jar \
    && rm netty-all-4.1.27-linux-aarch64.jar

RUN sudo echo "umask 022" >> ~/.profile

# Use pre-compiled hbase artifact
#RUN mkdir -p ~/.m2/repository/org/apache/ \
#    && cd ~/.m2/repository/org/apache/ \
#    && curl -sL https://github.com/liusheng/package/releases/download/hbase-2.0.2-artifacts-aarch64/hbase.tar.gz | tar zx

###
# Avoid out of memory errors in builds
###
ENV MAVEN_OPTS -Xms256m -Xmx1536m -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss

RUN mkdir -p ~/hadoop-results/

# docker build . -t liusheng2048/hadoop-aarch64:pre-build --build-arg prebuild=true
ARG prebuild=false
RUN if [ "$prebuild" = "true" ]; then git clone https://github.com/apache/hadoop \
    && cd hadoop \
    && mvn clean install -e -B -Pdist,native -Dtar -DskipTests -Dmaven.javadoc.skip 2>&1 | sudo tee ~/hadoop-results/hadoop_build.log \
    && export PATH=${PATH}:$(realpath ~/hadoop/hadoop-dist/target/hadoop-*-SNAPSHOT/bin); fi

CMD if [ ! -d hadoop ]; then git clone https://github.com/apache/hadoop; fi \
    && cd hadoop \
    && mvn clean install -e -B -Pdist,native -Dtar -DskipTests -Dmaven.javadoc.skip 2>&1 | sudo tee ~/hadoop-results/hadoop_build.log \
    && export PATH=$PATH:$(realpath hadoop-dist/target/hadoop-*-SNAPSHOT/bin/) \
    && mvn test -B -e -fn | sudo tee ~/hadoop-results/hadoop_all_test.log
