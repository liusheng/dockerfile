#!/bin/bash

BASE_IMG_URL=http://121.36.84.172/dailybuild/openEuler-20.03-LTS-Next/openeuler-2021-04-15-17-46-51/docker_img/aarch64/openEuler-docker.aarch64.tar.xz

cd `dirname $0`
curl -L $BASE_IMG_URL | docker load
docker build . -t openeuler-pkg-build
