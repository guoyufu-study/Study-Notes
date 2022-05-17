# LOAD DATA 语句

> https://dev.mysql.com/doc/refman/8.0/en/load-data.html

``` sql
LOAD DATA
    [LOW_PRIORITY | CONCURRENT] [LOCAL]
    INFILE 'file_name'
    [REPLACE | IGNORE]
    INTO TABLE tbl_name
    [PARTITION (partition_name [, partition_name] ...)]
    [CHARACTER SET charset_name]
    [{FIELDS | COLUMNS}
        [TERMINATED BY 'string']
        [[OPTIONALLY] ENCLOSED BY 'char']
        [ESCAPED BY 'char']
    ]
    [LINES
        [STARTING BY 'string']
        [TERMINATED BY 'string']
    ]
    [IGNORE number {LINES | ROWS}]
    [(col_name_or_user_var
        [, col_name_or_user_var] ...)]
    [SET col_name={expr | DEFAULT}
        [, col_name={expr | DEFAULT}] ...]
```

[`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 语句以非常高的速度将文本文件中的行读入表中。该文件可以从服务器主机或客户端主机读取，这取决于是否给出了 `LOCAL` 修饰符。 `LOCAL`也影响数据解释和错误处理。

[`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html)是 [`SELECT ... INTO OUTFILE`](https://dev.mysql.com/doc/refman/8.0/en/select-into.html) 的补码。（请参阅[第 13.2.10.1 节，“SELECT ... INTO 语句”](https://dev.mysql.com/doc/refman/8.0/en/select-into.html)。）要将数据从表写入文件，请使用 [`SELECT ... INTO OUTFILE`](https://dev.mysql.com/doc/refman/8.0/en/select-into.html)。要将文件读回表中，请使用 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html)。 两个语句的 `FIELDS` 和 `LINES`子句的语法是相同的。

[**mysqlimport**](https://dev.mysql.com/doc/refman/8.0/en/mysqlimport.html) 实用程序提供了另一种加载数据文件的方法；它通过向服务器发送 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 语句来运行。请参阅[第 4.5.5 节，“mysqlimport - 数据导入程序”](https://dev.mysql.com/doc/refman/8.0/en/mysqlimport.html)。

有关 [`INSERT`](https://dev.mysql.com/doc/refman/8.0/en/insert.html)相对于 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 的效率和加速 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 的信息，请参阅 [第 8.2.5.1 节，“优化 INSERT 语句”](https://dev.mysql.com/doc/refman/8.0/en/insert-optimization.html)。

- [Non-LOCAL 与 LOCAL 操作](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-local)
- [输入文件字符集](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-character-set)
- [输入文件位置](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-file-location)
- [安全要求](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-security-requirements)
- [重复键和错误处理](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-error-handling)
- [索引处理](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-index-handling)
- [字段和行处理](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-field-line-handling)
- [列列表规范](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-column-list)
- [输入预处理](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-input-preprocessing)
- [列值分配](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-column-assignments)
- [分区表支持](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-partitioning-support)
- [并发注意事项](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-concurrency)
- [语句结果信息](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-statement-result-information)
- [复制注意事项](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-replication)
- [杂项主题](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-miscellaneous)

#### Non-LOCAL 与 LOCAL 操作

与 non-`LOCAL` 操作相比， `LOCAL` 修饰符会影响 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 的这些方面 ：

- 它改变了输入文件的预期位置；请参阅 [输入文件位置](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-file-location)。
- 它改变了语句的安全要求；请参阅 [安全要求](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-security-requirements)。
- 对输入文件内容的解释和错误处理与 `IGNORE`  修饰符的作用相同；请参阅 [重复键和错误处理](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-error-handling) 以及 [列值分配](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-column-assignments)。

仅当服务器和您的客户端都已配置为允许它时，`LOCAL` 才有效。比如，如果 [**mysqld**](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 在 [`local_infile`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_local_infile) 系统变量禁用的情况下启动，`LOCAL` 会产生错误。请参见 [第 6.1.6 节，“LOAD DATA LOCAL 的安全注意事项”](https://dev.mysql.com/doc/refman/8.0/en/load-data-local-security.html)。

#### 输入文件字符集

文件名必须以文字字符串的形式给出。在 Windows 上，将路径名中的反斜杠指定为正斜杠或双反斜杠。服务器使用系统变量 [`character_set_filesystem`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_character_set_filesystem) 指示的字符集解释文件名 。

默认情况下，服务器使用 [`character_set_database`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_character_set_database)系统变量指示的字符集解释文件内容。如果文件内容使用不同于此默认值的字符集，则最好使用`CHARACTER SET`子句指定该字符集。字符集 `binary` 指定“不转换。”

[`SET NAMES`](https://dev.mysql.com/doc/refman/8.0/en/set-names.html)和 [`character_set_client`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_character_set_client) 的设置不影响文件内容解释。

[`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 将文件中的所有字段解释为具有相同的字符集，而不考虑加载字段值的列的数据类型。为了正确解释文件，您必须确保它是使用正确的字符集编写的。例如，如果您使用 [**mysqldump -T**](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html) 来编写数据文件，或通过在 [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 中发出[`SELECT ... INTO OUTFILE`](https://dev.mysql.com/doc/refman/8.0/en/select-into.html)语句，请务必使用  [`--default-character-set`](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html#option_mysql_default-character-set) 选项以在文件加载时使用 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 的字符集写入输出。

> 无法加载使用 `ucs2`、`utf16`、 `utf16le`或`utf32` 字符集的数据文件。

#### 输入文件位置

这些规则确定[`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html)输入文件的位置：

- 如果 `LOCAL` 未指定，则文件必须位于服务器主机上。服务器直接读取文件，定位如下：

  - 如果文件名是绝对路径名，则服务器按给定的方式使用它。
  - 如果文件名是带有前导组件的相对路径名，则服务器会查找相对于其数据目录的文件。
  - 如果文件名没有前导组件，则服务器在默认数据库的数据库目录中查找该文件。

- 如果 `LOCAL` 指定，则文件必须位于客户端主机上。客户端程序读取文件，定位如下：

  - 如果文件名是绝对路径名，则客户端程序按给定的方式使用它。
  - 如果文件名是相对路径名，则客户端程序查找相对于其调用目录的文件。

  使用 `LOCAL` 时，客户端程序读取文件并将其内容发送到服务器。服务器在它存储临时文件的目录中创建文件的副本。请参阅 [第 B.3.3.5 节，“MySQL 存储临时文件的位置”](https://dev.mysql.com/doc/refman/8.0/en/temporary-files.html)。此目录中的副本空间不足可能会导致 [`LOAD DATA LOCAL`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 语句失败。

非 `LOCAL` 规则意味着服务器读取相对于其数据目录的一个名为 `./myfile.txt` 的文件，而它从默认数据库的数据库目录中读取一个名为  `myfile.txt` 的文件。比如，当 `db1` 是默认数据库时，执行下面的 [`LOAD DATA`](https://dev.mysql.com/doc/refman/8.0/en/load-data.html) 语句，则服务器会从 `db1` 数据库目录中读取文件 `data.txt`，即使该语句显式地将文件加载到 `db2` 数据库中的表中： 

```sql
LOAD DATA INFILE 'data.txt' INTO TABLE db2.my_table;
```

> 服务器还使用非`LOCAL`规则来为 [`IMPORT TABLE`](https://dev.mysql.com/doc/refman/8.0/en/import-table.html) 语句定位 `.sdi`的文件 。

#### 安全要求

对于非`LOCAL`加载操作，服务器读取位于服务器主机上的文本文件，因此必须满足以下安全要求：

- 你必须有 [`FILE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_file) 特权。请参阅[第 6.2.2 节，“MySQL 提供的特权”](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html)。
- 操作以 [`secure_file_priv`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_secure_file_priv) 系统变量设置为准：
  - 如果变量值是非空目录名，则文件必须位于该目录中。
  - 如果变量值是空的（这是不安全的），文件只需要被服务器读取。

对于 `LOCAL` 加载操作，客户端程序读取位于客户端主机上的文本文件。因为文件内容是由客户端通过连接发送到服务器的，所以使用`LOCAL` 比服务器直接访问文件时要慢一些。另一方面，您不需要 [`FILE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_file) 特权，文件可以位于客户端程序可以访问的任何目录中。

#### 重复键和错误处理

`REPLACE` 和 `IGNORE` 修饰符控制在唯一键值（`PRIMARY KEY`或`UNIQUE`索引值） 上复制现有表行的新（输入）行 的处理：

- 使用`REPLACE`，与现有行中的唯一键值具有相同值的新行将替换现有行。请参见[第 13.2.9 节，“REPLACE 语句”](https://dev.mysql.com/doc/refman/8.0/en/replace.html)。
- 使用`IGNORE`，与唯一键值上的现有行重复的新行将被丢弃。有关详细信息，请参阅 [IGNORE 对语句执行的影响](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#ignore-effect-on-execution)。

修饰符与`LOCAL`具有相同的效果 `IGNORE`。发生这种情况是因为服务器无法在操作过程中停止文件传输。

如果未指定`REPLACE`、 `IGNORE`或`LOCAL`，则在找到重复键值时会发生错误，并忽略文本文件的其余部分。

除了影响刚才描述的重复键处理，`IGNORE`还 `LOCAL`影响错误处理：

- 没有`IGNORE`也没有 `LOCAL`，数据解释错误会终止操作。
- 使用`IGNORE`or`LOCAL`时，数据解释错误会变成警告并且加载操作会继续，即使 SQL 模式是限制性的。有关示例，请参阅 [列值分配](https://dev.mysql.com/doc/refman/8.0/en/load-data.html#load-data-column-assignments)。
