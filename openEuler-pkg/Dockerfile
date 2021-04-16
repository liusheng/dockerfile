FROM openeuler-20.03-lts-next
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY openEuler.repo /etc/yum.repos.d/

RUN yum update -y && yum install -y \
    sudo git tar curl patch shadow-utils make cmake gcc gcc-c++ \
    rpm-build make rpmdevtools wget

RUN sed -i s'/TMOUT=300/TMOUT=300000000000/' /etc/bashrc

WORKDIR /opt
RUN rpmdev-setuptree