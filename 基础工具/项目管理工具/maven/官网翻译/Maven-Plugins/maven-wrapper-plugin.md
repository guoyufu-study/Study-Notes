# Maven Wrapper 插件

> https://maven.apache.org/wrapper/index.html

Maven Wrapper 是**确保 Maven 构建的用户拥有运行 Maven 构建所需的一切**的一种简单方法。

> 项目结构：
>
> ```ascii
> my-project
> ├── .mvn
> │   └── wrapper
> │       ├── MavenWrapperDownloader.java
> │       ├── maven-wrapper.jar
> │       └── maven-wrapper.properties
> ├── mvnw
> ├── mvnw.cmd
> ├── pom.xml
> └── src
>     ├── main
>     │   ├── java
>     │   └── resources
>     └── test
>         ├── java
>         └── resources
> ```
>
> 发现多了`mvnw`、`mvnw.cmd`和`.mvn`目录，我们只需要把`mvn`命令改成`mvnw`就可以使用跟项目关联的Maven。
>
> 通常把项目的`mvnw`、`mvnw.cmd`和`.mvn`提交到版本库中，使所有开发人员使用统一的Maven版本。

## 最新版本

``` xml
<dependency>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-wrapper-plugin</artifactId>
    <version>3.1.0</version>
</dependency>
```



## 简单应用

迄今为止，Maven 对用户来说非常稳定，可在大多数系统上使用或易于获取：但随着 Maven 最近的许多变化，用户将更容易获得项目提供的完全封装的构建设置。使用 Maven Wrapper，这很容易做到，这是一个从 Gradle 借来的好主意。

为您的项目设置 Maven Wrapper 的最简单方法是使用[Maven Wrapper Plugin](https://maven.apache.org/wrapper/maven-wrapper-plugin)及其提供的`wrapper`目标。要将所有必要的 Maven Wrapper 文件添加或更新到您的项目中，请执行以下命令：

``` shell
mvn wrapper:wrapper
```

通常，您会指示用户安装特定版本的 Apache Maven，将其放在 PATH 上，然后运行`mvn`命令，如下所示：

``` shell
mvn clean package
```

但是现在，通过 Maven Wrapper 设置，您可以指示用户运行 wrapper 脚本：

``` shell
./mvnw clean install
```

或在 Windows 上

``` powershell
mvnw.cmd clean install
```

一个正常的 Maven 构建将被执行，一个重要的变化是如果用户没有在`.mvn/wrapper/maven-wrapper.properties`中指定的必要版本的 Maven，它将首先为用户下载，安装，然后被使用。

`mvnw` / `mvnw.cmd`的后续使用根据需要使用之前下载的特定版本。



## verbose 模式

包装器支持输出更多信息的 verbose 模式。它通过将`MVNW_VERBOSE`环境变量设置为`true`来激活。

默认情况下它是关闭的。

## 使用不同版本的 Maven

要切换用于构建项目的 Maven 版本，您可以使用以下命令对其进行初始化：

``` shell
mvn wrapper:wrapper -Dmaven=3.5.4
```

它适用于除快照之外的任何版本。有了包装器后，您可以通过在`.mvn/wrapper/maven-wrapper.properties中设置``distributionUrl`来更改其版本，例如

``` 
distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.5.4/apache-maven-3.5.4-bin.zip
```

## 指定 Maven 分发基本路径

这是 Maven 本身的一个特性，而包装器恰好考虑到了它。只需将`MAVEN_USER_HOME`设置为所需的路径，包装器就会使用它作为 Maven 发行版安装的基础。

请参阅https://www.lewuathe.com/maven-wrapper-home.html和https://github.com/takari/maven-wrapper/issues/17

## 使用 Maven 存储库管理器

使用内部 Maven 存储库管理器时，您有两种选择：

1. 只需在项目中的`maven-wrapper.properties`中设置正确的 URL 来包装 jar 和 Maven 发行版
2. 保留项目中指向 Maven Central 的默认 URL，并将环境变量`MVNW_REPOURL`设置为您的存储库管理器 URL，例如`https://repo.example.com/central-repo-proxy`。

如果在包装器安装期间使用 maven-wrapper-plugin 设置了 MVNW_REPOURL，则 URL 将在 maven-wrapper.properties 文件中使用`。`

如果未设置，但您的 `settings.xml` 中的镜像 URL 已配置，则将使用它。

### 加速下载

文件`maven-wrapper.properties`，原内容

``` shell
distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.6.3/apache-maven-3.6.3-bin.zip
wrapperUrl=https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar
```

修改，使用国内镜像地址

发布包的国内镜像地址，可以在其[官网下载页](https://maven.apache.org/download.cgi)找到。

``` shell
distributionUrl=https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
```

包装器是一个jar包，所以其国内镜像地址，与下载其它jar包一样。比如使用阿里云镜像地址`http://maven.aliyun.com/nexus/content/groups/public`替换中央仓库地址`https://repo.maven.apache.org/maven2`

``` shell
wrapperUrl=http://maven.aliyun.com/nexus/content/groups/public/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar
```

