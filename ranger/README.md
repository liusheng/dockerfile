
```shell script
docker build . -t ghcr.io/liusheng/ranger-aarch64
```

```shell script
docker run --name ranger-build --hostname ranger-build --privileged=true -it ghcr.io/liusheng/ranger-aarch64 bash
```