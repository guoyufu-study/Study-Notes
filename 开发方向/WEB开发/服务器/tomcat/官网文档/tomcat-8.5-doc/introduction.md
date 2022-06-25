## 介绍

> https://tomcat.apache.org/tomcat-8.5-doc/introduction.html

### 目录

[TOC]

### 介绍

对于管理员和 Web 开发人员来说，在开始之前，您应该熟悉一些重要的信息。本文档简要介绍了 Tomcat 容器背后的一些概念和术语。还有，当你需要帮助的时候去哪里。

### 术语

在阅读这些文档的过程中，您会遇到许多术语；一些特定于 Tomcat，而另一些则由 [Servlet 和 JSP 规范](https://cwiki.apache.org/confluence/display/TOMCAT/Specifications)定义。

- **Context 上下文**- 简而言之，上下文是一个 Web 应用程序。

这就对了。如果您发现我们需要添加到此部分的任何更多术语，请告诉我们。

### 目录和文件

这些是一些关键的 tomcat 目录：

- **`/bin`** - 启动、关闭和其他脚本。`*.sh` 文件（对于 Unix 系统）是 `*.bat` 文件（对于 Windows 系统）的功能副本。由于 Win32 命令行缺少某些功能，因此这里有一些附加文件。
- **`/conf`** - 配置文件和相关的 DTDs。这里最重要的文件是 `server.xml`。它是容器的主要配置文件。
- **`/logs`** - 默认情况下，日志文件在此处。
- **`/webapps`** - 这是你的 `webapps` 所在的地方。

### CATALINA_HOME 和 CATALINA_BASE

在整个文档中，都引用了以下两个属性：

- **CATALINA_HOME**：代表 Tomcat 安装的根目录，例如`/home/tomcat/apache-tomcat-9.0.10` 或`C:\Program Files\apache-tomcat-9.0.10`.
- **CATALINA_BASE**：表示特定 Tomcat 实例的运行时配置的根。如果您想在一台机器上拥有多个 Tomcat 实例，请使用该`CATALINA_BASE` 属性。

如果将属性设置为不同的位置，CATALINA_HOME 位置包含静态源，例如 `.jar` 文件或二进制文件。CATALINA_BASE 位置包含配置文件、日志文件、部署的应用程序和其他运行时要求。

#### 为什么使用 CATALINA_BASE

默认情况下，CATALINA_HOME 和 CATALINA_BASE 指向同一个目录。当您需要在一台机器上运行多个 Tomcat 实例时，手动设置 CATALINA_BASE。这样做有以下好处：

- 更容易管理升级到新版本的 Tomcat。由于具有单个 CATALINA_HOME 位置的所有实例共享一组 `.jar` 文件和二进制文件，因此您可以轻松地将文件升级到较新版本，并将更改传播到使用相同 CATALINA_HOME 目录的所有 Tomcat 实例。
- 避免重复相同的静态 `.jar` 文件。
- 共享某些设置的可能性，例如 `setenv` shell 或 bat 脚本文件（取决于您的操作系统）。

#### CATALINA_BASE 的内容

在开始使用 CATALINA_BASE 之前，首先考虑并创建 CATALINA_BASE 使用的目录树。请注意，如果您不创建所有推荐的目录，Tomcat 会自动创建这些目录。如果它无法创建必要的目录，例如由于权限问题，Tomcat 将无法启动，或者可能无法正常运行。

考虑以下目录列表：

- 包含 `setenv.sh`、 `setenv.bat` 和 `tomcat-juli.jar` 文件的 `bin` 目录。

  *推荐：*没有。

  *查找顺序：*首先检查 CATALINA_BASE；fallback 提供给 CATALINA_HOME。

- 在类路径中添加更多资源的 `lib` 目录。

  *推荐：*是的，如果您的应用程序依赖于外部库。

  *查找顺序：*首先检查 CATALINA_BASE；CATALINA_HOME 第二个加载。

- 特定于实例的日志文件的 `logs` 目录。

  *推荐：*是的。

- 自动加载的 Web 应用程序的`webapps`目录。

  *推荐：*是的，如果您想部署应用程序。

  *查找顺序：*仅限 CATALINA_BASE。

- 包含已部署 Web 应用程序的临时工作目录的 `work` 目录 。

  *推荐：*是的。

- JVM 用于存放临时文件的 `temp` 目录。

  *推荐：*是的。

我们建议您不要更改 `tomcat-juli.jar` 文件。但是，如果您需要自己的日志记录实现，您可以替换特定 Tomcat 实例的 CATALINA_BASE 位置中的 `tomcat-juli.jar` 文件。

我们还建议您将 `CATALINA_HOME/conf` 目录中的所有配置文件复制到 `CATALINA_BASE/conf/` 目录中。如果 CATALINA_BASE 中缺少配置文件，则不会回退到 CATALINA_HOME。因此，这可能导致失败。

CATALINA_BASE 至少必须包含：

- `conf/server.xml`
- `conf/web.xml`

这包括 `conf` 目录。否则，Tomcat 将无法启动，或无法正常运行。

有关高级配置信息，请参阅 [`RUNNING.txt` ](https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt)文件。

#### 如何使用 CATALINA_BASE

CATALINA_BASE 属性是一个环境变量。您可以在执行 Tomcat 启动脚本之前设置它，例如：

- 在 Unix 上：`CATALINA_BASE=/tmp/tomcat_base1 bin/catalina.sh start`
- 在 Windows 上：`CATALINA_BASE=C:\tomcat_base1 bin/catalina.bat start`



### 配置 Tomcat

本节将让您了解在容器配置过程中使用的基本信息。

配置文件中的所有信息都是在启动时读取的，这意味着对文件的任何更改都需要重新启动容器。

### 去哪里寻求帮助

尽管我们已尽最大努力确保这些文档的书写清晰且易于理解，但我们可能遗漏了一些东西。下面提供了各种网站和邮件列表，以防您遇到困难。

请记住，Tomcat 的主要版本之间存在一些问题和解决方案。当您在网上搜索时，将会有一些与 Tomcat 8 无关的文档，而仅与早期版本有关。

- 当前文档 - 大多数文档将列出潜在的挂断。请务必完整阅读相关文档，因为它将为您节省大量时间和精力。没有什么比在网上搜索却发现答案一直就在你面前更棒的了！
- [Tomcat 常见问题](https://cwiki.apache.org/confluence/display/TOMCAT/FAQ)
- [雄猫维基](https://cwiki.apache.org/confluence/display/TOMCAT/)
- [jGuru](http://www.jguru.com/faq/home.jsp?topic=Tomcat)上的 Tomcat 常见问题解答
- Tomcat 邮件列表存档 - 许多站点存档 Tomcat 邮件列表。由于链接会随时间变化，因此单击此处将搜索 [Google](https://www.google.com/search?q=tomcat+mailing+list+archives)。
- TOMCAT-USER 邮件列表，您可以在 [此处](https://tomcat.apache.org/lists.html)订阅。如果您没有得到回复，那么您的问题很可能在列表档案或常见问题解答之一中得到了回答。尽管有时会询问和回答有关 Web 应用程序开发的一般问题，但请将您的问题集中在 Tomcat 特定的问题上。
- TOMCAT-DEV 邮件列表，您可以在 [此处](https://tomcat.apache.org/lists.html)订阅。此列表 **保留**用于讨论 Tomcat 本身的开发。有关 Tomcat 配置的问题，以及您在开发和运行应用程序时遇到的问题，通常更适合放在 TOMCAT-USER 列表中。

而且，如果您认为文档中应该包含某些内容，请务必在 TOMCAT-DEV 列表中告诉我们。