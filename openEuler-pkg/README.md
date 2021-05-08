- Use following script to build docker image
```shell script
bash build-img.sh
```

- Run container for package building
```shell script
docker run --name openeuler-pkg --hostname openeuler-pkg -it openeuler-pkg-build bash
```

- Run package building script in container
```shell script
python3 openeuler_pkg.py
```
**NOTE:** Before run the package building script, please check the pre-defined variable
in the header of script, change them as your self requirements. 