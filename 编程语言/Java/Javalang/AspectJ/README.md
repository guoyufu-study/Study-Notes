# AspectJ

> http://www.eclipse.org/aspectj/

AspectJ 是

- 对 Java 编程语言的无缝的面向切面的扩展
- Java平台兼容
- 易于学习和使用

AspectJ 能够

- 横切关注点的干净模块化，比如错误检查和处理、同步、上下文敏感行为、性能优化、监控和日志记录、调试支持和多对象协议

## 快速链接

- 对于 Eclipse 开发：[AJDT：AspectJ 开发工具](https://www.eclipse.org/ajdt)
- 博客：[AspectJ 编程博客](http://andrewclement.blogspot.com/)
- 流行的 AspectJ 下载：[最新开发版本](https://www.eclipse.org/aspectj/downloads.php#most_recent)| [最新稳定版本](https://www.eclipse.org/aspectj/downloads.php#stable_release)| [更多下载...](https://www.eclipse.org/aspectj/downloads.php)
- 流行的 AspectJ 文档：[AspectJ 5 开发人员笔记本](编程语言/Java/Javalang/AspectJ/AspectJ-5/)| [编程指南](编程语言/Java/Javalang/AspectJ/编程指南/)| [更多文档...](https://www.eclipse.org/aspectj/docs.php)
- [Eclipse AspectJ](http://www.amazon.com/exec/obidos/ASIN/0321245873/qid=1112868888/sr=2-3/ref=pd_bbs_b_2_3/103-5274059-2049410)：这本书，由一些领先的 ​​AspectJ 提交者撰写

## 最新版本

> https://github.com/eclipse/org.aspectj/releases

最新版本 `1.9.9.1`，支持 Java 18 及其最终和预览功能。比如，`switch` 模式匹配（预览 2）。

## 组件

### 运行时

AspectJ 运行时是一个小型库，用于运行由 AspectJ 切面增强的 Java 程序。这些 Java 程序在先前的编译时或编译后（二进制编织）构建步骤中生成。

```xml
<!-- https://mvnrepository.com/artifact/org.aspectj/aspectjrt -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjrt</artifactId>
    <version>1.9.9.1</version>
    <scope>runtime</scope>
</dependency>
```

### 编织器

AspectJ 编织器将切面应用于 Java 类。它可以用作 Java 代理，以便在类加载期间应用加载时编织 (LTW)，并且还包含 AspectJ 运行时类。

```xml
<!-- https://mvnrepository.com/artifact/org.aspectj/aspectjweaver -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.9.1</version>
    <scope>runtime</scope>
</dependency>
```

### 工具

AspectJ 工具最值得注意的是包含 AspectJ 编译器（AJC）。AJC 在编译期间将切面应用于Java类，完全取代 Javac 来替代普通 Java类，并且还编译原生的 AspectJ 或基于注解的 `@AspectJ` 语法。此外，AJC 可以在编译后的二进制编织步骤中将切面编织到现有的类文件中。这个库是 AspectJ weaver 的超集，因此也是 AspectJ 运行时的超集。

```xml
<!-- https://mvnrepository.com/artifact/org.aspectj/aspectjtools -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjtools</artifactId>
    <version>1.9.9.1</version>
</dependency> 
```

## AspectJ 使用提示

### AspectJ 编译器构建系统要求

从 `1.9.7` 开始， `ajc` 不再适用于 JDK 8 到 10，现在最低编译时要求是 JDK 11 。`aspectjrt` 和 `aspectjweaver` 仍然只需要 JRE 8+。

### 在 Java 16+ 上使用 LTW

如果您想在 Java 16+ 上使用加载时编织，编织代理会与 [JEP 396（默认情况下强封装 JDK 内部）](https://openjdk.java.net/jeps/396)和相关的后续 JEP 发生冲突。因此，您需要设置 JVM 参数 `--add-opens java.base/java.lang=ALL-UNNAMED` 以启用切面编织。

### 使用 Java 预览功能进行编译

对于在给定 JDK 上标记为预览的功能，使用 `ajc --enable-preview` 编译，并使用 `java --enable-preview` 运行。

> 除了用于编译的 JDK 之外，您不能在任何其他 JDK 上运行使用预览功能编译的代码。比如，在 JDK 15 上使用预览版编译的记录如果不重新编译，就无法在 JDK 16 上使用。这是与 AspectJ 无关的 JVM 限制。

## 插件

### Eclipse

[AJDT：AspectJ 开发工具](https://www.eclipse.org/ajdt)

### IDEA

[AspectJ | IntelliJ IDEA](https://www.jetbrains.com/help/idea/aspectj.html)

### MAVEN

> https://www.mojohaus.org/aspectj-maven-plugin/index.html

在 Maven 中处理 AspectJ 的使用。提供的功能是：将切面（或库中的现有切面）与测试和/或主类编织织在一起，将预先存在的 jar 和 ajdoc 报告编织在一起。

```xml
<!-- https://mvnrepository.com/artifact/org.codehaus.mojo/aspectj-maven-plugin -->
<dependency>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>aspectj-maven-plugin</artifactId>
    <version>1.14.0</version>
</dependency>
```
