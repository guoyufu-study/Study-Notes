### 使用 AUTO_INCREMENT :id=example-auto-increment

> https://dev.mysql.com/doc/refman/8.0/en/example-auto-increment.html

`AUTO_INCREMENT` 属性可用于为新行生成唯一标识：

```sql
CREATE TABLE animals (
     id MEDIUMINT NOT NULL AUTO_INCREMENT,
     name CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);

INSERT INTO animals (name) VALUES
    ('dog'),('cat'),('penguin'),
    ('lax'),('whale'),('ostrich');

SELECT * FROM animals;
```

返回：

```none
+----+---------+
| id | name    |
+----+---------+
|  1 | dog     |
|  2 | cat     |
|  3 | penguin |
|  4 | lax     |
|  5 | whale   |
|  6 | ostrich |
+----+---------+
```

没有为 `AUTO_INCREMENT` 列指定值，因此 MySQL 自动分配了序列号。除非启用 [`NO_AUTO_VALUE_ON_ZERO`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_auto_value_on_zero) SQL 模式，否则您还可以显式为列分配 `0` 以生成序列号 。例如：

```sql
INSERT INTO animals (id,name) VALUES(0,'groundhog');
```

如果声明了该列 `NOT NULL`，也可以分配 `NULL` 给该列以生成序列号。例如：

```sql
INSERT INTO animals (id,name) VALUES(NULL,'squirrel');
```

当您将任何其他值插入 `AUTO_INCREMENT` 列时，该列将设置为该值并重置序列，以便下一个自动生成的值从最大的列值开始按顺序排列。例如：

```sql
INSERT INTO animals (id,name) VALUES(100,'rabbit');
INSERT INTO animals (id,name) VALUES(NULL,'mouse');
SELECT * FROM animals;
+-----+-----------+
| id  | name      |
+-----+-----------+
|   1 | dog       |
|   2 | cat       |
|   3 | penguin   |
|   4 | lax       |
|   5 | whale     |
|   6 | ostrich   |
|   7 | groundhog |
|   8 | squirrel  |
| 100 | rabbit    |
| 101 | mouse     |
+-----+-----------+
```

更新现有`AUTO_INCREMENT` 列值也会重置 `AUTO_INCREMENT` 序列。

您可以使用 [`LAST_INSERT_ID()`](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html#function_last-insert-id) SQL 函数或 [`mysql_insert_id()`](https://dev.mysql.com/doc/c-api/8.0/en/mysql-insert-id.html) C API 函数检索最近自动生成的 `AUTO_INCREMENT` 值 。这些函数是特定于连接的，因此它们的返回值不受另一个也在执行插入的连接的影响。

对足以容纳所需最大序列值的 `AUTO_INCREMENT` 列使用最小整数数据类型 。当列达到数据类型的上限时，下一次生成序列号的尝试失败。如果可能，请使用 `UNSIGNED` 属性以允许更大的范围。比如，如果使用 [`TINYINT`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html)，则允许的最大序列号为 127。对于 [`TINYINT UNSIGNED`](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html) 最大值为 255。 有关所有整数类型的范围，请参考 [Section 11.1.2, “Integer Types (Exact Value) - INTEGER, INT, SMALLINT, TINYINT, MEDIUMINT, BIGINT”](https://dev.mysql.com/doc/refman/8.0/en/integer-types.html)。

> 对于多行插入， [`LAST_INSERT_ID()`](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html#function_last-insert-id) 和 [`mysql_insert_id()`](https://dev.mysql.com/doc/c-api/8.0/en/mysql-insert-id.html) 实际上从插入的*第一*行返回 `AUTO_INCREMENT` 键 。这使得多行插入能够在复制设置中的其他服务器上正确复制。

要从 1 以外的 `AUTO_INCREMENT` 值开始，请使用[`CREATE TABLE`](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)或 [`ALTER TABLE`](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html) 设置该值，如下所示：

```sql
mysql> ALTER TABLE tbl AUTO_INCREMENT = 100;
```

#### InnoDB 笔记

有关特定于 `InnoDB` 的 `AUTO_INCREMENT` 用法的信息，请参阅 [第 15.6.1.6 节，“InnoDB 中的 AUTO_INCREMENT 处理”](https://dev.mysql.com/doc/refman/8.0/en/innodb-auto-increment-handling.html)。

#### MyISAM 笔记

- 对于`MyISAM`表，您可以在多列索引中的辅助列上指定 `AUTO_INCREMENT`。在这种情况下，`AUTO_INCREMENT`列的生成值计算为  [`MAX(*`auto_increment_column`*) + 1 WHERE prefix=*`given-prefix`*`](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_max) 。当您要将数据放入有序组时，这很有用。

  ```sql
  CREATE TABLE animals (
      grp ENUM('fish','mammal','bird') NOT NULL,
      id MEDIUMINT NOT NULL AUTO_INCREMENT,
      name CHAR(30) NOT NULL,
      PRIMARY KEY (grp,id)
  ) ENGINE=MyISAM;

  INSERT INTO animals (grp,name) VALUES
      ('mammal','dog'),('mammal','cat'),
      ('bird','penguin'),('fish','lax'),('mammal','whale'),
      ('bird','ostrich');

  SELECT * FROM animals ORDER BY grp,id;
  ```

  返回：

  ```none
  +--------+----+---------+
  | grp    | id | name    |
  +--------+----+---------+
  | fish   |  1 | lax     |
  | mammal |  1 | dog     |
  | mammal |  2 | cat     |
  | mammal |  3 | whale   |
  | bird   |  1 | penguin |
  | bird   |  2 | ostrich |
  +--------+----+---------+
  ```

  在这种情况下（当 `AUTO_INCREMENT` 列是多列索引的一部分时），如果您删除任何组中具有最大  `AUTO_INCREMENT` 值的行，则会重用 `AUTO_INCREMENT`值。即使对于通常不重用  `AUTO_INCREMENT` 值 的`MyISAM`表也会发生这种情况。

- 如果 `AUTO_INCREMENT` 列是多个索引的一部分，则 MySQL 使用以 `AUTO_INCREMENT` 列开头的索引生成序列值（如果有的话）。比如，如果`animals`表包含索引 `PRIMARY KEY (grp, id)` 和 `INDEX (id)`，MySQL 将忽略用于生成序列值的 `PRIMARY KEY`。因此，该表将包含单个序列，而不是每个 `grp` 值一个序列。

#### 延伸阅读

更多信息 `AUTO_INCREMENT` 可在此处获得：

- 如何将 `AUTO_INCREMENT` 属性分配给列：[第 13.1.20 节，“CREATE TABLE 语句”](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) 和 [第 13.1.9 节，“ALTER TABLE 语句”](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html)。
- `AUTO_INCREMENT` 的行为方式取决于 [`NO_AUTO_VALUE_ON_ZERO`](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#sqlmode_no_auto_value_on_zero) SQL 模式：[第 5.1.11 节，“服务器 SQL 模式”](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)。
- 如何使用 [`LAST_INSERT_ID()`](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html#function_last-insert-id)函数查找包含最新 `AUTO_INCREMENT` 值的行： [第 12.16 节，“信息函数”](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html)。
- 设置要使用的 `AUTO_INCREMENT` 值：[第 5.1.8 节，“服务器系统变量”](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)。
- [第 15.6.1.6 节，“InnoDB 中的 AUTO_INCREMENT 处理”](https://dev.mysql.com/doc/refman/8.0/en/innodb-auto-increment-handling.html)
- `AUTO_INCREMENT`和复制： [第 17.5.1.1 节，“复制和 AUTO_INCREMENT”](https://dev.mysql.com/doc/refman/8.0/en/replication-features-auto-increment.html)。
- 与 `AUTO_INCREMENT` ([`auto_increment_increment`](https://dev.mysql.com/doc/refman/8.0/en/replication-options-source.html#sysvar_auto_increment_increment) 和 [`auto_increment_offset`](https://dev.mysql.com/doc/refman/8.0/en/replication-options-source.html#sysvar_auto_increment_offset)) 相关的可用于复制的服务器系统变量： [第 5.1.8 节，“服务器系统变量”](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html)。
