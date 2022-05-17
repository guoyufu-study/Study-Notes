## 5分钟认识Maven

> https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html

### 前提

你必须了解如何在计算机上安装软件。如果你不知道该怎么做，请咨询你所在办公室、学校等的人，或付钱请人向你解释一下。Maven邮件列表不是询问此建议的最佳地方。

### 安装

Maven 是一个 Java 工具，因此你必须安装 Java 才能继续。

首先，[下载maven](http://maven.apache.org/download.html)，并按照 [安装说明](http://maven.apache.org/install.html) 进行操作。之后，在终端或命令提示符中键入以下内容：

```shell
mvn -version
```

它应该打印出你安装的 Maven 版本，例如：

```
Apache Maven 3.8.3 (ff8e977a158738155dc465c6a97ffaf31982d739)
Maven home: D:\maven\apache-maven-3.8.3
Java version: 11.0.13, vendor: Oracle Corporation, runtime: D:\Java\jdk-11.0.13
Default locale: zh_CN, platform encoding: GBK
OS name: "windows 10", version: "10.0", arch: "amd64", family: "windows"
```

根据你的网络设置，你可能需要额外的配置。如有必要，请查看[配置maven指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Guides/guide-configuring-maven.md) 。

**如果您使用的是Windows，则应该查看** [Windows 先决条件](http://maven.apache.org/guides/getting-started/windows-prerequisites.html) **以确保你已准备好 在Windows上使用Maven。**

### 创建一个项目

你需要在某个地方存放你的项目，在某处创建一个目录并在该目录中启动一个 shell。 在命令行上，执行以下 Maven 目标：

```bash
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

如果你是刚刚安装了 Maven，第一次运行可能需要一段时间。这是因为 Maven 正在将最新的工件（插件 jars 和其他文件）下载到本地存储库中。在命令成功执行之前，您可能还需要多次执行该命令。这是因为远程服务器可能会在下载完成之前超时。别担心，有办法解决这个问题。 

你会注意到 *`generate`* 目标创建了一个与 `artifactId` 具有相同名称的目录。 切换到该目录。

```bash
cd my-app
```

在此目录下，你将注意到以下[标准项目结构](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Maven-Getting-Started-Guide/introduction-to-the-standard-directory-layout.md)。

> Windows 上使用 `tree /F` 命令。

```
my-app
|-- pom.xml
`-- src
    |-- main
    |   `-- java
    |       `-- com
    |           `-- mycompany
    |               `-- app
    |                   `-- App.java
    `-- test
        `-- java
            `-- com
                `-- mycompany
                    `-- app
                        `-- AppTest.java
```

`src/main/java`目录包含项目源代码，`src/test/java`目录包含测试源代码，`pom.xml`文件是项目的项目对象模型或`POM`。

#### `POM`文件

在 Maven 中，`pom.xml`文件是项目配置的核心。它是一个单一的配置文件，包含以你想要的方式构建项目所需的大部分信息。`POM` 体型很大，其复杂性令人望而生畏，但是你不需要预先理解所有的复杂问题就可以有效地使用它。本项目的 `POM` 是：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>1.7</maven.compiler.source>
        <maven.compiler.target>1.7</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

#### 我刚刚做了什么？

你执行了 maven 目标 *`archetype:generate`*，并向该目标传递了各种参数。前缀 *`architetype`* 是提供目标的[插件](基础工具/项目管理工具/maven/官网翻译/Maven-Plugins/)。如果你熟悉 [Ant](http://ant.apache.org)，你可能会认为这与任务类似。 这个 *`archetype:generate`* 目标创建了一个基于 [maven-archetype-quickstart](http://maven.apache.org/archetypes/maven-archetype-quickstart/) 原型的简单项目。 现在我只想说一个 *插件* 是 *目标* 的集合，具有一般的共同目的。 比如 `jboss-maven-plugin`，其目的是“处理各种 `jboss` 项目”。

#### 构建项目

```bash
mvn package
```

命令行将打印出各种操作，并以以下内容结束：

```
 ...
 [INFO] ------------------------------------------------------------------------
 [INFO] BUILD SUCCESSFUL
 [INFO] ------------------------------------------------------------------------
 [INFO] Total time: 2 seconds
 [INFO] Finished at: Thu Jul 07 21:34:52 CEST 2011
 [INFO] Final Memory: 3M/6M
 [INFO] ------------------------------------------------------------------------
```

与执行的第一个命令（*`archetype:generate`*）不同，你可能会注意到第二个命令只是一个单词 -  *`package`*。这不是一个 *目标*，而是一个 *阶段*。 **阶段**是[构建生命周期](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Maven-Getting-Started-Guide/introduction-to-the-lifecycle.md)中的一个步骤，**生命周期**是一个有序的阶段序列。 当给出一个阶段时，Maven 将执行序列中的每个阶段，直到并包括给定的阶段。 比如，如果我们执行 *`compile`* 阶段，实际执行的阶段是：

1. `validate`
2. `generate-sources`
3. `process-sources`
4. `generate-resources`
5. `process-resources`
6. `compile`

你可以使用以下命令测试新编译和打包的 JAR：  

```shell
java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
```

这将打印出典型的：

```
Hello World!
```

### Java 9 或更高版本

默认情况下，你的 Maven 版本可能使用旧版本的 [`maven-compiler-plugin`](基础工具/项目管理工具/maven/官网翻译/Maven-Plugins/maven-compiler-plugin.md)，该插件与Java 9 或更高版本不兼容。要以 Java 9 或更高版本为目标，你至少应该使用 `maven-compiler-plugin` 的 `3.6.0` 版，并将 `maven.compiler.release` 属性设置为你所针对的 Java 版本（例如9、10、11、12等）。

> `maven-compiler-plugin` 的 [最新版本](https://search.maven.org/search?q=maven-compiler-plugin) 是 `3.10.1`。

```xml
    <properties>
        <maven.compiler.release>11</maven.compiler.release>
    </properties>

    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.8.1</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
```

要了解有关 `javac` 的 `--release` 选项的更多信息，请参阅 [JEP 247](https://openjdk.java.net/jeps/247)。

### 运行 maven 工具

#### Maven阶段

虽然不是一份全面的列表，但这些是执行的最常见的默认生命周期阶段。

- **validate**: 验证项目是否正确，以及所有必要信息是否可用
- **compile**: 编译项目的源代码
- **test**: 使用适当的单元测试框架测试编译后的源代码。这些测试不应要求打包或部署代码。
- **package**: 获取编译后的代码，并将其打包为可分发的格式，例如JAR。
- **integration-test**: 必要时，处理包并将其部署到可以运行集成测试的环境中
- **verify**: 运行任何检查以验证包是否有效并符合质量标准
- **install**: 将包安装到本地存储库中，作为本地其他项目的依赖项使用
- **deploy**: 在集成或发布环境中完成，将最终包复制到远程存储库以与其他开发人员和项目共享。

在上面的 *default* 列表之外，还有另外两个maven生命周期。他们是

- **clean**: 清除先前构建创建的构件

- **site**: 为此项目生成网站文档

**阶段实际上映射到基本目标**。每个阶段执行的具体目标取决于项目的打包类型。例如，如果项目类型是JAR，则*`package`* 执行`jar:jar`；如果项目类型是（你猜到的）WAR，则*`package`* 执行`war:war`。

需要注意的一件有趣的事情是阶段和目标可以**按顺序执行**。

```shell
mvn clean dependency:copy-dependencies package
```

这个命令将清理项目，复制依赖项，并打包项目（当然，在打包之前执行所有阶段）。

#### 生成站点

```
mvn site
```

此阶段根据项目的`POM`信息生成一个站点。 你可以查看在`target/site`下生成的文档。

### 结论

我们希望这个快速的概述激发了你对Maven多功能性的兴趣。请注意，这是一个非常简短的快速入门指南。现在，你已经准备好了解有关刚才执行的操作的更全面的详细信息。查看[Maven入门指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Maven-Getting-Started-Guide/)。