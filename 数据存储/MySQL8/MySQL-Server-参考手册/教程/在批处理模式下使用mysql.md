## 在批处理模式下使用 mysql :id=batch-mode

> https://dev.mysql.com/doc/refman/8.0/en/batch-mode.html

在前面的部分中，您以交互方式使用 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 输入语句并查看结果。您还可以在批处理模式下运行 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)。为此，将要运行的语句放入文件中，然后告诉 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 从文件中读取其输入：

```terminal
$> mysql < batch-file
```

如果您在 Windows 下运行 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 并且文件中有一些导致问题的特殊字符，您可以这样做：

```terminal
C:\> mysql -e "source batch-file"
```

如果您需要在命令行中指定连接参数，该命令可能如下所示：

```terminal
$> mysql -h host -u user -p < batch-file
Enter password: ********
```

当您以这种方式使用 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 时，您正在创建一个脚本文件，然后执行该脚本。

如果您希望脚本在其中的某些语句产生错误的情况下继续运行，您应该使用 [`--force`](https://dev.mysql.com/doc/refman/8.0/en/mysql-command-options.html#option_mysql_force) 命令行选项。

为什么要使用脚本？这里有几个原因：

- 如果您**重复运行**查询（比如，每天或每周），将其设为脚本可以避免每次执行时都重新键入它。

- 您可以通过复制和编辑脚本文件从现有的类似查询中**生成新查询**。

- 在开发查询时，批处理模式也很有用，特别是对于**多行语句**或**多语句序列**。如果您犯了错误，您不必重新输入所有内容。只需编辑您的脚本以更正错误，然后告诉 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 再次执行它。

- 如果您有一个产生大量输出的查询，您可以通过一个**分页器**运行输出，而不是看着它从屏幕顶部滚动：

  ```terminal
  $> mysql < batch-file | more
  ```

- 您可以在文件中**捕获输出**以进行进一步处理：

  ```terminal
  $> mysql < batch-file > mysql.out
  ```

- 您可以将您的**脚本分发**给其他人，以便他们也可以运行这些语句。

- 某些情况不允许交互式使用，例如，当您从 **cron** 作业运行查询时。在这种情况下，您必须使用批处理模式。

以批处理模式运行 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 时，默认输出格式与交互使用时不同（更简洁） 。例如，交互式运行 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 时 `SELECT DISTINCT species FROM pet` 的输出如下所示 ：

```none
+---------+
| species |
+---------+
| bird    |
| cat     |
| dog     |
| hamster |
| snake   |
+---------+
```

在批处理模式下，输出看起来像这样：

```none
species
bird
cat
dog
hamster
snake
```

如果要以批处理模式获取**交互式输出格式**，请使用 [mysql -t](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)。要将执行的**语句回显**到输出，请使用 [mysql -v](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)。

您还可以使用 `source` 命令或  `\.` 命令从 [mysql](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) 提示符使用脚本：

```sql
mysql> source filename;
mysql> \. filename
```

有关详细信息，请参阅[第 4.5.1.5 节，“从文本文件执行 SQL 语句”](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html)。
