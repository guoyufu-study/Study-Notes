#### 使用 NULL 值 :id=working-with-null

> https://dev.mysql.com/doc/refman/8.0/en/working-with-null.html

在您习惯它之前，`NULL` 的值可能会令人惊讶。从概念上讲，`NULL`意思是 “**缺失的未知值**”，它的处理方式与其他值有些不同。

要测试 `NULL`，请使用 [`IS NULL` 和 `IS NOT NULL`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_is-not-null) 运算符，如下所示：

```sql
mysql> SELECT 1 IS NULL, 1 IS NOT NULL;
+-----------+---------------+
| 1 IS NULL | 1 IS NOT NULL |
+-----------+---------------+
|         0 |             1 |
+-----------+---------------+
```

您不能使用算术比较运算符（例如 [`=`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_equal)、 [`<`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_less-than)或 [`<>`](https://dev.mysql.com/doc/refman/8.0/en/comparison-operators.html#operator_not-equal)）来测试`NULL`。为了自己演示这一点，请尝试以下查询：

```sql
mysql> SELECT 1 = NULL, 1 <> NULL, 1 < NULL, 1 > NULL;
+----------+-----------+----------+----------+
| 1 = NULL | 1 <> NULL | 1 < NULL | 1 > NULL |
+----------+-----------+----------+----------+
|     NULL |      NULL |     NULL |     NULL |
+----------+-----------+----------+----------+
```

因为任何 `NULL` 算术比较的结果也是 `NULL`，所以您无法从此类比较中获得任何有意义的结果。

在 MySQL 中，`0` 或 `NULL` 表示 false，其他任何值都表示 true。布尔运算的**默认真值**是`1`.

这种  `NULL` 的特殊处理就是为什么，在上一节中，有必要使用  `death IS NOT NULL` 代替 `death <> NULL` 来确定哪些动物已经死亡。

两个 `NULL` 值**在 `GROUP BY` 中被视为相等**。

**执行 `ORDER BY`** 时，如果您执行 `ORDER BY ... ASC`，则首先显示 `NULL` 值；如果执行 `ORDER BY ... DESC`，则最后显示 `NULL` 值。

使用 `NULL` 时的一个常见错误是假设不可能将**零或空字符串**插入定义为 `NOT NULL` 的列中，但事实并非如此。这些实际上是值，而 `NULL` 意味着“没有值”。您可以使用 `IS [NOT] NULL` ，如下所示的方式，轻松测试：

```sql
mysql> SELECT 0 IS NULL, 0 IS NOT NULL, '' IS NULL, '' IS NOT NULL;
+-----------+---------------+------------+----------------+
| 0 IS NULL | 0 IS NOT NULL | '' IS NULL | '' IS NOT NULL |
+-----------+---------------+------------+----------------+
|         0 |             1 |          0 |              1 |
+-----------+---------------+------------+----------------+
```

因此，完全可以在 `NOT NULL` 列中插入零或空字符串，因为它们实际上是`NOT NULL`. 请参阅 [第 B.3.4.3 节，“NULL 值问题”](https://dev.mysql.com/doc/refman/8.0/en/problems-with-null.html)。
