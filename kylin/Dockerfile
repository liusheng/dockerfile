FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    sudo git iputils-ping vim curl openssh-server

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends openjdk-8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64

RUN apt-get -q update && apt-get -q install -y maven

RUN groupadd kylin
RUN useradd -m -d /home/kylin -s /bin/bash kylin -g kylin
RUN echo "kylin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER kylin
WORKDIR /home/kylin

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys
