# jar 命令

> https://docs.oracle.com/en/java/javase/18/docs/specs/man/jar.html

## 名称

jar - 为类和资源创建归档，并从归档中操作或恢复单个类或资源

## 概要

`jar` [*OPTION* ...] [ [`--release` *VERSION*] [`-C` *`dir`*] *files*] ...

## 描述

这个 `jar` 命令是**基于 ZIP 和 ZLIB 压缩格式的通用归档和压缩工具**。最初，`jar` 命令旨在打包 Java applets（自 JDK 11 起不支持）或应用程序；但是，从 JDK 9 开始，用户可以使用 `jar` 命令创建模块化 JAR。对于传输和部署，通常更方便的做法是将模块打包为模块化 JAR 。

`jar` 命令的**语法**类似于 `tar` 命令的语法。它有几种主要的操作模式，由强制操作参数之一定义。其他参数要么是修改操作行为的选项，要么是执行操作所必需的。

当一个应用程序的模块或组件（文件、图像和声音）被组合到一个单一的归档中时，它们可以由 Java 代理（如浏览器）在一个单一的 HTTP 事务中下载，而不需要为每个部分建立新的连接。这极大地缩短了下载时间。`jar` 命令还可以压缩文件，从而进一步**缩短下载时间**。`jar` 命令还**允许对文件中的各个条目进行签名**，以便对其来源进行身份验证。无论是否被压缩，JAR 文件都**可以用作类路径条目**。

当您在给定目录的根目录或 `.jar` 归档文件的根目录中包含模块描述符 `module-info.class` 时，归档就变成了模块化 JAR。[仅在创建和更新模式下有效的操作修饰符](https://docs.oracle.com/en/java/javase/18/docs/specs/man/jar.html#operation-modifiers-valid-only-in-create-and-update-modes)中描述的以下操作仅在创建或更新模块化 jar 或更新现有非模块化 jar 时有效：

- `--module-version`
- `--hash-modules`
- `--module-path`

**Note:**

长选项的所有强制或可选参数对于任何相应的短选项也是强制或可选的。

## 主要操作模式

使用 `jar` 命令时，您必须指定它要执行的操作。您可以通过包含本节中描述的适当操作参数来指定 `jar` 命令的操作模式。您可以将操作参数与其他单字母选项混合使用。通常操作参数是命令行中指定的第一个参数。

- `-c` 或者 `--create`

  创建存档。

- `-i=`*FILE* 或者 `--generate-index=`*FILE*

  为指定的 JAR 文件生成索引信息。

- `-t` 或者 `--list`

  列出存档的目录。

- `-u` 或者 `--update`

  更新现有的 JAR 文件。

- `-x` 或者 `--extract`

  从存档中提取指定的（或所有）文件。

- `-d` 或者 `--describe-module`

  打印模块描述符或自动模块名称。

## 操作修饰符在任何模式下都有效

您可以使用以下选项自定义 `jar` 命令中包含的任何操作模式的操作。

- `-C` *DIR*

  更改指定目录，并包括在命令行末尾指定的*文件*。

  `jar` [*OPTION* ...] [ [`--release` *VERSION*] [`-C` *dir*] *files*]

- `-f=`*FILE* 或者 `--file=` *FILE*

  指定归档文件名。

- `--release` *VERSION*

  创建一个多版本 JAR 文件。将选项后指定的所有文件放入名为 `META-INF/versions/`*VERSION*`/` 的 JAR 文件的版本化目录中，其中 *VERSION* 必须是一个正整数，其值为 9 或更大。

  在运行时，如果 JAR 中存在多个版本的类，JDK 将使用它找到的第一个版本，首先在目录树中搜索其*版本*号与 JDK 的主要版本号匹配的目录树。然后它将查找*VERSION*编号依次较低的目录，最后查找 JAR 的根目录。

- `-v` 或者 `--verbose`

  将详细输出发送或打印到标准输出。

## 操作修饰符仅在创建和更新模式下有效

您可以使用以下选项自定义创建和更新主要操作模式的操作：

- `-e=`*CLASSNAME* 或者 `--main-class=`*CLASSNAME*

  指定捆绑到模块化或可执行模块化 JAR 文件中的独立应用程序的应用程序入口点。

- `-m=`*FILE* 或者 `--manifest=`*FILE*

  包括来自给定清单文件的清单信息。

- `-M` 或者 `--no-manifest`

  不为条目创建清单文件。

- `--module-version=`*VERSION*

  在创建或更新模块化 JAR 文件或更新非模块化 JAR 文件时指定模块版本。

- `--hash-modules=`*PATTERN*

  计算并记录与给定模式匹配的模块的哈希值，这些模块直接或间接依赖于正在创建的模块化 JAR 文件或正在更新的非模块化 JAR 文件。

- `-p` 或者 `--module-path`

  指定生成散列的模块依赖的位置。

- `@`*file*

  从文本文件中读取`jar`选项和文件名。

## 操作修饰符仅在创建、更新和生成索引模式下有效

您可以使用以下选项自定义创建（`-c`或`--create`）更新（`-u`或`--update`）和生成索引（`-i`或`--generate-index=`*FILE*）主要操作模式的操作：

- `-0` 或 `--no-compress`

  不使用 ZIP 压缩存储。

## 其他选项

`jar` 命令可识别以下选项，但不与操作模式一起使用：

- `-h` 或者 `--help`[`:compat`]

  显示 `jar` 命令的命令行帮助或可选的兼容性帮助。

- `--help-extra`

  显示额外选项的帮助。

- `--version`

  打印程序版本。

## jar 命令语法示例

- 创建一个归档， `classes.jar`，包含两个类文件，`Foo.class` 和 `Bar.class`。

  > `jar --create --file classes.jar Foo.class Bar.class`

- 创建一个归档，`classes.jar`，使用现有的清单，`mymanifest`， 其中包含 `foo/` 中的所有文件。

  > `jar --create --file classes.jar --manifest mymanifest -C foo/`

- 创建一个模块化 JAR 归档文件 ，`foo.jar`，其中模块描述符位于 `classes/module-info.class`。

  > `jar --create --file foo.jar --main-class com.foo.Main --module-version 1.0 -C foo/classes resources`

- 将现有的非模块化 JAR ， `foo.jar`，更新为模块化 JAR 文件。

  > `jar --update --file foo.jar --main-class com.foo.Main --module-version 1.0 -C foo/module-info.class`

- 创建一个版本化或多版本 JAR，`foo.jar`，将文件放在 JAR 的根目录下的 `classes` 目录中，并将 `classes-10` 目录中的文件放在 JAR 的 `META-INF/versions/10` 目录中。

  在此示例中，`classes/com/foo`目录包含两个类 `com.foo.Hello` （入口点类）和 `com.foo.NameProvider`，它们都是为 JDK 8 编译的。`classes-10/com/foo` 目录包含 `com.foo.NameProvider` 类的不同版本，该版本包含 JDK 10 特定代码并为 JDK 10 编译。

  在此设置下，在包含目录 `classes` 和 `classes-10` 的目录中运行以下命令，创建一个多版本 JAR 文件 `foo.jar`。

  > `jar --create --file foo.jar --main-class com.foo.Hello -C classes . --release 10 -C classes-10 .`

  JAR 文件 `foo.jar` 现在包含：

  ```
  % jar -tf foo.jar
  
  META-INF/
  META-INF/MANIFEST.MF
  com/
  com/foo/
  com/foo/Hello.class
  com/foo/NameProvider.class
  META-INF/versions/10/com/
  META-INF/versions/10/com/foo/
  META-INF/versions/10/com/foo/NameProvider.class
  ```

  除了其他信息，文件 `META-INF/MANIFEST.MF` 将包含以下行，以表明这是一个多版本 JAR 文件，其入口点为 `com.foo.Hello`。

  ```
  ...
  Main-Class: com.foo.Hello
  Multi-Release: true
  ```

  假设 `com.foo.Hello` 类调用类上的方法 `com.foo.NameProvider`，使用 JDK 10 运行程序将确保`com.foo.NameProvider` 类是在 `META-INF/versions/10/com/foo/`中的那个。使用 JDK 8 运行程序将确保 `com.foo.NameProvider` 类是在 JAR 根目录中的`com/foo` 中的类。

- 创建一个归档，`my.jar`，通过从文件 `classes.list` 中读取选项和类文件列表创建。

  **Note:**

  为了缩短或简化 `jar` 命令，您可以在一个单独的文本文件中指定参数，并将其传递给 `jar` 命令，并使用 at 符号（ `@`）作为前缀。

  > `jar --create --file my.jar @classes.list`