#!/bin/bash
mkdir -p /opt/kudu/build/debug
cd /opt/kudu/build/debug
cmake ../..
make -j4
