## Maven入门指南

本指南旨在为初次使用 Maven 的人员提供参考，但它也可以作为一本食谱，为常见用例提供自包含的参考和解决方案。对于初次使用的用户，建议你按顺序逐步浏览材料。对于更熟悉 Maven 的用户，本指南致力于为手头的需求提供快速解决方案。此刻假定你已经下载了 Maven 并在本地机器上安装了 Maven。如果尚未安装，请参阅下载和安装说明。

好的，现在你已经安装了 Maven，我们可以开始了。在开始我们的示例之前，我们将非常简要地介绍一下 Maven 是什么，以及它如何帮助你进行日常工作和与团队成员的协作。当然，Maven 适用于小型项目，但 Maven 通过允许团队成员专注于项目的利益相关者的需求来帮助团队更有效地运作。您可以将构建基础架构留给 Maven！

### 什么是Maven？

乍一看，Maven 似乎有很多东西，但简言之，Maven 是一种**将模式应用于项目的基础设施建设**的尝试，目的是**通过提供使用最佳实践的清晰路径来提高理解力和生产效率**。Maven 本质上是一种项目管理和理解工具，因此提供了一种帮助管理的方法：

- Builds
- Documentation
- Reporting
- Dependencies
- SCMs
- Releases
- Distribution

如果你想了解更多关于 Maven 的背景信息，你可以查阅 [Maven 的哲学](https://maven.apache.org/background/philosophy-of-maven.html) 和 [Maven 的历史](https://maven.apache.org/background/history-of-maven.html)。现在让我们继续讨论你（用户）如何从使用 Maven 中获益。

### Maven 如何使我的开发过程受益？

Maven 可以通过使用标准约定和实践来加快开发周期，同时帮助你实现更高的成功率，从而为你的构建过程带来好处。

现在我们已经介绍了 Maven 的一些历史和用途，让我们进入一些真实的例子，让你开始使用 Maven！

### 如何设置Maven？

Maven 的默认设置通常足够了，但是如果需要更改缓存位置或位于 HTTP 代理之后，则需要创建配置。有关更多信息，请参阅[配置 Maven 指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Guides/guide-configuring-maven.md)。

### 如何制作我的第一个Maven项目？

我们将立即开始创建您的第一个 Maven 项目！为了创建我们的第一个Maven 项目，我们将使用 Maven 的原型机制。原型被定义为一个原始的模式或模型，所有其他同类事物都是从这个模式或模型中产生的。在 Maven 中，原型是一个项目的模板，它与一些用户输入相结合，以生成一个根据用户要求定制的工作 Maven 项目。我们现在将向您展示原型机制是如何工作的，但是如果您想了解更多关于原型的信息，请参阅我们的[原型介绍](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html)。

开始创建您的第一个项目！为了创建最简单的 Maven 项目，从命令行执行以下命令：

```powershell
mvn -B archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4
```

执行此命令后，您会注意到发生了一些事情。首先，您会注意到，已为新项目创建了一个名为 `my-app` 的目录，该目录包含一个名为 `pom.xml` 的文件，该文件应如下所示：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0-SNAPSHOT</version>

    <name>my-app</name>
    <!-- FIXME change it to the project's website -->
    <url>http://www.example.com</url>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.7</maven.compiler.source>
        <maven.compiler.target>1.7</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <pluginManagement><!-- lock down plugins versions to avoid using Maven defaults (may be moved to parent pom) -->
            ... lots of helpful plugins
        </pluginManagement>
    </build>
</project>
```

`pom.xml` 包含此项目的项目对象模型 (POM)。POM 是 Maven 中的基本工作单元。记住这一点很重要，因为 Maven 本质上是以项目为中心的，因为一切都围绕着项目的概念。简而言之，POM 包含有关您项目的每条重要信息，并且本质上是一站式，可以找到与您的项目相关的任何信息。了解 POM 很重要，鼓励新用户参考 [POM 简介](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html)。

这是一个非常简单的 POM，但仍然显示了每个 POM 包含的关键元素，所以让我们逐一介绍以熟悉 POM 的基本要素：

- **project** 
  
  这是所有 Maven `pom.xml` 文件中的顶级元素。

- **modelVersion** 
  
  此元素指示此 POM 使用的对象模型的版本。模型本身的版本很少更改，但是当 Maven 开发人员认为有必要更改模型时，它是强制性的，以确保使用的稳定性。

- **groupId**
  
  此元素指示创建项目的组织或组的唯一标识符。`groupId` 是项目的关键标识符之一，通常基于组织的完全限定域名。比如 `org.apache.maven.plugins` 是为所有 Maven 插件指定的 `groupId`。

- **artifactId**
  
  此元素指示此项目正在生成的主要工件的唯一基本名称。项目的主要工件通常是 JAR 文件。像源包这样的次要工件也使用 `artifactId` 作为其最终名称的一部分。由 Maven 生成的典型工件的格式为 `<artifactId>-<version>.<extension>`（比如 `myapp-1.0.jar`）。

- **version**
  
  此元素指示项目生成的工件的版本。Maven 在帮助您进行版本管理方面有很大帮助，您经常会在版本中看到 `SNAPSHOT` 标志符，这表明项目处于开发状态。我们将在本指南中讨论[快照](https://maven.apache.org/guides/getting-started/index.html#What_is_a_SNAPSHOT_version)的使用以及它们是如何工作的。

- **name**
  
  此元素指示用于项目的显示名称。这经常在 Maven 生成的文档中使用。

- **url**
  
  此元素指示可以找到项目站点的位置。这经常在 Maven 生成的文档中使用。

- **properties**
  
  此元素包含可在 POM 中的任何位置访问的值占位符。

- **dependencies**
  
  此元素的子项列出[依赖项](https://maven.apache.org/pom.html#dependencies)。POM 的基石。

- **build**
  
  这个元素处理诸如声明项目的目录结构和管理插件之类的事情。

有关 POM 中可用元素的完整参考，请参考我们的 [POM参考](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/POM.md)。现在让我们回到手头的项目。

在第一个项目的原型生成之后，您还将注意到已创建以下目录结构：

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

> Windows 系统下，使用 `tree /F` 命令查看目录结构。

如您所见，从原型创建的项目有一个 POM、一个用于应用程序源的源树和一个用于测试源的源树。这是 Maven 项目的标准布局（应用程序源位于 `${basedir}/src/main/java` 中，测试源位于 `${basedir}/src/test/java` 中，其中 `${basedir}` 表示包含 `pom.xml` 的目录）。
如果您要手动创建 Maven 项目，这就是我们建议使用的目录结构。这是一个 Maven 约定，要了解更多信息，您可以阅读我们[对标准目录布局的介绍](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/Maven-Getting-Started-Guide/introduction-to-the-standard-directory-layout.md)。
现在我们有了一个 POM，一些应用程序源和一些测试源，您可能会问...

### 如何编译我的应用程序源？

切换到由 `archetype:generate` 创建的 `pom.xml` 目录并执行以下命令来编译您的应用程序源：

```powershell
 mvn compile
```

执行此命令后，您应该会看到如下输出：

```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.mycompany.app:my-app >----------------------
[INFO] Building my-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ my-app ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory <dir>/my-app/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ my-app ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to <dir>/my-app/target/classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.899 s
[INFO] Finished at: 2020-07-12T11:31:54+01:00
[INFO] ------------------------------------------------------------------------
```

第一次执行此（或任何其他）命令时，Maven 将需要下载执行该命令所需的所有插件和相关依赖项。从全新安装的 Maven 开始，这可能需要相当长的时间（在上面的输出中，大约需要 4 分钟）。如果您再次执行该命令，Maven 现在将拥有它需要的东西，因此它不需要下载任何新内容，并且能够更快地执行该命令。

从输出中可以看出，编译后的类被放置在 `${basedir}/target/classes` 中，这是 Maven 使用的另一个标准约定。所以，如果你是一个敏锐的观察者，你会注意到通过使用标准约定，上面的 POM 非常小，你不必明确告诉 Maven 你的任何源在哪里或输出应该去哪里。通过遵循标准的 Maven 约定，您可以轻松完成很多工作！只是作为一个随意的比较，让我们看看您在 [Ant](http://ant.apache.org/) 中可能必须做些什么来完成同样的[事情](https://maven.apache.org/ant/build-a1.xml)。

现在，这只是为了编译单个应用程序源树，并且显示的 Ant 脚本与上面显示的 POM 的大小几乎相同。但是我们会看到我们可以用这个简单的 POM 做更多的事情！

### 如何编译我的测试源并运行我的单元测试？

现在您已经成功编译了应用程序的源代码，并且现在您已经有了一些要编译和执行的单元测试（因为每个程序员总是编写和执行他们的单元测试 *nudge nudge wink wink*）。

执行以下命令：

```powershell
mvn test
```

执行此命令后，您应该会看到如下输出：

```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.mycompany.app:my-app >----------------------
[INFO] Building my-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ my-app ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory <dir>/my-app/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ my-app ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:testResources (default-testResources) @ my-app ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory <dir>/my-app/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ my-app ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to <dir>/my-app/target/test-classes
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ my-app ---
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.mycompany.app.AppTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.025 s - in com.mycompany.app.AppTest
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.881 s
[INFO] Finished at: 2020-07-12T12:00:33+01:00
[INFO] ------------------------------------------------------------------------
```

关于输出的一些注意事项：

- 这次 Maven 下载了更多的依赖项。这些是执行测试所需的依赖项和插件（它已经具有编译所需的依赖项，不会再次下载它们）。
- 在编译和执行测试之前，Maven 编译主要代码（所有这些类都是最新的，因为自上次编译以来我们没有更改任何内容）。

如果您只是想编译您的测试源（但不执行测试），您可以执行以下操作：

```powershell
mvn test-compile
```

现在您可以编译您的应用程序源代码、编译您的测试并执行测试，您需要继续进行下一个合乎逻辑的步骤，所以您会问...

### 如何创建 JAR 并将其安装在本地存储库中？

制作 JAR 文件非常简单，可以通过执行以下命令来完成：

```powershell
mvn package
```

您现在可以查看 `${basedir}/target` 目录，您将看到生成的 JAR 文件。

现在您需要在本地存储库中安装您生成的工件，JAR 文件。默认位置是 `${user.home}/.m2/repository`。有关存储库的更多信息，您可以参考我们的[存储库简介](https://maven.apache.org/guides/introduction/introduction-to-repositories.html)。让我们继续安装我们的工件！为此，请执行以下命令：

```powershell
mvn install
```

执行此命令后，您应该看到以下输出：

```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.mycompany.app:my-app >----------------------
[INFO] Building my-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ my-app ---
...
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ my-app ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:testResources (default-testResources) @ my-app ---
...
[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ my-app ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ my-app ---
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.mycompany.app.AppTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.025 s - in com.mycompany.app.AppTest
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] 
[INFO] --- maven-jar-plugin:3.0.2:jar (default-jar) @ my-app ---
[INFO] Building jar: <dir>/my-app/target/my-app-1.0-SNAPSHOT.jar
[INFO] 
[INFO] --- maven-install-plugin:2.5.2:install (default-install) @ my-app ---
[INFO] Installing <dir>/my-app/target/my-app-1.0-SNAPSHOT.jar to <local-repository>/com/mycompany/app/my-app/1.0-SNAPSHOT/my-app-1.0-SNAPSHOT.jar
[INFO] Installing <dir>/my-app/pom.xml to <local-repository>/com/mycompany/app/my-app/1.0-SNAPSHOT/my-app-1.0-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.678 s
[INFO] Finished at: 2020-07-12T12:04:45+01:00
[INFO] ------------------------------------------------------------------------
```

请注意，surefire 插件（执行测试）会查找包含在具有特定命名约定的文件中的测试。默认情况下，包含的测试是：

- `**/*Test.java`
- `**/Test*.java`
- `**/*TestCase.java`

默认排除是：

- `**/Abstract*Test.java`
- `**/Abstract*TestCase.java`

您已经完成了设置、构建、测试、打包和安装一个典型 Maven 项目的过程。这可能是绝大多数项目将使用 Maven 进行的操作，如果您已经注意到，到目前为止您所做的一切都是由一个 18 行文件驱动的，即项目的模型或 POM。如果您查看一个典型的 [Ant 构建文件](https://maven.apache.org/ant/build-a1.xml)，它提供了与我们迄今为止实现的功能相同的功能，您会注意到它已经是 POM 大小的两倍，而我们才刚刚开始！Maven 可以为您提供更多功能，而无需像当前那样对我们的 POM 进行任何添加。要从我们的示例 Ant 构建文件中获得更多功能，您必须不断进行容易出错的添加。

那么你还能免费获得什么？有很多 Maven 插件可以开箱即用，即使是像我们上面那样的简单 POM。我们将在这里特别提到一个，因为它是 Maven 最受重视的特性之一：无需您做任何工作，这个 POM 就有足够的信息来为您的项目生成一个网站！您很可能想要自定义您的 Maven 站点，但如果您时间紧迫，您只需执行以下命令即可提供有关项目的基本信息：

```powershell
mvn site
```

还有许多其他独立的目标也可以执行，例如：

```powershell
mvn clean
```

这将在开始之前删除包含所有构建数据的 `target` 目录，使其保持新鲜。

### 什么是 SNAPSHOT 版本？

请注意，下面显示的 `pom.xml` 文件中 **version** 标记的值具有后缀：`-SNAPSHOT`.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
      ...
      <groupId>...</groupId>
      <artifactId>my-app</artifactId>
      ...
      <version>1.0-SNAPSHOT</version>
      <name>Maven Quick Start Archetype</name>
      ...
```

`SNAPSHOT` 值是指开发分支中的`latest` “最新”代码，不保证代码是稳定的或不变的。相反，`release` “发布”版本（任何不带后缀 `SNAPSHOT` 的版本值）中的代码是不变的。

换句话说，SNAPSHOT 版本是最终“发布”版本之前的“开发”版本。SNAPSHOT 比它的版本“旧”。

在[发布](https://maven.apache.org/plugins/maven-release-plugin/)过程中，**`x.y-SNAPSHOT`** 的一个版本更改为 **`x.y`**。发布过程还将开发版本增加到**x.(y+1)-SNAPSHOT**。例如，版本**1.0-SNAPSHOT**发布为**1.0**版本，新的开发版本为**1.1-SNAPSHOT**版本。

### How do I use plugins?[](https://maven.apache.org/guides/getting-started/index.html#how-do-i-use-plugins)

### How do I add resources to my JAR?[](https://maven.apache.org/guides/getting-started/index.html#how-do-i-add-resources-to-my-jar)

### How do I filter resource files?[](https://maven.apache.org/guides/getting-started/index.html#how-do-i-filter-resource-files)

### How do I use external dependencies?[](https://maven.apache.org/guides/getting-started/index.html#how-do-i-use-external-dependencies)

### How do I deploy my jar in my remote repository?[](https://maven.apache.org/guides/getting-started/index.html#how-do-i-deploy-my-jar-in-my-remote-repository)

### 如何创建文档？

为了让您开始使用 Maven 的文档系统，您可以使用原型机制使用以下命令为现有项目生成站点：

```powershell
mvn archetype:generate \
      -DarchetypeGroupId=org.apache.maven.archetypes \
      -DarchetypeArtifactId=maven-archetype-site \
      -DgroupId=com.mycompany.app \
      -DartifactId=my-app-site
```

现在转到[创建站点指南](基础工具/项目管理工具/maven/官网翻译/Maven-Users-Centre/guide-site/)，了解如何为您的项目创建文档。

### 如何构建其他类型的项目？

请注意，生命周期适用于任何项目类型。比如，回到基本目录，我们可以创建一个简单的 Web 应用程序：

```powershell
mvn archetype:generate \
        -DarchetypeGroupId=org.apache.maven.archetypes \
        -DarchetypeArtifactId=maven-archetype-webapp \
        -DgroupId=com.mycompany.app \
        -DartifactId=my-webapp
```

请注意，这些都必须在一行上。这将创建一个名为 `my-webapp` 的目录，其中包含以下项目描述符：

```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>

      <groupId>com.mycompany.app</groupId>
      <artifactId>my-webapp</artifactId>
      <version>1.0-SNAPSHOT</version>
      <packaging>war</packaging>

      <dependencies>
        <dependency>
          <groupId>junit</groupId>
          <artifactId>junit</artifactId>
          <version>4.11</version>
          <scope>test</scope>
        </dependency>
      </dependencies>

      <build>
        <finalName>my-webapp</finalName>
      </build>
    </project>
```

注意 `<packaging>` 元素 - 这告诉 Maven 构建为 WAR。切换到 webapp 项目的目录并尝试：

```powershell
mvn package
```

您会看到 `target/my-webapp.war` 构建完成，并且所有正常步骤都已执行。

### 如何一次构建多个项目？

处理多个模块的概念内置在 Maven 中。在本节中，我们将展示如何构建上面的 WAR，并在一个步骤中包含之前的 JAR。

首先，我们需要在另外两个上面的目录中添加一个父 `pom.xml` 文件，所以它应该是这样的：

```
+- pom.xml
+- my-app
| +- pom.xml
| +- src
|   +- main
|     +- java
+- my-webapp
| +- pom.xml
| +- src
|   +- main
|     +- webapp
```

您将创建的 POM 文件应包含以下内容：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>

      <groupId>com.mycompany.app</groupId>
      <artifactId>app</artifactId>
      <version>1.0-SNAPSHOT</version>
      <packaging>pom</packaging>

      <modules>
        <module>my-app</module>
        <module>my-webapp</module>
      </modules>
</project>
```

我们需要从 webapp 获得 JAR 依赖项，因此将下面的配置添加到 `my-webapp/pom.xml`：

```xml
      ...
      <dependencies>
        <dependency>
          <groupId>com.mycompany.app</groupId>
          <artifactId>my-app</artifactId>
          <version>1.0-SNAPSHOT</version>
        </dependency>
        ...
      </dependencies>
```

最后，将以下 `<parent>` 元素添加到子目录中的其他两个 `pom.xml` 文件中：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
      <parent>
        <groupId>com.mycompany.app</groupId>
        <artifactId>app</artifactId>
        <version>1.0-SNAPSHOT</version>
      </parent>
      ...
```

现在，试一试......从顶级目录，运行：

```powershell
mvn verify
```

现在已经在 `my-webapp/target/my-webapp.war` 中创建了 WAR ，并且包含了 JAR：

```
$ jar tvf my-webapp/target/my-webapp-1.0-SNAPSHOT.war
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/
 222 Fri Jun 24 10:59:54 EST 2005 META-INF/MANIFEST.MF
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/my-webapp/
3239 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/my-webapp/pom.xml
   0 Fri Jun 24 10:59:56 EST 2005 WEB-INF/
 215 Fri Jun 24 10:59:56 EST 2005 WEB-INF/web.xml
 123 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/my-webapp/pom.properties
  52 Fri Jun 24 10:59:56 EST 2005 index.jsp
   0 Fri Jun 24 10:59:56 EST 2005 WEB-INF/lib/
2713 Fri Jun 24 10:59:56 EST 2005 WEB-INF/lib/my-app-1.0-SNAPSHOT.jar
```

这是如何运作的？首先，创建的父 POM（称为 `app`）具有 `pom` 打包类型和一个定义的模块列表。这告诉 Maven 在一组项目上运行所有操作，而不仅仅是当前一个项目（要覆盖此行为，您可以使用 `--non-recursive` 命令行选项）。

接下来，我们告诉 WAR 它需要 `my-app` JAR。这做了一些事情：它使它在类路径上可用于 WAR 中的任何代码（在当前示例中没有使用），它确保 JAR 始终在 WAR 之前构建，并且它指示 WAR 插件将 JAR 包含在它的库目录。

您可能已经注意到这 `junit-4.11.jar` 是一个依赖项，但最终并未出现在 WAR 中。原因是 `<scope>test</scope>` 元素 - 它仅用于测试，因此不像编译时依赖项 `my-app` 那样包含在 Web 应用程序中。

最后一步是包含父定义。这确保了 POM 始终可以被定位，即使项目是通过在存储库中查找而与其父项目分开分发的。