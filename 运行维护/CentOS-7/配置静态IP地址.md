# CentOS 8 配置静态IP地址

## 安装 NetworkManager

在RHEL7中默认使用 `NetworkManager` 守护进程来监控和管理网络设置。`NetworkManager`包含命令行工具和文本界面工具：
* nmcli：网络管理命令行接口：NetworkManager Command-Line Interface
* nmtui：网络管理文本用户接口：NetworkManager Text-User Interface

CentOS7之前的网络管理是通过`ifcfg`文件配置管理接口(device)，而现在是通过`NetworkManager`服务管理连接(connection)。
`nmcli`会自动把配置写到`/etc/sysconfig/network-scripts/`目录下面（`nmcli`和`nmtui`的网络配置会覆盖配置文件的内容），配置文件的生成与使用状态均由`NetworkManager`控制。

``` shell
#nmcli工具由NetworkManager提供
[root@centos804 ~]# yum provides nmcli
上次元数据过期检查：1:07:17 前，执行于 2021年12月11日 星期六 15时59分11秒。
NetworkManager-1:1.26.0-8.el8.x86_64 : Network connection manager and user applications
仓库        ：@System
匹配来源：
文件名    ：/usr/bin/nmcli

NetworkManager-1:1.32.10-4.el8.x86_64 : Network connection manager and user applications
仓库        ：baseos
匹配来源：
文件名    ：/usr/bin/nmcli

#安装NetworkManager
yum install -y NetworkManager

#启动NetworkManager服务
systemctl enable --now NetworkManager
```



## 修改IP地址

### 查看

``` shell
[root@localhost ~]# nmcli connection show
NAME   UUID                                  TYPE      DEVICE 
enp0s3  0c06116c-a539-41fa-98e4-b22280dab895  ethernet  enp0s3 
```

> 格式：`show [--active] [--order <order spec>]` 或
>
> `show [--active] [id | uuid | path | apath] <ID> ...`

### 修改

```shell
[root@centos804 ~]# nmcli connection modify enp0s3 ipv4.addresses 192.168.1.110/24
```

> 格式：`modify [--temporary] [id | uuid | path] <ID> ([+|-]<setting>.<property> <value>)+`

配置信息自动更新到`/etc/sysconfig/network-scripts/ifcfg-enp0s3`

``` shell
[root@centos804 ~]# cat /etc/sysconfig/network-scripts/ifcfg-enp0s3 
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=0c06116c-a539-41fa-98e4-b22280dab895
DEVICE=enp0s3
ONBOOT=yes
IPADDR=192.168.1.110
PREFIX=24
GATEWAY=192.168.1.1
DNS1=192.168.1.1
IPV6_PRIVACY=no
```


### 重启生效

```shell
#方法1
nmcli device reapply ens33 

#方法2
nmcli con reload && nmcli con up ens33

#方法3
nmcli networking off && nmcli networking on
```


### 验证

```shell
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:e5:59:09 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.104/24 brd 192.168.1.255 scope global noprefixroute enp0s3
       valid_lft forever preferred_lft forever
    inet6 2409:8a00:7852:6720:895e:e2e:75c6:b4c5/64 scope global dynamic noprefixroute 
       valid_lft 242807sec preferred_lft 156407sec
    inet6 fe80::fab6:859b:75ee:ac37/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```



————————————————
版权声明：本文为CSDN博主「willblog」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/networken/article/details/106867172