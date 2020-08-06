FROM ubuntu:bionic

LABEL maintainer="liusheng <liusheng2048@gmail.com>"

RUN apt-get -q update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q install -y --no-install-recommends \
        ca-certificates \
        python-pip \
        libsodium-dev \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install setuptools \
    && pip install wheel \
    && pip install --upgrade git+https://github.com/shadowsocks/shadowsocks.git@master

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
