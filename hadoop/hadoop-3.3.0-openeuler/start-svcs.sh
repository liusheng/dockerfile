#!/bin/bash
set -ex

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

svcs=$*
[[ $# == 1 ]] && [[ "$1" == "all" ]] && svcs="namenode datanode resourcemanager nodemanager historyserver"
[[ $# == 1 ]] && [[ "$1" == "controller" ]] && svcs="namenode resourcemanager historyserver"
[[ $# == 1 ]] && [[ "$1" == "worker" ]] && svcs="datanode nodemanager"

for svc in $svcs; do
  start_svc "$svc"
done
