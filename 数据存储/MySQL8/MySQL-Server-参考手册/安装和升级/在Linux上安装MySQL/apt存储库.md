# 使用 MySQL APT 存储库在 Linux 上安装 MySQL

> https://dev.mysql.com/doc/refman/8.0/en/linux-installation-apt-repo.html

MySQL APT 存储库提供 **`deb` 软件包**，用于在当前 **Debian 和 Ubuntu** 版本上安装和管理 MySQL 服务器、客户端和其他组件。

可在 [使用 MySQL APT 存储库的快速指南](数据存储/MySQL8/MySQL-Server-参考手册/安装和升级/在Linux上安装MySQL/使用MySQL-APT存储库的快速指南.md) 中找到 MySQL APT 存储库的**使用说明**。



## 笔记

``` shell
sudo apt-get install mysql-apt-config
sudo apt-get install mysql-server
sudo mysql
```

> 安装时，将`root` 密码留空，以启用基于UNIX套接字的身份验证的无密码登录。
