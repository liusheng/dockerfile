FROM ghcr.io/liusheng/hadoop-2.7.7-openeuler:pre-build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN yum update && yum install -y iproute

ENV HADOOP_HOME /home/hadoop/hadoop/hadoop-dist/target/hadoop-2.7.7
ENV PATH "${PATH}:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"

USER hadoop
WORKDIR $HADOOP_HOME

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
