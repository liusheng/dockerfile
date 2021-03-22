Build Kudu building env:
```shell script
docker build . -f Dockerfile -t ghcr.io/liusheng/kudu-aarch64:build3rd
```


Build for OpenLab ARM CI:
```shell script
docker build . -f CI.Dockerfile -t ghcr.io/liusheng/kudu-aarch64:build3rd
```

