FROM openeuler-20.03-lts:latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY openEuler_aarch64.repo /etc/yum.repos.d/
RUN sed -i s'/TMOUT=300/TMOUT=3000000000/' /etc/bashrc

######
# Install common dependencies from packages. Versions here are either
# sufficient or irrelevant.
######
RUN yum update && yum install -y \
    git tar curl patch shadow-utils make cmake gcc gcc-c++ \
    snappy snappy-devel \
    bzip2 libzip-devel \
    java-1.8.0-openjdk java-1.8.0-openjdk-devel \
    zlib zlib-devel
    #openssl openssl-devel

# Hadoop 2.7 require openssl 1.0.x than 1.1.x
RUN curl -sL https://www.openssl.org/source/old/1.0.1/openssl-1.0.1u.tar.gz | tar zx -C /opt/ \
&& cd /opt/openssl-1.0.1u \
&& ./config --prefix=/usr/local --openssldir=/usr/local/ssl \
&& make \
&& make install

# Install maven 3.2.5
RUN curl -sL https://downloads.apache.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz | tar zx -C /opt/
ENV MAVEN_HOME /opt/apache-maven-3.2.5/
ENV PATH "/opt/apache-maven-3.2.5/bin:${PATH}"

####
# Building patched protobuf-2.5.0
###
RUN curl -sSL https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz | tar zx -C /opt/ \
&& cd /opt/protobuf-2.5.0 \
&& curl -L -O https://gist.githubusercontent.com/liusheng/64aee1b27de037f8b9ccf1873b82c413/raw/118c2fce733a9a62a03281753572a45b6efb8639/protobuf-2.5.0-arm64.patch \
&& patch -p1 < protobuf-2.5.0-arm64.patch \
&& ./configure --prefix=/opt/protobuf \
&& make install
RUN echo "/opt/protobuf/lib/" > /etc/ld.so.conf.d/protobuf-2.5.0.conf && ldconfig
ENV PROTOBUF_HOME /opt/protobuf
ENV PATH "${PATH}:/opt/protobuf/bin"

ENV MAVEN_OPTS -Xms256m -Xmx1536m

RUN groupadd hadoop
RUN useradd -m -d /home/hadoop -s /bin/bash hadoop -g hadoop
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hadoop
WORKDIR /home/hadoop

RUN git clone https://github.com/kunpengcompute/hadoop -b release-2.7.7-aarch64
COPY fix-hadoop-native-building.patch hadoop/

ARG prebuild=false
RUN if [ "$prebuild" = "true" ]; then \
    && cd hadoop \
    && git apply fix-hadoop-native-building.patch \
    && mkdir -p ~/hadoop-results/ \
    && export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac)))) \
    && mvn clean install -e -B -Pdist,native -Dtar -DskipTests -Dmaven.javadoc.skip 2>&1 | sudo tee ~/hadoop-results/hadoop_build.log \
    && export PATH=${PATH}:$(readlink -f ~/hadoop/hadoop-dist/target/hadoop-2.7.7/bin); fi
