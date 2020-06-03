#!/bin/bash -ex
sudo service ssh restart
hdfs namenode -format
start-dfs.sh
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/mytest
start-yarn.sh
sleep 3
# one row of terasort data is 100B size, we are testing with 5GB data, 5*1024*1024*1024/100=53896806
if [ -n "$1" ] && [ "$1" -gt 0 ] 2>/dev/null;then
  rows=$((${1}*1024*1024*1024/100))
  example_jar=hadoop-3.4.0-SNAPSHOT/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.0-SNAPSHOT.jar
  echo "Start at: $(date -u "+%Y-%m-%d %H:%M:%S.%N")"
  hadoop jar $example_jar teragen -Dmapred.map.tasks=100 ${rows} terasort/tera1-input
  hadoop fs -ls /user/hadoop/terasort/
  hadoop jar $example_jar terasort -Dmapred.reduce.tasks=50 terasort/tera1-input terasort/tera1-output
  hadoop fs -ls /user/hadoop/terasort/
  hadoop jar $example_jar teravalidate /user/hadoop/terasort/tera1-output /user/hadoop/terasort/tera1-validate
  echo "End at: $(date -u "+%Y-%m-%d %H:%M:%S.%N")"
else
  exec "$@"
fi
