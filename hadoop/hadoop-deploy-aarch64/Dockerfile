FROM liusheng2048/hadoop-aarch64:pre-build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
        openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN cp -r /home/hadoop/hadoop/hadoop-dist/target/hadoop-3.3.0-SNAPSHOT /opt/
ENV PATH :PATH "${PATH}:/opt/hadoop-3.3.0-SNAPSHOT/{bin,sbin}"

RUN service ssh start

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

RUN cp /opt/hadoop-3.3.0-SNAPSHOT/etc/hadoop/core-site.xml{,-bak}
COPY core-site.xml /opt/hadoop-3.3.0-SNAPSHOT/etc/hadoop/

RUN cp /opt/hadoop-3.3.0-SNAPSHOT/etc/hadoop/hdfs-site.xml{,-bak}
COPY hdfs-site.xml /opt/hadoop-3.3.0-SNAPSHOT/etc/hadoop/

USER hadoop
RUN hdfs namenode -format \
    && /opt/hadoop-3.3.0-SNAPSHOT/sbin/start-dfs.sh \
    && hdfs dfs -mkdir /user \
    && bin/hdfs dfs -mkdir /user/dfs-test
