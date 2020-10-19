#!/bin/bash -ex
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))

case $1 in
test)
  [ ! -d ~/hadoop ] && git clone https://github.com/kunpengcompute/hadoop -b release-2.7.7-aarch64
  cd ~/hadoop/
  git pull
  mvn test -B -e -fn | sudo tee ~/hadoop-results/hadoop_all_test.log
  ;;
*)
  echo "Welcome to Hadoop develop env for openEuler :)"
  exec "$@"
  ;;
esac
