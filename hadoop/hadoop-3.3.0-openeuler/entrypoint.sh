#!/bin/bash
set -ex

svcs_specified=${HADOOP_SERVICES:-""}
hadoop_controller=${HADOOP_CONTROLLER:-""}

if [[ "$hadoop_controller" != "" ]]; then
  sed -i "/localhost/$hadoop_controller/g" $HADOOP_HOME/etc/hadoop/core-site.xml
  sed -i "/localhost/$hadoop_controller/g" $HADOOP_HOME/etc/hadoop/yarn-site.xml
fi

function start_svc() {
  case $1 in
  namenode)
    hdfs namenode -format
    hdfs --daemon start namenode
    ;;
  datanode)
    hdfs --daemon start datanode
    ;;
  resourcemanager)
    yarn --daemon start resourcemanager
    ;;
  nodemanager)
    yarn --daemon start nodemanager
    ;;
  historyserver)
    mapred --daemon start historyserver
    ;;
  *)
    echo "Unsupported service $1"
    exit 1
    ;;
  esac
}
[[ $# != 0 ]] && exec "$@"

if [[ "$svcs_specified" == "all" ]];then
  svcs="namenode datanode resourcemanager nodemanager historyserver"
elif [[ "$svcs_specified" == "controller" ]];then
  svcs="namenode resourcemanager historyserver"
elif [[ "$svcs_specified" == "worker" ]];then
  svcs="datanode nodemanager"
else
  svcs="$svcs_specified"
fi

for svc in $svcs; do
  start_svc "$svc"
done

tail -f /dev/null