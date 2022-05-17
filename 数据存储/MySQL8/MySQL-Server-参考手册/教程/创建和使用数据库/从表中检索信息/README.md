### 从表中检索信息

> https://dev.mysql.com/doc/refman/8.0/en/retrieving-data.html

[3.3.4.1 选择所有数据](数据存储/MySQL8/MySQL-Server-参考手册/教程/#选择所有数据)

[3.3.4.2 选择特定行](数据存储/MySQL8/MySQL-Server-参考手册/教程/#选择特定行)

[3.3.4.3 选择特定列](数据存储/MySQL8/MySQL-Server-参考手册/教程/#选择特定列)

[3.3.4.4 排序行](数据存储/MySQL8/MySQL-Server-参考手册/教程/#排序行)

[3.3.4.5 日期计算](数据存储/MySQL8/MySQL-Server-参考手册/教程/#日期计算)

[3.3.4.6 使用 NULL 值](数据存储/MySQL8/MySQL-Server-参考手册/教程/#working-with-null)

[3.3.4.7 模式匹配](数据存储/MySQL8/MySQL-Server-参考手册/教程/#模式匹配)

[3.3.4.8 计数行](数据存储/MySQL8/MySQL-Server-参考手册/教程/#计数行)

[3.3.4.9 使用多个表](数据存储/MySQL8/MySQL-Server-参考手册/教程/#使用多个表)



[`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/select.html) 语句用于**从表中提取信息**。语句的一般形式是：

```sql
SELECT what_to_select
FROM which_table
WHERE conditions_to_satisfy;
```

*`what_to_select`* 表示你想看到什么。这可以是列的列表，也可以用 `*` 表示“所有列”。 *`which_table`* 表示要从中检索数据的表。`WHERE` 子句是可选的。如果存在，*`conditions_to_satisfy`* 指定一个或多个条件，行必须满足这些条件才有资格进行检索。
