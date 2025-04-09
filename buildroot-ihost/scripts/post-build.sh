#!/bin/bash

set -e

BOARD_DIR=${2}
. "${BOARD_DIR}/meta"

function gadget_console() {
    mkdir -p "${TARGET_DIR}/etc/systemd/system/getty.target.wants"
    ln -fs "/usr/lib/systemd/system/serial-getty@.service" "${TARGET_DIR}/etc/systemd/system/getty.target.wants/serial-getty@ttyGS0.service"
}

if [ "${BOARD_ID}" == "ihost" ]; then
    gadget_console
fi