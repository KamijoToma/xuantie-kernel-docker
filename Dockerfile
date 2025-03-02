# Description: Dockerfile for building a Docker image for the Xuantie 900 Linux kernel build environment

FROM ubuntu:24.04

# Define build arguments for toolchain version
ARG TOOLCHAIN_VERSION=14
ARG TOOLCHAIN_URL_V3=https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1732863205852/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz
ARG TOOLCHAIN_URL_V2=https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1663142514282/Xuantie-900-gcc-linux-5.10.4-glibc-x86_64-V2.6.1-20220906.tar.gz

# Install required packages
RUN apt update && apt install -y gdisk dosfstools build-essential \
    libncurses-dev gawk flex bison openssl libssl-dev tree dkms libelf-dev libudev-dev \
    libpci-dev libiberty-dev autoconf device-tree-compiler git wget bc python3 \
    libmpc-dev cpio debhelper rsync pahole

# Download and install the Xuantie 900 compile toolchain based on the specified version
RUN if [ "$TOOLCHAIN_VERSION" = "6.6.0" ]; then \
        wget $TOOLCHAIN_URL_V3 -O /tmp/Xuantie-900-gcc-linux.tar.gz; \
    elif [ "$TOOLCHAIN_VERSION" = "5.10.0" ]; then \
        wget $TOOLCHAIN_URL_V2 -O /tmp/Xuantie-900-gcc-linux.tar.gz; \
    elif [ "$TOOLCHAIN_VERSION" = "13" ]; then \
        apt install -y gcc-13-riscv64-linux-gnu gcc-riscv64-linux-gnu; \
    elif [ "$TOOLCHAIN_VERSION" = "14" ]; then \
        apt install -y gcc-14-riscv64-linux-gnu gcc-riscv64-linux-gnu; \
    fi \
    && if [ -f /tmp/Xuantie-900-gcc-linux.tar.gz ]; then \
        tar -xvf /tmp/Xuantie-900-gcc-linux.tar.gz -C /opt/ \
        && rm /tmp/Xuantie-900-gcc-linux.tar.gz; \
    fi

# Export toolchains to PATH
RUN if [ "$TOOLCHAIN_VERSION" = "6.6.0" ] || [ "$TOOLCHAIN_VERSION" = "5.10.0" ]; then \
        export TOOLCHAIN_DIR=$(find /opt -maxdepth 1 -type d -name "Xuantie*" | head -n 1) \
        && echo "export PATH=$TOOLCHAIN_DIR/bin:\$PATH" >> /etc/profile.d/toolchain.sh \
        && echo "export CROSS_COMPILE=riscv64-unknown-linux-gnu-" >> /etc/profile.d/toolchain.sh; \
    elif [ "$TOOLCHAIN_VERSION" = "13" ]; then \
        echo "export PATH=/usr/bin/gcc-13-riscv64-linux-gnu:\$PATH" >> /etc/profile.d/toolchain.sh \
        && echo "export CROSS_COMPILE=riscv64-linux-gnu-" >> /etc/profile.d/toolchain.sh; \
    elif [ "$TOOLCHAIN_VERSION" = "14" ]; then \
        echo "export PATH=/usr/bin/gcc-14-riscv64-linux-gnu:\$PATH" >> /etc/profile.d/toolchain.sh \
        && echo "export CROSS_COMPILE=riscv64-linux-gnu-" >> /etc/profile.d/toolchain.sh; \
    fi \
    && echo "source /etc/profile.d/toolchain.sh" >> ~/.bashrc

# Set environment variables
ENV ARCH=riscv

# Copy mkkernel.sh to /kernel based on architecture
COPY mkkernel_xuantie.sh /kernel/mkkernel_xuantie.sh
COPY mkkernel_riscv64.sh /kernel/mkkernel_riscv64.sh
COPY mkkernel_x64.sh /kernel/mkkernel_x64.sh

# Set working directory
WORKDIR /kernel

# Default command
CMD ["bash"]
