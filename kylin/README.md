
```shell script
docker build . -t kylin-build
```

```shell script
docker run --name kylin-build --hostname kylin-build --privileged=true -it kylin-aarch64 bash
```