This docker image is based on the `openEuler-20.03-LTS` on ARM/aarch64 platform,
the base images can be downloaded and imported as below:

```shell script
curl -L -O https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
docker load --input openEuler-docker.aarch64.tar.xz
```

Build command, 1st one to build testing env, 2rd is to build pre-built package:
```shell script
docker build . -t docker.pkg.github.com/liusheng/dockerfile/hadoop-2.7.7-openeuler
docker build . -t docker.pkg.github.com/liusheng/dockerfile/hadoop-2.7.7-openeuler:pre-build --build-arg prebuild=true
```