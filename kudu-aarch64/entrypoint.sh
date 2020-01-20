#!/bin/bash -ex
#cd /opt/kudu
#git pull

case $1 in
lint)
  mkdir -p /opt/results/lint/
  mkdir -p /opt/kudu/build/lint
  cd /opt/kudu/build/lint
  cmake ../.. | tee -a /opt/results/lint/console.log
  make ilint | tee -a /opt/results/lint/console.log
  ;;
iwyu)
  mkdir -p /opt/results/iwyu/
  mkdir -p /opt/kudu/build/iwyu
  cd /opt/kudu/build/iwyu
  cmake ../.. 2>&1 | tee -a /opt/results/iwyu/console.log
  make iwyu 2>&1 | tee -a /opt/results/iwyu/console.log
  ;;
debug)
  mkdir -p /opt/results/debug
  mkdir -p /opt/kudu/build/debug
  cd /opt/kudu/build/debug
  cmake ../..
  make -j8 2>&1 | tee mkdir -p /opt/results/debug/build.log
  ctest -j8 2>&1 | tee /opt/results/debug/test_console.log
  cp -r /opt/kudu/build/debug/test-logs/ /opt/results/debug/
  ;;
release)
  mkdir -p /opt/results/release/
  mkdir -p /opt/kudu/build/release
  cd /opt/kudu/build/release
  ../../build-support/enable_devtoolset.sh \
  ../../thirdparty/installed/common/bin/cmake \
  -DCMAKE_BUILD_TYPE=release ../..
  make -j8 2>&1 | tee mkdir -p /opt/results/release/build.log
  ;;
asan)
  mkdir -p /opt/results/asan/
  mkdir -p /opt/kudu/build/asan
  cd /opt/kudu/build/asan
  CC=../../thirdparty/clang-toolchain/bin/clang \
  CXX=../../thirdparty/clang-toolchain/bin/clang++ \
  ../../thirdparty/installed/common/bin/cmake \
  -DKUDU_USE_ASAN=1 ../..
  make -j8 2>&1 | tee /opt/results/asan/build.log
  ctest -j8 2>&1 | tee /opt/results/asan/test_console.log
  cp -r /opt/kudu/build/asan/test-logs/ /opt/results/asan/
  ;;
tsan)
  mkdir -p /opt/results/tsan/
  mkdir -p /opt/kudu/build/tsan
  cd /opt/kudu/build/tsan
  CC=../../thirdparty/clang-toolchain/bin/clang \
  CXX=../../thirdparty/clang-toolchain/bin/clang++ \
  ../../thirdparty/installed/common/bin/cmake \
  -DKUDU_USE_TSAN=1 ../..
  make -j8 2>&1 | tee /opt/results/tsan/build.log
  ctest -j8 2>&1 | tee /opt/results/tsan/test_console.log
  cp -r /opt/kudu/build/tsan/test-logs/ /opt/results/tsan/
  ;;
*)
  exec "$@"
  ;;
esac
