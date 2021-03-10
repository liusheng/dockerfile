
```shell script
docker build . -t accumulo-build
```

```shell script
docker run --name accumulo-build --hostname accumulo-build --privileged=true -it accumulo-build bash
```