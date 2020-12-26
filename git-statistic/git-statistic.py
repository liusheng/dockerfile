#!/usr/bin/env python3
import sys

import argparse
import pandas
import requests
from github import Github  # https://pygithub.readthedocs.io/en/latest/examples.html
from requests.auth import HTTPBasicAuth

CAL_ORGS = ["OpenStack", "Spring Cloud", "aosp-mirror"]


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
        if resp.status_code == 404 or resp.status_code == 409:
            print("NotFound ERROR: %s" % resp.text)
            return 0, 0
        if resp.status_code != 200:
            raise Exception(resp.text)
        contributors.extend([c['commit']['author']['name'] for c in resp.json()])
        if 'next' not in resp.links:
            break
        url = resp.links['next']['url']

    return contributors


def get_org_repos(org, token):
    res = []
    url = "https://api.github.com/orgs/%s/repos?per_page=100" % org
    while True:
        print("Query repos of %s organization: %s" % (org, url))
        resp = requests.request("GET", url, auth=HTTPBasicAuth('liusheng', token))
        if resp.status_code == 404:
            print("NotFound ERROR: %s" % resp.text)
            return []
        if resp.status_code != 200:
            raise Exception(resp.text)
        res.extend([r['full_name'] for r in resp.json()])
        if 'next' not in resp.links:
            break
        url = resp.links['next']['url']
    return res


def main():
    parsed_args = add_cli_args().parse_args()
    row_data = pandas.read_excel("../ARM_CI_Plan.xlsx", sheet_name="Project schedule", engine="openpyxl")
    df = pandas.DataFrame(row_data, columns=["Project", "Repository"])

    for row in df.iterrows():
        repo = row[1]["Repository"]
        print("=" * 100)
        print("Start to process project: %s, repo: %s" % (row[1]["Project"], repo))
        repos = list(filter(lambda s: "github.com" in s, str(repo).split()))
        repos = [repo.partition("github.com/")[2].replace(".git", "").strip('/') for repo in repos]
        if not repos:
            continue
        if str(row[1]["Project"]).strip() in CAL_ORGS:
            repos = get_org_repos(repos[0], parsed_args.token)
        else:
            repos = repos[:1]
        commits_authors = []
        for repo_name in repos:
            statistics = stats_github(repo_name, parsed_args.since, parsed_args.until, parsed_args.token)
            commits_authors.extend(statistics)

        df.loc[row[0], "commits_6months"] = len(commits_authors)
        df.loc[row[0], "contributors_6months"] = len(set(commits_authors))

        print("Finish processing project: %s" % row[1]["Project"])

    df.to_html("git-statistic-results.html")
    df.to_excel("git-statistic-results.xlsx")


if __name__ == '__main__':
    sys.exit(main())
