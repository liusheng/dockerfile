#!/bin/bash -ex
source ~/.profile
case $1 in
start)
  sudo service ssh restart
  sleep 1
  hdfs namenode -format
  start-dfs.sh
  start-yarn.sh
  mapred --daemon start historyserver
  ;;
*)
  echo "Hadoop All-in-One deployment :)"
  exec "$@"
  ;;
esac
tail -f /dev/null
