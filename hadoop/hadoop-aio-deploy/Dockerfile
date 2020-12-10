FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG HADOOP_DIST=hadoop-3.3.0

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
       openssh-server sudo curl openjdk-8-jdk curl vim

#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV HADOOP_HOME /home/hadoop/${HADOOP_DIST}

RUN groupadd hadoop
RUN useradd -m -d /home/hadoop -s /bin/bash hadoop -g hadoop
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hadoop
WORKDIR /home/hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

RUN [ "$(uname -p)" == "aarch64" ] && echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64" >> ~/.profile \
    || echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.profile

RUN [ "$(uname -p)" == "aarch64" ] && hadoop_dist=${HADOOP_DIST}-aarch64 \
    && curl -L https://downloads.apache.org/hadoop/common/${HADOOP_DIST}/${hadoop_dist}.tar.gz | tar zx

COPY --chown=hadoop:hadoop core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml $HADOOP_HOME/etc/hadoop/
ENV PATH "${PATH}:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"

COPY --chown=hadoop:hadoop entrypoint.sh /home/hadoop/
RUN chmod +x /home/hadoop/entrypoint.sh

EXPOSE 8088 19888
ENTRYPOINT ["/home/hadoop/entrypoint.sh"]
