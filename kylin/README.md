
```shell script
docker build . -t ghcr.io/liusheng/kylin-aarch64
```

```shell script
docker run --name kylin-build --hostname kylin-build --privileged=true -it ghcr.io/liusheng/kylin-aarch64 bash
```