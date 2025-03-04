#!/bin/bash
set -e
source /etc/profile.d/toolchain.sh
mkdir -p /output
git clone --depth=1 -b th1520-lts https://github.com/revyos/th1520-linux-kernel.git /kernel/thead-kernel
cd /kernel/thead-kernel
make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv revyos_defconfig
export KDEB_PKGVERSION="$(make kernelversion)-$(date "+%Y.%m.%d.%H.%M")+$(git rev-parse --short HEAD)"
make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv -j$(nproc) bindeb-pkg LOCALVERSION="-th1520"
make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv -j$(nproc) dtbs
cp /kernel/*.deb /output/
