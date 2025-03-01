# Description: Dockerfile for building a Docker image for the Xuantie 900 Linux kernel build environment

FROM debian:bookworm-slim

# Define build arguments for toolchain version
ARG TOOLCHAIN_VERSION=6.6.0
ARG TOOLCHAIN_URL_V3=https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1732863205852/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz
ARG TOOLCHAIN_URL_V2=https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz

# Install required packages
# apt install -y gdisk dosfstools build-essential
# libncurses-dev gawk flex bison openssl libssl-dev tree dkms libelf-dev libudev-dev
# libpci-dev libiberty-dev autoconf device-tree-compiler git wget bc python3

RUN apt update && apt install -y gdisk dosfstools build-essential \
    libncurses-dev gawk flex bison openssl libssl-dev tree dkms libelf-dev libudev-dev \
    libpci-dev libiberty-dev autoconf device-tree-compiler git wget bc python3 \
    libmpc-dev cpio

# Download the Xuantie 900 compile toolchain based on the specified version
RUN if [ "$TOOLCHAIN_VERSION" = "6.6.0" ]; then \
        wget $TOOLCHAIN_URL_V3 -O /tmp/Xuantie-900-gcc-linux.tar.gz; \
    else \
        wget $TOOLCHAIN_URL_V2 -O /tmp/Xuantie-900-gcc-linux.tar.gz; \
    fi \
    && tar -xvf /tmp/Xuantie-900-gcc-linux.tar.gz -C /opt/ \
    && rm /tmp/Xuantie-900-gcc-linux.tar.gz

# Export toolchains to PATH
# Export toolchains to PATH
RUN export TOOLCHAIN_DIR=$(find /opt -maxdepth 1 -type d -name "Xuantie*" | head -n 1) \
    && echo "export PATH=$TOOLCHAIN_DIR/bin:\$PATH" >> /etc/profile.d/toolchain.sh
ENV CROSS_COMPILE=riscv64-unknown-linux-gnu-
ENV ARCH=riscv

# Copy mkkernel.sh to /kernel
COPY mkkernel.sh /kernel/mkkernel.sh

# Set working directory
WORKDIR /kernel

# Default command
CMD ["bash"]
