## 安装 3rd 方 JAR 的指南

> https://maven.apache.org/guides/mini/guide-3rd-party-jars-local.html#guide-to-installing-3rd-party-jars

有时，您需要将第 3 方 JAR 放入本地存储库以在构建中使用，因为它们不存在于任何公共存储库（比如，[Maven Central](https://search.maven.org/) ）中。JAR 必须放置在本地存储库中正确位置，以便 Apache Maven 正确拾取它。

为了使这更容易，更不容易出错，我们在 [maven-install-plugin](https://maven.apache.org/plugins/maven-install-plugin/) 中提供了一个 `install-file` 目标，它应该使这相对容易。

要在本地存储库中安装 JAR，请使用以下命令：

```powershell
mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
```

如果还有 pom 文件，您可以使用以下命令安装它：

```powershell
mvn install:install-file -Dfile=<path-to-file> -DpomFile=<path-to-pomfile>
```

使用 2.5 版的 `maven-install-plugin`，它可以变得更简单：如果 JAR 是由 Apache Maven 构建的，它会在 `META-INF/` 目录的子文件夹中包含一个 `pom.xml`，该文件将被默认读取。在这种情况下，您需要做的就是：

```powershell
mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file -Dfile=<path-to-file>
```
