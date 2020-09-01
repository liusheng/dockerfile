- ARM64:
```shell script
docker build . -f arm.Dockerfile -t hadoop-deploy-arm64
```
```shell script
docker run --name hadoop-benchmark --hostname hadoop-benchmark -p 8088:8088 -p 19888:19888 -it hadoop-deploy-arm64 bash
```

- X86:
```shell script
docker build . -f x86.Dockerfile -t hadoop-deploy-x86
```
```shell script
docker run --name hadoop-benchmark --hostname hadoop-benchmark -p 8088:8088 -p 19888:19888 -it hadoop-deploy-x86 bash
```