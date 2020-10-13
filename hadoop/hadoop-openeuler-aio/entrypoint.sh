#!/bin/bash -ex
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))

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
