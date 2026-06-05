#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

export DEBIAN_FRONTEND=noninteractive
export TZ="${TZ:-UTC}"

if [ -f "${THIRD_PARTY_ROOT}/system-packages.ubuntu2404.txt" ]; then
    run_privileged apt-get update
    mapfile -t system_packages < "${THIRD_PARTY_ROOT}/system-packages.ubuntu2404.txt"
    run_privileged apt-get install -y --no-install-recommends "${system_packages[@]}"
fi

if git -C "${DATA_SUBSTRATE_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    "${SCRIPT_DIR}/fetch.sh"
else
    for source_dir in "${THIRD_PARTY_SRC}"/*; do
        [ -d "${source_dir}" ] || continue
        [ "$(find "${source_dir}" -mindepth 1 -maxdepth 1 | head -n 1)" ] || {
            echo "Empty third-party source directory: ${source_dir}" >&2
            exit 1
        }
    done
fi

"${SCRIPT_DIR}/build-ubuntu2404.sh"
