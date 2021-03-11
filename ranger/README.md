
```shell script
docker build . -t ranger-build
```

```shell script
docker run --name ranger-build --hostname ranger-build --privileged=true -it ranger-build bash
```