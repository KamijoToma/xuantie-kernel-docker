#!/bin/bash
# Disabled for now
# set -e
mkdir -p /kernel/rootfs/boot
git clone --depth=1 https://github.com/revyos/thead-kernel.git /kernel/thead-kernel
cd /kernel/thead-kernel
make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv revyos_defconfig
make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv -j$(nproc)
make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv -j$(nproc) dtbs
# Disabled for now
# make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv INSTALL_MOD_PATH=../rootfs/ modules_install -j$(nproc)
make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv INSTALL_PATH=../rootfs/boot zinstall -j$(nproc)
