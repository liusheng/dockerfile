
```shell script
docker build . -t ambari-build
```

```shell script
docker run --name ambari-build --hostname ambari-build --privileged=true -it ambari-build bash
```