## POM 简介

> https://maven.apache.org/guides/introduction/introduction-to-the-pom.htm

- 

### 什么是 POM？

项目对象模型或 POM 是 Maven 中的基本工作单元。它是一个 XML 文件，其中包含有关项目信息和 Maven 用于构建项目的配置详细信息。它包含大多数项目的默认值。这方面的示例是构建目录，即 `target`；源目录，即 `src/main/java`；测试源目录，即 `src/test/java`；等等。执行任务或目标时，Maven 在当前目录中查找 POM。它读取 POM，获取所需的配置信息，然后执行目标。

可以在 POM 中指定的一些配置是项目依赖项、插件或可以执行的目标、构建 profiles等。也可以指定其他信息，例如项目版本、描述、开发人员、邮件列表等。

### 超级 POM

Super POM 是 Maven 的默认 POM。除非明确设置，否则所有 POM 都扩展了 Super POM，这意味着 Super POM 中指定的配置由您为项目创建的 POM 继承。

您可以在 Maven Core 参考文档中查看 [Maven 3.6.3 的 Super POM](https://maven.apache.org/ref/3.6.3/maven-model-builder/super-pom.html)。

### 最小 POM

POM 的最低要求如下：

- `project` 根
- `modelVersion`- 应设置为 4.0.0
- `groupId`- 项目的组 id。
- `artifactId`- 工件（项目）的 id
- `version`- 指定组下工件的版本

示例：

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
</project>
```

POM 要求配置其 `groupId`、`artifactId` 和 `version`。这三个值构成项目的完全限定工件名称。这是 `<groupId>:<artifactId>:<version>` 的形式。对于上面的示例，其完全限定的工件名称是 `com.mycompany.app:my-app:1`。

此外，如第一节所述，如果未指定配置详细信息，Maven 将使用它们的默认值。这些默认值之一是 `packaging` 类型。每个 Maven 项目都有一个打包类型。如果在 POM 中未指定，则将使用默认值 `jar`。

此外，您可以看到在最小 POM 中没有指定 *`repositories`*。如果您使用最小 POM 构建项目，它将继承超级 POM 中的 *`repositories`* 配置。因此，当 Maven 在最小 POM 中看到依赖项时，它会知道这些依赖项将从 Super POM 中指定的位置 `https://repo.maven.apache.org/maven2` 下载。

### 项目继承

POM 中合并的元素如下：

- dependencies
- developers and contributors
- plugin lists (including reports)
- plugin executions with matching ids
- plugin configuration
- resources

Super POM 是项目继承的一个示例，但是您也可以通过在 POM 中指定 `parent` 元素来引入自己的父 POM，如下例所示。

#### 示例 1

##### 场景

比如，让我们重用我们之前的工件 `com.mycompany.app:my-app:1`。让我们引入另一个工件 `com.mycompany.app:my-module:1`。

```xml
    <project>
      <modelVersion>4.0.0</modelVersion>

      <groupId>com.mycompany.app</groupId>
      <artifactId>my-module</artifactId>
      <version>1</version>
    </project>
```

让我们指定它们的目录结构如下：

```
.
 |-- my-module
 |   `-- pom.xml
 `-- pom.xml
```

> 注意： `my-module/pom.xml` 是 `com.mycompany.app:my-module:1` 的 POM，而 `pom.xml` 是 `com.mycompany.app:my-app:1` 的 POM。

##### 解决方案

现在，如果我们要将 `com.mycompany.app:my-app:1` 变成 `com.mycompany.app:my-module:1` 的父工件，我们将不得不修改 `com.mycompany.app:my-module:1` 的 POM 到如下配置：

**`com.mycompany.app:my-module:1` 的 POM**

```xml
    <project>
      <modelVersion>4.0.0</modelVersion>

      <parent>
        <groupId>com.mycompany.app</groupId>
        <artifactId>my-app</artifactId>
        <version>1</version>
      </parent>

      <groupId>com.mycompany.app</groupId>
      <artifactId>my-module</artifactId>
      <version>1</version>
    </project>
```

请注意，我们现在添加了一个部分，即 `parent` 部分。这部分允许我们指定哪个工件是我们的 POM 的父级。我们通过指定父 POM 的完全限定工件名称来做到这一点。通过这个设置，我们的模块现在可以继承父 POM 的一些属性。

或者，如果您希望模块的 `groupId` 或 `version` 与其父模块相同，则可以在其 POM 中删除模块的 `groupId` 或 `version` 标识。

```xml
    <project>
      <modelVersion>4.0.0</modelVersion>

      <parent>
        <groupId>com.mycompany.app</groupId>
        <artifactId>my-app</artifactId>
        <version>1</version>
      </parent>

      <artifactId>my-module</artifactId>
    </project>
```

这允许模块继承其父 POM 的 `groupId` 或 `version`。

#### 示例 2

##### 场景

但是，如果父项目已经安装在我们的本地存储库中，或者在特定的目录结构中（父项目 `pom.xml` 比模块 `pom.xml` 的目录高一个目录），那么这是可行的。

但是，如果尚未安装父级并且目录结构如下例所示，该怎么办？

```
.
 |-- my-module
 |   `-- pom.xml
 `-- parent
     `-- pom.xml
```

##### 解决方案

为了解决这个目录结构（或任何其他目录结构），我们必须将 `<relativePath>` 元素添加到我们的 `parent` 部分。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <parent>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1</version>
    <relativePath>../parent/pom.xml</relativePath>
  </parent>

  <artifactId>my-module</artifactId>
</project>
```

顾名思义，它是从模块 `pom.xml` 到父模块 `pom.xml` 的相对路径。

### 项目聚合

项目聚合类似于项目继承。但不是从模块中指定父 POM，而是从父 POM 中指定模块。通过这样做，父项目现在知道它的模块，并且如果对父项目调用 Maven 命令，那么该 Maven 命令也将对父项目的模块执行。要进行项目聚合，您必须执行以下操作：

- 将父 POM `packaging` 更改为值 `pom`。
- 在父 POM 中指定其模块（子 POM）的目录。

#### 示例 3

##### 场景

给定先前的原始工件 POMs 和目录结构：

**`com.mycompany.app:my-app:1` 的 POM**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
</project>
```

**`com.mycompany.app:my-module:1` 的 POM**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.mycompany.app</groupId>
  <artifactId>my-module</artifactId>
  <version>1</version>
</project>
```

**目录结构**

```
.
 |-- my-module
 |   `-- pom.xml
 `-- pom.xml
```

##### 解决方案

如果我们要将 `my-module` 聚合到 `my-app` 中，我们只需要修改 `my-app`。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
  <packaging>pom</packaging>

  <modules>
    <module>my-module</module>
  </modules>
</project>
```

在修改后的 `com.mycompany.app:my-app:1` 中，添加了 `packaging` 部分和 `modules` 部分。对于包装，它的值设置为 `pom`，对于模块部分，我们有元素 `<module>my-module</module>`。`<module>` 的值是从 `com.mycompany.app:my-app:1` 到 `com.mycompany.app:my-module:1` 的 POM 的相对路径（*实际上，我们使用模块的 `artifactId` 作为模块目录的名称*）。

现在，每当 Maven 命令处理 `com.mycompany.app:my-app:1` 时，同样的 Maven 命令也会针对 `com.mycompany.app:my-module:1` 运行。此外，一些命令（特别是目标）以不同的方式处理项目聚合。

#### 示例 4

##### 场景

但是，如果我们将目录结构更改为以下内容：

```
.
 |-- my-module
 |   `-- pom.xml
 `-- parent
     `-- pom.xml
```

父 POM 将如何指定其模块？

##### 解决方案

答案？- 与示例 3 相同，通过指定模块的路径。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
  <packaging>pom</packaging>

  <modules>
    <module>../my-module</module>
  </modules>
</project>
```

### 项目继承与项目聚合

如果您有多个 Maven 项目，并且它们都有相似的配置，您可以通过提取这些相似的配置并创建一个父项目来重构您的项目。因此，您所要做的就是让您的 Maven 项目继承该父项目，然后这些配置将应用于所有项目。

如果您有一组一起构建或处理的项目，您可以创建一个父项目并让该父项目将这些项目声明为其模块。通过这样做，您只需构建父级，其余的将随之而来。

但当然，您可以同时拥有项目继承和项目聚合。这意味着，您可以让您的模块指定一个父项目，同时让该父项目将这些 Maven 项目指定为其模块。您只需要应用所有三个规则：

- 在每个子 POM 中指定其父 POM 是谁。
- 将父 POM  `packaging` 更改为值 `pom` 。
- 在父 POM 中指定其模块的目录（子 POM）

#### 示例 5

##### 场景

再次给出之前的原始工件 POM，

**`com.mycompany.app:my-app:1` 的 POM**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
</project>
```

**`com.mycompany.app:my-module:1` 的 POM**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-module</artifactId>
  <version>1</version>
</project>
```

和这个**目录结构**

```
.
 |-- my-module
 |   `-- pom.xml
 `-- parent
     `-- pom.xml
```

##### 解决方案

要同时进行项目继承和聚合，您只需应用所有三个规则。

**`com.mycompany.app:my-app:1` 的 POM**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
  <packaging>pom</packaging>
 
  <modules>
    <module>../my-module</module>
  </modules>
</project>
```

**`com.mycompany.app:my-module:1` 的 POM**

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <parent>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1</version>
    <relativePath>../parent/pom.xml</relativePath>
  </parent>
 
  <artifactId>my-module</artifactId>
</project>
```

**注意：** Profile 继承继承与 POM 本身使用的继承策略相同。

### 项目插值和变量

Maven 鼓励的一种做法是*不要重复自己*。但是，在某些情况下，您需要在几个不同的位置使用相同的值。为了帮助确保该值只指定一次，Maven 允许您在 POM 中使用自己的和预定义的变量。

比如，要访问 `project.version` 变量，您可以像这样引用它：

```xml
      <version>${project.version}</version>
```

需要注意的一个因素是，这些变量是*在*继承后处理的，如上所述。这意味着，如果父项目使用一个变量，那么最终使用的将是子项目中的变量定义，而不是父项目中的变量定义。

#### 可用变量

##### 项目模型变量

模型中作为单值元素的任何字段都可以作为变量引用。比如，`${project.groupId}`、`${project.version}`、`${project.build.sourceDirectory}` 等。请参阅 POM 参考以查看完整的属性列表。

这些变量都被前缀 `project` 引用。您可能还会看到带有 `pom.` 前缀的引用，或者完全省略了前缀 - 这些形式现在已被弃用，不应使用。

##### 特殊变量

<table>
    <tr>
        <th>`project.basedir`</th>
        <td>当前项目所在的目录。</td>
    <tr>
    <tr>
        <th>`project.baseUri`</th>
        <td>当前项目所在的目录，以 URI 表示。从 Maven 2.1.0 开始</td>
    <tr>
    <tr>
        <th>`maven.build.timestamp`</th>
        <td>表示构建开始的时间戳 (UTC)。从 Maven 2.1.0-M1 开始</td>
    <tr>
</table>

可以通过声明属性 `maven.build.timestamp.format` 来自定义构建时间戳的格式，如下例所示：

```xml
    <project>
      ...
      <properties>
        <maven.build.timestamp.format>yyyy-MM-dd'T'HH:mm:ss'Z'</maven.build.timestamp.format>
      </properties>
      ...
    </project>
```

格式模式必须符合 [SimpleDateFormat](https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html) API 文档中给出的规则。如果该属性不存在，则格式默认为示例中已经给出的值。

##### properties

您还可以将项目中定义的任何 `properties` 作为变量引用。考虑以下示例：

```xml
    <project>
      ...
      <properties>
        <mavenVersion>3.0</mavenVersion>
      </properties>
     
      <dependencies>
        <dependency>
          <groupId>org.apache.maven</groupId>
          <artifactId>maven-artifact</artifactId>
          <version>${mavenVersion}</version>
        </dependency>
        <dependency>
          <groupId>org.apache.maven</groupId>
          <artifactId>maven-core</artifactId>
          <version>${mavenVersion}</version>
        </dependency>
      </dependencies>
      ...
    </project>
```
