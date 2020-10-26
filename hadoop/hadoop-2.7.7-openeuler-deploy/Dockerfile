FROM ghcr.io/liusheng/hadoop-2.7.7-openeuler:pre-build

LABEL org.opencontainers.image.source="https://github.com/liusheng/dockerfile"
LABEL maintainer="liusheng2048@gmail.com"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root

RUN yum update -y && yum install -y iproute

USER hadoop
WORKDIR $HADOOP_HOME

ENV HADOOP_HOME /home/hadoop/hadoop/hadoop-dist/target/hadoop-2.7.7
ENV PATH "${PATH}:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"

COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/

RUN sudo ssh-keygen -A \
&& sudo /usr/sbin/sshd \
&& ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
&& cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
&& chmod 0600 ~/.ssh/authorized_keys

RUN echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))" >> ~/.bashrc

## I have no idea about this
#RUN echo "export JAVA_HOME=${JAVA_HOME}" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

EXPOSE 8088 19888
COPY entrypoint.sh /opt/
RUN sudo chmod +x /opt/entrypoint.sh && sudo chown hadoop.hadoop /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]
