SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
        openssh-server \
        sudo \
        openjdk-11-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG BASEDIR=/opt
ENV HADOOP_HOME $BASEDIR/hadoop-3.3.0
COPY hadoop-3.3.0-aarch64-RC0.tar.gz $BASEDIR
RUN cd $BASEDIR && tar zxf hadoop-*.tar.gz

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-arm64
ENV PATH "${PATH}:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"

RUN cp $HADOOP_HOME/etc/hadoop/core-site.xml{,-bak}
COPY core-site.xml $HADOOP_HOME/etc/hadoop/

RUN cp $HADOOP_HOME/etc/hadoop/hdfs-site.xml{,-bak}
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/

RUN cp $HADOOP_HOME/etc/hadoop/mapred-site.xml{,-bak}
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/

RUN cp $HADOOP_HOME/etc/hadoop/yarn-site.xml{,-bak}
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/

COPY workers $HADOOP_HOME/etc/hadoop/

RUN groupadd hadoop
RUN useradd -m -d /home/yarn -s /bin/bash yarn -g hadoop -G sudo && echo yarn:yarn | chpasswd
RUN useradd -m -d /home/hdfs -s /bin/bash hdfs -g hadoop -G sudo && echo hdfs:hdfs | chpasswd
RUN useradd -m -d /home/mapred -s /bin/bash mapred -g hadoop -G sudo && echo mapred:mapred | chpasswd

RUN echo "yarn ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "hdfs ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "mapred ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER hdfs
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

USER yarn
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

USER root
## I have no idea about this
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
