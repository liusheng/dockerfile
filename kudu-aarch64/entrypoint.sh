#!/bin/bash -ex
base_dir=/opt
[ -d ${base_dir}/kudu ] && cd ${base_dir}/kudu/

#git clone https://github.com/liusheng/kudu
#cd kudu
#git fetch origin pull/8/head:build-on-aarch64
#git checkout build-on-aarch64
if [[ -n "$PULL_CODE" ]]; then
  cd ${base_dir}/kudu
  git checkout master
  git remote update
  git branch -D build-on-aarch64 || true
  git checkout -b build-on-aarch64 remotes/origin/build-on-aarch64
fi

# The Java tests need 'JAVA8_HOME' env varq
export JAVA8_HOME=/usr/lib/jvm/java-8-openjdk-arm64
sudo ln -s /usr/include/locale.h /usr/include/xlocale.h || true
export TEST_TIMEOUT_SECS=1800

case $1 in
lint)
  mkdir -p ${base_dir}/results/lint
  BUILD_TYPE="LINT" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a ${base_dir}/results/lint/console.log
  cp -r ${base_dir}/kudu/build/lint/test-logs/ ${base_dir}/results/lint/
  ;;
iwyu)
  mkdir -p ${base_dir}/results/iwyu
  BUILD_TYPE="IWYU" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a ${base_dir}/results/iwyu/console.log
  cp -r ${base_dir}/kudu/build/iwyu/test-logs/ ${base_dir}/results/iwyu/
  ;;
debug)
  mkdir -p ${base_dir}/results/debug
  BUILD_TYPE="DEBUG" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/debug/console.log
  cp -r ${base_dir}/kudu/build/debug/test-logs/ ${base_dir}/results/debug/
  ;;
release)
  mkdir -p ${base_dir}/results/release
  BUILD_TYPE="RELEASE" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/release/console.log
  cp -r ${base_dir}/kudu/build/release/test-logs/ ${base_dir}/results/release/
  ;;
asan)
  mkdir -p ${base_dir}/results/asan
  BUILD_TYPE="ASAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/asan/console.log
  cp -r ${base_dir}/kudu/build/asan/test-logs/ ${base_dir}/results/asan/
  ;;
tsan)
  mkdir -p ${base_dir}/results/tsan
  BUILD_TYPE="TSAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/tsan/console.log
  cp -r ${base_dir}/kudu/build/tsan/test-logs/ ${base_dir}/results/tsan/
  ;;
*)
  echo "NOTICE: you may need to update the code and apply the patch!"
  exec "$@"
  ;;
esac
