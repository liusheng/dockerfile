FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    cmake make g++ python openssh-server \
    sudo git iputils-ping vim curl

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends openjdk-8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64

RUN apt-get -q update && apt-get -q install -y maven

RUN groupadd ambari
RUN useradd -m -d /home/ambari -s /bin/bash ambari -g ambari
RUN echo "ambari ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ambari
WORKDIR /home/ambari

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

CMD git clone https://github.com/apache/ambari \
    && cd ambari \
    && mvn -e install
#ENV MAVEN_OPTS -Xms256m -Xmx1536m