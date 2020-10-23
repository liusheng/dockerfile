#!/bin/bash -ex
sudo /usr/sbin/sshd

NODE_TYPE=${HADOOP_NODE_TYPE:-manual}

case $NODE_TYPE in
allinone)
  hdfs namenode -format
  start-dfs.sh
  start-yarn.sh
  ;;
controller)
  hdfs namenode -format
  start-dfs.sh
  start-yarn.sh
  ;;
worker)
  hadoop-daemon.sh --script hdfs start datanode
  yarn-daemon.sh start nodemanager
  ;;
manual)
  echo "You need to manually start services!"
  exec "$@"
  ;;
*)
  echo "Hadoop All-in-One deployment :)"
  exec "$@"
  ;;
esac
