#!/bin/bash

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
  *)
    echo "Unsupported service $1"
    exit 1
    ;;
  esac
}

for svc in "$@"; do
  start_svc "$svc"
done
