### Apache Tomcat 版本

> https://tomcat.apache.org/whichversion.html

Apache Tomcat ® 是 Jakarta EE（以前称为 Java EE）技术子集的开源软件实现。不同版本的 Apache Tomcat 可用于不同版本的规范。[规范](https://cwiki.apache.org/confluence/display/TOMCAT/Specifications)和各自的 Apache Tomcat 版本之间的映射是：

| **Servlet 规范** | **JSP 规范** | **EL规范** | **WebSocket 规范** | **身份验证 (JASPIC) 规范** | **Apache Tomcat 版本** | **最新发布的版本**   | **支持的 Java 版本**                       |
| :--------------- | :----------- | :--------- | :----------------- | :------------------------- | :--------------------- | :------------------- | :----------------------------------------- |
| 6.0              | 3.1          | 5.0        | 2.1                | 3.0                        | 10.1.x                 | 10.1.0-M16（测试版） | 11 及以后                                  |
| 5.0              | 3.0          | 4.0        | 2.0                | 2.0                        | 10.0.x                 | 10.0.22              | 8 及以后                                   |
| 4.0              | 2.3          | 3.0        | 1.1                | 1.1                        | 9.0.x                  | 9.0.64               | 8 及以后                                   |
| 3.1              | 2.3          | 3.0        | 1.1                | 1.1                        | 8.5.x                  | 8.5.81               | 7 及以后                                   |
| 3.1              | 2.3          | 3.0        | 1.1                | 不适用                     | 8.0.x（被取代）        | 8.0.53（被取代）     | 7 及以后                                   |
| 3.0              | 2.2          | 2.2        | 1.1                | 不适用                     | 7.0.x（存档）          | 7.0.109（存档）      | 6 及更高版本 （WebSocket 为 7 及更高版本） |
| 2.5              | 2.1          | 2.1        | 不适用             | 不适用                     | 6.0.x（存档）          | 6.0.53（存档）       | 5 及以后                                   |
| 2.4              | 2.0          | 不适用     | 不适用             | 不适用                     | 5.5.x（存档）          | 5.5.36（存档）       | 1.4 及更高版本                             |
| 2.3              | 1.2          | 不适用     | 不适用             | 不适用                     | 4.1.x（存档）          | 4.1.40（存档）       | 1.3 及更高版本                             |
| 2.2              | 1.1          | 不适用     | 不适用             | 不适用                     | 3.3.x（存档）          | 3.3.2（存档）        | 1.1 及更高版本                             |

任何满足上表最后一列要求的稳定 Java 版本都支持每个版本的 Tomcat。

Tomcat 还应该适用于满足上表中最后一列要求的任何 Java 早期访问版本。例如，在第一个稳定的 Java 8 发布之前的几个月，用户就在 Java 8 上成功运行了 Tomcat 8。但是，早期访问版本的用户应注意以下事项：

- 最初的早期访问版本包含可能导致在 Tomcat 上运行的 Web 应用程序出现问题的错误并不罕见。
- 如果新的 Java 版本引入了新的语言特性，那么默认的 JSP 编译器可能不会立即支持它们。将 JSP 编译器切换到 javac 可以使这些新的语言特性能够在 JSP 中使用。
- 如果您在使用 Java 早期访问版本时发现问题，请 [寻求帮助](https://tomcat.apache.org/findhelp.html)。Tomcat 用户的邮件列表可能是最好的起点。

下面对这些版本进行了更详细的描述，以帮助您确定哪个版本适合您。可以在相关的发行说明中找到有关每个版本的更多详细信息。

请注意，尽管我们提供旧版本的下载和文档，例如 Apache Tomcat 7.x，但我们**强烈建议用户尽可能使用最新的稳定版本的 Apache Tomcat**。我们认识到，跨主要版本的升级可能不是一件容易的事，并且仍然在邮件列表中为旧版本的用户提供一些支持。但是，由于社区驱动的支持方法，您的版本越旧，感兴趣或能够支持您的人就越少。

### Alpha / Beta / Stable

在为发布投票时，审阅者会指定他们认为发布已达到的稳定性级别。新主要版本的初始版本通常在几个月的时间内从 Alpha 到 Beta 到 Stable。但是，只有在发布实现的 Java 规范最终确定后，才能使用稳定级别。这意味着在所有其他方面都被认为是稳定的版本，如果规范不是最终的，仍可能被标记为 Beta。

下载页面将始终显示最新的稳定版本和任何较新的 Alpha 或 Beta 版本（如果存在）。Alpha 和 Beta 版本始终在下载页面上清楚地标明。

稳定性是一种主观判断，您应该始终仔细阅读您打算使用的任何版本的发行说明。如果您是某个版本的早期采用者，我们很乐意听到您对其稳定性的意见，作为投票的一部分：它发生在[开发邮件列表中](https://tomcat.apache.org/lists.html)。

**Alpha** 版本可能包含规范要求的大量未经测试/缺失的功能和/或重大错误，并且预计不会在任何时间段内稳定运行。

**Beta** 版本可能包含一些未经测试的功能和/或一些相对较小的错误。Beta 版本预计不会稳定运行。

**Stable** 版本可能包含少量相对较小的错误。稳定版本旨在用于生产用途，并有望在较长时间内稳定运行。

### Apache Tomcat 10.1.x

**Apache Tomcat 10.1.x** 是当前的开发重点。它基于 Tomcat 10.0.x 构建，并实现了**Servlet 6.0**、**JSP TBD**、**EL TBD**、**WebSocket TBD** 和**Authentication TBD** 规范（Jakarta EE 10 平台所需的版本）。

### Apache Tomcat 10.0.x

**Apache Tomcat 10.0.x** 基于 Tomcat 9.0.x 构建，并实现了**Servlet 5.0**、**JSP 3.0**、 **EL 4.0**、**WebSocket 2.0**和 **Authentication 2.0**规范（Jakarta EE 9 平台所需的版本）。

### Apache Tomcat 9.x

**Apache Tomcat 9.x** 建立在 Tomcat 8.0.x 和 8.5.x 之上，并实现了**Servlet 4.0**、**JSP 2.3**、 **EL 3.0**、**WebSocket 1.1**和 **JASPIC 1.1**规范（Java EE 8 平台所需的版本）。除此之外，它还包括以下重大改进：

- 添加对 HTTP/2 的支持（需要在 Java 9 上运行（自 Apache Tomcat 9.0.0.M18 起）或安装[Tomcat Native](https://tomcat.apache.org/native-doc/)库）
- 通过 JSSE 连接器（NIO 和 NIO2）添加对使用 OpenSSL 的 TLS 支持的支持
- 添加对 TLS 虚拟主机 (SNI) 的支持

### Apache Tomcat 8.x

**Apache Tomcat 8.0.x** 基于 Tomcat 7.0.x 构建，并实现了 **Servlet 3.1**、**JSP 2.3**、**EL 3.0** 和**WebSocket 1.1**规范。除此之外，它还包括以下重大改进：

- 用于替换早期版本中提供的多个资源扩展功能的单个通用资源实现。

**Apache Tomcat 8.5.x** 支持与 Apache Tomcat 8.0.x 相同的 Servlet、JSP、EL 和 WebSocket 规范版本。除此之外，它还实现了**JASPIC 1.1** 规范。

它创建于 2016 年 3 月，作为 Tomcat 9.0.0.M4（alpha）里程碑版本的一个分支。它提供来自 Tomcat 9.x 代码库的 HTTP/2 支持和其他功能，同时兼容 Tomcat 8.0 运行时和规范要求。（当时无法创建 Tomcat 9.0 的稳定版本，因为 Tomcat 9 所针对的 Java EE 规范仅在几年后才最终确定）。

Tomcat 8.5 被认为是 Tomcat 8.0 的替代品。有关迁移到 Tomcat 8.5 的指导，请参阅 [迁移指南](https://tomcat.apache.org/migration.html)。

Apache Tomcat 8.5.x 包括以下重大改进：

- 添加对 HTTP/2 的支持（需要[Tomcat Native](https://tomcat.apache.org/native-doc/)库）
- 通过 JSSE 连接器（NIO 和 NIO2）添加对使用 OpenSSL 的 TLS 支持的支持
- 添加对 TLS 虚拟主机 (SNI) 的支持

Apache Tomcat 8.5.x 中删除了以下技术：

- HTTP 和 AJP 连接器的 BIO 实现
- 支持彗星API

引擎盖下的许多领域都发生了重大变化，从而提高了性能、稳定性和总拥有成本。有关详细信息，请参阅 Apache Tomcat 8.5 变更日志。

Tomcat 8.0 的用户应该知道 Tomcat 8.0 现已 [结束生命周期](https://tomcat.apache.org/tomcat-80-eol.html)。Tomcat 8.0.x 的用户应升级到 Tomcat 8.5.x 或更高版本。

### Apache Tomcat 7.x

**Apache Tomcat 7.x**建立在 Tomcat 6.0.x 的改进基础之上，并实现了**Servlet 3.0**、 **JSP 2.2**、**EL 2.2**和 **WebSocket 1.1**规范。除此之外，它还包括以下改进：

- Web 应用程序内存泄漏检测和预防
- 提高了 Manager 和 Host Manager 应用程序的安全性
- 通用 CSRF 保护
- 支持在 Web 应用程序中直接包含外部内容
- 重构（连接器、生命周期）和大量内部代码清理

Tomcat 7 的用户应该知道 Tomcat 7 现已 [结束生命周期](https://tomcat.apache.org/tomcat-70-eol.html)。Tomcat 7.x 的用户应升级到 Tomcat 8.5.x 或更高版本。

### Apache Tomcat 6.x

**Apache Tomcat 6.x**建立在 Tomcat 5.5.x 的改进基础之上，并实现了**Servlet 2.5**和 **JSP 2.1**规范。除此之外，它还包括以下改进：

- 内存使用优化
- 先进的 IO 能力
- 重构聚类

Tomcat 6 的用户应该知道 Tomcat 6 现在已经到 [了生命周期的尽头](https://tomcat.apache.org/tomcat-60-eol.html)。Tomcat 6.x 的用户应升级到 Tomcat 7.x 或更高版本。

### Apache Tomcat 5.x

**Apache Tomcat 5.x**可以从档案中下载。

**Apache Tomcat 5.5.x**支持与 Apache Tomcat 5.0.x 相同的 Servlet 和 JSP 规范版本。引擎盖下的许多领域都发生了重大变化，从而提高了性能、稳定性和总拥有成本。有关详细信息，请参阅 Apache Tomcat 5.5 变更日志。

**Apache Tomcat 5.0.x**在许多方面对 Apache Tomcat 4.1 进行了改进，包括：

- 性能优化和减少垃圾收集
- 重构的应用程序部署器，带有一个可选的独立部署器，允许在将 Web 应用程序投入生产之前对其进行验证和编译
- 使用 JMX 和管理器 Web 应用程序完成服务器监控
- 可扩展性和可靠性增强
- 改进的 Taglibs 处理，包括高级池和标签插件
- 改进的平台集成，带有原生 Windows 和 Unix 包装器
- 使用 JMX 嵌入
- 增强的安全管理器支持
- 集成会话集群
- 扩展文档

Tomcat 5 的用户应该知道 Tomcat 5 现在已经到 [了生命的尽头](https://tomcat.apache.org/tomcat-55-eol.html)。Tomcat 5.x 的用户应升级到 Tomcat 7.x 或更高版本。

### Apache Tomcat 4.x

**Apache Tomcat 4.x**可以从档案中下载。

**Apache Tomcat 4.x**实现了一个基于全新架构的新 servlet 容器（称为 Catalina）。4.x 版本实现了**Servlet 2.3**和**JSP 1.2** 规范。

**Apache Tomcat 4.1.x**是对 Apache Tomcat 4.0.x 的重构，包含重要的增强功能，包括：

- 基于 JMX 的管理功能
- 基于 JSP 和 Struts 的管理 Web 应用程序
- 新的 Coyote 连接器（HTTP/1.1、AJP 1.3 和 JNI 支持）
- 重写 Jasper JSP 页面编译器
- 性能和内存效率改进
- 增强的管理器应用程序支持与开发工具集成
- 直接从 build.xml 脚本与管理器应用程序交互的自定义 Ant 任务

**Apache Tomcat 4.0.x**。Apache Tomcat 4.0.6 是旧的生产质量版本。4.0 servlet 容器 (Catalina) 是为了灵活性和性能而从头开始开发的。4.0 版实现了 Servlet 2.3 和 JSP 1.2 规范的最终发布版本。根据规范的要求，Apache Tomcat 4.0 还支持为 Servlet 2.2 和 JSP 1.1 规范构建的 Web 应用程序，无需更改。

Tomcat 4 的用户应该知道 Tomcat 4 现已结束生命周期。Tomcat 4.x 的用户应升级到 Tomcat 7.x 或更高版本。

### Apache Tomcat 3.x

**Apache Tomcat 3.x**可以从档案中下载。

- 版本**3.3**是 Servlet 2.2 和 JSP 1.1 规范的当前生产质量版本。Apache Tomcat 3.3 是 Apache Tomcat 3.x 架构的最新延续；它比 3.2.4 更先进，这是“旧”的生产质量版本。
- 版本 3.2.4 是“旧”生产质量版本，现在处于仅维护模式。
- 版本 3.1.1 是旧版本。

所有**Apache Tomcat 3.x**版本都可以追溯到 Sun 捐赠给 Apache 软件基金会的原始 Servlet 和 JSP 实现。3.x 版本都实现了**Servlet 2.2**和**JSP 1.1**规范。

**Apache Tomcat 3.3.x**。版本 3.3.2 是当前的生产质量版本。它继续从 3.2 版开始的重构，并将其推向合乎逻辑的结论。3.3 版提供了更加模块化的设计，并允许通过添加和删除控制 servlet 请求处理的模块来自定义 servlet 容器。此版本还包含许多性能改进。

**Apache Tomcat 3.2.x**。自 3.1 以来，3.2 版添加了一些新功能；主要工作是重构内部结构以提高性能和稳定性。3.2.1 版本与 3.1.1 一样，是一个安全补丁。版本 3.2.2 修复了大量错误和所有已知的规范合规性问题。版本 3.2.3 是一个安全更新，可以关闭一个严重的安全漏洞。版本 3.2.4 是一个小错误修复版本。Apache Tomcat 3.2.3 之前版本的所有用户都应该尽快升级。除了对关键安全相关错误的修复外，Apache Tomcat 3.2.x 分支的开发已停止。

**Apache Tomcat 3.1.x**。3.1 版本包含对 Apache Tomcat 3.0 的多项改进，包括 servlet 重新加载、WAR 文件支持以及为 IIS 和 Netscape Web 服务器添加的连接器。最新的维护版本 3.1.1 包含对安全问题的修复。Apache Tomcat 3.1.x 没有正在进行的积极开发。Apache Tomcat 3.1 的用户应更新到 3.1.1 以消除安全漏洞，强烈建议他们迁移到当前的生产版本 Apache Tomcat 3.3。

**Apache Tomcat 3.0.x**。初始 Apache Tomcat 版本。

Tomcat 3 的用户应该知道 Tomcat 3 现在已经到了生命的尽头。Tomcat 3.x 的用户应升级到 Tomcat 7.x 或更高版本。