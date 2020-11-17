#!/usr/bin/env python3
import os
import sys
import subprocess
import glob

import argparse
import json


HADOOP_BINPATH = os.path.dirname(subprocess.check_output(["which", "hadoop"]).strip())
BENCH_JAR = glob.glob(str(HADOOP_BINPATH, 'utf-8') + "/../share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar")[0]


def add_cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-m', '--maps',
                        default=100,
                        type=int,
                        help='The numbers of maps',
                        )
    parser.add_argument('-d', '--datasize',
                        default=5,
                        type=int,
                        help='The size of data in GB',
                        )
    parser.add_argument('-r', '--reduces',
                        default=100,
                        type=int,
                        help='The numbers of reduces',
                        )
    parser.add_argument('--input-path',
                        default="terasort/tera-input",
                        help='The input path of terasort (output of teragen)',
                        )
    parser.add_argument('--output-path',
                        default="terasort/tera-output",
                        help='The output directory of terasort(in HDFS)',
                        )
    parser.add_argument('--repeats',
                        default=5,
                        type=int,
                        help='The output path of terasort',
                        )
    parser.add_argument('--results-dir',
                        default="terasort_benchmark",
                        help='The benchmark results directory',
                        )
    return parser


def extract_results(jobid, maps, reduces, jhs):
    map_time = jhs["taskSummary"]["map"]["finishTime"] - jhs["taskSummary"]["map"]["startTime"]
    reduce_time = jhs["taskSummary"]["reduce"]["finishTime"] - jhs["taskSummary"]["reduce"]["startTime"]
    total_time = jhs["finishedAt"] - jhs["launchedAt"]
    return ','.join([jobid, str(maps), str(reduces), str(map_time/1000), str(reduce_time/1000), str(total_time/1000)]) + '\n'


def main():
    parsed_args = add_cli_args().parse_args()
    map_arg = "-Dmapred.map.tasks=%s" % parsed_args.maps
    rows = parsed_args.datasize * 1024 * 1024 * 1024 // 100
    subprocess.call(["hadoop", "fs", "-rm", "-r", parsed_args.input_path])

    teragen_cmd = ["hadoop", "jar", BENCH_JAR, "teragen", map_arg, str(rows), parsed_args.input_path]
    subprocess.call(teragen_cmd)
    reduce_arg = "-Dmapred.reduce.tasks=%s" % parsed_args.reduces
    terasort_cmd = ["hadoop", "jar", BENCH_JAR, "terasort", reduce_arg, parsed_args.input_path, parsed_args.output_path]
    subprocess.call(["rm", "-fr", parsed_args.results_dir])
    os.makedirs(parsed_args.results_dir, exist_ok=True)
    with open(os.path.join(parsed_args.results_dir, "results.csv"), 'a+') as f:
        f.write(','.join(["jobid", "maps", "reduces", "map_time", "reduce_time", "total_time"]) + "\n")

    for i in range(parsed_args.repeats):
        subprocess.call(["hadoop", "fs", "-rm", "-r", parsed_args.output_path])
        subprocess.call(terasort_cmd)
        jobid_cmd = "mapred job -list all |grep TeraSort |grep -Eo 'job_[0-9]+_[0-9]+' |sort |tail -1"
        jobid = subprocess.check_output(jobid_cmd, shell=True).strip().decode("utf-8")
        jobhis = subprocess.check_output(["mapred", "job", "-history", jobid])
        joblogs = subprocess.check_output(["mapred", "job", "-logs", jobid])
        path = os.path.join(parsed_args.results_dir, jobid)
        os.makedirs(path, exist_ok=True)
        with open(os.path.join(path, "jobhistory"), 'w+') as f:
            f.write(jobhis.decode("utf-8"))
        with open(os.path.join(path, "joblogs"), 'w') as f:
            f.write(joblogs.decode("utf-8"))
        jobhis_json = subprocess.check_output(["mapred", "job", "-history", jobid, "-format", "json"]).decode("utf-8")
        jobhis_json = json.loads(jobhis_json)
        print(json.dumps(jobhis_json, indent=4))
        with open(os.path.join(parsed_args.results_dir, "results.csv"), 'a+') as f:
            f.write(extract_results(jobid, parsed_args.maps, parsed_args.reduces, jobhis_json))


if __name__ == '__main__':
    sys.exit(main())
