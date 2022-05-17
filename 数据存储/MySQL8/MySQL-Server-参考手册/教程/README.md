# 教程

> https://dev.mysql.com/doc/refman/8.0/en/tutorial.html


## 目录

[3.1 连接和断开服务器](数据存储/MySQL8/MySQL-Server-参考手册/教程/#连接和断开服务器)

[3.2 输入查询](数据存储/MySQL8/MySQL-Server-参考手册/教程/#输入查询)

[3.3 创建和使用数据库](数据存储/MySQL8/MySQL-Server-参考手册/教程/#创建和使用数据库)

[3.4 获取有关数据库和表的信息](数据存储/MySQL8/MySQL-Server-参考手册/教程/#获取有关数据库和表的信息)

[3.5 在批处理模式下使用 mysql](数据存储/MySQL8/MySQL-Server-参考手册/教程/#batch-mode)

[3.6 常见查询的示例](数据存储/MySQL8/MySQL-Server-参考手册/教程/#常见查询的示例)

3.7 将 MySQL 与 Apache 一起使用


本章通过展示如何使用 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 客户端程序创建和使用简单数据库，来提供 MySQL 的教程介绍。[mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)（有时称为“终端监视器”，或简称 “监视器”）是一个**交互式**程序，使您可以连接到 MySQL 服务器，运行查询并查看结果。[mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 也可以在**批处理模式**下使用：您预先将查询放在文件中，然后告诉 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 以执行文件的内容。这里介绍了使用 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 的两种方式。

要查看 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 提供的选项列表，请在调用它时使用`-help`选项：

```powershell
mysql --help
```

本章假定 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 已安装在您的计算机上，并且可以连接到 MySQL 服务器。如果不是这样，请联系 MySQL 管理员。（如果您就是管理员，则需要查阅本手册的相关部分，比如[第5章MySQL Server管理](https://dev.mysql.com/doc/refman/8.0/en/server-administration.html)。）

本章描述了设置和使用数据库的整个过程。如果您只对访问现有数据库感兴趣，您可能希望跳过描述如何创建数据库和它包含的表的部分。

由于本章是教程性质的，许多细节必然省略。有关此处涵盖的主题的更多信息，请参阅本手册的相关部分。

***

[3.1 连接和断开服务器](连接和断开服务器.md ':include')

[3.2 输入查询](输入查询.md ':include')

[3.3 创建和使用数据库](创建和使用数据库/README.md ':include')

[3.3.1 创建并选择数据库](创建和使用数据库/创建并选择数据库.md ':include')

[3.3.2 创建表](创建和使用数据库/创建表.md ':include')

[3.3.3 将数据加载到表中](创建和使用数据库/将数据加载到表中.md ':include')

[3.3.4 从表中检索信息](创建和使用数据库/从表中检索信息/README.md ':include')

[3.3.4.1 选择所有数据](创建和使用数据库/从表中检索信息/选择所有数据.md ':include')

[3.3.4.2 选择特定行](创建和使用数据库/从表中检索信息/选择特定行.md ':include')

[3.3.4.3 选择特定列](创建和使用数据库/从表中检索信息/选择特定列.md ':include')

[3.3.4.4 排序行](创建和使用数据库/从表中检索信息/排序行.md ':include')

[3.3.4.5 日期计算](创建和使用数据库/从表中检索信息/日期计算.md ':include')

[3.3.4.6 使用 NULL 值](创建和使用数据库/从表中检索信息/使用NULL值.md ':include')

[3.3.4.7 模式匹配](创建和使用数据库/从表中检索信息/模式匹配.md ':include')

[3.3.4.8 计数行](创建和使用数据库/从表中检索信息/计数行.md ':include')

[3.3.4.9 使用多个表](创建和使用数据库/从表中检索信息/使用多个表.md ':include')

[3.4 获取有关数据库和表的信息](获取有关数据库和表的信息.md ':include')

[3.5 在批处理模式下使用 mysql](在批处理模式下使用mysql.md ':include')

[3.6 常见查询的示例](常见查询的示例/README.md ':include')

[3.6.1 列的最大值](常见查询的示例/列的最大值.md ':include')

[3.6.2 某列的最大值所在的行](常见查询的示例/某列的最大值所在的行.md ':include')

[3.6.3 每组中某列的最大值](常见查询的示例/每组中某列的最大值.md ':include')

[3.6.4 持有某一列的分组最大值的行](常见查询的示例/持有某一列的分组最大值的行.md ':include')

[3.6.5 使用用户定义的变量](常见查询的示例/使用用户定义的变量.md ':include')

[3.6.6 使用外键](常见查询的示例/使用外键.md ':include')

[3.6.7 搜索两个键](常见查询的示例/搜索两个键.md ':include')

[3.6.8 计算每天访问量](常见查询的示例/计算每天访问量.md ':include')

[3.6.9 使用 AUTO_INCREMENT](常见查询的示例/使用AUTO_INCREMENT.md ':include')
