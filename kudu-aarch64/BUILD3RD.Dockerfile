FROM ghcr.io/liusheng/kudu-aarch64:no3rd

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#
ENV PARALLEL 4
#enlarge default timeout from 900 to 1800
ENV TEST_TIMEOUT_SECS 1800

# For TSAN: 3rdparty_type=tsan {common uninstrumented tsan}, default is: common uninstrumented
ARG build_type=""

RUN git clone https://github.com/apache/kudu \
    && cd kudu \
    && bash -ex thirdparty/build-if-necessary.sh $build_type 2>&1 |tee -a ~/kudu-build3rd.log \
    && mkdir -p /opt/results/debug \
    && mkdir -p build/debug \
    && cd build/debug \
    && ../../thirdparty/installed/common/bin/cmake -DCMAKE_BUILD_TYPE=DEBUG ../.. \
    && make -j4