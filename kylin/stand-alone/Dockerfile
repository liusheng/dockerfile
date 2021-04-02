#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Docker image with Hadoop/Hive/HBase/Spark/ZK/Kafka/Livy installed
FROM ubuntu:bionic

ENV MAVEN_VERSION 3.6.3
ENV HADOOP_VERSION 3.3.0
ENV HBASE_VERSION 2.4.2
ENV HIVE_VERSION 3.1.2
ENV SPARK_VERSION 3.1.1
ENV KAFKA_VERSION 2.7.0
ENV LIVY_VERSION 0.7.1

ENV WORK_DIR /home/admin
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-arm64
ENV MVN_HOME $WORK_DIR/apache-maven-$MAVEN_VERSION
ENV HADOOP_HOME $WORK_DIR/hadoop-$HADOOP_VERSION
ENV HBASE_HOME $WORK_DIR/hbase-$HBASE_VERSION
ENV HIVE_HOME $WORK_DIR/apache-hive-${HIVE_VERSION}-bin
ENV SPARK_HOME $WORK_DIR/spark-${SPARK_VERSION}-bin-custom-spark
ENV KAFKA_HOME $WORK_DIR/kafka_2.13-$KAFKA_VERSION
ENV LIVY_HOME $WORK_DIR/apache-livy-${LIVY_VERSION}-incubating-bin

ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin:$HBASE_HOME/bin:$MVN_HOME/bin:spark-$SPARK_VERSION-bin-hadoop2.6/bin:$KAFKA_HOME/bin

USER root

WORKDIR $WORK_DIR

# Install dependencies
RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
       openssh-server sudo openjdk-8-jdk lsof tar mysql-server npm curl

# Install Maven
RUN wget -qc https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar zx -C $WORK_DIR

# Install Hadoop(download aarch64 binaries)
RUN wget -qc https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-${HADOOP_VERSION}-aarch64.tar.gz -O - | tar -xz -C $WORK_DIR
COPY conf/hadoop/* $HADOOP_CONF/

# A workaround for Hbase dependencies of protobuf-2.5.0
RUN wget -qc https://github.com/liusheng/package/releases/download/protobuf-aarch64/protobuf-2.5.0.tar.gz  -O - | tar -zx -C $WORK_DIR \
    && echo $WORK_DIR/protobuf-2.5.0/lib/ > /etc/ld.so.conf.d/protobuf-2.5.0.conf && ldconfig \
    && mvn install:install-file -DgroupId=com.google.protobuf -DartifactId=protoc -Dversion=2.5.0 -Dclassifier=linux-aarch_64 -Dpackaging=exe -Dfile=$WORK_DIR/protobuf-2.5.0/bin/protoc
#ENV PROTOBUF_HOME $WORK_DIR/protobuf-2.5.0
#ENV PATH "${PATH}:$WORK_DIR/protobuf-2.5.0/bin"

# setup hbase
RUN wget -qc https://downloads.apache.org/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-src.tar.gz -O - | tar -xz -C $WORK_DIR \
    && cd hbase-${HBASE_VERSION} \
    && mvn install -DskipTests assembly:single -Prelease \
    && cp $WORK_DIR/hbase-${HBASE_VERSION}/hbase-assembly/target/hbase-${HBASE_VERSION}-bin.tar.gz $WORK_DIR/ \
    && cd $WORK_DIR \
    && rm -fr hbase-${HBASE_VERSION} \
    && tar zxf hbase-${HBASE_VERSION}-bin.tar.gz \
    && rm hbase-${HBASE_VERSION}-bin.tar.gz
COPY conf/hbase/hbase-site.xml $HBASE_HOME/conf

# setup hive
RUN wget -qc https://downloads.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-src.tar.gz -O - | tar -xz -C $WORK_DIR \
    && cd $WORK_DIR/apache-hive-${HIVE_VERSION}-src/ \
    && mvn clean package -Pdist -DskipTests \
    && cp $WORK_DIR/apache-hive-${HIVE_VERSION}-src//packaging/target/apache-hive-${HIVE_VERSION}-bin.tar.gz $WORK_DIR/ \
    && cd $WORK_DIR \
    && rm -fr apache-hive-${HIVE_VERSION}-src \
    && tar zxf apache-hive-${HIVE_VERSION}-bin.tar.gz \
    && rm apache-hive-${HIVE_VERSION}-bin.tar.gz
COPY conf/hive/hive-site.xml $HIVE_HOME/conf

# setup Spark
RUN wget -qc https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}.tgz -O - | tar -xz -C $WORK_DIR \
    && cd spark-${SPARK_VERSION} \
    # ./dev/make-distribution.sh --name custom-spark --tgz
    && ./dev/make-distribution.sh --name custom-spark --pip --r --tgz -Psparkr -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes \
    && cp spark-${SPARK_VERSION}-bin-custom-spark.tgz $WORK_DIR/ \
    && cd $WORK_DIR/ \
    && rm -fr spark-${SPARK_VERSION} \
    && tar zxf spark-${SPARK_VERSION}-bin-custom-spark.tgz \
    && rm spark-${SPARK_VERSION}-bin-custom-spark.tgz

# setup kafka
RUN wget -qc https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka-${KAFKA_VERSION}-src.tgz  -O - | tar -xz -C $WORK_DIR \
    && cd ${WORK_DIR}/kafka-${KAFKA_VERSION}-src \
    && ./gradlew clean releaseTarGz \
    && cp ${WORK_DIR}/kafka-${KAFKA_VERSION}-src/core/build/distributions/*.tgz ${WORK_DIR}/
    && cd ${WORK_DIR} \
    && tar -zxf kafka_2.13-${KAFKA_VERSION}.tgz \
    && rm -fr ${WORK_DIR}/kafka-${KAFKA_VERSION}-src

# setup livy
RUN wget https://downloads.apache.org/incubator/livy/${LIVY_VERSION}-incubating/apache-livy-${LIVY_VERSION}-incubating-bin.zip \
    && unzip apache-livy-${LIVY_VERSION}-incubating-bin.zip \
    && rm apache-livy-${LIVY_VERSION}-incubating-bin.zip
