FROM liusheng2048/hadoop-aarch64:pre-build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
        openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN cp -r hadoop-dist/target/hadoop-3.3.0-SNAPSHOT /opt/
ENV PATH :PATH "${PATH}:/opt/hadoop-3.3.0-SNAPSHOT/bin"