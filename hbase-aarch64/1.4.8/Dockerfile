FROM liusheng2048/hbase-2.0.2-aarch64

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PATH  "/opt/protobuf-2.5.0/bin/:${PATH}"

# -Prelease will package shaded jars
CMD git clone https://github.com/apache/hbase \
    && cd hbase \
    && git checkout rel/1.4.8 \
    && mvn clean install -DskipTests -Prelease -DcompileSource=1.8 2>&1 | sudo tee ~/hbase-results/hbase_1.4.8_build.log \
    && sudo tar zcf ~/hbase-results/hbase-1.4.8-artifacts.tar.gz -C ~/.m2/repository/org/apache/ hbase/
