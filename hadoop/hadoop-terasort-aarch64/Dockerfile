# docker run -p 8088:8088 -it liusheng2048/deploy-hadoop bash

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

EXPOSE 8088

COPY entrypoint.sh /home/hadoop/

ENTRYPOINT /home/hadoop/entrypoint.sh && bash

# one row of terasort data is 100B size, we are testing with 5GB data, 5*1024*1024*1024/100=53896806
RUN mkdir -p /tmp/hadoop-terasort/
CMD example_jar=hadoop-3.3.0-SNAPSHOT/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0-SNAPSHOT.jar \
    && hadoop jar $example_jar teragen -Dmapred.map.tasks=100 53896806 terasort/tera1-input \
    && hadoop fs -ls /user/hadoop/terasort/ \
    && hadoop jar $example_jar terasort -Dmapred.reduce.tasks=50 terasort/tera1-input terasort/tera1-output\
    && hadoop fs -ls /user/hadoop/terasort/ \
    && hadoop jar $example_jar teravalidate /user/hadoop/terasort/tera1-output /user/hadoop/terasort/tera1-validate \
    2>&1 | sudo tee /tmp/hadoop-terasort/console.log
