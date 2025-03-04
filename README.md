# Docker image for building RevyOS kernel

**Under Construction**

Supported Architectures: `x86_64` `riscv64`

`x86_64` Supported Toolchains:
* `6.6.0` Xuantie-900 Linux 6.6.0 (Not yet supported)
* `5.10.0` Xuantie-900 Linux 5.10.0 (Not yet supported)
* `13` Mainline RISC-V GCC 13 Cross Compiler
* `14` Mainline RISC-V GCC 14 Cross Compiler (default)

`riscv64` Supported Toolchains:
* `rv` Mainline GCC Compiler

Select the compiler to use via the `TOOLCHAIN_VERSION` variable

## Usage

```bash
docker build --build-arg TOOLCHAIN_VERSION=14 -t xuantie900:linux14 .
docker run -it --rm -v LOCAL_PATH:/output xuantie900:linux14 bash
./mkkernel_x64.sh # use mkkernel_xuantie.sh or mkkernel_riscv64.sh depend on your TOOLCHAIN_VERSION
```

The built kernel deb packages will be copied to the directory specified by `LOCAL_PATH`, and then you can install them using `dpkg`.

The compilation process will produce several results:
* linux-headers-6.6.77-th1520_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb (Install when compiling kernel modules or for kernel development)
* linux-image-6.6.77-th1520-dbg_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb (Debug symbols, install when debugging the kernel)
* linux-image-6.6.77-th1520_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb (Kernel, must install)
* linux-libc-dev_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb (libc interface, generally not installed, use the generic version)

## Notes

1. To change the version to be compiled, you can freely modify it after entering the docker environment (input `bash`)
2. The `linux-header` package cross-compiled in the `x86_64` environment may contain `x86_64` header files. If you need to develop the kernel or use DKMS modules such as `zfs`, please compile with `TOOLCHAIN_VERSION=rv` in the RISC-V environment.

# 用于构建RevyOS内核的Docker镜像

**仍在施工中**

支持架构：`x86_64` `riscv64`

`x86_64` 支持工具链：
* `6.6.0` Xuantie-900 Linux 6.6.0 (暂不能编译)
* `5.10.0` Xuantie-900 Linux 5.10.0 (暂不能编译)
* `13` 主线 RISC-V GCC 13交叉编译器
* `14` 主线 RISC-V GCC 14交叉编译器（默认）

`riscv64` 支持工具链：
* `rv` 主线 GCC 编译器

通过`TOOLCHAIN_VERSION`变量选择要使用的编译器

## 使用方法

```bash
docker build --build-arg TOOLCHAIN_VERSION=14 -t xuantie900:linux14 .
docker run -it --rm -v LOCAL_PATH:/output xuantie900:linux14 bash
./mkkernel_x64.sh # 根据 TOOLCHAIN_VERSION 配置选择 mkkernel_xuantie.sh 或 mkkernel_riscv64.sh
```

会将构建好的内核deb包拷贝到`LOCAL_PATH`指定的目录中，然后使用`dpkg`安装即可。

编译过程会产生多个结果：
* linux-headers-6.6.77-th1520_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(需要编译内核模块或内核开发时安装)
* linux-image-6.6.77-th1520-dbg_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(调试符号，需要调试内核时安装)
* linux-image-6.6.77-th1520_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(内核，必装)
* linux-libc-dev_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(libc接口，一般不安装，使用通用版即可)

## 注意事项

1. 如需更改编译的版本，可在进入docker环境（输入`bash`）后自由修改
2. `x86_64`环境下交叉编译出的`linux-header`包可能包含`x86_64`的头文件。如需进行内核开发或使用如`zfs`之类的DKMS模块，请在RISC-V环境下使用`TOOLCHAIN_VERSION=rv`编译。

