# Description: Dockerfile for building a Docker image for the Xuantie 900 Linux kernel build environment

FROM debian:bookworm-slim

# Install required packages
# apt install -y gdisk dosfstools build-essential
# libncurses-dev gawk flex bison openssl libssl-dev tree dkms libelf-dev libudev-dev
# libpci-dev libiberty-dev autoconf device-tree-compiler git wget bc python3

RUN apt update && apt install -y gdisk dosfstools build-essential \
    libncurses-dev gawk flex bison openssl libssl-dev tree dkms libelf-dev libudev-dev \
    libpci-dev libiberty-dev autoconf device-tree-compiler git wget bc python3

# Download the Xuantie 900 compile toolchain
# URL: https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1732863205852/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz
# and extract it to /opt/
RUN wget https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1732863205852/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz -O /tmp/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz \ 
    && tar -xvf /tmp/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz -C /opt/ \
    && rm /tmp/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1-20241120.tar.gz

# Export toolchains to PATH
ENV PATH=/opt/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.0.1/bin:$PATH
ENV CROSS_COMPILE=riscv64-unknown-linux-gnu-
ENV ARCH=riscv

# Copy mkkernel.sh to /kernel
COPY mkkernel.sh /kernel/mkkernel.sh

# Set working directory
WORKDIR /kernel

# Default command
CMD ["bash"]
