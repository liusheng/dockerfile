#!/usr/bin/env python3
import os
import sys
import subprocess
import glob

import argparse
import datetime
import json
import pandas
import requests
import time

HADOOP_BINPATH = os.path.dirname(subprocess.check_output(["which", "hadoop"]).strip())
BENCH_JAR = glob.glob(str(HADOOP_BINPATH, 'utf-8') + "/../share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar")[0]

HADOOP_HOST = "localhost"
JOBINFO_URL = "http://%s:19888/ws/v1/history/mapreduce/jobs/" % HADOOP_HOST


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
                        default="benchmark",
                        help='The benchmark results directory',
                        )
    return parser


def extract_results(jobid, maps, reduces, job_info):
    map_avgtime = str(job_info["job"]["avgMapTime"] / 1000)
    shuffle_avgtime = str(job_info["job"]["avgShuffleTime"] / 1000)
    merge_avgtime = str(job_info["job"]["avgMergeTime"] / 1000)
    reduce_avgtime = str(job_info["job"]["avgReduceTime"] / 1000)
    total_time = str((job_info["job"]["finishTime"] - job_info["job"]["startTime"]) / 1000)
    return jobid, str(maps), str(reduces), map_avgtime, shuffle_avgtime, merge_avgtime, reduce_avgtime, total_time


def main():
    parsed_args = add_cli_args().parse_args()
    map_arg = "-Dmapred.map.tasks=%s" % parsed_args.maps
    rows = parsed_args.datasize * 1024 * 1024 * 1024 // 100
    subprocess.call(["hadoop", "fs", "-rm", "-r", parsed_args.input_path])
    results_dir = os.path.join(parsed_args.results_dir, datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S"))
    os.makedirs(results_dir, exist_ok=True)

    teragen_cmd = ["hadoop", "jar", BENCH_JAR, "teragen", map_arg, str(rows), parsed_args.input_path]
    subprocess.call(teragen_cmd)
    reduce_arg = "-Dmapred.reduce.tasks=%s" % parsed_args.reduces
    terasort_cmd = ["hadoop", "jar", BENCH_JAR, "terasort", reduce_arg, parsed_args.input_path, parsed_args.output_path]
    df = pandas.DataFrame(columns=["jobid", "maps", "reduces", "map_avgtime",
                                   "shuffle_avgtime", "merge_avgtime", "reduce_avgtime", "total_time"])
    for i in range(parsed_args.repeats):
        subprocess.call(["hadoop", "fs", "-rm", "-r", parsed_args.output_path])
        subprocess.call(terasort_cmd)
        jobid_cmd = "mapred job -list all |grep TeraSort |grep -Eo 'job_[0-9]+_[0-9]+' |sort |tail -1"
        jobid = subprocess.check_output(jobid_cmd, shell=True).strip().decode("utf-8")
        time.sleep(2)
        jobhis = subprocess.check_output(["mapred", "job", "-history", jobid])
        joblogs = subprocess.check_output(["mapred", "job", "-logs", jobid])
        path = os.path.join(results_dir, jobid)
        os.makedirs(path, exist_ok=True)
        with open(os.path.join(path, "jobhistory"), 'w+') as f:
            f.write(jobhis.decode("utf-8"))
        with open(os.path.join(path, "joblogs"), 'w') as f:
            f.write(joblogs.decode("utf-8"))
        job_info = requests.request("GET", JOBINFO_URL + jobid).json()
        print(json.dumps(job_info, indent=4))
        df.loc[i] = list(extract_results(jobid, parsed_args.maps, parsed_args.reduces, job_info))
    df.loc["mean"] = {"map_avgtime": round(df["map_avgtime"].astype(float).mean(), 3),
                      "shuffle_avgtime": round(df["shuffle_avgtime"].astype(float).mean(), 3),
                      "merge_avgtime": round(df["merge_avgtime"].astype(float).mean(), 3),
                      "reduce_avgtime": round(df["reduce_avgtime"].astype(float).mean(), 3),
                      "total_time": round(df["total_time"].astype(float).mean(), 3),
                      }
    # If we want to strip min and max of a specified columns
    # (df["reduce_time"].astype(float).sum() - df["reduce_time"].astype(float).min() - df["reduce_time"].astype(
    #    float).max()) / (df["reduce_time"].count() - 2)
    # (df["map_time"].astype(float).sum() - df["map_time"].astype(float).min() - df["map_time"].astype(
    #    float).max()) / (df["map_time"].count() - 2)
    # (df["total_time"].astype(float).sum() - df["total_time"].astype(float).min() - df["total_time"].astype(
    #    float).max()) / (df["total_time"].count() - 2)

    df.to_csv(os.path.join(results_dir, "results.csv"))
    df.to_html(os.path.join(results_dir, "results.html"))
    df.to_excel(os.path.join(results_dir, "results.xlsx"))


if __name__ == '__main__':
    sys.exit(main())
