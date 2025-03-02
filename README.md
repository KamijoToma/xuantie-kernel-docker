# Docker image for building RevyOS kernel

**仍在施工中**

支持架构：`x86_64` `riscv64`(待添加)

支持工具链：
* `6.6.0` Xuantie-900 Linux 6.6.0 (暂不能编译)
* `5.10.0` Xuantie-900 Linux 5.10.0 (暂不能编译)
* `13` 主线 RISC-V GCC 13交叉编译器
* `14` 主线 RISC-V GCC 14交叉编译器（默认）
* 主线 GCC 编译器（RISC-V）架构（暂未支持）

通过`TOOLCHAIN_VERSION`变量选择要使用的编译器

## 使用方法

```bash
docker build --build-arg TOOLCHAIN_VERSION=14 -t xuantie900:linux14 .
docker run -it --rm -v LOCAL_PATH:/output xuantie900:linux14 bash
./mkkernel.sh
```

会将构建好的内核deb包拷贝到`LOCAL_PATH`指定的目录中，然后使用`dpkg`安装即可。

编译过程会产生多个结果：
* linux-headers-6.6.77-th1520_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(需要编译内核模块或内核开发时安装)
* linux-image-6.6.77-th1520-dbg_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(调试符号，需要调试内核时安装)
* linux-image-6.6.77-th1520_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(内核，必装)
* linux-libc-dev_6.6.77-2025.03.02.09.37+cb159e628_riscv64.deb(libc接口，一般不安装，使用通用版即可)

## 注意事项

1. 如需更改编译的版本，可在进入docker环境后自由修改
2. `x86_64`环境下交叉编译出的`linux-header`包可能包含`x86_64`的头文件。如需进行内核开发或使用如`zfs`之类的DKMS模块，请在RISC-V环境下编译。

