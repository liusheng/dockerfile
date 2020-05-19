#!/bin/bash -ex
set -xo pipefail

base_dir=/opt
[ -d ${base_dir}/kudu ] && cd ${base_dir}/kudu/

PULL=${PULL:-true}
[[ "$PULL" == true ]] && git pull

# curl https://patch-diff.githubusercontent.com/raw/liusheng/kudu/pull/17.patch | git apply
[[ -n "$PATCH" ]] && curl "$PATCH" | git apply

# The Java tests need 'JAVA8_HOME' env varq
export JAVA8_HOME=/usr/lib/jvm/java-8-openjdk-arm64
sudo ln -s /usr/include/locale.h /usr/include/xlocale.h || true
export TEST_TIMEOUT_SECS=1800

mkdir -p ${base_dir}/results/$1
case $1 in
lint)
  BUILD_TYPE="LINT" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a ${base_dir}/results/lint/console.log
  ;;
iwyu)
  BUILD_TYPE="IWYU" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a ${base_dir}/results/iwyu/console.log
  ;;
debug)
  BUILD_TYPE="DEBUG" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/debug/console.log
  ;;
release)
  BUILD_TYPE="RELEASE" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/release/console.log
  ;;
asan)
  BUILD_TYPE="ASAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/asan/console.log
  ;;
tsan)
  BUILD_TYPE="TSAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ${base_dir}/results/tsan/console.log
  ;;
*)
  echo "NOTICE: you may need to update the code and apply the patch!"
  exec "$@"
  ;;
esac
exit_code=$?
cp -r ${base_dir}/kudu/build/$1/test-logs/ ${base_dir}/results/$1/
exit $exit_code
