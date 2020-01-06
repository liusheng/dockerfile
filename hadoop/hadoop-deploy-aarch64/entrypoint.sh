#!/bin/bash
sudo service ssh restart
hdfs namenode -format
start-dfs.sh
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/mytest
start-yarn.sh