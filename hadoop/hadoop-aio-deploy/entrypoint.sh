#!/bin/bash -ex
sudo service ssh restart
hdfs namenode -format
start-dfs.sh
start-yarn.sh
sleep 3
exec "$@"
