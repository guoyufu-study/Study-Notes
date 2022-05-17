## 标准目录布局简介

> https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html#introduction-to-the-standard-directory-layout

拥有一个通用的目录布局可以让熟悉一个 Maven 项目的用户立即在另一个 Maven 项目中感到宾至如归。这些优点类似于采用站点范围的外观（site-wide look-and-feel）。

下一节记录了 Maven 预期的目录布局和 Maven 创建的目录布局。尽量符合这个结构。但是，如果您做不到，这些设置可以通过项目描述符覆盖。

| 目录                   | 说明              |
| -------------------- | --------------- |
| `src/main/java`      | 应用程序/库的源        |
| `src/main/resources` | 应用程序/库的资源       |
| `src/main/filters`   | 资源过滤器文件         |
| `src/main/webapp`    | Web 应用程序的源      |
| `src/test/java`      | 测试的源            |
| `src/test/resources` | 测试的资源           |
| `src/test/filters`   | 测试资源过滤器文件       |
| `src/it`             | 集成测试（主要用于插件）    |
| `src/assembly`       | 装配描述符           |
| `src/site`           | 站点              |
| `LICENSE.txt`        | 项目许可证           |
| `NOTICE.txt`         | 项目所依赖的库所需的通知和属性 |
| `README.txt`         | 项目自述文件          |

在顶层，描述项目的文件：一个 `pom.xml` 文件。此外，还有一些文本文档可供用户在收到源文件后立即阅读：`README.txt`、`LICENSE.txt` 等。

这个结构只有两个子目录：`src` 和 `target`。此处预期的唯一其他目录是元数据，如`CVS`,`.git`或`.svn`，以及多项目构建中的任何子项目（每个子项目都将如上所示）。

`target` 目录用于存放构建的所有输出。

`src` 目录包含用于构建项目的所有源材料，其站点等。它包含每种类型的子目录：`main`主要构建工件、`test`单元测试代码和资源、`site`等。

在工件生成源目录（即`main`和`test`）中，有一个目录用于语言`java`（在其下存在正常的包层次结构），一个用于`resources`（在给定默认资源定义的情况下复制到目标类路径的结构）。

如果工件构建中有其他贡献源，它们将位于其他子目录下。比如`src/main/antlr`将包含 Antlr 语法定义文件。
