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

#### 挂载镜像盘

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

#### 安装前置软件包

先安装一些前置软件包。

对于 CentOS Stream 8 需要安装：

``` shell
dnf install tar bzip2 gcc make kernel-devel elfutils-libelf-devel
```

对于 Ubuntu 22-04 需要安装：

```
apt install tar bzip2 gcc make linux-headers-generic libxt6 libxmu6
```

#### 运行安装

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

#### 重启系统

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

### ssh 远程登录

#### 安装服务器

确保客户机安装 openssh 服务器和客户端。

对于 ubuntu-22-04，命令如下：

``` sh
apt list openssh*
```

> 安装 `openssh-server` 和 `openssh-client`

对于 CentOS-Stream-8，命令如下：

``` shell
dnf list openssh*
```

> 安装 `openssh-server` 和 `openssh-clients`。注意客户端软件有不同。

#### 启动服务

``` shell
systemctl status sshd
systemctl reload-or-restart sshd
systemctl enable sshd
```

启动 sshd 服务，并设置开机自启动。

#### 开放端口

先明确 ip 地址，通过下面的命令查看：

``` shell
ip address
```

查看防火墙服务是否启用。

对于 CentOS-Stream-8，命令如下：

``` bash
systemctl status firwared
```

对于 Ubuntu-22-04，命令如下：

``` bash
ufw status
```

如果启用了防火墙服务，需要开放端口。

对于 Ubuntu-22-04，命令如下：

``` bash
ufw allow to 10.0.2.15 app openssh
```

#### 修改服务器配置

```bash
vim /etc/ssh/sshd_config
```

#### 添加授权公钥

``` bash
vim ~/.ssh/authorized_keys
```

> 注意：
>
> `.ssh` 目录的权限 `700`，`authorized_keys` 的权限 `600`，其他用户不能有写权限。

#### 远程登录

在 Windows 命令行窗口登录，输入以下命令：

``` bash
ssh -p 22 username@10.0.2.15
```

如果是 NAT 网络，则需要配置端口转发。

![nat-port-forward](images\nat-port-forward.png)

在 Windows 命令行窗口登录，输入以下命令：

``` bash
ssh -p 1022 username@10.0.2.15
```

