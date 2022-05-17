# 安全

> https://dev.mysql.com/doc/refman/8.0/en/security.html

在考虑 MySQL 安装中的安全性时，您应该考虑广泛的可能主题，以及它们如何影响 MySQL 服务器和相关应用程序的安全性：

- 影响安全性的**一般因素**。其中包括选择好的密码、不授予用户不必要的权限、通过防止 SQL 注入和数据损坏来确保应用程序安全等。请参见 [第 6.1 节“一般安全问题”](https://dev.mysql.com/doc/refman/8.0/en/general-security-issues.html)。
- **安装**本身的安全性。应保护数据文件、日志文件和您安装的所有应用程序文件，以确保它们不会被未经授权方读取或写入。有关详细信息，请参阅 [第 2.10 节，“安装后设置和测试”](https://dev.mysql.com/doc/refman/8.0/en/postinstallation.html)。
- **数据库系统**本身的访问控制和安全性，包括被授予访问数据库、视图和数据库中使用的存储程序的权限的用户和数据库。有关详细信息，请参阅[第 6.2 节，“访问控制和帐户管理”](https://dev.mysql.com/doc/refman/8.0/en/access-control.html)。
- **安全相关插件**提供的功能。请参阅 [第 6.4 节，“安全组件和插件”](https://dev.mysql.com/doc/refman/8.0/en/security-plugins.html)。
- MySQL 和您的**系统的网络安全**。安全性与单个用户的授权有关，但您可能还希望限制 MySQL，使其仅在 MySQL 服务器主机上本地可用，或对一组有限的其他主机可用。
- 确保您对数据库文件、配置和日志文件进行了充分且适当的**备份**。还要确保您有适当的**恢复**解决方案，并测试您是否能够成功地从备份中恢复信息。请参阅 [第 7 章，*备份和恢复*](https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)。

> 本章中的几个主题也在 [安全部署指南](https://dev.mysql.com/doc/mysql-secure-deployment-guide/8.0/en/) 中得到解决，它提供了部署 MySQL Enterprise Edition Server 的通用二进制发行版的过程，该发行版具有管理 MySQL 安装安全性的功能。

***

**目录**

- [6.1 一般安全问题](数据存储/MySQL8/MySQL-Server-参考手册/安全/一般安全问题/)
- [6.2 访问控制和账户管理](数据存储/MySQL8/MySQL-Server-参考手册/安全/访问控制和账户管理/)
- [6.3 使用加密连接](https://dev.mysql.com/doc/refman/8.0/en/encrypted-connections.html)
- [6.4 安全组件和插件](https://dev.mysql.com/doc/refman/8.0/en/security-plugins.html)
- [6.5 MySQL企业数据屏蔽和去标识化](https://dev.mysql.com/doc/refman/8.0/en/data-masking.html)
- [6.6 MySQL企业加密](https://dev.mysql.com/doc/refman/8.0/en/enterprise-encryption.html)
- [6.7 SELinux](https://dev.mysql.com/doc/refman/8.0/en/selinux.html)
- [6.8 FIPS 支持](https://dev.mysql.com/doc/refman/8.0/en/fips-mode.html)