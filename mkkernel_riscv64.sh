#!/bin/bash
set -e
mkdir -p /output
git clone --depth=1 -b th1520-lts https://github.com/revyos/th1520-linux-kernel.git /kernel/thead-kernel
cd /kernel/thead-kernel
make ARCH=riscv revyos_defconfig
export KDEB_PKGVERSION="$(make kernelversion)-$(date "+%Y.%m.%d.%H.%M")+$(git rev-parse --short HEAD)"
make ARCH=riscv -j$(nproc) bindeb-pkg LOCALVERSION="-th1520"
make ARCH=riscv -j$(nproc) dtbs
cp /kernel/*.deb /output/