## 安装

> https://tomcat.apache.org/tomcat-8.5-doc/appdev/installation.html

### 安装

为了使用 Tomcat 开发 Web 应用程序，您必须首先安装它（以及它所依赖的软件）。以下小节概述了所需的步骤。

#### JDK

Tomcat 8.5 设计为在 Java 7 或更高版本上运行。

可在 http://www.oracle.com/technetwork/java/javase/downloads/index.html 获得适用于许多平台的兼容 JDK（或可以找到它们的链接） 。

#### Tomcat

**Tomcat** 服务器的二进制下载可从 https://tomcat.apache.org/ 获得。本手册假定您使用的是 Tomcat 8 的最新版本。下载和安装 Tomcat 的详细说明可在[此处](https://tomcat.apache.org/tomcat-8.5-doc/setup.html)获得。

在本手册的其余部分，示例 shell 脚本假定您设置了一个环境变量 `CATALINA_HOME`，其中包含安装 Tomcat 的目录的路径名。或者，如果已为多个实例配置了 Tomcat，则每个实例都将有自己的 `CATALINA_BASE` 配置。

#### Ant

**Ant** 构建工具的二进制下载可从 https://ant.apache.org/ 获得。本手册假定您使用的是 Ant 1.8 或更高版本。这些说明也可能与其他版本兼容，但尚未经过测试。

下载并安装 Ant。然后，按照您的操作系统平台的标准做法，将 Ant 分发的 `bin` 目录添加到您的 `PATH` 环境变量中。完成此操作后，您将能够直接执行 `ant` shell 命令。

#### CVS

除了上述所需的工具外，强烈建议您下载并安装*源代码控制*系统，例如 **并发版本系统 Concurrent Version System** (CVS)，以维护构成 Web 应用程序的源文件的历史版本。除了服务器，您还需要适当的客户端工具来签出源代码文件，并签入修改后的版本。

安装和使用源代码控制应用程序的详细说明超出了本手册的范围。但是，可以从 http://www.cvshome.org/ 下载适用于许多平台的 CVS 服务器和客户端工具（连同文档）。