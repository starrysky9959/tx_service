#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

ensure_dirs

TOP_LEVEL_THIRD_PARTY_SUBMODULES=(
    third_party/src/lua
    third_party/src/protobuf
    third_party/src/glog
    third_party/src/liburing
    third_party/src/brpc
    third_party/src/braft
    third_party/src/mimalloc
    third_party/src/cuckoofilter
    third_party/src/aws-sdk-cpp
    third_party/src/rocksdb
    third_party/src/prometheus-cpp
    third_party/src/Catch2
    third_party/src/abseil-cpp
    third_party/src/re2
    third_party/src/grpc
    third_party/src/crc32c
    third_party/src/nlohmann-json
    third_party/src/google-cloud-cpp
    third_party/src/FakeIt
    third_party/src/rocksdb-cloud
    third_party/src/usearch
    third_party/src/yaml-cpp
)

AWS_CRT_SUBMODULES=(
    crt/aws-c-common
    crt/aws-c-io
    crt/aws-c-compression
    crt/aws-c-cal
    crt/aws-c-auth
    crt/aws-c-http
    crt/aws-c-mqtt
    crt/s2n
    crt/aws-checksums
    crt/aws-c-event-stream
    crt/aws-c-s3
    crt/aws-lc
    crt/aws-c-sdkutils
)

PROMETHEUS_CPP_SUBMODULES=(
    3rdparty/civetweb
    3rdparty/googletest
)

SUBMODULE_DEPTH="${ELOQ_THIRD_PARTY_SUBMODULE_DEPTH:-1}"
SUBMODULE_FILTER="${ELOQ_THIRD_PARTY_SUBMODULE_FILTER-blob:none}"

SUBMODULE_UPDATE_ARGS=(submodule update --init --recommend-shallow)

# These third-party repositories are large; default to shallow partial clones.
# Set ELOQ_THIRD_PARTY_SUBMODULE_DEPTH=0 or ELOQ_THIRD_PARTY_SUBMODULE_FILTER= to disable.
if [ "${SUBMODULE_DEPTH}" != "0" ]; then
    SUBMODULE_UPDATE_ARGS+=(--depth "${SUBMODULE_DEPTH}")
fi

if [ -n "${SUBMODULE_FILTER}" ]; then
    SUBMODULE_UPDATE_ARGS+=(--filter "${SUBMODULE_FILTER}")
fi

cd "${DATA_SUBSTRATE_ROOT}"
run_with_retry git "${SUBMODULE_UPDATE_ARGS[@]}" "${TOP_LEVEL_THIRD_PARTY_SUBMODULES[@]}"
run_with_retry git -C "${THIRD_PARTY_SRC}/aws-sdk-cpp" "${SUBMODULE_UPDATE_ARGS[@]}" crt/aws-crt-cpp
run_with_retry git -C "${THIRD_PARTY_SRC}/aws-sdk-cpp/crt/aws-crt-cpp" \
    "${SUBMODULE_UPDATE_ARGS[@]}" "${AWS_CRT_SUBMODULES[@]}"
run_with_retry git -C "${THIRD_PARTY_SRC}/prometheus-cpp" \
    "${SUBMODULE_UPDATE_ARGS[@]}" "${PROMETHEUS_CPP_SUBMODULES[@]}"
run_with_retry git -C "${THIRD_PARTY_SRC}/usearch" "${SUBMODULE_UPDATE_ARGS[@]}" fp16
