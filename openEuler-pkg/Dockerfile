FROM openeuler-20.03-lts-next
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY openEuler.repo /etc/yum.repos.d/

RUN yum update -y && yum install -y \
    sudo git tar curl patch shadow-utils make cmake gcc gcc-c++ \
    rpm-build dnf-plugins-core make rpmdevtools wget python3-pip python2-pip

RUN sed -i s'/TMOUT=300/TMOUT=300000000000/' /etc/bashrc

RUN pip install renderspec

RUN rpmdev-setuptree

RUN git clone https://opendev.org/openstack/rpm-packaging.git /root/rpm-packaging
RUN pip3 install git+https://gitee.com/openeuler/pyporter

WORKDIR /root/rpmbuild

# yum-builddep SPECS/openstack-glance.spec