#!/usr/bin/env python3
import os
import sys
import subprocess
import glob

import argparse
import json

HEADER = ["hostname", "ip", "cpu_num", "cpu_hz", "cpu_version", "memory", "disk", "is_datanode"]


def add_cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--clusterinfo-filename',
                        default="clusterinfo",
                        help='The benchmark results directory',
                        )
    return parser


def main():
    parsed_args = add_cli_args().parse_args()
    hdfs_topo = subprocess.check_output(["hdfs", "dfsadmin", "-printTopology"])
    hdfs_report = subprocess.check_output(["hdfs", "dfsadmin", "-report"])
    yarn_nodes = subprocess.check_output(["yarn", "node", "-list", "-showDetails"])
    with open(parsed_args.clusterinfo_filename, 'w+') as f:
        subprocess.call(["hadoop", "fs", "-rm", "-r", parsed_args.clusterinfo_filename])
        f.write("=" * 30 + "HDFS Topology" + "=" * 30 + "\n")
        f.write(hdfs_topo.decode("utf-8"))
        f.write("=" * 30 + "HDFS Reports" + "=" * 30 + "\n")
        f.write(hdfs_report.decode("utf-8"))
        f.write("=" * 30 + "YARN Nodes Info" + "=" * 30 + "\n")
        f.write(yarn_nodes.decode("utf-8"))


if __name__ == '__main__':
    sys.exit(main())
