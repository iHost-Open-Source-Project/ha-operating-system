#!/bin/bash

function hassos_image_name() {
    if [ "${BOARD_ID}" == "ihost" ] && grep -q ^BR2_PACKAGE_HASSIO_FULL_CORE=y "${BASE_DIR}/.config"; then
        echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}_CoreBox-$(hassos_version).${1}"
    else
        echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}-$(hassos_version).${1}"
    fi
}

function hassos_image_basename() {
    if [ "${BOARD_ID}" == "ihost" ] && grep -q ^BR2_PACKAGE_HASSIO_FULL_CORE=y "${BASE_DIR}/.config"; then
        echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}_CoreBox-$(hassos_version)"
    else
        echo "${BINARIES_DIR}/${HASSOS_ID}_${BOARD_ID}-$(hassos_version)"
    fi
}

function hassos_rauc_compatible() {
    echo "${HASSOS_ID}-${BOARD_ID}"
}

function hassos_version() {
    if [ -z "${VERSION_SUFFIX}" ]; then
        echo "${VERSION_MAJOR}.${VERSION_MINOR}"
    else
        echo "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_SUFFIX}"
    fi
}

function path_boot_dir() {
    echo "${BINARIES_DIR}/boot"
}

function path_data_img() {
    echo "${BINARIES_DIR}/data.ext4"
}

function path_rootfs_img() {
    echo "${BINARIES_DIR}/rootfs.erofs"
}
