
```shell script
docker build . -t ghcr.io/liusheng/alluxio-aarch64
```

```shell script
docker run --name alluxio-build --hostname alluxio-build --privileged=true -it ghcr.io/liusheng/alluxio-aarch64 bash
```