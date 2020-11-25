This docker image is based on the `openEuler-20.09` on ARM/aarch64 platform, you can also use 
`openEuler-20.03-LTS` the base images can be downloaded and imported as below:

```shell script
# For openEuler-20.03-LTS
curl -L -O https://repo.openeuler.org/openEuler-20.03-LTS/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
# For openEuler-20.09
curl -L -O https://repo.openeuler.org/openEuler-20.09/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
docker load --input openEuler-docker.aarch64.tar.xz
```

Build command, 1st one to build testing env, 2rd is to build pre-built package:
```shell script
docker build . -t ghcr.io/liusheng/hadoop-2.7.7-openeuler
docker build . -t ghcr.io/liusheng/hadoop-2.7.7-openeuler:pre-build --build-arg prebuild=true
```