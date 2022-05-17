## 创建和使用数据库

> https://dev.mysql.com/doc/refman/8.0/en/database-use.html

[3.3.1 创建并选择数据库](数据存储/MySQL8/MySQL-Server-参考手册/教程/#创建并选择数据库)

[3.3.2 创建表](数据存储/MySQL8/MySQL-Server-参考手册/教程/#创建表)

[3.3.3 将数据加载到表中](数据存储/MySQL8/MySQL-Server-参考手册/教程/#将数据加载到表中)

[3.3.4 从表中检索信息](数据存储/MySQL8/MySQL-Server-参考手册/教程/#从表中检索信息)

一旦您知道如何输入 SQL 语句，您就可以访问数据库了。

假设您家（您的 menagerie 动物园）中有几只宠物，并且您想跟踪有关它们的各种类型的信息。您可以通过创建用来保存您的数据的表，并加载所需的信息，来做到这一点。然后，您可以通过从表中检索数据来回答有关您的动物的不同类型的问题。本节介绍如何执行以下操作：

- 创建数据库
- 创建表
- 将数据加载到表中
- 以各种方式从表中检索数据
- 使用多个表

我们故意把 `menagerie` 数据库设计地很简单，但不难想到可能使用类似类型数据库的现实情况。比如，农民可以使用这样的数据库来跟踪家畜，或者兽医可以使用这样的数据库来跟踪患者记录。可以从 MySQL 网站获得包含以下部分中使用的一些查询和示例数据的 menagerie      distribution。它在 [https://dev.mysql.com/doc/index-other.html](https://dev.mysql.com/doc/index-other.html) 以压缩 tar 文件和 Zip 格式提供。

使用 [`SHOW`](https://dev.mysql.com/doc/refman/8.0/en/show.html) 语句找出当前在服务器上存在哪些数据库：

``` sql
mysql> SHOW DATABASES;
+----------+
| Database |
+----------+
| mysql    |
| test     |
| tmp      |
+----------+
```

`mysql`数据库描述了用户访问权限。`test` 数据库通常可用作用户试用的工作空间。

该语句显示的数据库列表，在您的机器上可能会有所不同；[`SHOW DATABASES`](https://dev.mysql.com/doc/refman/8.0/en/show-databases.html) 不会显示那些您没有相应 [`SHOW DATABASES`](https://dev.mysql.com/doc/refman/8.0/en/show-databases.html) 权限的数据库 。请参阅[第 13.7.7.14 节，“SHOW DATABASES 语句”](https://dev.mysql.com/doc/refman/8.0/en/show-databases.html)。

如果存在 `test` 数据库，请尝试访问它：

``` sql
mysql> USE test
Database changed
```

[`USE`](https://dev.mysql.com/doc/refman/8.0/en/use.html)，跟 `QUIT` 一样, 不需要分号。（如果你愿意，你可以用分号结束这样的语句；没坏处。）这个 [`USE`](https://dev.mysql.com/doc/refman/8.0/en/use.html)语句在另一个方面也很特别：它必须在一行中给出。

您可以在后面的示例中使用这个 `test` 数据库（如果您可以访问它），但是您在这个数据库中创建的任何内容都可以被任何有权访问它的人删除。出于这个原因，您可能应该向您的 MySQL 管理员请求使用您自己的数据库的权限。假设您想调用您的 `menagerie`。管理员需要执行如下语句：

``` sql
mysql> GRANT ALL ON menagerie.* TO 'your_mysql_name'@'your_client_host';
```

其中， `your_mysql_name` 是分配给您的 MySQL 用户名，`your_client_host` 是您连接到服务器的主机。
