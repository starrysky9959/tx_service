# Data Substrate Third-Party Dependencies

`data_substrate/third_party` is the shared third-party dependency workspace for Data Substrate consumers such as EloqKV.

Layout:

- `manifest.yml` records every source-managed dependency, its repo, ref, pinned commit, and consumers.
- `system-packages.ubuntu2404.txt` records apt packages that remain system prerequisites.
- `src/` contains Git submodules only.
- `install/` contains locally installed headers, libraries, and CMake package config files.
- `/opt/eloq/third_party` is the CI builder image prefix.

Local build flow:

```bash
data_substrate/scripts/third_party/install-ubuntu2404.sh
cmake -S . -B build -DELOQ_THIRD_PARTY_PREFIX="$PWD/data_substrate/third_party/install"
cmake --build build -j"$(nproc)"
```

CI flow:

```bash
cmake -S . -B build -DELOQ_THIRD_PARTY_PREFIX=/opt/eloq/third_party
cmake --build build -j"$(nproc)"
```

Policy:

- Do not install source-built third-party libraries into `/usr` or `/usr/local` from this repository.
- Do not use floating branch refs in committed submodules.
- Update `manifest.yml` in the same commit that changes a third-party submodule pointer.
- Builder image `latest` must be rebuilt when dependencies or build scripts change.
- Normal CI must not initialize `third_party/src`.
- Keep first-party Eloq repositories outside `third_party` unless they are true third-party forks.
