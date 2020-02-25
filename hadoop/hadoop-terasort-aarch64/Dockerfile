# docker run -p 8088:8088 -it liusheng2048/hadoop-terasort-aarch64 bash

# For x86 testing
# FROM liusheng2048/hadoop-x86:pre-build
FROM liusheng2048/hadoop-aarch64:pre-build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
        openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER hadoop
WORKDIR /home/hadoop

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

RUN cp -r ~/hadoop/hadoop-dist/target/hadoop-3.3.0-SNAPSHOT ~/
ENV PATH "${PATH}:~/hadoop-3.3.0-SNAPSHOT/bin:~/hadoop-3.3.0-SNAPSHOT/sbin"

RUN cp ~/hadoop-3.3.0-SNAPSHOT/etc/hadoop/core-site.xml{,-bak}
COPY core-site.xml /home/hadoop/hadoop-3.3.0-SNAPSHOT/etc/hadoop/

RUN cp ~/hadoop-3.3.0-SNAPSHOT/etc/hadoop/hdfs-site.xml{,-bak}
COPY hdfs-site.xml /home/hadoop/hadoop-3.3.0-SNAPSHOT/etc/hadoop/

RUN cp ~/hadoop-3.3.0-SNAPSHOT/etc/hadoop/mapred-site.xml{,-bak}
COPY mapred-site.xml /home/hadoop/hadoop-3.3.0-SNAPSHOT/etc/hadoop/

RUN cp ~/hadoop-3.3.0-SNAPSHOT/etc/hadoop/yarn-site.xml{,-bak}
COPY yarn-site.xml /home/hadoop/hadoop-3.3.0-SNAPSHOT/etc/hadoop/

# I have no idea about this
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /home/hadoop/hadoop-3.3.0-SNAPSHOT/etc/hadoop/hadoop-env.sh

RUN mkdir -p /tmp/hadoop-terasort/

EXPOSE 8088

COPY entrypoint.sh /home/hadoop/

ENTRYPOINT ["/home/hadoop/entrypoint.sh"]

# NOTE: need to specify the num of GB zise of data for terasort, e.g.
# docker run -p 8088:8088 --name hadoop-terasort-1 -d liusheng2048/hadoop-terasort-x86 5
# docker logs hadoop-terasort-1
