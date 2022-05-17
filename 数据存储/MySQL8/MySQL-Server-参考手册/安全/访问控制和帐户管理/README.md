# 访问控制和帐户管理

> https://dev.mysql.com/doc/refman/8.0/en/access-control.html

MySQL 允许创建允许客户端用户连接到服务器并访问由服务器管理的数据的帐户。MySQL 权限系统的主要功能是**对从给定主机连接的用户进行身份验证，并将该用户与数据库上的权限相关联**，例如 [`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/select.html)、 [`INSERT`](https://dev.mysql.com/doc/refman/8.0/en/insert.html)、 [`UPDATE`](https://dev.mysql.com/doc/refman/8.0/en/update.html)和 [`DELETE`](https://dev.mysql.com/doc/refman/8.0/en/delete.html)。其他功能包括授予管理操作权限的能力。

为了控制哪些用户可以连接，可以为每个帐户分配身份验证凭据，例如密码。MySQL 帐户的用户界面由 SQL 语句组成，例如 [`CREATE USER`](https://dev.mysql.com/doc/refman/8.0/en/create-user.html)、 [`GRANT`](https://dev.mysql.com/doc/refman/8.0/en/grant.html)和 [`REVOKE`](https://dev.mysql.com/doc/refman/8.0/en/revoke.html)。请参阅 [第 13.7.1 节，“账户管理声明”](https://dev.mysql.com/doc/refman/8.0/en/account-management-statements.html)。

MySQL 特权系统确保所有用户只能执行允许他们执行的操作。作为用户，当您连接到 MySQL 服务器时，您的**身份由*您连接的主机*和*您指定的用户名*决定**。当您连接后发出请求时，系统会**根据您的身份和 *您想做的事情*授予权限**。

MySQL 在识别您时会考虑您的主机名和用户名，因为没有理由假设给定的用户名在所有主机上属于同一个人。比如， 从 `office.example.com` 连接的 `joe` 用户不必与从 `home.example.com` 连接的 `joe` 用户是同一个人 。MySQL 通过使您能够区分碰巧具有相同名称的不同主机上的用户来处理此问题：你可以授予来自 `office.example.com` 的 `joe` 一组连接特权，并授予来自 `home.example.com` 的 `joe` 另一组连接特权。要查看给定帐户具有哪些权限，请使用 [`SHOW GRANTS`](https://dev.mysql.com/doc/refman/8.0/en/show-grants.html) 语句。比如：

```sql
SHOW GRANTS FOR 'joe'@'office.example.com';
SHOW GRANTS FOR 'joe'@'home.example.com';
```

在内部，服务器将权限信息**存储**在`mysql`系统数据库的授权表中。MySQL 服务器在启动时将这些表的内容读入内存，并根据授权表的内存副本做出访问控制决策。

当您运行连接到服务器的客户端程序时，MySQL 访问控制涉及两个阶段：

**第 1 阶段：**服务器根据您的身份和您是否可以通过提供正确的密码来验证您的身份，接受或拒绝连接。

**第 2 阶段：**假设您可以连接，服务器会检查您发出的每个语句以确定您是否有足够的权限来执行它。比如，如果您尝试从数据库中的表中选择行或从数据库中删除表，则服务器会验证您是否具有 [`SELECT`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_select)该表的权限或 [`DROP`](https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#priv_drop)数据库的权限。

有关每个阶段发生的情况的更详细描述，请参阅[第 6.2.6 节，“访问控制，第 1 阶段：连接验证”](https://dev.mysql.com/doc/refman/8.0/en/connection-access.html)和 [第 6.2.7 节，“访问控制，第 2 阶段：请求验证”](https://dev.mysql.com/doc/refman/8.0/en/request-access.html)。有关诊断权限相关问题的帮助，请参阅 [第 6.2.22 节，“解决连接到 MySQL 的问题”](https://dev.mysql.com/doc/refman/8.0/en/problems-connecting.html)。

如果您在连接时更改了您的权限（您自己或其他人），这些更改不一定会立即对您发出的下一个语句生效。有关服务器重新加载授权表的条件的详细信息，请参阅[第 6.2.13 节，“当权限更改生效时”](https://dev.mysql.com/doc/refman/8.0/en/privilege-changes.html)。

有些事情你**不能用 MySQL 特权系统做**：

- 您不能明确指定应拒绝给定用户访问。也就是说，您不能显式匹配用户然后拒绝连接。
- 您不能指定用户有权在数据库中创建或删除表，但不能创建或删除数据库本身。
- 密码全局应用于帐户。您不能将密码与特定对象（例如数据库、表或例程）相关联。