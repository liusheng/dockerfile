#!/bin/bash -ex
[ -d ~/kudu ] && cd ~/kudu/

#git clone https://github.com/liusheng/kudu
#cd kudu
#git fetch origin pull/8/head:build-on-aarch64
#git checkout build-on-aarch64

# The Java tests need 'JAVA8_HOME' env varq
export JAVA8_HOME=/usr/lib/jvm/java-8-openjdk-arm64
sudo ln -s /usr/include/locale.h /usr/include/xlocale.h

case $1 in
lint)
  mkdir -p ~/results/lint
  BUILD_TYPE="LINT" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a ~/results/lint/console.log
  cp -r ~/kudu/build/lint/test-logs/ ~/results/lint/
  ;;
iwyu)
  mkdir -p ~/results/iwyu
  BUILD_TYPE="IWYU" bash -x build-support/jenkins/build-and-test.sh 2>&1 | tee -a ~/results/iwyu/console.log
  cp -r ~/kudu/build/iwyu/test-logs/ ~/results/iwyu/
  ;;
debug)
  mkdir -p ~/results/debug
  BUILD_TYPE="DEBUG" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ~/results/debug/console.log
  cp -r ~/kudu/build/debug/test-logs/ ~/results/debug/
  ;;
release)
  mkdir -p ~/results/release
  BUILD_TYPE="RELEASE" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ~/results/release/console.log
  cp -r ~/kudu/build/release/test-logs/ ~/results/release/
  ;;
asan)
  mkdir -p ~/results/asan
  BUILD_TYPE="ASAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ~/results/asan/console.log
  cp -r ~/kudu/build/asan/test-logs/ ~/results/asan/
  ;;
tsan)
  mkdir -p ~/results/tsan
  BUILD_TYPE="TSAN" KUDU_ALLOW_SLOW_TESTS=0 bash -x build-support/jenkins/build-and-test.sh 2>&1 |tee ~/results/tsan/console.log
  cp -r ~/kudu/build/tsan/test-logs/ ~/results/tsan/
  ;;
*)
  echo "NOTICE: you may need to update the code and apply the patch!"
  exec "$@"
  ;;
esac
