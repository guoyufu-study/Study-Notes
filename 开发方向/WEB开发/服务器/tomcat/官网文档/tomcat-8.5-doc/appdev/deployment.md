## 部署

> https://tomcat.apache.org/tomcat-8.5-doc/appdev/deployment.html

### 目录

[toc]

### 背景

在描述如何组织源代码目录之前，检查 Web 应用程序的运行时组织很有用。在 Servlet API 规范 2.2 版之前，服务器平台之间几乎没有一致性。但是，符合 2.2（或更高版本）规范的服务器需要接受标准格式的 *Web 应用程序存档*，这将在下面进一步讨论。

Web 应用程序被定义为标准布局中的目录和文件的层次结构。这样的层次结构可以以“未打包”形式访问，其中每个目录和文件分别存在于文件系统中，或者以称为 Web ARchive 或 WAR 文件的“打包”形式访问。前一种格式在开发过程中更有用，而后一种格式在您分发要安装的应用程序时使用。

Web 应用程序层次结构的顶级目录也是应用程序的 *文档根目录*。在这里，您将放置构成应用程序用户界面的 HTML 文件和 JSP 页面。当系统管理员将您的应用程序部署到特定服务器时，他们会为您的应用程序分配一个*上下文路径*（本手册的后面部分描述了在 Tomcat 上的部署）。因此，如果系统管理员将您的应用程序分配给上下文路径 `/catalog`，那么引用 `/catalog/index.html`  的请求 URI 将从您的文档根目录检索 `index.html` 文件。

### 标准目录布局

为了便于创建所需格式的 Web 应用程序存档文件，可以方便地将 Web 应用程序的“可执行”文件（即 Tomcat 在执行应用程序时实际使用的文件）按照 WAR 格式本身要求的相同的组织安排。为此，您将在应用程序的“文档根”目录中获得以下内容：

- **`*.html`、`*.jsp` 等** - HTML 和 JSP 页面，以及应用程序的客户端浏览器必须可见的其他文件（例如 JavaScript、样式表文件和图像）。在较大的应用程序中，您可以选择将这些文件划分为子目录层次结构，但对于较小的应用程序，通常只为这些文件维护一个目录要简单得多。
- **`/WEB-INF/web.xml`** - 应用程序的 *Web 应用程序部署描述符*。这是一个 XML 文件，描述了构成您的应用程序的 servlet 和其他组件，以及您希望服务器为您强制执行的任何初始化参数和容器管理的安全约束。此文件将在以下小节中更详细地讨论。
- **`/WEB-INF/classes/`** - 此目录包含应用程序所需的任何 Java 类文件（和相关资源），包括 servlet 和非 servlet 类，它们未组合到 JAR 文件中。如果您的类被组织成 Java 包，您必须在 `/WEB-INF/classes/` 下的目录层次结构中反映这一点。例如，一个名为 `com.mycompany.mypackage.MyServlet`  的 Java 类需要存储在一个名为 `/WEB-INF/classes/com/mycompany/mypackage/MyServlet.class` 的文件中。
- **`/WEB-INF/lib/`** - 此目录包含 JAR 文件，其中包含应用程序所需的 Java 类文件（和相关资源），例如第三方类库或 JDBC 驱动程序。

当您将应用程序安装到 Tomcat（或任何其他 2.2 或更高版本的 Servlet 容器）中时，`WEB-INF/classes/` 目录中的类以及在 `WEB-INF/lib/` 目录中找到的 JAR 文件中的所有类都对您特定 Web 应用程序中的其他类可见。因此，如果您在其中一个位置包含所有必需的库类（请务必检查您使用的任何第三方库的再分发权利的许可证），您将简化 Web 应用程序的安装——无需调整系统类路径（或在您的服务器中安装全局库文件）。

这些信息中的大部分是从 Servlet API 规范 2.3 版的第 9 章中提取的，您应该查阅它以获取更多详细信息。

### 共享库文件

与大多数 servlet 容器一样，Tomcat 也支持一次安装库 JAR 文件（或解压缩的类）的机制，并使它们对所有已安装的 Web 应用程序可见（不必包含在 Web 应用程序本身中）。[Class Loader How-To](https://tomcat.apache.org/tomcat-8.5-doc/class-loader-howto.html) 文档中描述了 Tomcat 如何定位和共享此类类的详细信息。Tomcat 安装中共享代码的常用位置是 **`$CATALINA_HOME/lib`**。放置在这里的 JAR 文件对 Web 应用程序和内部 Tomcat 代码都是可见的。这是放置应用程序或内部 Tomcat 使用（例如 `DataSourceRealm`）所需的 JDBC 驱动程序的好地方。

开箱即用的标准 Tomcat 安装包括各种预安装的共享库文件，包括：

- *Servlet 3.1* 和 *JSP 2.3* API，它们是编写 servlets 和 JavaServer Pages 的基础。

  

### Web 应用程序部署描述符

如上所述，`/WEB-INF/web.xml` 文件包含您的应用程序的 Web 应用程序部署描述符。正如文件扩展名所暗示的那样，该文件是一个 XML 文档，它**定义了服务器需要知道的有关应用程序的所有内容**（*上下文路径* 除外，它由系统管理员在部署应用程序时分配）。

部署描述符的完整语法和语义在 Servlet API 规范 2.3 版的第 13 章中定义。随着时间的推移，预计将提供开发工具来为您创建和编辑部署描述符。同时，为了提供一个起点，提供了一个[基本的 web.xml 文件](https://tomcat.apache.org/tomcat-8.5-doc/appdev/web.xml.txt) 。该文件包含描述每个包含元素用途的注释。

**注意** - Servlet 规范包括 Web 应用程序部署描述符的文档类型描述符 (DTD)，并且 Tomcat 在处理应用程序 `/WEB-INF/web.xml` 文件时强制执行此处定义的规则。特别是，您**必须**按照 DTD 定义的顺序输入描述符元素（例如 `<filter>`、 `<servlet>` 和 `<servlet-mapping>`（参见第 13.3 节））。

### Tomcat 上下文描述符

`/META-INF/context.xml` 文件可用于定义 Tomcat 特定的配置选项，例如访问日志、数据源、会话管理器配置等。此 XML 文件必须包含一个 `Context` 元素，该元素将被视为与正在部署 Web 应用程序的 Host 对应的 `Host` 元素的子元素。[Tomcat 配置文档](https://tomcat.apache.org/tomcat-8.5-doc/config/context.html)包含有关 `Context` 元素的信息。

### 使用 Tomcat 部署

*下面的描述使用变量名 $CATALINA_BASE 来引用解析大多数相对路径的基本目录。如果您没有通过设置 CATALINA_BASE 目录为多个实例配置 Tomcat，则 $CATALINA_BASE 将设置为 $CATALINA_HOME 的值，即您安装 Tomcat 的目录。*

为了执行，Web 应用程序必须部署在 servlet 容器上。即使在开发过程中也是如此。我们将描述使用 Tomcat 来提供执行环境。可以通过以下方法之一在 Tomcat 中部署 Web 应用程序：

- *将解压后的目录层次结构复制到 `$CATALINA_BASE/webapps/` 目录的子目录中*。Tomcat 将根据您选择的子目录名称为您的应用程序分配一个上下文路径。我们将在我们构建的 `build.xml` 文件中使用这种技术，因为它是开发过程中最快和最简单的方法。请务必在安装或更新应用程序后重新启动 Tomcat。

- *将 Web 应用程序存档文件复制到 `$CATALINA_BASE/webapps/` 目录中*。当 Tomcat 启动时，它会自动将 Web 应用程序归档文件展开为解压后的形式，并以这种方式执行应用程序。这种方法通常用于将第三方供应商或您的内部开发人员提供的附加应用程序安装到现有的 Tomcat 安装中。 **注意** - 如果您使用此方法，并希望稍后更新您的应用程序，您必须同时替换 Web 应用程序存档文件**并**删除 Tomcat 创建的扩展目录，然后重新启动 Tomcat，以反映您的更改。

- *使用 Tomcat“管理器”Web 应用程序来部署和取消部署 Web 应用程序*。Tomcat 包含一个 Web 应用程序，默认情况下部署在 context path `/manager` 上，它允许您在正在运行的 Tomcat 服务器上部署和取消部署应用程序，而无需重新启动它。有关使用 Manager Web 应用程序的更多信息，请参阅 [Manager App How-To](https://tomcat.apache.org/tomcat-8.5-doc/manager-howto.html) 。

- *在您的构建脚本中使用“管理器”Ant 任务*。Tomcat 包含一组用于`Ant` 构建工具的自定义任务定义，允许您自动执行对“管理器”Web 应用程序的命令。这些任务在 Tomcat 部署程序中使用。

- *使用 Tomcat 部署程序*。Tomcat 包含一个捆绑 Ant 任务的打包工具，可用于在部署到服务器之前自动预编译作为 Web 应用程序一部分的 JSP。

  

在其他 servlet 容器上部署您的应用程序将特定于每个容器，但所有与 Servlet API 规范（版本 2.2 或更高版本）兼容的容器都需要接受 Web 应用程序存档文件。请注意，其他容器**不需要**接受解压缩的目录结构（如 Tomcat 那样），或提供共享库文件的机制，但这些功能通常可用。