FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
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

RUN curl -sL https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-2.5.0.tar.gz | tar zx -C /opt/
RUN echo /opt/protobuf-2.5.0/lib/ > /etc/ld.so.conf.d/protobuf-2.5.0.conf && ldconfig
ENV PROTOBUF_HOME /opt/protobuf-2.5.0
ENV PATH "${PATH}:/opt/protobuf-2.5.0/bin"

RUN useradd -m -d /home/hive -s /bin/bash hive && echo hive:hive | chpasswd && adduser hive sudo
RUN echo "hive ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hive
WORKDIR /home/hive

###
ENV MAVEN_OPTS -Xms256m -Xmx1536m -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss

RUN mvn install:install-file -DgroupId=com.google.protobuf -DartifactId=protoc -Dversion=2.5.0 -Dclassifier=linux-aarch_64 -Dpackaging=exe -Dfile=/opt/protobuf-2.5.0/bin/protoc

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
