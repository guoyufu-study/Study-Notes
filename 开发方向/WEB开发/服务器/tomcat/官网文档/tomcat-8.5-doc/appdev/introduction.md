## 介绍

> https://tomcat.apache.org/tomcat-8.5-doc/appdev/introduction.html

### 概述

恭喜！您已决定（或被告知）学习如何使用 servlets 和 JSP 页面构建 Web 应用程序，并选择了 Tomcat 服务器用于您的学习和开发。但是现在你怎么办？

本手册是一本入门书，涵盖了**使用 Tomcat 设置开发环境、组织源代码以及构建和测试应用程序的基本步骤**。它不讨论 Web 应用程序开发的体系结构或推荐的编码实践，也不提供有关操作所讨论的开发工具的深入说明。以下小节中包含对其他信息来源的引用。

本手册中的讨论**面向将使用文本编辑器和命令行工具来开发和调试其应用程序的开发人员**。因此，这些建议是相当通用的——但您应该能够轻松地将它们应用到基于 Windows 或基于 Unix 的开发环境中。如果您使用的是集成开发环境 (IDE) 工具，则需要根据您的特定环境的详细信息调整此处给出的建议。

### 链接

以下链接提供了对在使用 Tomcat 开发 Web 应用程序时有用的在线信息、文档和软件的选定来源的访问。

- https://jcp.org/aboutJava/communityprocess/mrel/jsr245/index2.html - *JavaServer Pages (JSP) 规范，版本 2.3*。描述由 JavaServer Pages (JSP) 技术的标准实现提供的编程环境。结合 Servlet API 规范（见下文），本文档描述了可移植 API 页面允许包含的内容。关于脚本（第 9 章）、标签扩展（第 7 章）和打包 JSP 页面（附录 A）的特定信息很有用。Javadoc API 文档包含在规范中，并随 Tomcat 下载。
- http://jcp.org/aboutJava/communityprocess/final/jsr340/index.html - *Servlet API 规范，版本 3.1*。描述所有符合本规范的 servlet 容器必须提供的编程环境。特别是，您将需要本文档来了解 Web 应用程序目录结构和部署文件（第 10 章）、将请求 URI 映射到 servlet 的方法（第 12 章）、容器管理的安全性（第 13 章）以及`web.xml` Web 应用程序的语法部署描述符（第 14 章）。Javadoc API 文档包含在规范中，并随 Tomcat 下载。