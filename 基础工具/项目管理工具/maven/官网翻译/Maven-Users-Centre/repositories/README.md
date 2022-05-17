## 存储库简介

> https://maven.apache.org/guides/introduction/introduction-to-repositories.html

### 工件存储库

Maven 中的存储库包含不同类型的构建工件和依赖项。

有两种类型的存储库：**`local`** 和 **`remote`**：

1. **`local`** 存储库是运行 Maven 的计算机上的一个目录。它缓存远程下载并包含您尚未发布的临时构建工件。
2. **`remote`** 存储库指的是通过各种协议，比如 `file://` 和 `https://`，访问的任何其他类型的存储库。这些存储库可能是由第三方设置的真正的远程存储库，以提供供下载的工件（比如，[repo.maven.apache.org](https://repo.maven.apache.org/maven2/)）。其他“远程”存储库可能是在您公司的文件服务器或 HTTP 服务器上设置的内部存储库，用于在开发团队之间共享私有工件和用于发布。

本地和远程存储库的结构相同，因此脚本可以在任意一端运行，或者可以对它们进行同步以脱机使用。然而，存储库的布局对 Maven 用户是完全透明的。

### 使用存储库

通常，您不需要定期对本地存储库进行任何操作，除非在磁盘空间不足时将其清除（如果您愿意再次下载所有内容，则将其完全擦除）。

对于远程存储库，它们用于下载和上传（如果您有这样做的权限）。

#### 从远程存储库下载

Maven 中的下载是由这样一个项目触发的，该项目声明了本地存储库中不存在的依赖项（或者对于一个 `SNAPSHOT`，当远程存储库包含较新的存储库时）。默认情况下，Maven 将从[中央](https://repo.maven.apache.org/maven2/)存储库下载。

要改写它，您需要指定一个 `mirror`，如[存储库镜像指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/guide-mirror-settings.md)中所示。

您可以在 `settings.xml` 文件中设置它，以全局使用某个镜像。但是，项目通常会[在项目自己的 `pom.xml` 中自定义存储库](https://maven.apache.org/guides/mini/guide-multiple-repositories.html)，并且您的设置将优先使用。如果未找到依赖项，请检查您是否未改写远程存储库。

有关依赖关系的更多信息，请参阅[依赖机制](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)。

#### 为中央存储库使用镜像

有几个地理分布的[官方中央存储库](https://maven.apache.org/repository/)。您可以修改 `settings.xml` 文件以使用一个或多个镜像。这方面的说明可以在[存储库镜像指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/guide-mirror-settings.md)中找到。

### 离线构建

如果您暂时断开了与 Internet 的连接，并且需要离线构建您的项目，您可以使用 CLI 上的离线开关：

```powershell
 mvn -o package
```

许多插件支持离线设置并且不执行任何连接到互联网的操作。一些示例是解析 Javadoc 链接和链接检查站点。

### 上传到远程存储库

虽然这对于任何类型的远程存储库都是可能的，但您必须具有这样做的权限。要让某人上传到中央 Maven 存储库，请参阅[中央存储库](https://maven.apache.org/repository/index.html)。

### 内部存储库

在使用 Maven 时，尤其是在企业环境中，出于安全、速度或带宽的原因，连接到 Internet 以下载依赖项是不可接受的。出于这个原因，我们希望建立一个内部存储库来存放工件的副本，并向其发布私有工件。

这种内部存储库可以使用 HTTP 或文件系统（带有 `file://` 的 URL）下载，并使用 SCP、FTP 或文件副本上传。

就 Maven 而言，这个存储库没有什么特别之处：它是另一个**远程存储库**，其中包含要下载到用户本地缓存的工件，并且是工件发布的发布目的地。

此外，您可能希望与生成的项目站点共享存储库服务器。有关创建和部署站点的更多信息，请参阅[创建站点](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/guide-site/)。

### 建立内部存储库

要建立一个内部存储库，只需要您有一个放置它的地方，然后使用与远程存储库（例如[repo.maven.apache.org](https://repo.maven.apache.org/maven2/) ）相同的布局复制所需的工件。

不建议您抓取或 `rsync://` 中央的一个完整副本，因为那里有大量数据，这样做会被禁止。您可以使用[存储库管理](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/repositories/repository-management.md)页面中描述的程序来运行内部存储库的服务器，根据需要从 Internet 下载，然后将工件保存在内部存储库中以便以后更快地下载。

其他可用的选项是手动下载和审查发布，然后将它们复制到内部存储库，或者让 Maven 为用户下载它们，然后手动将审查过的工件上传到用于发布的内部存储库。此步骤是唯一可用于许可证自动禁止分发的工件，例如 Sun 提供的几个 J2EE JAR。有关更多信息，请参阅[处理 SUN JAR](https://maven.apache.org/guides/mini/guide-coping-with-sun-jars.html)文档的指南。

应该注意的是，Maven 打算在未来包括对此类功能的增强支持，包括点击下载许可证和签名验证。

### 使用内部存储库

使用内部存储库非常简单。只需做一个更改来添加一个 `repositories` 元素：

```xml
<project>
  ...
  <repositories>
    <repository>
      <id>my-internal-site</id>
      <url>https://myserver/repo</url>
    </repository>
  </repositories>
  ...
</project>
```

如果您的内部存储库需要身份验证，则可以在您的[设置](https://maven.apache.org/settings.html#Servers)文件中使用 `id` 元素来指定登录信息。

### 部署到内部存储库

拥有一个或多个内部存储库的最重要原因之一是能够发布您自己的私有版本。

要发布到存储库，您需要通过 SCP、SFTP、FTP、WebDAV 或文件系统之一进行访问。连接是通过各种 [wagons](https://maven.apache.org/wagon/wagon-providers/index.html) 实现的。一些  wagons 可能需要作为[扩展](https://maven.apache.org/ref/current/maven-model/maven.html#class_extension)添加到您的构建中。
