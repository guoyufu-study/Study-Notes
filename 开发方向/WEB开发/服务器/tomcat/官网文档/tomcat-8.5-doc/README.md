# Apache Tomcat 8.5

> https://tomcat.apache.org/tomcat-8.5-doc/index.html

## 文献索引

### 介绍

这是 **Apache Tomcat** Servlet/JSP 容器的文档包的顶级入口点 。Apache Tomcat 8.5 版实现了来自 [Java Community Process](https://www.jcp.org/) 的 Servlet 3.1 和 JavaServer Pages 2.3 [规范](https://cwiki.apache.org/confluence/display/TOMCAT/Specifications)，并包含许多附加功能，使其成为开发和部署 Web 应用程序和 Web 服务的有用平台。

从导航菜单（左侧）中选择一个链接以深入了解可用的更详细文档。下面更详细地描述了每个可用的手册。

### Apache Tomcat 用户指南

以下文档将帮助您下载和安装 Apache Tomcat，以及使用许多 Apache Tomcat 功能。

1. [**简介**](开发方向/WEB开发/服务器/tomcat/官网文档/tomcat-8.5-doc/introduction.md)- Apache Tomcat 的简要、高级概述。
2. [**设置**](https://tomcat.apache.org/tomcat-8.5-doc/setup.html)- 如何在各种平台上安装和运行 Apache Tomcat。
3. [**第一个 Web 应用程序**](开发方向/WEB开发/服务器/tomcat/官网文档/tomcat-8.5-doc/appdev/) - 介绍 Servlet 规范中定义的 *Web 应用程序*的概念。涵盖 Web 应用程序源代码树的基本组织、Web 应用程序存档的结构以及 Web 应用程序部署描述符 (`/WEB-INF/web.xml`) 的介绍。
4. [**Deployer**](https://tomcat.apache.org/tomcat-8.5-doc/deployer-howto.html) - 操作 Apache Tomcat Deployer 来部署、预编译和验证 Web 应用程序。
5. [**Manager**](https://tomcat.apache.org/tomcat-8.5-doc/manager-howto.html) - 在 Apache Tomcat 运行时操作 **Manager** Web 应用程序以部署、取消部署和重新部署应用程序。
6. [**主机管理器**](https://tomcat.apache.org/tomcat-8.5-doc/host-manager-howto.html)- 运行**主机管理器**Web 应用程序以在 Apache Tomcat 运行时添加和删除虚拟主机。
7. [**领域和访问控制**](https://tomcat.apache.org/tomcat-8.5-doc/realm-howto.html) - 描述如何配置*领域*（用户、密码及其相关角色的数据库）以用于利用*容器管理安全*的 Web 应用程序。
8. [**安全管理器**](https://tomcat.apache.org/tomcat-8.5-doc/security-manager-howto.html) - 配置和使用 Java 安全管理器以支持对 Web 应用程序行为的细粒度控制。
9. [**JNDI 资源**](https://tomcat.apache.org/tomcat-8.5-doc/jndi-resources-howto.html) - 在提供给每个 Web 应用程序的 JNDI 命名上下文中配置标准和自定义资源。
10. [**JDBC 数据源**](https://tomcat.apache.org/tomcat-8.5-doc/jndi-datasource-examples-howto.html) - 使用数据库连接池配置 JNDI 数据源。许多流行数据库的示例。
11. [**类加载**](https://tomcat.apache.org/tomcat-8.5-doc/class-loader-howto.html) - 有关 Apache Tomcat 中类加载的信息，包括放置应用程序类的位置以便它们可见。
12. [**JSP**](https://tomcat.apache.org/tomcat-8.5-doc/jasper-howto.html) - 有关 Jasper 配置的信息，以及 JSP 编译器的使用。
13. [**SSL/TLS**](https://tomcat.apache.org/tomcat-8.5-doc/ssl-howto.html) - 安装和配置 SSL/TLS 支持，以便您的 Apache Tomcat 使用该`https`协议服务请求。
14. [**SSI**](https://tomcat.apache.org/tomcat-8.5-doc/ssi-howto.html) - 在 Apache Tomcat 中使用服务器端包含。
15. [**CGI**](https://tomcat.apache.org/tomcat-8.5-doc/cgi-howto.html) - 将 CGI 与 Apache Tomcat 一起使用。
16. [**代理支持**](https://tomcat.apache.org/tomcat-8.5-doc/proxy-howto.html)- 将 Apache Tomcat 配置为在代理服务器（或充当代理服务器的 Web 服务器）后面运行。
17. [**MBeans Descriptors**](https://tomcat.apache.org/tomcat-8.5-doc/mbeans-descriptors-howto.html) - 为自定义组件配置 MBean 描述符文件。
18. [**默认 Servlet**](https://tomcat.apache.org/tomcat-8.5-doc/default-servlet.html) - 配置默认 servlet 并自定义目录列表。
19. [**Apache Tomcat 集群**](https://tomcat.apache.org/tomcat-8.5-doc/cluster-howto.html)- 在 Apache Tomcat 环境中启用会话复制。
20. [**Balancer**](https://tomcat.apache.org/tomcat-8.5-doc/balancer-howto.html) - 配置、使用和扩展负载均衡器应用程序。
21. [**连接器**](https://tomcat.apache.org/tomcat-8.5-doc/connectors.html)- Apache Tomcat 中可用的连接器，以及本机 Web 服务器集成。
22. [**监控和管理**](https://tomcat.apache.org/tomcat-8.5-doc/monitoring.html)- 启用 JMX 远程支持，并使用工具监控和管理 Apache Tomcat。
23. [**日志记录**](https://tomcat.apache.org/tomcat-8.5-doc/logging.html)- 在 Apache Tomcat 中配置日志记录。
24. [**Apache Portable Runtime**](https://tomcat.apache.org/tomcat-8.5-doc/apr.html) - 使用 APR 提供卓越的性能、可扩展性以及与本机服务器技术的更好集成。
25. [**虚拟主机**](https://tomcat.apache.org/tomcat-8.5-doc/virtual-hosting-howto.html)- 在 Apache Tomcat 中配置虚拟主机。
26. [**高级 IO**](https://tomcat.apache.org/tomcat-8.5-doc/aio.html) - 可通过常规阻塞 IO 获得的扩展。
27. [**附加组件**](https://tomcat.apache.org/tomcat-8.5-doc/extras.html)- 获取附加的可选组件。
28. [**Using Tomcat library with Maven**](https://tomcat.apache.org/tomcat-8.5-doc/maven-jars.html) - 通过 Maven 获取 Tomcat jars。
29. [**安全注意事项**](https://tomcat.apache.org/tomcat-8.5-doc/security-howto.html)- 保护 Apache Tomcat 安装时要考虑的选项。
30. [**Windows 服务**](https://tomcat.apache.org/tomcat-8.5-doc/windows-service-howto.html)- 在 Microsoft Windows 上将 Tomcat 作为服务运行。
31. [**Windows 身份验证**](https://tomcat.apache.org/tomcat-8.5-doc/windows-auth-howto.html)- 将 Tomcat 配置为使用集成的 Windows 身份验证。
32. [**高并发 JDBC 池**](https://tomcat.apache.org/tomcat-8.5-doc/jdbc-pool.html)- 配置 Tomcat 以使用备用 JDBC 池。
33. [**WebSocket 支持**](https://tomcat.apache.org/tomcat-8.5-doc/web-socket-howto.html)- 为 Apache Tomcat 开发 WebSocket 应用程序。
34. [**URL 重写**](https://tomcat.apache.org/tomcat-8.5-doc/rewrite.html)- 使用基于正则表达式的重写阀进行条件 URL 和主机重写。

### 参考

以下文档面向负责安装、配置和操作 Apache Tomcat 服务器的*系统管理员*。

- [**发行说明**](https://tomcat.apache.org/tomcat-8.5-doc/RELEASE-NOTES.txt) - 此 Apache Tomcat 发行版中的已知问题。
- [**Apache Tomcat 服务器配置参考**](https://tomcat.apache.org/tomcat-8.5-doc/config/index.html) - 记录所有可用元素和属性的参考手册，这些元素和属性可以放置在 Apache Tomcat `conf/server.xml` 文件中。
- [**JK 文档**](https://tomcat.apache.org/connectors-doc/index.html) - JK 本机 Web 服务器连接器上的完整文档和 HOWTO，用于将 Apache Tomcat 与 Apache HTTPd、IIS 等服务器连接。
- Servlet 3.1 [**规范**](http://jcp.org/aboutJava/communityprocess/final/jsr340/index.html)和 [**Javadoc**](http://docs.oracle.com/javaee/7/api/javax/servlet/package-summary.html)
- JSP 2.3 [**规范**](https://jcp.org/aboutJava/communityprocess/mrel/jsr245/index2.html)和 [**Javadoc**](http://docs.oracle.com/javaee/7/api/javax/servlet/jsp/package-summary.html)
- EL 3.0 [**规范**](https://jcp.org/aboutJava/communityprocess/final/jsr341/index.html)和 [**Javadoc**](http://docs.oracle.com/javaee/7/api/javax/el/package-summary.html)
- WebSocket 1.1 [**规范**](https://jcp.org/aboutJava/communityprocess/mrel/jsr356/index.html)和 [**Javadoc**](http://docs.oracle.com/javaee/7/api/javax/websocket/package-summary.html)
- JASPIC 1.1 [**规范**](https://jcp.org/aboutJava/communityprocess/mrel/jsr196/index.html)和 [**Javadoc**](http://docs.oracle.com/javaee/7/api/javax/security/auth/message/package-summary.html)

### Apache Tomcat 开发人员

以下文档适用于希望为 *Apache Tomcat* 项目的开发做出贡献的 Java 开发人员。

- [**从源代码构建**](https://tomcat.apache.org/tomcat-8.5-doc/building.html)- 详细说明下载 Apache Tomcat 源代码（以及它所依赖的其他包）并从这些源代码构建二进制分发所需的步骤。
- [**Changelog**](https://tomcat.apache.org/tomcat-8.5-doc/changelog.html) - 详细说明对 Apache Tomcat 所做的更改。
- [**状态**](https://wiki.apache.org/tomcat/TomcatVersions)- Apache Tomcat 开发状态。
- [**开发人员**](https://tomcat.apache.org/tomcat-8.5-doc/developers.html)- 活跃的 Apache Tomcat 贡献者列表。
- [**Javadocs**](https://tomcat.apache.org/tomcat-8.5-doc/api/index.html) - Apache Tomcat 内部的 Javadoc API 文档。
- [**Apache Tomcat Architecture**](https://tomcat.apache.org/tomcat-8.5-doc/architecture/index.html) - Apache Tomcat 服务器架构的文档。