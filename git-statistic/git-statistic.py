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
from github import Github # https://pygithub.readthedocs.io/en/latest/examples.html


def add_cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--placeholder',
                        help='placeholder',
                        )
    return parser


def main():
    parsed_args = add_cli_args().parse_args()
    df = pandas.DataFrame(columns=["project_name", "repo",])
    pandas.read_excel()