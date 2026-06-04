#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_SUBSTRATE_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
THIRD_PARTY_ROOT="${ELOQ_THIRD_PARTY_ROOT:-${DATA_SUBSTRATE_ROOT}/third_party}"
THIRD_PARTY_SRC="${ELOQ_THIRD_PARTY_SRC:-${THIRD_PARTY_ROOT}/src}"
THIRD_PARTY_BUILD="${ELOQ_THIRD_PARTY_BUILD:-${THIRD_PARTY_ROOT}/build}"
THIRD_PARTY_PREFIX="${ELOQ_THIRD_PARTY_PREFIX:-${THIRD_PARTY_ROOT}/install}"

export CMAKE_PREFIX_PATH="${THIRD_PARTY_PREFIX}:${CMAKE_PREFIX_PATH:-}"
export PKG_CONFIG_PATH="${THIRD_PARTY_PREFIX}/lib/pkgconfig:${THIRD_PARTY_PREFIX}/lib64/pkgconfig:${PKG_CONFIG_PATH:-}"
export LD_LIBRARY_PATH="${THIRD_PARTY_PREFIX}/lib:${THIRD_PARTY_PREFIX}/lib64:${LD_LIBRARY_PATH:-}"
export C_INCLUDE_PATH="${THIRD_PARTY_PREFIX}/include:${C_INCLUDE_PATH:-}"
export CPLUS_INCLUDE_PATH="${THIRD_PARTY_PREFIX}/include:${CPLUS_INCLUDE_PATH:-}"
export LIBRARY_PATH="${THIRD_PARTY_PREFIX}/lib:${THIRD_PARTY_PREFIX}/lib64:${LIBRARY_PATH:-}"
export PATH="${THIRD_PARTY_PREFIX}/bin:${PATH}"

run() {
    printf '+ %q' "$@"
    printf '\n'
    "$@"
}

run_with_retry() {
    local max_retries=5
    local attempt=1

    while [ "${attempt}" -le "${max_retries}" ]; do
        if run "$@"; then
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 2
    done

    return 1
}

ensure_dirs() {
    mkdir -p "${THIRD_PARTY_SRC}" "${THIRD_PARTY_BUILD}" "${THIRD_PARTY_PREFIX}"
}

nproc_or_one() {
    nproc 2>/dev/null || printf '1\n'
}

cmake_build_install() {
    local name="$1"
    local source_dir="$2"
    shift 2

    local build_dir="${THIRD_PARTY_BUILD}/${name}"
    run cmake -S "${source_dir}" -B "${build_dir}" \
        -DCMAKE_INSTALL_PREFIX="${THIRD_PARTY_PREFIX}" \
        -DCMAKE_PREFIX_PATH="${THIRD_PARTY_PREFIX}" \
        "$@"
    run cmake --build "${build_dir}" -- -j"$(nproc_or_one)"
    run cmake --install "${build_dir}"
}
