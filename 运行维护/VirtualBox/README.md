# VirtualBox

> 官网 https://www.virtualbox.org/

## 版本选择，下载并安装

6.0/5.2 版本在 2020-07 EOL，现在最新版本 6.1.x 。

> 没有特殊需求，选 6.1.x 即可。

Virtual Box 支持多种操作系统平台，提供了多种安装方式，包括：二进制、平台包、源码编译。

> 通常使用 Windows 操作系统作为宿主机，选择 exe 安装包即可。

下载说明见 https://www.virtualbox.org/wiki/Downloads，安装很简单，不赘述。

## 常见问题

### 用户手册

遇到问题，先查用户手册是一个好习惯。

点击菜单 “帮助 -> 内容”，打开用户手册。

### 安装增强功能

GUI 操作客户机时，安装步骤很简单，在用户手册 `Guest Additions -> Installing and Maintaining Guest Additions` 中有描述，不赘述。

CUI 操作类 UNIX 客户机时，需要挂载 ISO 镜像盘。

``` shell
[jasper@centos809 ~]$ mkdir winshare
# 记得用户要有 root 权限
[jasper@centos809 ~]$ sudo mount /dev/cdrom winshare
mount: /home/jasper/winshare: WARNING: device write-protected, mounted read-only.
```

验证一下，

``` shell
[jasper@centos809 winshare]$ ll
总用量 46916
-r--r--r--. 1 root root      763 2月  20 2020 AUTORUN.INF
-r-xr-xr-x. 1 root root     6384 11月 22 23:17 autorun.sh
dr-xr-xr-x. 2 root root      792 11月 22 23:24 cert
dr-xr-xr-x. 2 root root     1824 11月 22 23:24 NT3x
dr-xr-xr-x. 2 root root     2652 11月 22 23:24 OS2
-r-xr-xr-x. 1 root root     4821 11月 22 23:17 runasroot.sh
-r--r--r--. 1 root root      592 11月 22 23:24 TRANS.TBL
-r--r--r--. 1 root root  3991991 11月 22 23:21 VBoxDarwinAdditions.pkg
-r-xr-xr-x. 1 root root     3949 11月 22 23:16 VBoxDarwinAdditionsUninstall.tool
-r-xr-xr-x. 1 root root  7443891 11月 22 23:18 VBoxLinuxAdditions.run
-r--r--r--. 1 root root  9420288 11月 22 23:10 VBoxSolarisAdditions.pkg
-r-xr-xr-x. 1 root root 16890912 11月 22 23:21 VBoxWindowsAdditions-amd64.exe
-r-xr-xr-x. 1 root root   270840 11月 22 23:18 VBoxWindowsAdditions.exe
-r-xr-xr-x. 1 root root  9998128 11月 22 23:19 VBoxWindowsAdditions-x86.exe
-r--r--r--. 1 root root      259 10月  4 23:48 windows11-bypass.re
```

挂载成功。

先安装一些前置软件包：

``` shell
dnf install tar bzip2 kernel-devel gcc make elfutils-libelf-devel
```

由于客户机是 CentOS Linux 8，选择 `VBoxLinuxAdditions.run` 执行。

``` shell
[jasper@centos850 winshare]# ./VBoxLinuxAdditions.run 
Verifying archive integrity... All good.
Uncompressing VirtualBox 6.1.30 Guest Additions for Linux........
VirtualBox Guest Additions installer
Removing installed version 6.1.30 of VirtualBox Guest Additions...
Copying additional installer modules ...
Installing additional modules ...
VirtualBox Guest Additions: Starting.
VirtualBox Guest Additions: Building the VirtualBox Guest Additions kernel 
modules.  This may take a while.
VirtualBox Guest Additions: To build modules for other installed kernels, run
VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup <version>
VirtualBox Guest Additions: or
VirtualBox Guest Additions:   /sbin/rcvboxadd quicksetup all
VirtualBox Guest Additions: Building the modules for kernel 4.18.0-348.7.1.el8_5.x86_64.
VirtualBox Guest Additions: Running kernel modules will not be replaced until the system is restarted
```

最后一句，提示让重启系统。取消挂载，删除临时目录，重启系统：

``` shell
umount winshare
rm -rf winshare
shutdown -r now
```



### 实现共享文件夹

在用户手册`Guest Additions -> Shared Folders`中有描述。

> 实现共享文件夹功能前，需要先安装增强功能。

在 Virtual Box 管理器中选择目标客户机，点击 “设置 -> 共享文件夹 -> 添加共享文件夹”，按需设置，选择自动挂载即可。

如果没有自动挂载，手动挂载一下：

``` shell
mount -t vboxsf vm-share /mnt/vm-share
```

