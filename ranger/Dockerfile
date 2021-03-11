FROM ubuntu:focal

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    cmake make g++ python openssh-server \
    sudo git iputils-ping vim curl

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends openjdk-11-jdk

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64

RUN apt-get -q update && apt-get -q install -y maven

RUN groupadd ranger
RUN useradd -m -d /home/ranger -s /bin/bash ranger -g ranger
RUN echo "ranger ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ranger
WORKDIR /home/ranger

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

#ENV MAVEN_OPTS -Xms256m -Xmx1536m