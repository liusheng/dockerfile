
```shell script
docker build . -t alluxio-build
```

```shell script
docker run --name alluxio-build --hostname alluxio-build --privileged=true -it alluxio-aarch64 bash
```