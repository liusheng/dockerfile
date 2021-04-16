FROM openeuler-21.03
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN yum update -y && yum install -y \
    sudo git tar curl patch shadow-utils make cmake gcc gcc-c++ \
    rpm-build make rpmdevtools wget

RUN sed -i s'/TMOUT=300/TMOUT=300000000000/' /etc/bashrc

WORKDIR /opt
RUN rpmdev-setuptree