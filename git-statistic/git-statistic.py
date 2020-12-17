#!/usr/bin/env python3
import sys

import argparse
import pandas
import requests
from github import Github  # https://pygithub.readthedocs.io/en/latest/examples.html
from requests.auth import HTTPBasicAuth


def add_cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--since',
                        default='2020-06-01T00:00:00Z',
                        help='Only show results after the given time, ISO8601 format:YYYY-MM-DDTHH:MM:SSZ',
                        )
    parser.add_argument('--until',
                        default='2020-12-31T00:00:00Z',
                        help='Only show results before the given time, ISO8601 format:YYYY-MM-DDTHH:MM:SSZ',
                        )
    parser.add_argument('--token',
                        required=True,
                        help='Github auth token',
                        )
    return parser


def stats_github(repo_name, since, until, token):
    base_url = "https://api.github.com/repos/%s/commits"
    url = base_url % repo_name
    contributors = []
    url = url + "?since=" + since + "&until=" + until + "&per_page=100"
    while True:
        print("Query commits stats from github: %s" % url)
        resp = requests.request("GET", url, auth=HTTPBasicAuth('liusheng', token))
        if resp.status_code != 200:
            raise Exception(resp.text)
        if resp.status_code == 404:
            print("NotFound ERROR: %s" % resp.text)
        contributors.extend([c['commit']['author']['name'] for c in resp.json()])
        if 'next' not in resp.links:
            break
        url = resp.links['next']['url']

    return len(contributors), len(set(contributors))


def main():
    parsed_args = add_cli_args().parse_args()
    row_data = pandas.read_excel("ARM CI Plan.xlsx", engine="openpyxl")
    df = pandas.DataFrame(row_data, columns=["Project", "Repository"])

    for row in df.iterrows():
        repo = row[1]["Repository"]
        print("=" * 100)
        print("Start to process project: %s, repo: %s" % (row[1]["Project"], repo))
        if 'github' in str(repo):
            repo = list(filter(lambda s: "github.com" in s, repo.splitlines()))[0]
            repo_name = repo.partition("github.com/")[2].replace(".git", "")
            statistics = stats_github(repo_name, parsed_args.since, parsed_args.until, parsed_args.token)
            df.loc[row[0], "commits_6months"] = statistics[0]
            df.loc[row[0], "contributors_6months"] = statistics[1]

        print("Finish processing project: %s" % row[1]["Project"])

    df.to_html("git-statistic-results.html")
    df.to_excel("git-statistic-results.xlsx")


if __name__ == '__main__':
    sys.exit(main())
