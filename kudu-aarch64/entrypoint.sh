#!/bin/bash -ex
cd /opt/kudu

# use latest patch
git config --global user.email "nobody@example.com"
git config --global user.name "nobody"
git checkout master
git pull
git branch -D aarch64-support
git checkout -b aarch64-support
curl -sL https://patch-diff.githubusercontent.com/raw/liusheng/kudu/pull/7.patch -o aarch64-support.patch
git am aarch64-support.patch
git rebase master

# The Java tests need 'JAVA8_HOME' env varq
export JAVA8_HOME=/usr/lib/jvm/java-8-openjdk-arm64
ln -s /usr/include/locale.h /usr/include/xlocale.h

case $1 in
lint)
  mkdir -p /opt/results/lint
  BUILD_TYPE="LINT" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a /opt/results/lint/console.log
  cp -r /opt/kudu/build/lint/test-logs/ /opt/results/lint/
  ;;
iwyu)
  mkdir -p /opt/results/iwyu
  BUILD_TYPE="IWYU" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a /opt/results/iwyu/console.log
  cp -r /opt/kudu/build/iwyu/test-logs/ /opt/results/iwyu/
  ;;
debug)
  mkdir -p /opt/results/debug
  BUILD_TYPE="DEBUG" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee /opt/results/debug/console.log
  cp -r /opt/kudu/build/debug/test-logs/ /opt/results/debug/
  ;;
release)
  mkdir -p /opt/results/release
  BUILD_TYPE="RELEASE" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee /opt/results/release/console.log
  cp -r /opt/kudu/build/release/test-logs/ /opt/results/release/
  ;;
asan)
  mkdir -p /opt/results/asan
  BUILD_TYPE="ASAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee /opt/results/asan/console.log
  cp -r /opt/kudu/build/asan/test-logs/ /opt/results/asan/
  ;;
tsan)
  mkdir -p /opt/results/tsan
  BUILD_TYPE="TSAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee /opt/results/tsan/console.log
  cp -r /opt/kudu/build/tsan/test-logs/ /opt/results/tsan/
  ;;
*)
  exec "$@"
  ;;
esac
