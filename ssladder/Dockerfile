FROM ubuntu:bionic

LABEL maintainer="liusheng <liusheng2048@gmail.com>"

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
        ca-certificates \
        python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install setuptools \
    && pip install wheel \
    && pip install shadowsocks

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]