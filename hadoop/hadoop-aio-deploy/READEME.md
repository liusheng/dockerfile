- ARM64:
```shell script
docker build . -t hadoop-deploy-arm64
```
```shell script
docker run --name hadoop-benchmark --hostname hadoop-benchmark -p 8088:8088 -p 19888:19888 -it hadoop-deploy-arm64 bash
```
 **NOTE:** This Dockerfile support both ARM and x86 building