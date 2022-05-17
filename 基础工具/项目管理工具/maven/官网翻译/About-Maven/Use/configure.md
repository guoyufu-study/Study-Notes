# 配置 Apache Maven

> https://maven.apache.org/configure.html

Apache Maven 本身使用的配置以及构建项目的配置位于多个位置：

## `MAVEN_OPTS`环境变量

此变量包含用于启动运行 Maven 的 JVM 的参数，并可用于为其提供附加选项。比如，JVM 内存设置可以用值 `-Xms256m -Xmx512m` 来定义。

## `MAVEN_ARGS`环境变量

从 Maven 4 开始，此变量包含在 CLI 参数之前传递给 Maven 的参数。比如，选项和目标可以用值 `-B -V checkstyle:checkstyle` 来定义。

## `settings.xml`文件

位于 `USER_HOME/.m2` 中的设置文件旨在包含跨项目使用 Maven 的任何配置。

## `.mvn`目录

位于项目的顶级目录中，文件 `maven.config`、`jvm.config`和`extensions.xml` 包含用于运行 Maven 的项目特定配置。

此目录是项目的一部分，可以签入到您的版本控制中。

### `.mvn/extensions.xml`文件

旧方法（直到 Maven 3.2.5）是创建一个包含扩展的 jar（如果您有其他依赖项，则必须 shaded 着色）并将其手动放入`${MAVEN_HOME}/lib/ext` 目录中。这意味着您必须更改 Maven 安装。结果是每个喜欢使用它的人都需要更改它的安装，并使开发人员的入职更加不便。另一种选择是通过 `mvn -Dmaven.ext.class.path=extension.jar`。这样做的缺点是每次调用 Maven 时都会为 Maven 构建提供这些选项。也不是很方便。

从现在开始，这可以更简单，更类似于 Maven 的方式来完成。因此，您可以定义如下所示的 `${maven.projectBasedir}/.mvn/extensions.xml` 文件：

```xml
<extensions xmlns="http://maven.apache.org/EXTENSIONS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/EXTENSIONS/1.0.0 http://maven.apache.org/xsd/core-extensions-1.0.0.xsd">
  <extension>
    <groupId/>
    <artifactId/>
    <version/>
  </extension>
</extensions>
```

现在，您可以通过将通常的 maven 坐标 `groupId`、`artifactId`、`version` 定义为任何其他工件来简单地使用扩展。此外，这些扩展的所有传递依赖项都将自动从您的存储库中下载。所以不再需要创建 shaded 工件了。

### `.mvn/maven.config`文件

定义一组通用的调用 maven 命令行的选项真的很困难。从 Maven 3.3.1+ 开始，这可以通过将此选项放入脚本来解决，但现在可以通过定义包含 `mvn` 命令行配置选项的 `${maven.projectBasedir}/.mvn/maven.config` 文件来简单地完成。

比如，像 `-T3 -U --fail-at-end`。 因此，您调用 Maven，只需使用 `mvn clean package` 而不是 `mvn -T3 -U --fail-at-end clean package` ，并且每次调用都不会丢失 `-T3 -U --fail-at-end` 选项。`${maven.projectBasedir}/.mvn/maven.config` 位于 `${maven.projectBasedir}/.mvn/` 目录中；如果在多模块构建的根目录下，也可以正常工作。

### `.mvn/jvm.config`文件

从 Maven 3.3.1+ 开始，您可以通过 `${maven.projectBasedir}/.mvn/jvm.config` 文件定义 JVM 配置，这意味着您可以在每个项目基础上定义构建选项。该文件将成为您项目的一部分，并将与您的项目一起签入。所以不再需要 `MAVEN_OPTS`、`.mavenrc` 文件。因此，比如，如果您将以下 JVM 选项放入 `${maven.projectBasedir}/.mvn/jvm.config` 文件中

```config
-Xmx2048m -Xms1024m -XX:MaxPermSize=512m -Djava.awt.headless=true
```

您无需在 `MAVEN_OPTS` 中使用这些选项，也不需要在不同的配置之间切换。

## 其他指南

以下指南包含有关特定配置方面的更多信息：

- [推荐的最佳实践 - 使用存储库管理器](https://maven.apache.org/repository-management.html)
- [settings.xml 的文档](https://maven.apache.org/settings.html)
- [配置日志记录](https://maven.apache.org/maven-logging.html)
- [配置 HTTP 代理](https://maven.apache.org/guides/mini/guide-proxies.html)
- [配置存储库镜像](https://maven.apache.org/guides/mini/guide-mirror-settings.html)
- [配置 Maven 的各种技巧](https://maven.apache.org/guides/mini/guide-configuring-maven.html)
- [密码加密](https://maven.apache.org/guides/mini/guide-encryption.html)


