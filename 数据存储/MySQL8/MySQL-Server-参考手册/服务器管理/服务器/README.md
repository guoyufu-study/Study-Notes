# MySQL Server

> https://dev.mysql.com/doc/refman/8.0/en/mysqld-server.html

- [5.1.1 配置服务器](https://dev.mysql.com/doc/refman/8.0/en/server-configuration.html)
- [5.1.2 服务器配置默认值](https://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html)
- [5.1.3 服务器配置验证](https://dev.mysql.com/doc/refman/8.0/en/server-configuration-validation.html)
- [5.1.4 服务器选项、系统变量和状态变量参考](https://dev.mysql.com/doc/refman/8.0/en/server-option-variable-reference.html)
- [5.1.5 服务器系统变量参考](https://dev.mysql.com/doc/refman/8.0/en/server-system-variable-reference.html)
- [5.1.6 服务器状态变量参考](https://dev.mysql.com/doc/refman/8.0/en/server-status-variable-reference.html)
- [5.1.7 服务器命令选项](https://dev.mysql.com/doc/refman/8.0/en/server-options.html)
- [5.1.8 服务器系统变量](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)
- [5.1.9 使用系统变量](https://dev.mysql.com/doc/refman/8.0/en/using-system-variables.html)
- [5.1.10 服务器状态变量](https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html)
- [5.1.11 服务器 SQL 模式](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)
- [5.1.12 连接管理](https://dev.mysql.com/doc/refman/8.0/en/connection-management.html)
- [5.1.13 IPv6 支持](https://dev.mysql.com/doc/refman/8.0/en/ipv6-support.html)
- [5.1.14 网络命名空间支持](https://dev.mysql.com/doc/refman/8.0/en/network-namespace-support.html)
- [5.1.15 MySQL 服务器时区支持](https://dev.mysql.com/doc/refman/8.0/en/time-zone-support.html)
- [5.1.16 资源组](https://dev.mysql.com/doc/refman/8.0/en/resource-groups.html)
- [5.1.17 服务器端帮助支持](https://dev.mysql.com/doc/refman/8.0/en/server-side-help-support.html)
- [5.1.18 客户端会话状态的服务器跟踪](https://dev.mysql.com/doc/refman/8.0/en/session-state-tracking.html)
- [5.1.19 服务器关机流程](https://dev.mysql.com/doc/refman/8.0/en/server-shutdown.html)



[**mysqld**](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 是 MySQL 服务器。以下讨论涵盖了这些 MySQL 服务器配置主题：

- 服务器支持的**启动选项**。您可以在命令行上、通过配置文件，或两者都用，来指定这些选项。
- 服务器**系统变量**。这些变量反映了启动选项的当前状态和值，其中一些可以在服务器运行时进行修改。
- 服务器**状态变量**。这些变量包含有关运行时操作的计数器和统计信息。
- 如何**设置服务器 SQL 模式**。此设置修改 SQL 语法和语义的某些方面，比如为了与来自其他数据库系统的代码兼容，或控制特定情况下的错误处理。
- 服务器如何**管理客户端连接**。
- 配置和使用 **IPv6 和网络命名空间支持**。
- 配置和使用**时区支持**。
- 使用**资源组**。
- 服务器端**帮助**功能。
- 提供启用客户端**会话状态**更改的功能。
- 服务器**关闭**过程。根据表的类型（事务性或非事务性）以及是否使用复制，存在性能和可靠性方面的考虑。

有关 MySQL 8.0 中已添加、弃用，或删除的 MySQL 服务器变量和选项的列表，请参阅 [第 1.4 节，“MySQL 8.0 中添加、弃用或删除的服务器和状态变量和选项”](https://dev.mysql.com/doc/refman/8.0/en/added-deprecated-removed.html)。

> 并非所有 MySQL 服务器二进制文件和配置都支持所有存储引擎。要了解如何确定您的 MySQL 服务器安装支持哪些存储引擎，请参阅 [第 13.7.7.16 节，“SHOW ENGINES 语句”](https://dev.mysql.com/doc/refman/8.0/en/show-engines.html)。

***

[5.1.1 配置服务器](配置服务器.md ':include')

[5.1.2 服务器配置默认值](服务器配置默认值.md ':include')

[5.1.3 服务器配置验证](服务器配置验证.md ':include')
