FROM ubuntu:bionic

LABEL maintainer="liusheng <liusheng2048@gmail.com>"

ENV SS_DOWNLOAD_URL https://github.com/shadowsocks/shadowsocks-libev.git
ENV SS_LIBEV_VERSION v3.3.4

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