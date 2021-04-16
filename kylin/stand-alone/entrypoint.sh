#!/bin/bash -ex

# start Hadoop
sudo service ssh restart
hdfs namenode -format
start-dfs.sh
start-yarn.sh
mapred --daemon start historyserver
