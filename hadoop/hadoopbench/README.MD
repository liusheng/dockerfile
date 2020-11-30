# Hadoop Benchmark helper tools
## 1. Collect cluster info
Usages:
```shell script
./clusterinf.py
```

## 2. Hadoop Terasort Benchmark
Usages:
```shell script
./terasort.py -m 80 -r 80 -d 50 --repeats 10
```
Above command means run `terasort` with 50 GB data, 80 maps, 80 reduces and
repeat 10 times. you can also find more parameters with `./terasort.py --help`