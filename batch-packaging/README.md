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
export GITEE_PAT="you gitee personall access token"
python3 batch-packaging.py build
```
In default, above command will build `spec` and `rpm` for all the projects in
`.csv` format projects list file, and then will command and create PR to openEuler
source package repo one by one. This tool will also check the dependencies,
source repo existence, remote branch existence, will record to log file.
For more functionality, you can run `python3 openeuler_pkg.py --help` to get more help info.
