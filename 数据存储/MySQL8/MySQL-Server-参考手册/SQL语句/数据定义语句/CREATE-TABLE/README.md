# CREATE TABLE 语句

> https://dev.mysql.com/doc/refman/8.0/en/create-table.html

[13.1.20.1 由 CREATE TABLE 创建的文件](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/创建的文件.md)

[13.1.20.2 CREATE TEMPORARY TABLE 语句](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/创建临时表.md)

[13.1.20.3 CREATE TABLE ... LIKE 语句](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/创建表结构副本.md)

[13.1.20.4 CREATE TABLE ... SELECT 语句](https://dev.mysql.com/doc/refman/8.0/en/create-table-select.html)

[13.1.20.5 外键约束](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html)

[13.1.20.6 检查约束](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html)

[13.1.20.7 Silent Column Specification Changes](https://dev.mysql.com/doc/refman/8.0/en/silent-column-changes.html)

[13.1.20.8 CREATE TABLE and Generated Columns](https://dev.mysql.com/doc/refman/8.0/en/create-table-generated-columns.html)

[13.1.20.9 Secondary Indexes and Generated Columns](https://dev.mysql.com/doc/refman/8.0/en/create-table-secondary-indexes.html)

[13.1.20.10 Invisible Columns](https://dev.mysql.com/doc/refman/8.0/en/invisible-columns.html)

[13.1.20.11 Setting NDB Comment Options](https://dev.mysql.com/doc/refman/8.0/en/create-table-ndb-comment-options.html)

```sql
CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
    (create_definition,...)
    [table_options]
    [partition_options]

CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
    [(create_definition,...)]
    [table_options]
    [partition_options]
    [IGNORE | REPLACE]
    [AS] query_expression

CREATE [TEMPORARY] TABLE [IF NOT EXISTS] tbl_name
    { LIKE old_tbl_name | (LIKE old_tbl_name) }

create_definition: {
    col_name column_definition
  | {INDEX | KEY} [index_name] [index_type] (key_part,...)
      [index_option] ...
  | {FULLTEXT | SPATIAL} [INDEX | KEY] [index_name] (key_part,...)
      [index_option] ...
  | [CONSTRAINT [symbol]] PRIMARY KEY
      [index_type] (key_part,...)
      [index_option] ...
  | [CONSTRAINT [symbol]] UNIQUE [INDEX | KEY]
      [index_name] [index_type] (key_part,...)
      [index_option] ...
  | [CONSTRAINT [symbol]] FOREIGN KEY
      [index_name] (col_name,...)
      reference_definition
  | check_constraint_definition
}

column_definition: {
    data_type [NOT NULL | NULL] [DEFAULT {literal | (expr)} ]
      [VISIBLE | INVISIBLE]
      [AUTO_INCREMENT] [UNIQUE [KEY]] [[PRIMARY] KEY]
      [COMMENT 'string']
      [COLLATE collation_name]
      [COLUMN_FORMAT {FIXED | DYNAMIC | DEFAULT}]
      [ENGINE_ATTRIBUTE [=] 'string']
      [SECONDARY_ENGINE_ATTRIBUTE [=] 'string']
      [STORAGE {DISK | MEMORY}]
      [reference_definition]
      [check_constraint_definition]
  | data_type
      [COLLATE collation_name]
      [GENERATED ALWAYS] AS (expr)
      [VIRTUAL | STORED] [NOT NULL | NULL]
      [VISIBLE | INVISIBLE]
      [UNIQUE [KEY]] [[PRIMARY] KEY]
      [COMMENT 'string']
      [reference_definition]
      [check_constraint_definition]
}

data_type:
    (see Chapter 11, Data Types)

key_part: {col_name [(length)] | (expr)} [ASC | DESC]

index_type:
    USING {BTREE | HASH}

index_option: {
    KEY_BLOCK_SIZE [=] value
  | index_type
  | WITH PARSER parser_name
  | COMMENT 'string'
  | {VISIBLE | INVISIBLE}
  |ENGINE_ATTRIBUTE [=] 'string'
  |SECONDARY_ENGINE_ATTRIBUTE [=] 'string'
}

check_constraint_definition:
    [CONSTRAINT [symbol]] CHECK (expr) [[NOT] ENFORCED]

reference_definition:
    REFERENCES tbl_name (key_part,...)
      [MATCH FULL | MATCH PARTIAL | MATCH SIMPLE]
      [ON DELETE reference_option]
      [ON UPDATE reference_option]

reference_option:
    RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT

table_options:
    table_option [[,] table_option] ...

table_option: {
    AUTOEXTEND_SIZE [=] value
  | AUTO_INCREMENT [=] value
  | AVG_ROW_LENGTH [=] value
  | [DEFAULT] CHARACTER SET [=] charset_name
  | CHECKSUM [=] {0 | 1}
  | [DEFAULT] COLLATE [=] collation_name
  | COMMENT [=] 'string'
  | COMPRESSION [=] {'ZLIB' | 'LZ4' | 'NONE'}
  | CONNECTION [=] 'connect_string'
  | {DATA | INDEX} DIRECTORY [=] 'absolute path to directory'
  | DELAY_KEY_WRITE [=] {0 | 1}
  | ENCRYPTION [=] {'Y' | 'N'}
  | ENGINE [=] engine_name
  | ENGINE_ATTRIBUTE [=] 'string'
  | INSERT_METHOD [=] { NO | FIRST | LAST }
  | KEY_BLOCK_SIZE [=] value
  | MAX_ROWS [=] value
  | MIN_ROWS [=] value
  | PACK_KEYS [=] {0 | 1 | DEFAULT}
  | PASSWORD [=] 'string'
  | ROW_FORMAT [=] {DEFAULT | DYNAMIC | FIXED | COMPRESSED | REDUNDANT | COMPACT}
  | SECONDARY_ENGINE_ATTRIBUTE [=] 'string'
  | STATS_AUTO_RECALC [=] {DEFAULT | 0 | 1}
  | STATS_PERSISTENT [=] {DEFAULT | 0 | 1}
  | STATS_SAMPLE_PAGES [=] value
  | TABLESPACE tablespace_name [STORAGE {DISK | MEMORY}]
  | UNION [=] (tbl_name[,tbl_name]...)
}

partition_options:
    PARTITION BY
        { [LINEAR] HASH(expr)
        | [LINEAR] KEY [ALGORITHM={1 | 2}] (column_list)
        | RANGE{(expr) | COLUMNS(column_list)}
        | LIST{(expr) | COLUMNS(column_list)} }
    [PARTITIONS num]
    [SUBPARTITION BY
        { [LINEAR] HASH(expr)
        | [LINEAR] KEY [ALGORITHM={1 | 2}] (column_list) }
      [SUBPARTITIONS num]
    ]
    [(partition_definition [, partition_definition] ...)]

partition_definition:
    PARTITION partition_name
        [VALUES
            {LESS THAN {(expr | value_list) | MAXVALUE}
            |
            IN (value_list)}]
        [[STORAGE] ENGINE [=] engine_name]
        [COMMENT [=] 'string' ]
        [DATA DIRECTORY [=] 'data_dir']
        [INDEX DIRECTORY [=] 'index_dir']
        [MAX_ROWS [=] max_number_of_rows]
        [MIN_ROWS [=] min_number_of_rows]
        [TABLESPACE [=] tablespace_name]
        [(subpartition_definition [, subpartition_definition] ...)]

subpartition_definition:
    SUBPARTITION logical_name
        [[STORAGE] ENGINE [=] engine_name]
        [COMMENT [=] 'string' ]
        [DATA DIRECTORY [=] 'data_dir']
        [INDEX DIRECTORY [=] 'index_dir']
        [MAX_ROWS [=] max_number_of_rows]
        [MIN_ROWS [=] min_number_of_rows]
        [TABLESPACE [=] tablespace_name]

query_expression:
    SELECT ...   (Some valid select or union statement)
```

[`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 创建一个具有给定名称的表。您必须拥有 [`CREATE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_create) 表的权限。

默认情况下，使用 [`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html)存储引擎在默认数据库中创建表。如果表存在、没有默认数据库，或数据库不存在，则会发生错误。



MySQL 对**表的数量**没有限制。底层文件系统可能对代表表的文件数量有限制。单独的存储引擎可能会施加特定于引擎的约束。`InnoDB`允许多达 40 亿张表。

有关表的物理表示的信息，请参阅 [第 13.1.20.1 节，“由 CREATE TABLE 创建的文件”](https://dev.mysql.com/doc/refman/8.0/en/create-table-files.html)。

[`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句有几个方面，在本节的以下主题下进行了描述：

- [表名](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/#表名)
- [临时表](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/#临时表)
- [表克隆和复制](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/#表克隆和复制)
- [列数据类型和属性](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/#列数据类型和属性)
- [索引、外键和 CHECK 约束](https://dev.mysql.com/doc/refman/8.0/en/create-table.html#create-table-indexes-keys)
- [表选项](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/#表选项)
- [表分区](数据存储/MySQL8/MySQL-Server-参考手册/SQL语句/数据定义语句/CREATE-TABLE/#表分区)

#### 表名

- *`tbl_name`*

  表名可以指定为 *`db_name.tbl_name`* 在特定数据库中创建表。无论是否存在默认数据库，这都有效，假设数据库存在。如果您使用带引号的标识符，请分别引用数据库和表名。比如，写 ``mydb`.`mytbl``，不是 ``mydb.mytbl``。

  [第 9.2 节，“模式对象名称”](https://dev.mysql.com/doc/refman/8.0/en/identifiers.html) 中给出了允许的表名称的规则 。

- `IF NOT EXISTS`

  如果表存在，则防止发生错误。但是，无法验证现有表的结构与 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句所指定的结构是否相同。

#### 临时表

创建表时，可以使用 `TEMPORARY` 关键字。`TEMPORARY`表仅在当前会话中可见，并在会话关闭时自动删除。有关更多信息，请参阅 [第 13.1.20.2 节，“CREATE TEMPORARY TABLE 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-temporary-table.html)。

#### 表克隆和复制

- `LIKE`

  用于 `CREATE TABLE ... LIKE` 根据另一个表的定义创建一个空表，包括在原始表中定义的任何列属性和索引：

  ```sql
  CREATE TABLE new_tbl LIKE orig_tbl;
  ```

  有关更多信息，请参阅[第 13.1.20.3 节，“CREATE TABLE ... LIKE 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-table-like.html)。

- `[AS] query_expression`

  要从另一个表创建一个表， 请在 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句末尾添加一条 [`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/select.html) 语句：

  ```sql
  CREATE TABLE new_tbl AS SELECT * FROM orig_tbl;
  ```

  有关更多信息，请参阅 [第 13.1.20.4 节，“CREATE TABLE ... SELECT 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-table-select.html)。

- `IGNORE | REPLACE`

  `IGNORE` 和 `REPLACE` 选项指示在使用 [`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/select.html) 语句复制表时如何处理重复唯一键值的行 。

  有关更多信息，请参阅 [第 13.1.20.4 节，“CREATE TABLE ... SELECT 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-table-select.html)。

#### 列数据类型和属性

每个表有 4096 列的硬性限制，但对于给定的表，有效最大值可能会更少，这取决于[第 8.4.7 节“表列数和行大小的限制”](https://dev.mysql.com/doc/refman/8.0/en/column-count-limit.html)中讨论的因素。

- *`data_type`*

  *`data_type`*表示列定义中的数据类型。有关可用于指定列数据类型的语法的完整描述，以及有关每种类型的属性的信息，请参阅 [第 11 章，*数据类型*](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)。

  - 某些属性不适用于所有数据类型。 `AUTO_INCREMENT` 仅适用于整数和浮点类型。在 MySQL 8.0.13 之前， `DEFAULT` 不适用于 [`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html)、 [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html)、 `GEOMETRY` 和 [`JSON`](https://dev.mysql.com/doc/refman/8.0/en/json.html) 类型。

  - 字符数据类型（[`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html)类型、 [`ENUM`](https://dev.mysql.com/doc/refman/8.0/en/enum.html)、 [`SET`](https://dev.mysql.com/doc/refman/8.0/en/set.html)和任何同义词）可以包含 `CHARACTER SET` 以**指定列的字符集**。`CHARSET` 是 `CHARACTER SET` 的同义词。可以使用 `COLLATE` 属性以及任何其他属性来**指定字符集的排序规则** 。有关详细信息，请参阅[第 10 章，*字符集、排序规则、Unicode*](https://dev.mysql.com/doc/refman/8.0/en/charset.html)。示例：

    ```sql
    CREATE TABLE t (c CHAR(20) CHARACTER SET utf8 COLLATE utf8_bin);
    ```

    MySQL 8.0 将字符列定义中的长度规范解释为字符。[`BINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html) 和  [`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html) 的长度以字节为单位。

  - 对于[`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`BINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html)和 [`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html)列，可以创建仅使用列值的前导部分的索引，使用 *`col_name(length)`* 语法指定索引前缀长度。[`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 和 [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 列也可以被索引，但*必须*给出前缀长度。对于非二进制字符串类型，前缀长度以字符为单位，对于二进制字符串类型，前缀长度以字节为单位。也就是说，索引条目由 [`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html) 、[`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html) 和 [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 的每个列值的最前面的 *`length`* 个字符组成列，以及  [`BINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html) 、[`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html) 和 [`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 列的每列值的最前面的 *`length`* 个字节。像这样只**索引列值的前缀**可以使索引文件更小。有关索引前缀的更多信息，请参阅[第 13.1.15 节，“CREATE INDEX 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-index.html)。



    只有 `InnoDB` 和 `MyISAM` 存储引擎支持对 [`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 和 [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 列进行索引。比如：

    ```sql
    CREATE TABLE test (blob_col BLOB, INDEX(blob_col(10)));
    ```

    如果指定的索引前缀超过最大列数据类型大小，则 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 按如下方式处理索引：

    - 对于非唯一索引，要么发生错误（如果启用了严格 SQL 模式），要么索引长度减少到最大列数据类型大小内并产生警告（如果未启用严格 SQL 模式）。
    - 对于唯一索引，无论 SQL 模式如何都会发生错误，因为减少索引长度可能会导致插入不满足指定唯一性要求的非唯一条目。

  - [`JSON`](https://dev.mysql.com/doc/refman/8.0/en/json.html) 列不能被索引。您可以通过在从 `JSON` 列中提取标量值的生成列上创建索引来解决此限制。有关详细示例， 请参阅 [索引生成的列以提供 JSON 列索引。](https://dev.mysql.com/doc/refman/8.0/en/create-table-secondary-indexes.html#json-column-indirect-index)

- `NOT NULL | NULL`

  如果既未指定 `NULL` 也未 `NOT NULL` 指定，则将该列视为 `NULL` 已指定。

  在 MySQL 8.0 中，只有 `InnoDB`、 `MyISAM` 和 `MEMORY` 存储引擎支持可以具有 `NULL` 值的列的索引。在其他情况下，您必须将索引列声明为 `NOT NULL` 或导致错误结果。

- `DEFAULT`

  指定列的默认值。有关默认值处理的更多信息，包括列定义不包含显式 `DEFAULT` 值的情况，请参阅[第 11.6 节，“数据类型默认值”](https://dev.mysql.com/doc/refman/8.0/en/data-type-defaults.html)。

  如果启用了 [`NO_ZERO_DATE`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_zero_date) 或 [`NO_ZERO_IN_DATE`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_zero_in_date) SQL 模式，并且根据该模式，日期值默认值不正确，则 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)  在未启用严格 SQL 模式时生成警告，如果启用严格模式则生成错误。比如， [`NO_ZERO_IN_DATE`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_zero_in_date) 启用时，`c1 DATE DEFAULT '2010-00-00'` 会产生警告。

- `VISIBLE`, `INVISIBLE`

  指定列可见性。如果两个关键字都不存在，默认是 `VISIBLE`。一个表必须至少有一个可见列。试图使所有列不可见会产生错误。有关更多信息，请参阅[第 13.1.20.10 节，“不可见的列”](https://dev.mysql.com/doc/refman/8.0/en/invisible-columns.html)。

  `VISIBLE` 和 `INVISIBLE` 关键字 从 MySQL 8.0.23 开始可用。在 MySQL 8.0.23 之前，所有列都是可见的。

- `AUTO_INCREMENT`

  整数或浮点列可以具有附加属性 `AUTO_INCREMENT`。当您将值 `NULL`（推荐）或 `0` 插入索引 `AUTO_INCREMENT` 列时，该列将设置为下一个序列值。通常这是 `value+1`，其中 *`value`* 是表中当前列的最大值。 `AUTO_INCREMENT` 序列以 `1` 开始.

  要在插入行后检索 `AUTO_INCREMENT` 值，请使用[`LAST_INSERT_ID()`](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html#function_last-insert-id) SQL 函数或 [`mysql_insert_id()`](https://dev.mysql.com/doc/c-api/8.0/en/mysql-insert-id.html) C API 函数。请参阅[第 12.16 节，“信息函数”](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html) 和 [mysql_insert_id()](https://dev.mysql.com/doc/c-api/8.0/en/mysql-insert-id.html)。

  如果启用了 [`NO_AUTO_VALUE_ON_ZERO`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_auto_value_on_zero) SQL 模式，您可以在 `AUTO_INCREMENT`列中存储 `0` 作为 `0`，而不会生成新的序列值。请参阅[第 5.1.11 节，“服务器 SQL 模式”](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)。

  每个表只能有一个`AUTO_INCREMENT` 列，它必须被索引，并且不能有 `DEFAULT` 值。一个 `AUTO_INCREMENT` 列只有在它只包含正值时才能正常工作。插入一个负数被认为是插入一个非常大的正数。这样做是为了避免数字从正到负“换行”时出现精度问题，并确保您不会意外得到包含 `0` 的 `AUTO_INCREMENT` 列。

  对于 `MyISAM` 表，您可以在多列键中指定 `AUTO_INCREMENT` 辅助列。请参阅 [第 3.6.9 节，“使用 AUTO_INCREMENT”](https://dev.mysql.com/doc/refman/8.0/en/example-auto-increment.html)。



  为了使 MySQL 与某些 ODBC 应用程序兼容，您可以使用以下查询找到最后插入的行的 `AUTO_INCREMENT` 值：

  ```sql
SELECT * FROM tbl_name WHERE auto_col IS NULL
  ```

  此方法要求 [`sql_auto_is_null`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_sql_auto_is_null) 变量不设置为 0。请参阅[第 5.1.8 节，“服务器系统变量”](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)。

  有关 `InnoDB` 和 `AUTO_INCREMENT` 的信息，请参阅 [第 15.6.1.6 节，“InnoDB 中的 AUTO_INCREMENT 处理”](https://dev.mysql.com/doc/refman/8.0/en/innodb-auto-increment-handling.html)。有关 `AUTO_INCREMENT` 和 MySQL 复制的信息，请参阅 [第 17.5.1.1 节，“复制和 AUTO_INCREMENT”](https://dev.mysql.com/doc/refman/8.0/en/replication-features-auto-increment.html)。

- `COMMENT`

  可以使用该 `COMMENT` 选项指定列的注释，最长为 1024 个字符。注释由[`SHOW CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html) 和 [`SHOW FULL COLUMNS`](https://dev.mysql.com/doc/refman/8.0/en/show-columns.html) 语句显示。它也显示在 [`INFORMATION_SCHEMA.COLUMNS`](https://dev.mysql.com/doc/refman/8.0/en/information-schema-columns-table.html) 表的 `COLUMN_COMMENT` 列中。

- `COLUMN_FORMAT`

  在 NDB Cluster 中，还可以使用 `COLUMN_FORMAT` 为 [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 表的各个列指定数据存储格式。允许的列格式为`FIXED`、`DYNAMIC`和 `DEFAULT`。`FIXED`用于指定固定宽度的存储，`DYNAMIC` 允许列为可变宽度，`DEFAULT`  使列使用由列的数据类型确定的固定宽度或可变宽度存储（可能被 `ROW_FORMAT`说明符覆盖）。

  对于 [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 表，`COLUMN_FORMAT` 的默认值为 `FIXED`。

  在 NDB Cluster 中，使用 `COLUMN_FORMAT=FIXED` 定义的列的最大可能偏移量为 8188 字节。有关更多信息和可能的解决方法，请参阅 [第 23.2.7.5 节，“与 NDB Cluster 中的数据库对象关联的限制”](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster-limitations-database-objects.html)。

  `COLUMN_FORMAT`目前对使用除 [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 以外存储引擎的表的列没有影响。MySQL 8.0静默地忽略`COLUMN_FORMAT`.

- `ENGINE_ATTRIBUTE` 和 `SECONDARY_ENGINE_ATTRIBUTE` 选项（自 MySQL 8.0.21 起可用）用于指定主存储引擎和辅助存储引擎的列属性。这些选项被保留供将来使用。

  允许的值是字符串字面量，包括有效 `JSON` 文档，或空字符串 (`''`) 。无效 `JSON` 会被拒绝。

  ```sql
  CREATE TABLE t1 (c1 INT ENGINE_ATTRIBUTE='{"key":"value"}');
  ```

  `ENGINE_ATTRIBUTE` 和 `SECONDARY_ENGINE_ATTRIBUTE` 值可以重复，不会报错。在这种情况下，使用最后指定的值。

  服务器不会检查 `ENGINE_ATTRIBUTE` 和 `SECONDARY_ENGINE_ATTRIBUTE` 值，也不会在更改表的存储引擎时清除它们。

- `STORAGE`

  对于 [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 表，可以使用  `STORAGE` 子句指定列是存储在磁盘上还是内存中。`STORAGE DISK` 导致列存储在磁盘上，`STORAGE MEMORY` 导致使用内存存储。使用的 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句仍必须包含一个 `TABLESPACE` 子句：

  ```sql
mysql> CREATE TABLE t1 (
      ->     c1 INT STORAGE DISK,
      ->     c2 INT STORAGE MEMORY
      -> ) ENGINE NDB;
  ERROR 1005 (HY000): Can't create table 'c.t1' (errno: 140)

  mysql> CREATE TABLE t1 (
      ->     c1 INT STORAGE DISK,
      ->     c2 INT STORAGE MEMORY
      -> ) TABLESPACE ts_1 ENGINE NDB;
  Query OK, 0 rows affected (1.06 sec)
  ```

  对于[`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)表，`STORAGE DEFAULT` 相当于 `STORAGE MEMORY`。

  `STORAGE` 子句对使用除 [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 以外的存储引擎的表没有影响。`STORAGE` 关键字仅在 NDB Cluster 提供的 [**mysqld**](https://dev.mysql.com/doc/refman/8.0/en/mysqld.html) 的构建中受支持；它在任何其他版本的 MySQL 中都无法识别，任何尝试使用 `STORAGE` 关键字都会导致语法错误。

- `GENERATED ALWAYS`

  用于指定生成的列表达式。有关 [生成列](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_generated_column) 的信息，请参阅 [第 13.1.20.8 节，“CREATE TABLE 和生成的列”](https://dev.mysql.com/doc/refman/8.0/en/create-table-generated-columns.html)。

  [存储的生成列](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_stored_generated_column)可以被索引。`InnoDB` 支持 [虚拟生成列](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_virtual_generated_column) 的二级索引。请参阅 [第 13.1.20.9 节，“二级索引和生成的列”](https://dev.mysql.com/doc/refman/8.0/en/create-table-secondary-indexes.html)。

#### 索引、外键和 CHECK 约束

有几个关键字适用于索引、外键和 `CHECK`约束的创建。除了以下描述之外，一般背景信息请参见 [第 13.1.15 节，“CREATE INDEX 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-index.html)， [第 13.1.20.5 节，“外键约束”](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html) 和 [第 13.1.20.6 节，“检查约束”](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html)。

- `CONSTRAINT symbol`

  可以给定  `CONSTRAINT symbol` 子句来**命名一个约束** 。如果没有给出子句，或者 `CONSTRAINT` 关键字后面没有包含 *`symbol`*，MySQL 会自动生成一个约束名称，但下面会提到例外情况。如果使用 *`symbol`* 值，则该值对于每个模式（数据库）、每个约束类型必须是唯一的。重复 *`symbol`* 导致错误。另请参阅[第 9.2.1 节“标识符长度限制”](https://dev.mysql.com/doc/refman/8.0/en/identifier-length.html)中有关生成的约束标识符的长度限制的讨论。

  > 如果没有在外键定义中给出 `CONSTRAINT symbol` 子句，或者 `CONSTRAINT` 关键字后面没有包含 *`symbol`*，则 MySQL 使用外键索引名称最高到 MySQL 8.0.15，在此后自动生成约束名称。

  SQL 标准规定所有类型的约束（主键、唯一索引、外键、检查）属于同一个命名空间。在 MySQL 中，**每个模式的每种约束类型都有自己的命名空间**。因此，对于每个模式的每种类型的约束的名称必须是唯一的，但不同类型的约束可以具有相同的名称。

- `PRIMARY KEY`

  唯一的索引，其中所有键列必须定义为 `NOT NULL`。如果它们没有显式声明为 `NOT NULL`，MySQL 会隐含地（并且默默地）声明它们。一张表只能有一个 `PRIMARY KEY`。`PRIMARY KEY` 的名称总是`PRIMARY`，因此不能用作任何其他类型索引的名称。

  如果您没有 `PRIMARY KEY` 并且应用程序在您的表中请求 `PRIMARY KEY`， MySQL 将返回第一个没有`NULL`列的 `UNIQUE` 索引作为 `PRIMARY KEY`。

  在 `InnoDB` 表中，保持`PRIMARY KEY`短小以最小化二级索引的存储开销。每个二级索引条目都包含对应行的主键列的副本。（请参阅 [第 15.6.2.1 节，“聚集索引和二级索引”](https://dev.mysql.com/doc/refman/8.0/en/innodb-index-types.html)。）

  在创建的表中，首先放置 `PRIMARY KEY`，然后是所有 `UNIQUE` 索引，然后是非唯一索引。这有助于 MySQL 优化器确定要使用的索引的优先级，并更快地检测重复 `UNIQUE` 键。

  `PRIMARY KEY` 可以是多列索引。但是，您不能使用列规范中的 `PRIMARY KEY`  key 属性创建多列索引。这样做只会将该单列标记为主列。您必须使用单独的 `PRIMARY KEY(key_part, ...)` 子句。

  如果表有一个 `PRIMARY KEY` 或 `UNIQUE NOT NULL` 索引，该索引由单个整数类型的列组成，则可以使用 `_rowid` 来引用 [`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/select.html) 语句中的索引列，如 [唯一索引](https://dev.mysql.com/doc/refman/8.0/en/create-index.html#create-index-unique) 中所述。

  在 MySQL 中，`PRIMARY KEY` 的名称是 `PRIMARY`。 对于其他索引，如果不指定名称，则为索引指定与第一个索引列相同的名称，并带有可选的后缀 ( `_2`, `_3`, `...`) 以使其唯一。您可以使用 `SHOW INDEX FROM tbl_name` 查看表的索引名称。请参阅 [第 13.7.7.22 节，“SHOW INDEX 语句”](https://dev.mysql.com/doc/refman/8.0/en/show-index.html)。

- `KEY | INDEX`

  `KEY` 通常是 `INDEX` 的同义词。在列定义中指定 `PRIMARY KEY` key 属性时，也可以仅将其指定为 `KEY`。这是为了与其他数据库系统兼容而实现的。

- `UNIQUE`

  `UNIQUE` 索引创建一个约束，使得索引中的所有值都必须是不同的。如果您尝试使用与现有行匹配的键值添加新行，则会发生错误。对于所有引擎，`UNIQUE` 索引允许包含 `NULL` 的列有多个`NULL`值。如果为 `UNIQUE` 索引中的列指定前缀值，则列值在前缀长度内必须是唯一的。

  如果表有一个 `PRIMARY KEY` 或 `UNIQUE NOT NULL` 索引，该索引由单个整数类型的列组成，则可以使用 `_rowid` 来引用 [`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/select.html) 语句中的索引列，如 [唯一索引](https://dev.mysql.com/doc/refman/8.0/en/create-index.html#create-index-unique) 中所述。

- `FULLTEXT`

  `FULLTEXT`索引是用于全文搜索的一种特殊类型的索引 。只有 [`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html) 和 [`MyISAM`](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html) 存储引擎支持 `FULLTEXT` 索引。它们只能从[`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html) 和 [`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 列中创建。索引总是发生在整个列上；不支持列前缀索引，如果指定，任何前缀长度都将被忽略。有关操作的详细信息，请参见 [第 12.10 节，“全文搜索功能”](https://dev.mysql.com/doc/refman/8.0/en/fulltext-search.html)。 如果全文索引和搜索操作需要特殊处理，可以将 `WITH PARSER` 子句指定为 *`index_option`* 的值，以便将解析器插件与索引关联的值。该子句仅对 `FULLTEXT` 索引有效。 [`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html) 和 [`MyISAM`](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html)支持全文解析器插件。有关详细信息，请参阅 [全文解析器插件](https://dev.mysql.com/doc/extending-mysql/8.0/en/plugin-types.html#full-text-plugin-type) 和 [编写全文解析器插件](https://dev.mysql.com/doc/extending-mysql/8.0/en/writing-full-text-plugins.html)。

- `SPATIAL`

  您可以为空间数据类型创建 `SPATIAL` 索引。空间类型仅支持 `InnoDB` 和 `MyISAM` 表，索引列必须声明为 `NOT NULL`。请参见[第 11.4 节，“空间数据类型”](https://dev.mysql.com/doc/refman/8.0/en/spatial-types.html)。

- `FOREIGN KEY`

  MySQL 支持外键，让您可以跨表交叉引用相关数据，以及外键约束，这有助于保持分散数据的一致性。有关定义和选项信息，请参阅 [*`reference_definition`*](https://dev.mysql.com/doc/refman/8.0/en/create-table.html#create-table-reference-definition) 和 [*`reference_option`*](https://dev.mysql.com/doc/refman/8.0/en/create-table.html#create-table-reference-option)。

  使用 [`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html) 存储引擎的分区表不支持外键。有关详细信息，请参阅 [第 24.6 节，“分区的限制和限制”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-limitations.html)。

- `CHECK`

  `CHECK` 子句允许创建约束，以便检查表行中的数据值。请参阅 [第 13.1.20.6 节，“检查约束”](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html)。

- *`key_part`*

  - *`key_part`* 规范可以以 `ASC` 或 `DESC` 指定索引值是以升序还是降序存储。如果没有给出顺序说明符，则默认为升序。

  - 对于使用 `REDUNDANT` 或 `COMPACT` 行格式的 `InnoDB` 表， 由*`length`* 属性定义的前缀最长可达 767 个字节 。 对于使用 `DYNAMIC` 或 `COMPRESSED` 行格式的 `InnoDB` 表， 前缀长度限制为 3072 字节 。对于 `MyISAM` 表，前缀长度限制为 1000 字节。

    前缀*限制*以字节为单位。但是，[`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)、[`ALTER TABLE`](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html) 和 [`CREATE INDEX`](https://dev.mysql.com/doc/refman/8.0/en/create-index.html) 语句中的索引规范的前缀*长度*被解释为非二进制字符串类型（ [`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、[`TEXT`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) ）的字符数和二进制字符串类型（[`BINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html)、[`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html)、[`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html)） 的字节数。在为使用多字节字符集的非二进制字符串列指定前缀长度时，请考虑到这一点。

  - 从 MySQL 8.0.17 开始，*`key_part`*规范的 *`expr`* 可以采用 `(CAST json_path AS type ARRAY)` 的形式在 [`JSON`](https://dev.mysql.com/doc/refman/8.0/en/json.html) 列上创建多值索引 。 [多值索引](https://dev.mysql.com/doc/refman/8.0/en/create-index.html#create-index-multi-valued)，提供有关多值索引的创建、使用以及限制和限制的详细信息。

- *`index_type`*

  一些存储引擎允许您在创建索引时指定**索引类型**。*`index_type`* 说明符的语法是 `USING type_name`。

  示例：

  ```sql
  CREATE TABLE lookup
    (id INT, INDEX USING BTREE (id))
    ENGINE = MEMORY;
  ```

  `USING` 的首选位置是在索引列列表之后。它可以在列列表之前给出，但不赞成在该位置使用该选项的支持，预期它会在未来的 MySQL 版本中被删除。

- *`index_option`*

  *`index_option`* 值指定索引的**附加选项**。

  - `KEY_BLOCK_SIZE`

    对于[`MyISAM`](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html) 表， `KEY_BLOCK_SIZE`可以选择指定用于索引键块的大小，以字节为单位。该值被视为提示；如有必要，可以使用不同的尺寸。为单个索引定义指定的`KEY_BLOCK_SIZE`值会覆盖表级`KEY_BLOCK_SIZE`值。

    有关表级 `KEY_BLOCK_SIZE`属性的信息，请参阅 [表选项](https://dev.mysql.com/doc/refman/8.0/en/create-table.html#create-table-options)。

  - `WITH PARSER`

    `WITH PARSER` 选项只能与 `FULLTEXT` 索引一起使用。如果全文索引和搜索操作需要特殊处理，它将**解析器插件**与索引相关联。 [`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html) 和 [`MyISAM`](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html)支持全文解析器插件。如果您有一个带有关联全文解析器插件的 [`MyISAM`](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html) 表，您可以使用 `ALTER TABLE` 将表转换为`InnoDB`。

  - `COMMENT`

    索引定义可以包括最多 1024 个字符的可选**注释**。

    您可以使用 `index_option COMMENT` 子句设置 `InnoDB` `MERGE_THRESHOLD` 单个索引的值 。请参阅 [第 15.8.11 节，“为索引页配置合并阈值”](https://dev.mysql.com/doc/refman/8.0/en/index-page-merge-threshold.html)。

  - `VISIBLE`, `INVISIBLE`

    指定索引**可见性**。默认情况下，索引是可见的。优化器不使用不可见索引。索引可见性规范适用于除主键之外的索引（显式或隐式）。有关详细信息，请参阅[第 8.3.12 节，“不可见索引”](https://dev.mysql.com/doc/refman/8.0/en/invisible-indexes.html)。

  - `ENGINE_ATTRIBUTE` 和 `SECONDARY_ENGINE_ATTRIBUTE` 选项（自 MySQL 8.0.21 起可用）用于指定主存储引擎和辅助存储引擎的索引属性。这些选项保留供将来使用。

  有关允许 *`index_option`* 值的更多信息，请参阅 [第 13.1.15 节，“CREATE INDEX 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-index.html)。有关索引的更多信息，请参阅[第 8.3.1 节，“MySQL 如何使用索引”](https://dev.mysql.com/doc/refman/8.0/en/mysql-indexes.html)。

- `reference_definition`

  有关 *`reference_definition`* 语法详细信息和示例，请参阅 [第 13.1.20.5 节，“外键约束”](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html)。

  [`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html) 和 [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)表支持检查外键约束。被引用表的列必须始终显式命名。支持外键的 `ON DELETE` 和 `ON UPDATE` 操作。有关更多详细信息和示例，请参阅[第 13.1.20.5 节，“外键约束”](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html)。

  对于其他存储引擎，MySQL Server 会解析并忽略 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句中的 `FOREIGN KEY` 语法。

  > 对于熟悉 ANSI/ISO SQL 标准的用户，请注意，没有存储引擎，包括 `InnoDB`，识别或强制执行引用完整性约束定义中使用的  `MATCH` 子句。使用显式 `MATCH` 子句没有指定的效果，也会导致`ON DELETE`和 `ON UPDATE`子句被忽略。由于这些原因，应避免指定 `MATCH`。
>
  > SQL 标准中的 `MATCH` 子句控制在与主键比较时如何处理复合（多列）外键中的 `NULL` 值。`InnoDB`本质上实现了 `MATCH SIMPLE` 定义的语义，允许外键全部或部分是 `NULL`。在这种情况下，允许插入包含此类外键的（子表）行，并且与引用的（父）表中的任何行都不匹配。可以使用触发器实现其他语义。
>
  > 此外，MySQL 要求对被引用的列进行索引以提高性能。但是，`InnoDB` 不强制要求被引用的列声明为 `UNIQUE` 或 `NOT NULL`。对非唯一键或包含`NULL` 值的键的外键引用的处理对于诸如 `UPDATE` 或 `DELETE CASCADE` 之类的操作没有明确定义。建议您使用仅引用`UNIQUE` (或 `PRIMARY`) 和`NOT NULL` 键的外键。
>
  > MySQL 解析但忽略“内联 `REFERENCES`规范”（如 SQL 标准中所定义），其中引用被定义为列规范的一部分。MySQL `REFERENCES`仅在指定为单独`FOREIGN KEY` 规范的一部分时才接受子句。有关详细信息，请参阅 [第 1.7.2.3 节，“外键约束差异”](https://dev.mysql.com/doc/refman/8.0/en/ansi-diff-foreign-keys.html)。

- `reference_option`

  有关 `RESTRICT`、 `CASCADE`、`SET NULL`、 `NO ACTION` 和 `SET DEFAULT` 选项的信息，请参阅 [第 13.1.20.5 节，“外键约束”](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html)。

#### 表选项

表选项用于**优化表的行为**。在大多数情况下，您不必指定其中任何一个。除非另有说明，否则这些选项适用于所有存储引擎。不适用于给定存储引擎的选项可以作为表定义的一部分被接受和记住。如果您稍后使用 [`ALTER TABLE`](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html) 将表转换为使用不同的存储引擎，则此类选项将适用。

- `ENGINE`

  使用下表中显示的名称之一指定表的**存储引擎**。引擎名称可以不加引号，也可以加引号。被引用的名称 `'DEFAULT'` 会被识别，但同时会被忽略。

  | 存储引擎                                                     | 描述                                                         |
  | :----------------------------------------------------------- | :----------------------------------------------------------- |
  | `InnoDB`                                                     | 具有行锁定和外键的事务安全表。新表的默认存储引擎。如果您有 MySQL 经验，但不熟悉`InnoDB`，请参阅[第15章，InnoDB存储引擎](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html)，特别是[第15.1节，“InnoDB简介” ](https://dev.mysql.com/doc/refman/8.0/en/innodb-introduction.html)。 |
  | `MyISAM`                                                     | 二进制可移植存储引擎，主要用于只读或以读取为主的工作负载。请参阅 [第 16.2 节，“MyISAM 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html)。 |
  | `MEMORY`                                                     | 此存储引擎的数据仅存储在内存中。请参阅 [第 16.3 节，“MEMORY 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/memory-storage-engine.html)。 |
  | `CSV`                                                        | 以逗号分隔值格式存储行的表。请参阅 [第 16.4 节，“CSV 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/csv-storage-engine.html)。 |
  | `ARCHIVE`                                                    | 归档存储引擎。请参见 [第 16.5 节，“ARCHIVE 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/archive-storage-engine.html)。 |
  | `EXAMPLE`                                                    | 一个示例引擎。请参见[第 16.9 节，“示例存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/example-storage-engine.html)。 |
  | `FEDERATED`                                                  | 访问远程表的存储引擎。请参阅 [第 16.8 节，“联合存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/federated-storage-engine.html)。 |
  | `HEAP`                                                       | 这是 `MEMORY` 的同义词。                                     |
  | `MERGE`                                                      | 作为一个表使用的 `MyISAM` 表的集合。也称为`MRG_MyISAM`. 请参阅 [第 16.7 节，“MERGE 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/merge-storage-engine.html)。 |
  | [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) | 集群、容错、基于内存的表，支持事务和外键。也称为 [`NDBCLUSTER`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html). 请参阅 [第 23 章，*MySQL NDB Cluster 8.0*](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)。 |



  默认情况下，如果指定的存储引擎不可用，则语句将失败并出现错误。您可以通过从服务器 SQL 模式中删除 [`NO_ENGINE_SUBSTITUTION`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_engine_substitution) 来覆盖此行为 （请参阅[第 5.1.11 节，“服务器 SQL 模式”](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)），以便 MySQL 允许用默认存储引擎替换指定的引擎。通常在这种情况下，是`InnoDB`，这是[`default_storage_engine`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_storage_engine) 系统变量的默认值。禁用 `NO_ENGINE_SUBSTITUTION` 时，如果不遵守存储引擎规范，则会出现警告。

- `AUTOEXTEND_SIZE`

  定义当表空间变满时 `InnoDB` 扩展表空间大小的量。在 MySQL 8.0.23 中引入。该设置必须是 4MB 的倍数。默认设置为 0，这会导致表空间根据隐式默认行为进行扩展。有关更多信息，请参阅 [第 15.6.3.9 节，“表空间 AUTOEXTEND_SIZE 配置”](https://dev.mysql.com/doc/refman/8.0/en/innodb-tablespace-autoextend-size.html)。

- `AUTO_INCREMENT`

  表的初始`AUTO_INCREMENT`值。在 MySQL 8.0 中，这适用于 `InnoDB`、`MyISAM`、`MEMORY` 和 `ARCHIVE` 表。要为不支持`AUTO_INCREMENT` 表选项的引擎设置第一个自增值，请在创建表后插入一个值比期望值小 1 的“ dummy ”行，然后删除 dummy 行。

  对于支持 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句中的 `AUTO_INCREMENT` 表选项的引擎，您还可以使用 `ALTER TABLE tbl_name AUTO_INCREMENT = N` 重置 `AUTO_INCREMENT` 值。该值不能设置为低于列中当前的最大值。

- `AVG_ROW_LENGTH`

  表的平均行长度的近似值。您只需为具有可变大小行的大型表设置此项。

  创建 `MyISAM` 表时，MySQL 使用 `MAX_ROWS` 和 `AVG_ROW_LENGTH` 选项的乘积来决定生成的表有多大。如果您不指定任一选项，则`MyISAM` 数据和索引文件的最大大小默认为 256TB。（如果您的操作系统不支持那么大的文件，则表大小受文件大小限制。）如果您想降低指针大小以使索引更小更快，并且您并不真的需要大文件，您可以通过设置[`myisam_data_pointer_size`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_myisam_data_pointer_size) 系统变量来减小默认指针大小 （参见 [第 5.1.8 节，“服务器系统变量”](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html))。 如果您希望所有表都能够增长到默认限制之上，并且愿意让您的表稍微慢一些并且比必要的大，您可以通过设置此变量来增加默认指针大小。将该值设置为 7 允许表大小最大为 65,536TB。

- `[DEFAULT] CHARACTER SET`

  指定表的默认字符集。 `CHARSET`是 `CHARACTER SET` 的同义词。如果字符集名称为 `DEFAULT`，则使用数据库字符集。

- `CHECKSUM`

  如果您希望 MySQL 为所有行维护实时校验和（即 MySQL 在表更改时自动更新的校验和），请将其设置为 1。这使得表更新速度有点慢，但也更容易找到损坏的表。[`CHECKSUM TABLE`](https://dev.mysql.com/doc/refman/8.0/en/checksum-table.html)语句报告校验和。（仅限 `MyISAM`。）

- `[DEFAULT] COLLATE`

  指定表的默认排序规则。

- `COMMENT`

  表的注释，最多 2048 个字符。

  您可以使用  *`table_option`* `COMMENT` 子句设置表的 `InnoDB` `MERGE_THRESHOLD` 值。请参阅 [第 15.8.11 节，“为索引页配置合并阈值”](https://dev.mysql.com/doc/refman/8.0/en/index-page-merge-threshold.html)。

  **设置 NDB_TABLE 选项。** 创建 `NDB` 表的 `CREATE TABLE` 语句中的表注释，或更改 `NDB` 表的 [`ALTER TABLE`](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html) 语句中的表注释，也可用于指定一到四个 `NDB_TABLE` 选项 `NOLOGGING`, `READ_BACKUP`, `PARTITION_BALANCE`, 或 `FULLY_REPLICATED`作为一组名-值对，如果需要，用逗号分隔，紧跟在字符串 `NDB_TABLE=` 之后，以引用的注释文本开头的。此处显示了使用此语法的示例语句（强调文本）：

  ```sql
  CREATE TABLE t1 (
      c1 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      c2 VARCHAR(100),
      c3 VARCHAR(100) )
  ENGINE=NDB
  COMMENT="NDB_TABLE=READ_BACKUP=0,PARTITION_BALANCE=FOR_RP_BY_NODE";
  ```

  带引号的字符串中不允许有空格。字符串不区分大小写。

  注释显示为 [`SHOW CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html) 的输出的一部分。注释的文本也可用作 MySQL 信息模式 [`TABLES`](https://dev.mysql.com/doc/refman/8.0/en/information-schema-tables-table.html) 表的 TABLE_COMMENT 列。

  `NDB` 表的 [`ALTER TABLE`](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html) 语句也支持此注释语法。请记住，与 `ALTER TABLE` 一起使用的表注释会替换该表以前可能具有的任何现有注释。

  [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 表不支持在表注释中设置 `MERGE_THRESHOLD` 选项（它被忽略）。

  有关完整的语法信息和示例，请参阅 [第 13.1.20.11 节，“设置 NDB 注释选项”](https://dev.mysql.com/doc/refman/8.0/en/create-table-ndb-comment-options.html)。

- `COMPRESSION`

  用于 `InnoDB` 表的页级压缩的压缩算法。支持的值包括 `Zlib`、`LZ4`和 `None`。`COMPRESSION` 属性是通过透明页面压缩特性引入的。页面压缩仅支持驻留在 [file-per-table](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_file_per_table) 表空间中的 `InnoDB` 表，并且仅在支持稀疏文件和穿孔的 Linux 和 Windows 平台上可用。有关更多信息，请参阅 [第 15.9.2 节，“InnoDB 页面压缩”](https://dev.mysql.com/doc/refman/8.0/en/innodb-page-compression.html)。

- `CONNECTION`

  `FEDERATED` 表的连接字符串 。

  > 旧版本的 MySQL 对连接字符串使用了 `COMMENT` 选项。

- `DATA DIRECTORY`, `INDEX DIRECTORY`

  对于`InnoDB`，`DATA DIRECTORY='directory'` 子句允许在数据目录之外创建表。必须启用 [`innodb_file_per_table`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_file_per_table) 变量才能使用 `DATA DIRECTORY` 子句。必须指定完整的目录路径。从 MySQL 8.0.21 开始，指定的目录必须是 `InnoDB` 知道的。 有关更多信息，请参阅 [第 15.6.1.2 节，“在外部创建表”](https://dev.mysql.com/doc/refman/8.0/en/innodb-create-table-external.html)。

  创建`MyISAM`表时，可以使用 `DATA DIRECTORY='directory'` 子句、 `INDEX DIRECTORY='directory'` 子句，或两者都使用。它们分别指定 `MyISAM` 表的数据文件和索引文件的放置位置。与 `InnoDB` 表不同，MySQL 在使用 `DATA DIRECTORY` 或 `INDEX DIRECTORY` 选项创建 `MyISAM` 表时不会创建与数据库名称对应的子目录。在指定的目录中创建文件。

  您必须有 [`FILE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_file) 权限才能使用 `DATA DIRECTORY` 或 `INDEX DIRECTORY`table 选项。

  > 对于分区表，表级`DATA DIRECTORY`和 `INDEX DIRECTORY`选项将被忽略。（错误 #32091）

  这些选项仅在您不使用 [`--skip-symbolic-links`](https://dev.mysql.com/doc/refman/8.0/en/server-options.html#option_mysqld_symbolic-links) 选项时才有效。您的操作系统还必须有一个有效的、线程安全的 `realpath()` 调用。有关更完整的信息， 请参阅 [第 8.12.2.2 节，“在 Unix 上为 MyISAM 表使用符号链接” 。](https://dev.mysql.com/doc/refman/8.0/en/symbolic-links-to-tables.html)

  如果`MyISAM`在没有 `DATA DIRECTORY` 选项的情况下创建表，则在数据库目录中创建 `.MYD` 文件。默认情况下，如果在这种情况下`MyISAM`找到现有`.MYD`文件，则会覆盖它。这同样适用于没有 `INDEX DIRECTORY` 选项创建的表的 `.MYI` 文件。要抑制此行为，请使用 [`--keep_files_on_create`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_keep_files_on_create) 选项启动服务器，在这种情况下 `MyISAM` 不会覆盖现有文件，并会返回错误。

  如果使用 `DATA DIRECTORY` 或 `INDEX DIRECTORY` 选项创建 `MyISAM` 表，并找到现有的 `.MYD` 或 `.MYI` 文件，则 `MyISAM` 始终返回错误，并且不会覆盖指定目录中的文件。

  > 您不能将包含 MySQL 数据目录的路径名与`DATA DIRECTORY`或 `INDEX DIRECTORY` 一起使用。这包括分区表和单个表分区。（参见错误 #32167。）

- `DELAY_KEY_WRITE`

  如果您想延迟表的键更新直到表关闭，请将此设置为 1。请参阅[第 5.1.8 节，“服务器系统变量”](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html) 中对 [`delay_key_write`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_delay_key_write) 系统变量的描述 （仅限 `MyISAM`）。

- `ENCRYPTION`

  `ENCRYPTION` 子句启用或禁用 `InnoDB` 表的**页级数据加密** 。必须先安装和配置密钥环插件，然后才能启用加密。在 MySQL 8.0.16 之前， 只能在 file-per-table 表空间中创建表时指定 `ENCRYPTION` 子句。从 MySQL 8.0.16 开始，也可以在通用表空间中创建表时指定 `ENCRYPTION` 子句。

  从 MySQL 8.0.16 开始，如果未指定 `ENCRYPTION` 子句 ，表将**继承默认模式加密**。如果启用了 [`table_encryption_privilege_check`](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_table_encryption_privilege_check) 变量， 则需要 [`TABLE_ENCRYPTION_ADMIN`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_table-encryption-admin) 权限来创建具有与默认模式加密不同的 `ENCRYPTION` 子句设置的表。在通用表空间中创建表时，表和表空间加密必须匹配。

  从 MySQL 8.0.16 开始， 在使用不支持加密的存储引擎时，不允许指定具有除  `'N'` 或 `''` 以外的值的 `ENCRYPTION` 子句 。此前，该条款被接受。

  有关更多信息，请参阅 [第 15.13 节，“InnoDB 静态数据加密”](https://dev.mysql.com/doc/refman/8.0/en/innodb-data-encryption.html)。

- `ENGINE_ATTRIBUTE`和 `SECONDARY_ENGINE_ATTRIBUTE`选项（自 MySQL 8.0.21 起可用）用于指定主存储引擎和辅助存储引擎的表属性。这些选项保留供将来使用。

  允许的值是包含有效 `JSON`文档或空字符串 ('') 的字符串文字。无效`JSON`被拒绝。

  ```sql
  CREATE TABLE t1 (c1 INT) ENGINE_ATTRIBUTE='{"key":"value"}';
  ```

  `ENGINE_ATTRIBUTE` 和 `SECONDARY_ENGINE_ATTRIBUTE` 值可以重复，不会报错。在这种情况下，使用最后指定的值。

  服务器不会检查 `ENGINE_ATTRIBUTE` 和 `SECONDARY_ENGINE_ATTRIBUTE` 值，也不会在更改表的存储引擎时清除它们。

- `INSERT_METHOD`

  如果要向 `MERGE` 表中插入数据 ，则必须使用 `INSERT_METHOD` 指定应插入行的表。 `INSERT_METHOD` 是一个仅对 `MERGE` 表有用的选项 。使用 `FIRST`或 `LAST` 的值可以让插入转到第一个或最后一个表，或者使用 `NO` 的值来阻止插入。请参阅 [第 16.7 节，“MERGE 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/merge-storage-engine.html)。

- `KEY_BLOCK_SIZE`

  对于[`MyISAM`](https://dev.mysql.com/doc/refman/8.0/en/myisam-storage-engine.html)表， `KEY_BLOCK_SIZE`可以选择指定用于索引键块的大小（以字节为单位）。该值被视为提示；如有必要，可以使用不同的尺寸。为单个索引定义指定的`KEY_BLOCK_SIZE`值会覆盖表级 `KEY_BLOCK_SIZE`值。

  对于[`InnoDB`](https://dev.mysql.com/doc/refman/8.0/en/innodb-storage-engine.html)表， `KEY_BLOCK_SIZE`指定 用于[压缩表的](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_compression)[页面](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_page)大小（以千字节为单位） 。该 值被视为提示；如有必要，可以使用不同的尺寸。只能小于或等于该 值。值 0 表示默认的压缩页面大小，是该 值的一半。根据 ，可能的 值包括 0、1、2、4、8 和 16。有关更多信息，请参阅[第 15.9.1 节，“InnoDB 表压缩”](https://dev.mysql.com/doc/refman/8.0/en/innodb-table-compression.html)。 `InnoDB``KEY_BLOCK_SIZE``InnoDB``KEY_BLOCK_SIZE`[`innodb_page_size`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_page_size)[`innodb_page_size`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_page_size)[`innodb_page_size`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_page_size)`KEY_BLOCK_SIZE`

  Oracle 建议 在为 表[`innodb_strict_mode`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_strict_mode)指定时启用。启用时 ，指定无效 值会返回错误。如果 禁用，则无效值会导致警告，并 忽略该选项。 `KEY_BLOCK_SIZE``InnoDB`[`innodb_strict_mode`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_strict_mode)`KEY_BLOCK_SIZE`[`innodb_strict_mode`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_strict_mode)`KEY_BLOCK_SIZE``KEY_BLOCK_SIZE`

  `Create_options`响应列 报告表[`SHOW TABLE STATUS`](https://dev.mysql.com/doc/refman/8.0/en/show-table-status.html)的实际`KEY_BLOCK_SIZE`使用情况，如[`SHOW CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html).

  `InnoDB`仅支持 `KEY_BLOCK_SIZE`表级别。

  `KEY_BLOCK_SIZE`不支持 32KB 和 64KB[`innodb_page_size`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_page_size) 值。`InnoDB`表压缩不支持这些页面大小。

  `InnoDB``KEY_BLOCK_SIZE`创建临时表时 不支持该 选项。

- `MAX_ROWS`

  您**计划在表中存储的最大行数**。这不是硬性限制，而是对存储引擎的提示，即表必须能够存储至少这么多行。

  > 不推荐在 `NDB` 表中使用 `MAX_ROWS` 来控制表分区的数量。它在以后的版本中仍然受支持以实现向后兼容性，但在未来的版本中可能会被删除。请改用 PARTITION_BALANCE；请参阅 [设置 NDB_TABLE 选项](https://dev.mysql.com/doc/refman/8.0/en/create-table.html#create-table-comment-ndb-table-options)。

  [`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)存储引擎将此值视为最大值 。如果您计划创建非常大的 NDB Cluster 表（包含数百万行），则应使用此选项，通过设置 `MAX_ROWS = 2 * rows` 来确保[`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html) 在哈希表中分配足够数量的索引槽，用于存储表的主键的哈希值，其中 *`rows`* 是您希望插入到表中的行数。

  `MAX_ROWS` 最大值为 4294967295；较大的值将被截断到此限制。

- `MIN_ROWS`

  您计划在表中存储的最小行数。[`MEMORY`](https://dev.mysql.com/doc/refman/8.0/en/memory-storage-engine.html)存储引擎使用此选项作为有关内存使用的提示 。

- `PACK_KEYS`

  仅对`MyISAM`表生效。如果您想拥有更小的索引，请将此选项设置为 1。这通常会使更新速度变慢，读取速度更快。将该选项设置为 0 将禁用所有密钥打包。将其设置为 `DEFAULT`告诉存储引擎仅打包 long [`CHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`VARCHAR`](https://dev.mysql.com/doc/refman/8.0/en/char.html)、 [`BINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html)或 [`VARBINARY`](https://dev.mysql.com/doc/refman/8.0/en/binary-varbinary.html)列。

  如果不使用`PACK_KEYS`，则默认打包字符串，但不打包数字。如果你使用 `PACK_KEYS=1`，数字也会被打包。

  在打包二进制数字键时，MySQL 使用前缀压缩：

  - 每个键都需要一个额外的字节来表示前一个键的多少字节与下一个键相同。
  - 指向行的指针以高字节优先顺序存储在键之后，以提高压缩率。

  这意味着如果你在两个连续的行上有许多相等的键，那么所有后面的“相同”键通常只占用两个字节（包括指向行的指针）。将此与以下键采用的普通情况 `storage_size_for_key + pointer_size`（指针大小通常为 4）进行比较。相反，只有当您有许多相同的数字时，您才能从前缀压缩中获得显着的好处。如果所有键都完全不同，则每个键多使用一个字节，如果键不是可以具有`NULL`值的键。（在这种情况下，打包的密钥长度存储在用于标记密钥是否为 的同一字节中`NULL`。）

- `PASSWORD`

  此选项未使用。

- `ROW_FORMAT`

  定义存储行的**物理格式**。

  创建禁用[严格模式](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_strict_mode)的表时，如果不支持指定的行格式，则使用存储引擎的默认行格式。表的实际行格式在响应[`SHOW TABLE STATUS`](https://dev.mysql.com/doc/refman/8.0/en/show-table-status.html) 的 `Row_format` 列中报告。`Create_options` 列显示了在 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)中语句指定的行格式 ，如 [`SHOW CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html)。

  行格式选择因表使用的存储引擎而异。

  对于 `InnoDB` 表：

  - 默认行格式由 [`innodb_default_row_format`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_default_row_format) 定义，其默认设置为`DYNAMIC`。未定义 `ROW_FORMAT` 选项，或使用了`ROW_FORMAT=DEFAULT` 时，使用默认行格式 。

    如果未定义 `ROW_FORMAT` 或使用了 `ROW_FORMAT=DEFAULT` 选项，则重建表的操作也会默默地将表的行格式更改为 [`innodb_default_row_format`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_default_row_format)。有关详细信息，请参阅 [定义表的行格式](https://dev.mysql.com/doc/refman/8.0/en/innodb-row-format.html#innodb-row-format-defining)。

  - 要更有效地`InnoDB`存储数据类型，尤其是[`BLOB`](https://dev.mysql.com/doc/refman/8.0/en/blob.html) 类型，请使用`DYNAMIC`。有关与 `DYNAMIC` 行格式相关的要求， 请参阅 [动态行格式](https://dev.mysql.com/doc/refman/8.0/en/innodb-row-format.html#innodb-row-format-dynamic)。

  - 要为 `InnoDB` 表启用压缩 ，请指定 `ROW_FORMAT=COMPRESSED`。创建临时表时不支持 `ROW_FORMAT=COMPRESSED` 选项。有关与 `COMPRESSED` 行格式相关的要求，请参阅 [第 15.9 节，“InnoDB 表和页面压缩” 。](https://dev.mysql.com/doc/refman/8.0/en/innodb-compression.html)

  - 旧版本 MySQL 中使用的行格式仍然可以通过指定 `REDUNDANT` 行格式来请求。

  - 当您指定非默认 `ROW_FORMAT`子句时，请考虑启用 [`innodb_strict_mode`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_strict_mode) 配置选项。

  - 不支持 `ROW_FORMAT=FIXED`。如果在禁用 [`innodb_strict_mode`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_strict_mode) 时指定 `ROW_FORMAT=FIXED`， 则 `InnoDB` 发出警告并假定 `ROW_FORMAT=DYNAMIC`。 如果在启用 [`innodb_strict_mode`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_strict_mode) 时，这默认设置，指定 `ROW_FORMAT=FIXED`，则 `InnoDB` 返回错误。

  - 有关`InnoDB` 行格式的更多信息，请参阅[第 15.10 节，“InnoDB 行格式”](https://dev.mysql.com/doc/refman/8.0/en/innodb-row-format.html)。

  对于`MyISAM`表，选项值可以是 `FIXED` 或 `DYNAMIC` 用于静态或可变长度行格式。 [**myisampack**](https://dev.mysql.com/doc/refman/8.0/en/myisampack.html) 将类型设置为 `COMPRESSED`。请参阅 [第 16.2.3 节，“MyISAM 表存储格式”](https://dev.mysql.com/doc/refman/8.0/en/myisam-table-formats.html)。

  对于[`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)表，默认 `ROW_FORMAT`值为`DYNAMIC`。

- `STATS_AUTO_RECALC`

  指定是否自动重新计算 `InnoDB` 表的[持久统计信息](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_persistent_statistics)。`DEFAULT` 值导致表的持久统计信息设置由 [`innodb_stats_auto_recalc`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_stats_auto_recalc) 配置选项确定。当表中 10% 的数据发生更改时，值`1`会导致重新计算统计信息。值`0`防止自动重新计算此表；使用此设置，在对表进行重大更改后发出一条 [`ANALYZE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/analyze-table.html) 语句以重新计算统计信息。有关持久统计功能的更多信息，请参阅 [第 15.8.10.1 节，“配置持久优化器统计参数”](https://dev.mysql.com/doc/refman/8.0/en/innodb-persistent-stats.html)。

- `STATS_PERSISTENT`

  指定是否为 `InnoDB` 表启用[持久统计](https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_persistent_statistics)。`DEFAULT` 值导致表的持久统计信息设置由 [`innodb_stats_persistent`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_stats_persistent) 配置选项确定。值`1`启用表的持久统计信息，而值 `0`关闭此功能。通过`CREATE TABLE` 或 `ALTER TABLE` 语句启用持久统计后，在将代表性数据加载到表中后，发出一条[`ANALYZE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/analyze-table.html) 语句来计算统计信息。有关持久统计功能的更多信息，请参阅 [第 15.8.10.1 节，“配置持久优化器统计参数”](https://dev.mysql.com/doc/refman/8.0/en/innodb-persistent-stats.html)。

- `STATS_SAMPLE_PAGES`

  在估计索引列的基数和其他统计信息时要采样的索引页数，比如由[`ANALYZE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/analyze-table.html) 计算的数据。 有关更多信息，请参阅 [第 15.8.10.1 节，“配置持久优化器统计参数”](https://dev.mysql.com/doc/refman/8.0/en/innodb-persistent-stats.html)。

- `TABLESPACE`

  `TABLESPACE` 子句可用于在现有的通用表空间、file-per-table 表空间或系统表空间中创建表。

  ```sql
  CREATE TABLE tbl_name ... TABLESPACE [=] tablespace_name
  ```

  在使用 `TABLESPACE` 子句之前，您指定的通用表空间必须存在。有关通用表空间的信息，请参阅 [第 15.6.3.3 节，“通用表空间”](https://dev.mysql.com/doc/refman/8.0/en/general-tablespaces.html)。

  *`tablespace_name`* 是区分大小写的标识符 。 它可以被引用或不被引用。不允许使用正斜杠字符 ( “ / ” )。以“`innodb_`”开头的名称保留用于特殊用途。

  要在系统表空间中创建表，请指定 `innodb_system` 为表空间名称。

  ```sql
  CREATE TABLE tbl_name ... TABLESPACE [=] innodb_system
  ```

  使用`TABLESPACE [=] innodb_system`，您可以在系统表空间中放置任何未压缩行格式的表，而不管 [`innodb_file_per_table`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_file_per_table) 设置如何。比如，您可以使用 `TABLESPACE [=] innodb_system` 向系统表空间添加一个 `ROW_FORMAT=DYNAMIC` 的表。

  要在 file-per-table 表空间中创建表，请指定 `innodb_file_per_table` 为表空间名称。

  ```sql
  CREATE TABLE tbl_name ... TABLESPACE [=] innodb_file_per_table
  ```

  > 如果启用 [`innodb_file_per_table`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_file_per_table)，则无需指定 `TABLESPACE=innodb_file_per_table`创建一个`InnoDB`file-per-table 表空间。启用 [`innodb_file_per_table`](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html#sysvar_innodb_file_per_table) 时，`InnoDB` 表默认在每表文件表空间中创建 。

  `DATA DIRECTORY` 子句允许与 `CREATE TABLE ... TABLESPACE=innodb_file_per_table` 子句结合使用，但不支持与 `TABLESPACE` 子句结合使用。从 MySQL 8.0.21 开始，`DATA DIRECTORY` 子句中指定的目录必须为`InnoDB` 所知。有关详细信息，请参阅 [使用 DATA DIRECTORY 子句](https://dev.mysql.com/doc/refman/8.0/en/innodb-create-table-external.html#innodb-create-table-external-data-directory)。

  > 自 MySQL 8.0.13 起，不赞成使用 [`CREATE TEMPORARY TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 支持`TABLESPACE = innodb_file_per_table` 和`TABLESPACE = innodb_temporary`子句；因为预期它会在 MySQL 的未来版本中被删除。

  `STORAGE` 表选项仅用于[`NDB`](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster.html)表 。`STORAGE`确定使用的存储类型（磁盘或内存），可以是`DISK`或 `MEMORY`。

  `TABLESPACE ... STORAGE DISK`将表分配给 NDB Cluster 磁盘数据表空间。表空间必须已经使用[`CREATE TABLESPACE`](https://dev.mysql.com/doc/refman/8.0/en/create-tablespace.html) 创建。有关更多信息，请参阅 [第 23.6.10 节，“NDB Cluster 磁盘数据表”](https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster-disk-data.html)。

  > `STORAGE` 子句不能在没有 `TABLESPACE` 子句的 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 语句中使用。

- [`UNION`](https://dev.mysql.com/doc/refman/8.0/en/union.html)

  用于访问一组相同的 `MyISAM` 表作为一个。这仅适用于 `MERGE` 表格。请参阅 [第 16.7 节，“MERGE 存储引擎”](https://dev.mysql.com/doc/refman/8.0/en/merge-storage-engine.html)。

  对于映射到 `MERGE` 表的表， 您必须具有[`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_select)、 [`UPDATE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_update)和  [`DELETE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_delete) 权限。

  > 以前，所有使用的表都必须与`MERGE`表本身位于同一数据库中。此限制不再适用。

#### 表分区

*`partition_options`* 可用于控制使用 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 创建的表的分区。

并非本节开头的 *`partition_options`* 语法中显示的所有选项都可用于所有分区类型。有关每种类型的特定信息，请参阅以下各个类型的列表，并参阅[第 24 章，*分区*](https://dev.mysql.com/doc/refman/8.0/en/partitioning.html)，了解有关 MySQL 中分区的工作和使用的更完整信息，以及表创建和其他相关语句的其他示例到 MySQL 分区。

可以修改、合并、添加到表以及从表中删除分区。有关完成这些任务的 MySQL 语句的基本信息，请参阅[第 13.1.9 节，“ALTER TABLE 语句”](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html)。有关更详细的描述和示例，请参阅 [第 24.3 节，“分区管理”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-management.html)。

- `PARTITION BY`

  如果使用，*`partition_options`*子句以 `PARTITION BY` 开头。该子句包含用于确定分区的函数；该函数返回一个从 1 到 *`num`* 的整数值 ，其中 *`num`*是分区数。（表可能包含的用户定义分区的最大数量为 1024；本节稍后讨论的子分区的数量包含在此最大值中。）

  > 子句中使用的表达式 ( *`expr`*) `PARTITION BY`不能引用不在正在创建的表中的任何列；此类引用是明确不允许的，并导致语句失败并出现错误。（错误 #29444）

- `HASH(expr)`

  散列一个或多个列以创建用于放置和定位行的键。*`expr`*是使用一个或多个表列的表达式。这可以是产生单个整数值的任何有效 MySQL 表达式（包括 MySQL 函数）。比如，这些都是使用 `PARTITION BY HASH` 的有效 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)语句：

  ```sql
  CREATE TABLE t1 (col1 INT, col2 CHAR(5))
      PARTITION BY HASH(col1);

  CREATE TABLE t1 (col1 INT, col2 CHAR(5), col3 DATETIME)
      PARTITION BY HASH ( YEAR(col3) );
  ```

  您不能将`VALUES LESS THAN` 或 `VALUES IN`子句与 `PARTITION BY HASH` 一起使用。

  `PARTITION BY HASH`使用 *`expr`* 除以分区数的余数（即模数）。有关示例和其他信息，请参阅[第 24.2.4 节，“HASH 分区”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-hash.html)。

  `LINEAR`关键字需要一个稍微不同的算法 。在这种情况下，存储行的分区的数量是作为一个或多个逻辑[`AND`](https://dev.mysql.com/doc/refman/8.0/en/logical-operators.html#operator_and)运算的结果来计算的。有关线性哈希的讨论和示例，请参阅 [第 24.2.4.1 节，“线性哈希分区”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-linear-hash.html)。

- `KEY(column_list)`

  这与 `HASH` 类似，只是 MySQL 提供了散列函数以保证数据分布均匀。*`column_list`* 参数只是一个包含 1 个或多个表列的列表（最大：16）。此示例显示了一个按键分区的简单表，有 4 个分区：

  ```sql
  CREATE TABLE tk (col1 INT, col2 CHAR(5), col3 DATE)
      PARTITION BY KEY(col3)
      PARTITIONS 4;
  ```

  对于键分区的表，可以使用`LINEAR`关键字进行线性分区。这与按 `HASH` 分区的表具有相同的效果。也就是说，分区号是使用 [`&`](https://dev.mysql.com/doc/refman/8.0/en/bit-functions.html#operator_bitwise-and) 运算符而不是模数找到的（有关详细信息，请参阅 [第 24.2.4.1 节，“LINEAR HASH 分区”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-linear-hash.html) 和 [第 24.2.5 节，“KEY 分区”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-key.html)）。此示例使用 key 线性分区在 5 个分区之间分配数据：

  ```sql
  CREATE TABLE tk (col1 INT, col2 CHAR(5), col3 DATE)
      PARTITION BY LINEAR KEY(col3)
      PARTITIONS 5;
  ```

  支持该`ALGORITHM={1 | 2}`选项`[SUB]PARTITION BY [LINEAR] KEY`。 `ALGORITHM=1`使服务器使用与 MySQL 5.1 相同的键散列函数； `ALGORITHM=2`意味着服务器使用默认实现并用于`KEY`MySQL 5.5 及更高版本中的新分区表的键散列函数。（使用 MySQL 5.5 和更高版本中使用的键散列函数创建的分区表不能被 MySQL 5.1 服务器使用。）不指定该选项与使用`ALGORITHM=2`. 此选项主要用于 `[LINEAR] KEY`在 MySQL 5.1 和更高版本的 MySQL 之间升级或降级分区表时使用，或用于创建分区表`KEY`或`LINEAR KEY`可在 MySQL 5.1 服务器上使用的 MySQL 5.5 或更高版本的服务器。有关更多信息，请参阅 [第 13.1.9.1 节，“ALTER TABLE 分区操作”](https://dev.mysql.com/doc/refman/8.0/en/alter-table-partition-operations.html)。

  [**MySQL 5.7（及更高版本）中的mysqldump**](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)将此选项写入版本化注释中，如下所示：

  ```sql
  CREATE TABLE t1 (a INT)
  /*!50100 PARTITION BY KEY */ /*!50611 ALGORITHM = 1 */ /*!50100 ()
        PARTITIONS 3 */
  ```

  这会导致 MySQL 5.6.10 和更早的服务器忽略该选项，否则会在这些版本中导致语法错误。如果您打算将在 MySQL 5.7 服务器上进行的转储加载到 MySQL 5.6 服务器中，在该服务器上使用分区或子分区的表`KEY`到版本 5.6.11 之前的 MySQL 5.6 服务器中，请务必 在继续之前查阅[MySQL 5.6 中的更改。](https://dev.mysql.com/doc/refman/5.6/en/upgrading-from-previous-series.html)`KEY` （如果您正在将包含由 MySQL 5.7（实际上是 5.6.11 或更高版本）服务器创建 的分区或子分区表的转储加载到 MySQL 5.5.30 或更早版本的服务器中，则此处找到的信息也适用。）

  同样在 MySQL 5.6.11 及更高版本`ALGORITHM=1` 中，在必要时 以与[**mysqldump**](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)[`SHOW CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html)相同的方式在使用版本化注释 的输出中显示。 始终从 输出中省略，即使在创建原始表时指定了此选项。 `ALGORITHM=2``SHOW CREATE TABLE`

  您不能将`VALUES LESS THAN`or `VALUES IN`子句与. 一起使用`PARTITION BY KEY`。

- `RANGE(*`expr`*)`

  在这种情况下，*`expr`*使用一组运算符显示一系列值`VALUES LESS THAN` 。使用范围分区时，您必须使用 定义至少一个分区`VALUES LESS THAN`。您不能`VALUES IN`与范围分区一起使用。

  > 对于由 分区的表`RANGE`， `VALUES LESS THAN`必须与整数文字值或计算结果为单个整数值的表达式一起使用。在 MySQL 8.0 中，您可以在使用 定义的表中克服此限制 `PARTITION BY RANGE COLUMNS`，如本节后面所述。

  假设您有一个表，您希望根据以下方案对包含年份值的列进行分区。

  | 分区号： | 年份范围：        |
| :------- | :---------------- |
  | 0        | 1990 年及更早     |
  | 1        | 1991 至 1994      |
  | 2        | 1995 年至 1998 年 |
  | 3        | 1999 年至 2002 年 |
  | 4        | 2003 年至 2005 年 |
  | 5        | 2006 年及以后     |

  实现这种分区方案的表可以通过[`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 此处显示的语句来实现：

  ```sql
CREATE TABLE t1 (
      year_col  INT,
      some_data INT
  )
  PARTITION BY RANGE (year_col) (
      PARTITION p0 VALUES LESS THAN (1991),
      PARTITION p1 VALUES LESS THAN (1995),
      PARTITION p2 VALUES LESS THAN (1999),
      PARTITION p3 VALUES LESS THAN (2002),
      PARTITION p4 VALUES LESS THAN (2006),
      PARTITION p5 VALUES LESS THAN MAXVALUE
  );
  ```

  `PARTITION ... VALUES LESS THAN ...` 语句以连续的方式工作。`VALUES LESS THAN MAXVALUE`用于指定 大于另外指定的最大值的 “剩余”值。

  `VALUES LESS THAN`子句以类似于块`case` 部分的方式顺序工作`switch ... case`（如在许多编程语言中发现的那样，如 C、Java 和 PHP）。也就是说，子句必须以这样一种方式排列，即每个连续指定的上限`VALUES LESS THAN`大于前一个的上限，引用的`MAXVALUE`一个在列表中排在最后。

- `RANGE COLUMNS(*`column_list`*)`

  此变体`RANGE`有助于使用多列上的范围条件（即具有`WHERE a = 1 AND b < 10`or之类的条件`WHERE a = 1 AND b = 10 AND c < 10`）对查询进行分区修剪。`COLUMNS`它使您能够通过使用子句中的列列表和每个分区定义子句中的一组列值来指定多个列中的值范围 。（在最简单的情况下，该集合由单个列组成。）在and 中可以引用的最大列数是 16。 `PARTITION ... VALUES LESS THAN (*`value_list`*)`*`column_list`**`value_list`*

  子句中的*`column_list`*used `COLUMNS`可能只包含列名；列表中的每一列必须是以下 MySQL 数据类型之一：整数类型；字符串类型；和时间或日期列类型。不允许使用 `BLOB`、`TEXT`、 `SET`、`ENUM`、 或空间数据类型的列；`BIT`也不允许使用浮点数类型的列。您也不能在`COLUMNS` 子句中使用函数或算术表达式。

  分区定义中使用的`VALUES LESS THAN`子句必须为子句中出现的每一列指定一个文字值`COLUMNS()` ；也就是说，用于每个 `VALUES LESS THAN`子句的值列表必须包含与子句中列出的列相同数量的值 `COLUMNS`。尝试在`VALUES LESS THAN`子句中使用比子句中更多或更少的值`COLUMNS`会导致语句失败，并出现错误Inconsistency in usage of column lists for partitioning...。您不能使用`NULL`出现在 中的任何值 `VALUES LESS THAN`。可以使用 `MAXVALUE`对于除第一列之外的给定列，不止一次，如本例所示：

  ```sql
  CREATE TABLE rc (
      a INT NOT NULL,
      b INT NOT NULL
  )
  PARTITION BY RANGE COLUMNS(a,b) (
      PARTITION p0 VALUES LESS THAN (10,5),
      PARTITION p1 VALUES LESS THAN (20,10),
      PARTITION p2 VALUES LESS THAN (50,MAXVALUE),
      PARTITION p3 VALUES LESS THAN (65,MAXVALUE),
      PARTITION p4 VALUES LESS THAN (MAXVALUE,MAXVALUE)
  );
  ```

  值列表中使用的每个值都`VALUES LESS THAN`必须与对应列的类型完全匹配；不进行任何转换。例如，您不能将字符串 `'1'`用于匹配使用整数类型的列的值（必须使用数字 `1`代替），也不能将数字 `1`用于匹配使用字符串类型的列的值（例如在这种情况下，您必须使用带引号的字符串：) `'1'`。

  有关更多信息，请参阅 [第 24.2.1 节，“RANGE 分区”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-range.html)和 [第 24.4 节，“分区修剪”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-pruning.html)。

- `LIST(*`expr`*)`

  这在基于具有一组受限可能值（例如州或国家/地区代码）的表列分配分区时很有用。在这种情况下，与某个州或国家有关的所有行都可以分配给单个分区，或者可以为一组特定的州或国家保留一个分区。它类似于 `RANGE`，除了只能`VALUES IN`用于为每个分区指定允许的值。

  `VALUES IN`与要匹配的值列表一起使用。例如，您可以创建一个分区方案，如下所示：

  ```sql
  CREATE TABLE client_firms (
      id   INT,
      name VARCHAR(35)
  )
  PARTITION BY LIST (id) (
      PARTITION r0 VALUES IN (1, 5, 9, 13, 17, 21),
      PARTITION r1 VALUES IN (2, 6, 10, 14, 18, 22),
      PARTITION r2 VALUES IN (3, 7, 11, 15, 19, 23),
      PARTITION r3 VALUES IN (4, 8, 12, 16, 20, 24)
  );
  ```

  使用列表分区时，您必须使用 定义至少一个分区`VALUES IN`。你不能使用 `VALUES LESS THAN`with `PARTITION BY LIST`。

  笔记

  对于按 分区的表`LIST`，与 一起使用的值列表`VALUES IN`必须仅包含整数值。在 MySQL 8.0 中，您可以使用分区方式来克服此限制`LIST COLUMNS`，本节稍后将对此进行介绍。

- `LIST COLUMNS(*`column_list`*)`

  此变体`LIST`有助于使用多列上的比较条件（即具有`WHERE a = 5 AND b = 5`or之类的条件`WHERE a = 1 AND b = 10 AND c = 5`）对查询进行分区修剪。`COLUMNS`它使您能够通过使用子句中的列列表和每个分区定义子句 中的一组列值来指定多个列中的 值。`PARTITION ... VALUES IN (*`value_list`*)`

  中使用的列列表和中使用的值列表 的数据类型管理规则分别与中使用的列列表和中使用的值列表的规则相同，除了 子句中不允许，并且您可以使用. `LIST COLUMNS(*`column_list`*)``VALUES IN(*`value_list`*)``RANGE COLUMNS(*`column_list`*)``VALUES LESS THAN(*`value_list`*)``VALUES IN``MAXVALUE``NULL`

  `VALUES IN`用于with的值列表与用于 with`PARTITION BY LIST COLUMNS`时 的值列表有一个重要区别`PARTITION BY LIST`。与 一起使用时 `PARTITION BY LIST COLUMNS`，子句中的每个元素都`VALUES IN`必须是一 *组*列值；每个集合中的值的数量必须与子句中使用的列数相同`COLUMNS`，并且这些值的数据类型必须与列的数据类型匹配（并且以相同的顺序出现）。在最简单的情况下，该集合由一列组成。可以在*`column_list`* 和 组成的元素 中使用的最大列数*`value_list`*是 16。

  以下`CREATE TABLE`语句定义的表提供了使用 `LIST COLUMNS`分区的表示例：

  ```sql
  CREATE TABLE lc (
      a INT NULL,
      b INT NULL
  )
  PARTITION BY LIST COLUMNS(a,b) (
      PARTITION p0 VALUES IN( (0,0), (NULL,NULL) ),
      PARTITION p1 VALUES IN( (0,1), (0,2), (0,3), (1,1), (1,2) ),
      PARTITION p2 VALUES IN( (1,0), (2,0), (2,1), (3,0), (3,1) ),
      PARTITION p3 VALUES IN( (1,3), (2,2), (2,3), (3,2), (3,3) )
  );
  ```

- `PARTITIONS *`num`*`

  可以选择使用 子句指定分区数，其中是分区数。如果同时使用此子句*和*任何 子句，则 必须等于使用子句声明的任何分区的总数 。 `PARTITIONS *`num`*`*`num`*`PARTITION`*`num`*`PARTITION`

  笔记

  无论您是否`PARTITIONS` 在创建由 `RANGE`or分区的表时使用子句`LIST`，您仍必须在表定义中包含至少一个`PARTITION VALUES`子句（见下文）。

- `SUBPARTITION BY`

  一个分区可以可选地划分为多个子分区。这可以通过使用可选 `SUBPARTITION BY`子句来表示。子分区可以由`HASH`或完成`KEY`。其中任何一个都可能是`LINEAR`. 它们的工作方式与前面描述的等效分区类型相同。（不能通过 `LIST`或进行子分区`RANGE`。）

  可以使用 `SUBPARTITIONS`关键字后跟整数值来指示子分区的数量。

- 严格检查 `PARTITIONS`or `SUBPARTITIONS`子句中使用的值，并且该值必须遵守以下规则：

  - 该值必须是一个正的非零整数。
  - 不允许有前导零。
  - 该值必须是整数文字，并且不能不是表达式。例如，`PARTITIONS 0.2E+01`不允许，即使 `0.2E+01`计算结果为 `2`。（错误 #15890）

- `*`partition_definition`*`

  可以使用 *`partition_definition`*子句单独定义每个分区。组成本条款的各个部分如下：

  - `PARTITION *`partition_name`*`

    指定分区的逻辑名称。

  - `VALUES`

    对于范围分区，每个分区必须包含一个 `VALUES LESS THAN`子句；对于列表分区，您必须`VALUES IN`为每个分区指定一个子句。这用于确定哪些行将存储在此分区中。有关语法示例， 请参阅[第 24 章，*分区*](https://dev.mysql.com/doc/refman/8.0/en/partitioning.html)中对分区类型的讨论 。

  - `[STORAGE] ENGINE`

    MySQL 接受和 的`[STORAGE] ENGINE`选项。目前，可以使用此选项的唯一方法是将所有分区或所有子分区设置为同一个存储引擎，并且尝试为同一个表中的分区或子分区设置不同的存储引擎会引发错误 ERROR 1469 (HY000) : 在这个版本的 MySQL 中不允许在分区中混合处理程序。 `PARTITION``SUBPARTITION`

  - `COMMENT`

    可选`COMMENT`子句可用于指定描述分区的字符串。例子：

    ```sql
    COMMENT = 'Data for the years previous to 1999'
    ```

    分区注释的最大长度为 1024 个字符。

  - `DATA DIRECTORY`和`INDEX DIRECTORY`

    `DATA DIRECTORY`并且`INDEX DIRECTORY`可用于指示分别存储该分区的数据和索引的目录。the `*`data_dir`*` 和 the 都`*`index_dir`*` 必须是绝对系统路径名。

    从 MySQL 8.0.21 开始，子句中指定的目录 `DATA DIRECTORY`必须为 `InnoDB`. 有关详细信息，请参阅 [使用 DATA DIRECTORY 子句](https://dev.mysql.com/doc/refman/8.0/en/innodb-create-table-external.html#innodb-create-table-external-data-directory)。

    您必须有权[`FILE`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_file) 使用`DATA DIRECTORY`或 `INDEX DIRECTORY`分区选项。

    例子：

    ```sql
    CREATE TABLE th (id INT, name VARCHAR(30), adate DATE)
    PARTITION BY LIST(YEAR(adate))
    (
      PARTITION p1999 VALUES IN (1995, 1999, 2003)
        DATA DIRECTORY = '/var/appdata/95/data'
        INDEX DIRECTORY = '/var/appdata/95/idx',
      PARTITION p2000 VALUES IN (1996, 2000, 2004)
        DATA DIRECTORY = '/var/appdata/96/data'
        INDEX DIRECTORY = '/var/appdata/96/idx',
      PARTITION p2001 VALUES IN (1997, 2001, 2005)
        DATA DIRECTORY = '/var/appdata/97/data'
        INDEX DIRECTORY = '/var/appdata/97/idx',
      PARTITION p2002 VALUES IN (1998, 2002, 2006)
        DATA DIRECTORY = '/var/appdata/98/data'
        INDEX DIRECTORY = '/var/appdata/98/idx'
    );
    ```

    `DATA DIRECTORY`并且行为方式与 用于表的 语句子句`INDEX DIRECTORY`中的方式相同 。 [`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)*`table_option`*`MyISAM`

    每个分区可以指定一个数据目录和一个索引目录。如果未指定，则数据和索引默认存储在表的数据库目录中。

    `DATA DIRECTORY`和选项 在`INDEX DIRECTORY`创建分区表时会被忽略，如果 [`NO_DIR_IN_CREATE`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_dir_in_create)有效的话。

  - `MAX_ROWS`和 `MIN_ROWS`

    可用于分别指定要存储在分区中的最大和最小行数。*`max_number_of_rows`* 和的值*`min_number_of_rows`*必须是正整数。与具有相同名称的表级选项一样，这些选项仅作为 对服务器的“建议”而不是硬限制。

  - `TABLESPACE`

    可用于通过指定`InnoDB` 为分区指定一个 file-per-table 表空间 `TABLESPACE `innodb_file_per_table``。所有分区必须属于同一个存储引擎。

    不支持 将`InnoDB`表分区放在共享表空间中。`InnoDB`共享表空间包括 `InnoDB`系统表空间和通用表空间。

- `*`subpartition_definition`*`

  分区定义可以可选地包含一个或多个 *`subpartition_definition`*子句。其中每一个都至少包含 ，其中 是子分区的标识符。除了将 关键字 替换为 之外，子分区定义的语法与分区定义的语法相同。 `SUBPARTITION *`name`*`*`name`*`PARTITION``SUBPARTITION`

  子分区必须由`HASH`or 完成`KEY`，并且只能在 `RANGE`or`LIST` 分区上完成。请参阅[第 24.2.6 节，“子分区”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-subpartitions.html)。

**按生成列分区**

允许按生成的列进行分区。例如：

```sql
CREATE TABLE t1 (
  s1 INT,
  s2 INT AS (EXP(s1)) STORED
)
PARTITION BY LIST (s2) (
  PARTITION p1 VALUES IN (1)
);
```

分区将生成的列视为常规列，这可以解决不允许分区的函数的限制（请参阅 [第 24.6.3 节，“与函数相关的分区限制”](https://dev.mysql.com/doc/refman/8.0/en/partitioning-limitations-functions.html)）。前面的示例演示了这种技术： [`EXP()`](https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_exp)不能直接在子句中使用，但允许 `PARTITION BY`使用定义的生成列。[`EXP()`](https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_exp)
