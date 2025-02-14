#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

pushd "${SCRIPT_DIR}" || exit 1

pushd "${SCRIPT_DIR}/src/" || exit 1

ninja

popd || exit 1

cargo run --release --features=6.0.169 -- \
    -g -p test-project -i corpus -c corpus -o solution -l TRACE -C 1 -P 2096:6.0.70 -S 8 -E 120 \
    -e "${SCRIPT_DIR}/rsrc/winintrin.efi" \
    -f "${SCRIPT_DIR}/rsrc/winintrin.efi:%simics%/winintrin.efi" \
    -f "${SCRIPT_DIR}/rsrc/minimal_boot_disk.craff:%simics%/minimal_boot_disk.craff" \
    -f "${SCRIPT_DIR}/rsrc/fuzz.simics:%simics%/fuzz.simics" \
    -x 'COMMAND:run-script "%simics%/fuzz.simics"' -N | tee log.txt
