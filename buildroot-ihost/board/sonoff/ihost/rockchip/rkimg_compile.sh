#!/bin/bash

# BOARD_DIR=/home/peter/workspace_external/projects/cube/distro/linux-distro/ha-over-ihost/ha-over-ihost-os/buildroot-ihost/board/sonoff/ihost
# BINARIES_DIR=/home/peter/workspace_external/projects/cube/distro/linux-distro/ha-over-ihost/ha-over-ihost-os/output/ihost_full/images

# build rockchip image
function build_rkimg() {
    # clean old images
    rm -rf "${BINARIES_DIR}/rockchip" "${BINARIES_DIR}/haos_ihost_emmc.img"
    mkdir -p "${BINARIES_DIR}/rockchip"
    # copy rockchip basic images
    cp -r "${BOARD_DIR}/rockchip" "${BINARIES_DIR}/"
    ln -s "${BINARIES_DIR}/boot.vfat" "${BINARIES_DIR}/rockchip/images/boot.img"
    ln -s "${BINARIES_DIR}/rootfs.squashfs" "${BINARIES_DIR}/rockchip/images/rootfs.img"
    ln -s "${BINARIES_DIR}/overlay.ext4" "${BINARIES_DIR}/rockchip/images/overlay.img"
    ln -s "${BINARIES_DIR}/data.ext4" "${BINARIES_DIR}/rockchip/images/data.img"
    ln -s "${BINARIES_DIR}/kernel.img" "${BINARIES_DIR}/rockchip/images/kernel.img"
    # pack rockchip image
    cd "${BINARIES_DIR}/rockchip"
    ./tools/afptool -pack ./images update.raw.img
    ./tools/rkImageMaker -RK1126 images/MiniLoaderAll.bin update.raw.img update.img -os_type:androidos
    if [ -f "${BINARIES_DIR}/rockchip/update.img" ]; then
        cp "${BINARIES_DIR}/rockchip/update.img" "${BINARIES_DIR}/haos_ihost_emmc.img"
    fi
}

build_rkimg