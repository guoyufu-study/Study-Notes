## 常见查询的示例

> https://dev.mysql.com/doc/refman/8.0/en/examples.html

- [3.6.1 列的最大值](数据存储/MySQL8/MySQL-Server-参考手册/教程/#列的最大值)
- [3.6.2 某列的最大值所在的行](数据存储/MySQL8/MySQL-Server-参考手册/教程/#某列的最大值所在的行)
- [3.6.3 每组中某列的最大值](数据存储/MySQL8/MySQL-Server-参考手册/教程/#每组中某列的最大值)
- [3.6.4 持有某一列的分组最大值的行](数据存储/MySQL8/MySQL-Server-参考手册/教程/#持有某一列的分组最大值的行)
- [3.6.5 使用用户定义的变量](数据存储/MySQL8/MySQL-Server-参考手册/教程/#使用用户定义的变量)
- [3.6.6 使用外键](数据存储/MySQL8/MySQL-Server-参考手册/教程/#使用外键)
- [3.6.7 搜索两个键](数据存储/MySQL8/MySQL-Server-参考手册/教程/#搜索两个键)
- [3.6.8 计算每天访问量](数据存储/MySQL8/MySQL-Server-参考手册/教程/#计算每天访问量)
- [3.6.9 使用 AUTO_INCREMENT](数据存储/MySQL8/MySQL-Server-参考手册/教程/#example-auto-increment)



以下是如何解决 MySQL 的一些常见问题的示例。

一些示例使用 `shop` 表来保存某些交易员（经销商）的每件商品（商品编号）的价格。假设每个交易员对每件商品都有一个固定价格，那么 ( `article`, `dealer`) 是记录的主键。

启动命令行工具 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 并选择一个数据库：

```terminal
$> mysql your-database-name
```

要创建和填充示例表，请使用以下语句：

```sql
CREATE TABLE shop (
    article INT UNSIGNED  DEFAULT '0000' NOT NULL,
    dealer  CHAR(20)      DEFAULT ''     NOT NULL,
    price   DECIMAL(16,2) DEFAULT '0.00' NOT NULL,
    PRIMARY KEY(article, dealer));
INSERT INTO shop VALUES
    (1,'A',3.45),(1,'B',3.99),(2,'A',10.99),(3,'B',1.45),
    (3,'C',1.69),(3,'D',1.25),(4,'D',19.95);
```

发出语句后，表应具有以下内容：

```sql
SELECT * FROM shop ORDER BY article;

+---------+--------+-------+
| article | dealer | price |
+---------+--------+-------+
|       1 | A      |  3.45 |
|       1 | B      |  3.99 |
|       2 | A      | 10.99 |
|       3 | B      |  1.45 |
|       3 | C      |  1.69 |
|       3 | D      |  1.25 |
|       4 | D      | 19.95 |
+---------+--------+-------+
```
