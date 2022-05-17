# 服务器日志

> https://dev.mysql.com/doc/refman/8.0/en/server-logs.html

- [5.4.1 选择通用查询日志和慢查询日志输出目的地](https://dev.mysql.com/doc/refman/8.0/en/log-destinations.html)
- [5.4.2 错误日志](https://dev.mysql.com/doc/refman/8.0/en/error-log.html)
- [5.4.3 通用查询日志](https://dev.mysql.com/doc/refman/8.0/en/query-log.html)
- [5.4.4 二进制日志](https://dev.mysql.com/doc/refman/8.0/en/binary-log.html)
- [5.4.5 慢查询日志](https://dev.mysql.com/doc/refman/8.0/en/slow-query-log.html)
- [5.4.6 服务器日志维护](https://dev.mysql.com/doc/refman/8.0/en/log-file-maintenance.html)



MySQL 服务器有几个日志，使用它们可以帮助您找出正在发生的活动。

| 日志类型               | 写入日志的信息                                               |
| :--------------------- | :----------------------------------------------------------- |
| 错误日志               | 启动、运行或停止 [mysqld** ](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html)时遇到的问题 |
| 通用查询日志           | 已建立的客户端连接和从客户端收到的语句                       |
| 二进制日志             | 更改数据的语句（也用于复制）                                 |
| 中继日志               | 从复制源服务器接收的数据更改                                 |
| 慢查询日志             | 执行时间超过 [`long_query_time`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_long_query_time) 秒的查询 |
| DDL 日志（元数据日志） | DDL 语句执行的元数据操作                                     |

除了 Windows 上的错误日志外，**默认不启用任何日志**。（DDL 日志总是在需要时创建，并且没有用户可配置的选项；请参阅 [DDL 日志](https://dev.mysql.com/doc/refman/5.7/en/ddl-log.html)。）以下特定于日志的部分提供了有关启用日志记录的服务器选项的信息。

默认情况下，服务器将所有已启用日志的文件写入数据目录中。您可以通过**刷新日志**来强制服务器关闭并重新打开日志文件（或者在某些情况下切换到新的日志文件）。发出 [`FLUSH LOGS`](https://dev.mysql.com/doc/refman/8.0/en/flush.html#flush-logs) 语句时会发生日志刷新；使用 `flush-logs` 或  `refresh` 参数执行 [mysqladmin](https://dev.mysql.com/doc/refman/8.0/en/mysqladmin.html)；或使用 [`--flush-logs`](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_flush-logs) 或 [`--master-data`](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_master-data) 选项执行 [mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html) 。请参阅 [第 13.7.8.3 节，“FLUSH 语句”](https://dev.mysql.com/doc/refman/8.0/en/flush.html)，[第 4.5.2 节，“mysqladmin — MySQL 服务器管理程序”](https://dev.mysql.com/doc/refman/8.0/en/mysqladmin.html) 和 [第 4.5.4 节，“mysqldump — 数据库备份程序”](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)。此外，当二进制日志的大小达到系统变量 [`max_binlog_size`](https://dev.mysql.com/doc/refman/8.0/en/replication-options-binary-log.html#sysvar_max_binlog_size) 时，会刷新二进制日志。

您可以在运行时控制**通用查询日志**和**慢查询日志**。您可以启用或禁用日志记录，或更改日志文件名。您可以告诉服务器将通用查询和慢查询条目写入日志表、日志文件或两者都写。有关详细信息，请参阅 [第 5.4.1 节“选择通用查询日志和慢查询日志输出目标”](https://dev.mysql.com/doc/refman/8.0/en/log-destinations.html)、[第 5.4.3 节“通用查询日志”](https://dev.mysql.com/doc/refman/8.0/en/query-log.html) 和 [第 5.4.5 节“慢查询日志”](https://dev.mysql.com/doc/refman/8.0/en/slow-query-log.html)。

**中继日志**仅用于副本，以保存来自复制源服务器的数据更改，这些更改也必须在副本上进行。有关中继日志内容和配置的讨论，请参阅 [第 17.2.4.1 节，“中继日志”](https://dev.mysql.com/doc/refman/8.0/en/replica-logs-relaylog.html)。

有关**日志维护**操作（比如旧日志文件到期）的信息，请参阅[第 5.4.6 节，“服务器日志维护”](https://dev.mysql.com/doc/refman/8.0/en/log-file-maintenance.html)。

有关保持**日志安全**的信息，请参阅 [第 6.1.2.3 节，“密码和日志记录”](https://dev.mysql.com/doc/refman/8.0/en/password-logging.html)。