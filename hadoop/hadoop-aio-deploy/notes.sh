# 1. "Aggregation is not enabled. Try the nodemanager at..." error
# config in yarn-site.xml adding:
# yarn.log-aggregation-enable as true
stop-yarn.sh
mr-jobhistory-daemon.sh  stop historyserver
start-yarn.sh
mr-jobhistory-daemon.sh  start historyserver
