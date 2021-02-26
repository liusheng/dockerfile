FROM ubuntu:focal

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    sudo git maven openjdk-11-jdk curl
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64

RUN groupadd alluxio
RUN useradd -m -d /home/alluxio -s /bin/bash alluxio -g alluxio
RUN echo "alluxio ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER alluxio
WORKDIR /home/alluxio
#ENV MAVEN_OPTS -Xms256m -Xmx1536m