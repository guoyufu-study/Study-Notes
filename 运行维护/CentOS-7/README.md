# CentOS 7

> https://www.centos.org/centos-linux/

* [yum 包管理器](运行维护/CentOS-7/yum.md)：没有预装 dnf
* [Linux 通用软件](运行维护/通用软件/)
* [配置静态IP地址](运行维护/CentOS-7/配置静态IP地址.md)：使用网络管理客户端 `nmcli` 来配置静态IP地址。
* [修改主机名](运行维护/CentOS-7/修改主机名.md)：使用 `hostnamectl` 修改主机名
* [防火墙](运行维护/CentOS-7/防火墙.md)：启用防火墙，开放端口
* [权限管理](运行维护/CentOS-7/权限管理.md)：创建用户、重置密码、sudoers

## 基本工作流

### 初始设置

```  shell
sudo yum update -- centos 7 没有预装 dnf
hostnamectl set-hostname cl7-template-101 -- 修改主机名
nmcli connection modify enp0s3 ipv4.addresses 192.168.1.101/24 --修改静态IP地址
nmcli device reapply enp0s3 -- 重启生效
```

## 安装通用软件

``` shell
sudo yum install bash-completion -- 命令补全
sudo yum install vim 
```



