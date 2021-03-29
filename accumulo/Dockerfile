FROM ubuntu:focal

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
    maven openjdk-11-jdk cmake make g++ python openssh-server \
    sudo git
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64

RUN groupadd accumulo
RUN useradd -m -d /home/accumulo -s /bin/bash accumulo -g accumulo
RUN echo "accumulo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER accumulo
WORKDIR /home/accumulo
# Need to set USER env for tests running of SiteConfigurationTest
ENV USER accumulo

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

#ENV MAVEN_OPTS -Xms256m -Xmx1536m

CMD git clone https://github.com/apache/accumulo \
    && cd accumulo \
    && mvn -e install
