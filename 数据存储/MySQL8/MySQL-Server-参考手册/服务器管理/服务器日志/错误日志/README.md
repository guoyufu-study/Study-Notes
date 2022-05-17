## 错误日志

> https://dev.mysql.com/doc/refman/8.0/en/error-log.html

- [5.4.2.1 错误日志配置](https://dev.mysql.com/doc/refman/8.0/en/error-log-configuration.html)
- [5.4.2.2 默认错误日志目标配置](https://dev.mysql.com/doc/refman/8.0/en/error-log-destination-configuration.html)
- [5.4.2.3 错误事件字段](https://dev.mysql.com/doc/refman/8.0/en/error-log-event-fields.html)
- [5.4.2.4 错误日志过滤的类型](https://dev.mysql.com/doc/refman/8.0/en/error-log-filtering.html)
- [5.4.2.5 基于优先级的错误日志过滤（log_filter_internal）](https://dev.mysql.com/doc/refman/8.0/en/error-log-priority-based-filtering.html)
- [5.4.2.6 基于规则的错误日志过滤（log_filter_dragnet）](https://dev.mysql.com/doc/refman/8.0/en/error-log-rule-based-filtering.html)
- [5.4.2.7 JSON 格式的错误记录](https://dev.mysql.com/doc/refman/8.0/en/error-log-json.html)
- [5.4.2.8 错误记录到系统日志](https://dev.mysql.com/doc/refman/8.0/en/error-log-syslog.html)
- [5.4.2.9 错误日志输出格式](https://dev.mysql.com/doc/refman/8.0/en/error-log-format.html)
- [5.4.2.10 错误日志文件刷新和重命名](https://dev.mysql.com/doc/refman/8.0/en/error-log-rotation.html)

本节讨论如何配置 MySQL 服务器以**将诊断消息记录到错误日志中**。有关选择错误消息字符集和语言的信息，请参阅 [第 10.6 节，“错误消息字符集”](https://dev.mysql.com/doc/refman/8.0/en/charset-errors.html) 和 [第 10.12 节，“设置错误消息语言”](https://dev.mysql.com/doc/refman/8.0/en/error-message-language.html)。

错误日志包含 **[mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 启动和关闭时间的记录**。它还包含诊断消息，比如在服务器启动和关闭期间以及在服务器运行期间发生的错误、警告和注释。比如，如果 [mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 注意到一个表需要自动检查或修复，它会在错误日志中写入一条消息。

根据错误日志配置，错误消息也可能填充性能模式 [`error_log`](https://dev.mysql.com/doc/refman/8.0/en/performance-schema-error-log-table.html) 表，以提供日志的 SQL 接口并允许查询其内容。请参阅 [第 27.12.21.1 节，“error_log 表”](https://dev.mysql.com/doc/refman/8.0/en/performance-schema-error-log-table.html)。

在某些操作系统上，如果 [mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 异常退出，错误日志会包含堆栈跟踪。跟踪可用于确定 [mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 退出的位置。请参阅 [第 5.9 节，“调试 MySQL”](https://dev.mysql.com/doc/refman/8.0/en/debugging-mysql.html)。

如果用于启动 [mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html)， [mysqld_safe](https://dev.mysql.com/doc/refman/8.0/en/mysqld-safe.html) 可能会将消息写入错误日志。比如，当 [mysqld_safe](https://dev.mysql.com/doc/refman/8.0/en/mysqld-safe.html) 注意到 [mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 异常退出时，它会重新启动 [mysqld](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html)并将一条`mysqld restarted`消息写入错误日志。

以下部分讨论配置错误日志记录的各个方面。