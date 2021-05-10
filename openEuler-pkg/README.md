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
python3 openeuler_pkg.py build
```
you can run `python3 openeuler_pkg.py --help` to get more help info.