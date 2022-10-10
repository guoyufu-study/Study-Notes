## Java 的简单日志门面 (SLF4J)

### 简介

Java 的简单日志门面 (SLF4J) 用作各种日志框架（例如 java.util.logging、logback、log4j）的简单外观或抽象，允许最终用户在*部署* 时插入所需的日志框架。

在开始使用 SLF4J 之前，我们强烈建议您阅读两页的[SLF4J 用户手册](https://www.slf4j.org/manual.html)。

请注意，启用 SLF4J 的库意味着**仅添加一个强制依赖项**，即*slf4j-api.jar*。如果在类路径上没有找到绑定/提供者，那么 SLF4J 将**默认为无操作实现**。

如果您希望**将 Java 源文件迁移到 SLF4J**，请考虑使用我们的[迁移工具](https://www.slf4j.org/migrator.html)，它可以在几分钟内迁移您的项目以使用 SLF4J API。

如果您依赖的外部维护组件使用 SLF4J 以外的日志记录 API，例如 commons logging、log4j 或 java.util.logging，请查看 SLF4J 对[遗留 API](https://www.slf4j.org/legacy.html)的二进制支持。

### 下载

#### 稳定版

SLF4J 当前稳定且积极开发的版本是 2.0.0。

#### 较旧的稳定版本（不活跃）

较旧的稳定 SLF4J 版本是1.7.36。它不再积极开发。

### 文档

鉴于 SLF4J 的体积小，它的文档不是很长。

- [用户手册](https://www.slf4j.org/manual.html)
- [FAQ](https://www.slf4j.org/faq.html)
- [SLF4J 错误信息](https://www.slf4j.org/codes.html)
- [桥接遗留 API](https://www.slf4j.org/legacy.html)
- [SLF4J 迁移器](https://www.slf4j.org/migrator.html)
- [关于 CVE-2021-44228 漏洞的评论](https://www.slf4j.org/log4shell.html)
- [SLF4J 扩展](https://www.slf4j.org/extensions.html)
- [本地化/内部化支持](https://www.slf4j.org/localization.html)
- [文档](https://www.slf4j.org/apidocs/index.html)
- [源](https://www.slf4j.org/xref/index.html), [测试源](https://www.slf4j.org/xref-test/index.html)