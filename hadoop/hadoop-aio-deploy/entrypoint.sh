#!/bin/bash -ex
case $1 in
start)
  sudo service ssh restart
  hdfs namenode -format
  start-dfs.sh
  start-yarn.sh
  ;;
*)
  echo "Hadoop All-in-One deployment :)"
  exec "$@"
  ;;
esac
tail -f /dev/null
