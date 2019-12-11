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
        apt-utils \
        build-essential \
        bzip2 \
        clang \
        curl \
        doxygen \
        fuse \
        g++ \
        gcc \
        git \
        gnupg-agent \
        libbz2-dev \
        libcurl4-openssl-dev \
        libfuse-dev \
        libprotobuf-dev \
        libprotoc-dev \
        libsasl2-dev \
        libsnappy-dev \
        libssl-dev \
        libtool \
        libzstd1-dev \
        locales \
        make \
        pinentry-curses \
        pkg-config \
        python \
        python2.7 \
        python-pip \
        python-pkg-resources \
        python-setuptools \
        python-wheel \
        rsync \
        software-properties-common \
        snappy \
        sudo \
        valgrind \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#######
# OpenJDK 8
#######
RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get -q update \
    &&	apt-get -q install -y maven \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/google/snappy /opt/snappy \
    && cd /opt/snappy \
    && mkdir build \
    && cd build/ && cmake ../ && make \
    && make install

RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-x86/protobuf-3.7.1.tar.gz | tar zx -C /opt/
RUN echo "/opt/protobuf-3.7.1/lib/" > /etc/ld.so.conf.d/protobuf-3.7.1.conf && ldconfig
ENV PROTOBUF_HOME /opt/protobuf-3.7.1
ENV PATH "${PATH}:/opt/protobuf-3.7.1/bin"

########## For Hbase building ###################

RUN useradd -m -d /home/hadoop -s /bin/bash hadoop && echo hadoop:hadoop | chpasswd && adduser hadoop sudo
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hadoop
WORKDIR /home/hadoop

RUN sudo echo "umask 022" >> ~/.profile

###
# Avoid out of memory errors in builds
###
ENV MAVEN_OPTS -Xms256m -Xmx1536m -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss

RUN mkdir -p ~/hadoop-results/

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
