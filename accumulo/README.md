
```shell script
docker build . -t ghcr.io/liusheng/accumulo-aarch64
```

```shell script
docker run --name accumulo-build --hostname accumulo-build --privileged=true -it ghcr.io/liusheng/accumulo-aarch64 bash
```