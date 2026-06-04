#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

ensure_dirs

cd "${DATA_SUBSTRATE_ROOT}"
run_with_retry git submodule update --init --recursive \
    third_party/src/lua \
    third_party/src/protobuf \
    third_party/src/glog \
    third_party/src/liburing \
    third_party/src/brpc \
    third_party/src/braft \
    third_party/src/mimalloc \
    third_party/src/cuckoofilter \
    third_party/src/aws-sdk-cpp \
    third_party/src/rocksdb \
    third_party/src/prometheus-cpp \
    third_party/src/Catch2 \
    third_party/src/abseil-cpp \
    third_party/src/re2 \
    third_party/src/grpc \
    third_party/src/crc32c \
    third_party/src/nlohmann-json \
    third_party/src/google-cloud-cpp \
    third_party/src/FakeIt \
    third_party/src/rocksdb-cloud \
    third_party/src/usearch \
    third_party/src/yaml-cpp
