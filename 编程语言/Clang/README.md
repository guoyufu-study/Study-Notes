# Clang 编译器

## gcc 编译器

``` shell
# gcc.x86_64 : Various compilers (C, C++, Objective-C, ...)
yum install gcc
```

> 依赖关系
>
> ``` none
> binutils.x86_64 : A GNU collection of binary utilities 二进制实用程序的GNU集合
> cpp.x86_64 : The C Preprocessor
> glibc-devel.x86_64 : Object files for development using standard C libraries.
> glibc-headers.x86_64 : Header files for development using standard C libraries.
> isl.x86_64 : Integer point manipulation library 整数点操作库
> kernel-headers.x86_64 : Header files for the Linux kernel for use by glibc
> libmpc.x86_64 : C library for multiple precision complex arithmetic 用于多精度复杂算法的C库
> libxcrypt-devel.x86_64 : Development files for libxcrypt
> ```
>
> 说明
>
> ``` none
> libxcrypt.x86_64 : Extended crypt library for DES, MD5, Blowfish and others
> ```



### gcc 手册页

执行 `man gcc` 命令

``` none
NAME
       gcc - GNU project C and C++ compiler

SYNOPSIS
       gcc [-c|-S|-E] [-std=standard]
           [-g] [-pg] [-Olevel]
           [-Wwarn...] [-Wpedantic]
           [-Idir...] [-Ldir...]
           [-Dmacro[=defn]...] [-Umacro]
           [-foption...] [-mmachine-option...]
           [-o outfile] [@file] infile...

       Only the most useful options are listed here; see below for the remainder.  g++ accepts mostly the same options as gcc.
DESCRIPTION
	当你调用GCC时，它通常会进行预处理、编译、汇编和链接。“整体选项”允许您在中间阶段停止此过程。例如，-c 选项表示不运行链接器。然后输出由汇编器输出的目标文件组成。
	其他选项被传递到一个或多个处理阶段。一些选项控制预处理器，另一些控制编译器本身。还有其他选项控制汇编器和链接器;由于您很少需要使用其中的任何一个，所以这里没有对其中的大多数进行文档化。
	你可以在GCC中使用的大多数命令行选项对C程序都很有用;当一个选项只在另一种语言(通常是c++)中有用时，解释是明确的。如果特定选项的描述没有提到源语言，那么可以将该选项用于所有受支持的语言。
	运行GCC的通常方式是在交叉编译时运行名为GCC的可执行文件，或在交叉编译时运行名为machine-gcc的可执行文件，或在运行特定版本的GCC时运行machine-gcc-version。当你编译c++程序时，你应该以g++的形式调用GCC。
	gcc 程序接受选项和文件名作为操作数。许多选项有多个字母的名称;因此，多个单字母选项可能不会被分组:-dv与-d -v非常不同。
	您可以混合使用选项和其他参数。在大多数情况下，你使用的顺序并不重要。当你使用多个相同的选项时，顺序确实很重要;例如，如果多次指定-L，将按照指定的顺序搜索目录。此外，-l选项的位置也很重要。
	许多选项的名称都很长，以-f或-W开头——例如，-fmove-loop-invariants， -Wformat等等。其中大多数都有正反两种形式;-ffoo的否定形式是-fno-foo。此手册仅记录这两种表单中的一种，无论哪种不是默认的。
	
       When you invoke GCC, it normally does preprocessing, compilation, assembly and linking.  The "overall options" allow you to stop this process at an intermediate stage.  For example, the -c option says not to run the linker.  Then the output consists of object files output by the assembler.

       Other options are passed on to one or more stages of processing.  Some options control the preprocessor and others the compiler itself.  Yet other options control the assembler and linker; most of these are not documented here, since you rarely need to use any of them.

       Most of the command-line options that you can use with GCC are useful for C programs; when an option is only useful with another language (usually C++), the explanation says so explicitly.  If the description for a particular option does not mention a source language, you can use that option with all supported languages.

       The usual way to run GCC is to run the executable called gcc, or machine-gcc when cross-compiling, or machine-gcc-version to run a specific version of GCC. When you compile C++ programs, you should invoke GCC as g++ instead.

       The gcc program accepts options and file names as operands.  Many options have multi-letter names; therefore multiple single-letter options may not be grouped: -dv is very different from -d -v.

       You can mix options and other arguments.  For the most part, the order you use doesn't matter.  Order does matter when you use several options of the same kind; for example, if you specify -L more than once, the directories are searched in the order specified.  Also, the placement of the -l option is significant.

       Many options have long names starting with -f or with -W---for example, -fmove-loop-invariants, -Wformat and so on.  Most of these have both positive and negative forms; the negative form of -ffoo is -fno-foo.  This manual documents only one of these two forms, whichever one is not the default.


```



## make 工具

``` shell
# make.x86_64 : A GNU tool which simplifies the build process for users  一个为用户简化构建过程的GNU工具
yum install -y make
```



## gdb

``` shell
# gdb.x86_64 : A stub package for GNU source-level debugger
yum install -y gdb
```

> 依赖关系
>
> ``` none
> gc.x86_64 : A garbage collector for C and C++
> gdb-headless.x86_64 : A GNU source-level debugger for C, C++, Fortran, Go and other languages
> guile.x86_64 : A GNU implementation of Scheme for application extensibility 用于应用程序可扩展性的Scheme的GNU实现
> libatomic_ops.x86_64 : Atomic memory update operations
> libbabeltrace.x86_64 : Common Trace Format Babel Tower
> libipt.x86_64 : Intel Processor Trace Decoder Library
> libtool-ltdl.x86_64 : Runtime libraries for GNU Libtool Dynamic Module Loader
> gcc-gdb-plugin.x86_64 : GCC plugin for GDB
> ```
>



## CLion输出乱码问题

> 参考自 https://segmentfault.com/a/1190000039128339

### 半完美方案

修改 `CMakeLists.txt` 文件，在文件中添加一条设置，即可：

``` none
# C 语言
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fexec-charset=GBK")
# C++ 语言
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fexec-charset=GBK")
```

> `-fexec-charset`：指定多字节字符串(`const char*`)常量在编译后的程序里保存的编码集（若不指定，默认是UTF-8）
> 其他都不用修改，如果项目换到如mac系统，注释即可。

该方法使得 relase 模式正常了，但是 debug 反而乱码了

### 完美方案：替换 gcc移植版本

植版本肯定会有各种问题，新增工具链，替换掉 gcc 移植版本即可。

#### wsl

https://docs.microsoft.com/en-us/windows/wsl/

 wsl 下的 gcc 提供的是原生支持，不会有任何问题

![image.png](https://segmentfault.com/img/bVcVR9m)

#### 远程主机（虚拟机Centos）

远程主机上需要安装

``` shell
yum install -y tar
yum install -y cmake gcc gcc-c++ gdb
```

