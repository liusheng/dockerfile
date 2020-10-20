#!/bin/bash -ex

sudo /usr/sbin/sshd

case $1 in
start)
  hdfs namenode -format
  start-dfs.sh
  start-yarn.sh
  ;;
*)
  echo "Hadoop All-in-One deployment :)"
  exec "$@"
  ;;
esac
