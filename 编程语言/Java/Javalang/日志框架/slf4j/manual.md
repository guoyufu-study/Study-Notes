## SLF4J 用户手册

> https://www.slf4j.org/manual.html

Java 的简单日志门面 (SLF4J) 用作各种日志框架的简单门面或抽象，例如 java.util.logging、logback 和 reload4j。SLF4J 允许最终用户在*部署* 时插入所需的日志框架。请注意，启用 SLF4J 的库/应用程序意味着仅添加一个强制依赖项，即 *slf4j-api-2.0.0.jar*。

**从 1.6.0 开始**如果在类路径上没有找到绑定，那么 SLF4J 将**默认为无操作实现**。

**从 1.7.0 开始**， [`Logger`](https://www.slf4j.org/apidocs/org/slf4j/Logger.html) 接口中的**打印方法现在提供接受 [varargs](http://docs.oracle.com/javase/1.5.0/docs/guide/language/varargs.html)** 而不是`Object[]`. 此更改意味着 SLF4J 需要 JDK 1.5 或更高版本。在底层，Java 编译器将方法中的可变参数部分转换为 `Object[]`。因此，编译器生成的 Logger 接口在 1.7.x 中与其对应的 1.6.x 没有区别。因此，SLF4J 版本 1.7.x 完全 100% 与 SLF4J 版本 1.6.x 兼容。

**自 1.7.5 以来**，logger **检索时间显着改善**。鉴于改进的程度，强烈建议用户迁移到 SLF4J 1.7.5 或更高版本。

**从 1.7.9 开始**，通过将系统属性 `slf4j.detectLoggerNameMismatch` 设置为 `true`，SLF4J 可以自动[发现命名错误的 loggers](https://www.slf4j.org/codes.html#loggerNameMismatch)。

**从 2.0.0 开始，** SLF4J API 2.0.0 版**需要 Java 8**，并**引入了向后兼容的流式日志 API**。通过向后兼容，我们的意思是不必更改现有的日志框架，以便用户从[流式日志 API](https://www.slf4j.org/manual.html#fluent)中受益。

**自 2.0.0 起** SLF4J API 版本 2.0.0 依赖 [ServiceLoader](https://docs.oracle.com/javase/8/docs/api/java/util/ServiceLoader.html) 机制来查找其日志记录后端。有关更多详细信息，请参阅相关的[常见问题解答条目](https://www.slf4j.org/faq.html#changesInVersion200)。

### 你好世界

按照编程传统的惯例，这里有一个示例，说明了使用 SLF4J 输出 `“Hello world”` 的最简单方法。首先获取一个名为 `“HelloWorld”` 的logger 。这个 logger 又用于记录消息 `“Hello World”`。

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloWorld {
  public static void main(String[] args) {
    Logger logger = LoggerFactory.getLogger(HelloWorld.class);
    logger.info("Hello World");
  }
}
```

要运行此示例，您首先需要 [获取 slf4j](https://www.slf4j.org/download.html) 工件。完成后，将文件 *slf4j-api-2.0.0.jar 添加*到您的类路径中。

编译并运行 *HelloWorld* 将在控制台上打印以下输出。

```
SLF4J: No SLF4J providers were found.
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See https://www.slf4j.org/codes.html#noProviders for further details.
```

如果您使用的是 SLF4J 1.7 或更早版本，则消息将是：

```
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See https://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
```

打印此警告是因为在您的类路径上找不到 slf4j 提供程序（或绑定）。

将提供程序添加到类路径后，警告就会消失。假设您添加 *slf4j-simple-2.0.0.jar* 以便您的类路径包含：

- slf4j-api-2.0.0.jar
- slf4j-simple-2.0.0.jar

编译和运行*HelloWorld*现在将在控制台上产生以下输出。

```
0 [main] INFO HelloWorld - Hello World
```

### 典型使用模式

下面的示例代码说明了 SLF4J 的典型使用模式。请注意第 15 行使用 `{}`-占位符。请参阅问题[“什么是最快的记录方式？” ](https://www.slf4j.org/faq.html#logging_performance)在常见问题解答中了解更多详细信息。

```java
 1: import org.slf4j.Logger;
 2: import org.slf4j.LoggerFactory;
 3: 
 4: public class Wombat {
 5:  
 6:   final Logger logger = LoggerFactory.getLogger(Wombat.class);
 7:   Integer t;
 8:   Integer oldT;
 9:
10:   public void setTemperature(Integer temperature) {
11:    
12:     oldT = t;        
13:     t = temperature;
14:
15:     logger.debug("Temperature set to {}. Old value was {}.", t, oldT);
16:
17:     if(temperature.intValue() > 50) {
18:       logger.info("Temperature has risen above 50 degrees.");
19:     }
20:   }
21: } 
```

### 流式日志记录 API

**从 2.0.0 开始，** SLF4J API 2.0.0 版需要 Java 8，并引入了向后兼容的流式日志记录 API。通过向后兼容，我们的意思是不必更改现有的日志框架，以便用户从流畅的日志 API 中受益。

其思想是使用[`**LoggingEventBuilder**`](https://www.slf4j.org/apidocs/org/slf4j/spi/LoggingEventBuilder.html) 逐块构建日志事件，并在事件完全构建后进行日志记录。`atTrace()`、`atDebug()`、`atInfo()`、`atWarn()` 和 `atError()` 方法都是 `org.slf4j.Logger` 接口中的新方法，它们返回一个[`LoggingEventBuilder`](https://www.slf4j.org/apidocs/org/slf4j/spi/LoggingEventBuilder.html)实例。对于禁用的日志级别，返回的 `LoggingEventBuilder` 实例什么都不做，从而保留了传统日志接口的纳秒级性能。

使用流式 API 时，您必须通过调用`log()`方法变体之一来终止调用链。无论日志级别如何，忘记调用任何`log()` 方法变体都将导致没有日志记录。幸运的是，许多 IDE 会通过 `“No return value”` 编译器警告来提醒您。

以下是几个使用示例：

语句

```java
logger.atInfo().log("Hello world.");
```

相当于：

```java
logger.info("Hello world.");
```

以下日志语句在其输出中是等效的（对于默认实现）：

```java
int newT = 15;
int oldT = 16;

// using traditional API
logger.debug("Temperature set to {}. Old value was {}.", newT, oldT);

// using fluent API, log message with arguments
logger.atDebug().log("Temperature set to {}. Old value was {}.", newT, oldT);

// using fluent API, add arguments one by one and then log message
logger.atDebug().setMessage("Temperature set to {}. Old value was {}.").addArgument(newT).addArgument(oldT).log();

// using fluent API, add one argument with a Supplier and then log message with one more argument.
// Assume the method t16() returns 16.
logger.atDebug().setMessage("Temperature set to {}. Old value was {}.").addArgument(() -> t16()).addArgument(oldT).log();
      
```

流式日志记录 API 允许将许多不同类型的数据规范到 `org.slf4j.Logger` 中，而不会导致 `Logger` 接口中方法数量的组合爆炸。

现在可以传递多个 [Markers](https://www.slf4j.org/apidocs/org/slf4j/Marker.html)，使用 [Supplier](https://docs.oracle.com/javase/8/docs/api/java/util/function/Supplier.html) 传递参数 或传递多个键值对。键值对与可以自动解释它们的日志数据分析器结合使用特别有用。

以下日志语句是等效的：

```java
int newT = 15;
int oldT = 16;

// using classical API
logger.debug("oldT={} newT={} Temperature changed.", newT, oldT);

// using fluent API
logger.atDebug().setMessge("Temperature changed.").addKeyValue("oldT", oldT).addKeyValue("newT", newT).log();          

```

API 的键值对变体将键值对存储为单独的对象。默认实现为在`org.slf4j.Logger`类 中将键值对作为消息的*前缀。*日志后端是免费的，甚至鼓励提供更可定制的行为。

### 在部署时与日志框架绑定

如前所述，SLF4J 支持各种日志框架。SLF4J 发行版附带了几个称为“SLF4J 提供程序”的 jar 文件，每个提供程序对应一个受支持的框架。SLF4J 1.7 和更早的版本使用术语“绑定”来表示提供程序。

- *slf4j-log4j12-2.0.0.jar*

  [log4j 1.2 版](http://logging.apache.org/log4j/1.2/index.html) 的绑定/提供程序，一个广泛使用的日志框架。鉴于 log4j 1.x 已在 2015 年和 2022 年宣布 EOL，从 SLF4J 1.7.35 开始，*slf4j-log4j* 模块在**构建时**自动重定向到 *slf4j-reload4j* 模块。 假设您希望继续使用 log4j 1.x 框架，我们强烈建议您改用 `slf4j-reload4j`。见下文。

- *slf4j-reload4j-2.0.0.jar*

  **自 1.7.33 以来 RELOAD4J**[框架](http://reload4j.qos.ch/)的绑定/提供程序 。Reload4j 是 log4j 版本 1.2.7 的直接替代品。您还需要将 *reload4j.jar* 放在您的类路径上。

- *slf4j-jdk14-2.0.0.jar*

  `java.util.logging` 的绑定/提供程序，也称为 JDK 1.4 日志记录

- *slf4j-nop-2.0.0.jar*

  [NOP](http://www.slf4j.org/api/org/slf4j/helpers/NOPLogger.html) 的绑定/提供者，默默地丢弃所有日志记录。

- *slf4j-simple-2.0.0.jar*

  [简单 ](http://www.slf4j.org/apidocs/org/slf4j/impl/SimpleLogger.html)实现的绑定/提供程序，它将所有事件输出到 `System.err`。只打印级别 INFO 和更高级别的消息。此绑定在小型应用程序的上下文中可能很有用。

- *slf4j-jcl-2.0.0.jar*

  [Jakarta Commons Logging](http://commons.apache.org/logging/) 的绑定/提供者。此绑定会将所有 SLF4J 日志记录委托给 JCL。

- *logback-classic-${logback.version}.jar（需要 logback-core-${logback.version}.jar）*

  **本地实现**SLF4J 项目外部还有 SLF4J 绑定/提供程序，例如本地实现 SLF4J的[logback](http://logback.qos.ch/) 。Logback 的 [`ch.qos.logback.classic.Logger`](http://logback.qos.ch/apidocs/ch/qos/logback/classic/Logger.html) 类是 SLF4J [`org.slf4j.Logger`](http://www.slf4j.org/apidocs/org/slf4j/Logger.html) 接口的直接实现。因此，将 SLF4J 与 logback 结合使用涉及严格的零内存和计算开销。 



要**切换日志框架**，只需替换类路径上的 slf4j 绑定。例如，要从 `java.util.logging` 切换到 log4j，只需将 `slf4j-jdk14-2.0.0.jar` 替换为 `slf4j-log4j12-2.0.0.jar`。

SLF4J 不依赖任何特殊的类加载器机制。事实上，每个 SLF4J 绑定*在编译时*都是硬连线的， 以**使用一个且只有一个特定的日志框架**。例如，slf4j-log4j12-2.0.0.jar 绑定在编译时绑定为使用 log4j。在您的代码中，除了*slf4j-api-2.0.0.jar 之外*，您只需将 **一个且只有一个**您选择的绑定拖放到适当的类路径位置。不要在类路径上放置多个绑定。

**从 2.0.0 开始**，从 2.0.0 版本开始，SLF4J 绑定被称为提供者。尽管如此，总体思路还是一样的。SLF4J API 版本 2.0.0 依赖[ServiceLoader](https://docs.oracle.com/javase/8/docs/api/java/util/ServiceLoader.html) 机制来查找其日志记录后端。有关更多详细信息，请参阅相关的[常见问题解答条目](https://www.slf4j.org/faq.html#changesInVersion200)。

这是一般想法的图形说明。

[![点击放大](https://www.slf4j.org/images/concrete-bindings.png)](https://www.slf4j.org/images/concrete-bindings.png)

SLF4J 接口及其各种适配器非常简单。大多数熟悉 Java 语言的开发人员应该能够在不到一小时的时间内阅读并完全理解代码。无需了解类加载器，因为 SLF4J 不使用也不直接访问任何类加载器。因此，SLF4J 没有遇到使用 Jakarta Commons Logging (JCL) 观察到的类加载器问题或内存泄漏。

鉴于 SLF4J 接口及其部署模型的简单性，新日志框架的开发人员应该会发现编写 SLF4J 绑定非常容易。

### 库 

广泛分布的组件和库的作者可能会针对 SLF4J 接口进行编码，以避免将日志框架强加给他们的最终用户。因此，最终用户可以在部署时通过在类路径上插入相应的 slf4j 绑定来选择所需的日志框架，稍后可以通过用类路径上的另一个绑定替换现有绑定并重新启动应用程序来更改该绑定。这种方法已被证明是简单且非常健壮的。

**从 SLF4J 版本 1.6.0 开始**，如果在类路径上找不到绑定，则 slf4j-api 将默认为丢弃所有日志请求的无操作实现。`NoClassDefFoundError`因此，SLF4J 版本 1.6.0 和更高版本不会因为 缺少类而抛出 a ，而是`org.slf4j.impl.StaticLoggerBinder`会发出一条关于没有绑定的警告消息，并继续丢弃所有日志请求而无需进一步抗议。例如，让 Wombat 成为一些依赖 SLF4J 进行日志记录的生物学相关框架。为了避免将日志框架强加给最终用户，Wombat 的发行版包括*slf4j-api.jar* 但没有约束力。即使类路径上没有任何 SLF4J 绑定，Wombat 的分发仍然可以开箱即用，并且不需要最终用户从 SLF4J 的网站下载绑定。只有当最终用户决定启用日志记录时，她才需要安装与她选择的日志记录框架相对应的 SLF4J 绑定。

**基本规则** **诸如库或框架之类的嵌入式组件不应声明对任何 SLF4J 绑定/提供程序的依赖，而应仅依赖 slf4j-api**。当库声明对特定绑定的传递依赖时，该绑定被强加给最终用户，否定了 SLF4J 的目的。请注意，声明对绑定的非传递依赖（例如用于测试）不会影响最终用户。

SLF4J 在嵌入式组件中的使用也在与[日志配置](https://www.slf4j.org/faq.html#configure_logging)、[依赖性减少](https://www.slf4j.org/faq.html#optional_dependency)和 [测试](https://www.slf4j.org/faq.html#optional_dependency)相关的常见问题解答中进行了讨论。

### 声明项目依赖项以进行日志记录

鉴于 Maven 的传递依赖规则，对于“常规”项目（不是库或框架），声明日志依赖关系可以通过单个依赖声明来完成。

**LOGBACK-CLASSIC**如果您希望使用 logback-classic 作为底层日志框架，您只需在*pom.xml*文件中声明“ch.qos.logback:logback-classic”作为依赖项，如下所示。除了*logback-classic-${logback.version}.jar 之外*，这会将 *slf4j-api-2.0.0.jar*和 *logback-core-${logback.version}.jar*引入您的项目。请注意，明确声明对 *logback-core-${logback.version}*或 *slf4j-api-2.0.0.jar 的依赖*没有错，并且可能有必要通过 Maven 的“最近定义”依赖调解规则来强加所述工件的正确版本。

```
<依赖> 
  < groupId > ch.qos.logback </ groupId >
  < artifactId > logback-classic </ artifactId >
  <版本> ${logback.version} </版本>
</依赖>
```



**RELOAD4J如果您希望使用 RELOAD4J 作为底层日志框架，您需要做的就是在***pom.xml*文件中声明“org.slf4j:slf4j-reload4j”作为依赖项， 如下所示。除了 *slf4j-reload4j-2.0.0.jar 之外*，这会将*slf4j-api-2.0.0.jar*和*reload4j-${reload4j.version}.jar*引入您的项目。请注意，明确声明对 *reload4j-${reload4j.version}.jar*或 *slf4j-api-2.0.0.jar 的依赖*并没有错，并且可能有必要通过 Maven 的“最近定义”来强加所述工件的正确版本依赖调解规则。

```
<依赖> 
  < groupId > org.slf4j </ groupId >
  < artifactId > slf4j-reload4j </ artifactId >
  <版本> 2.0.0 </版本>
</依赖>
```

**LOG4J**从 1.7.35 版开始，通过 Maven <relocation> 指令声明对`org.slf4j:slf4j-log4j12` 重定向的依赖。`org.slf4j:slf4j-reload4j`

```
<依赖> 
  < groupId > org.slf4j </ groupId >
  < artifactId > slf4j-log4j12 </ artifactId >
  <版本> 2.0.0 </版本>
</依赖>
```



**JAVA.UTIL.LOGGING**如果您希望使用 java.util.logging 作为底层日志框架，您需要做的就是在*pom.xml* 文件中声明“org.slf4j:slf4j-jdk14”作为依赖项，如下所示. 除了 *slf4j-jdk14-2.0.0.jar 之外*，这会将*slf4j-api-2.0.0.jar 拉*入您的项目中。请注意，明确声明对 *slf4j-api-2.0.0.jar*的依赖并没有错，并且可能需要借助 Maven 的“最近定义”依赖调解规则来强制实施所述工件的正确版本。

```
<依赖> 
  < groupId > org.slf4j </ groupId >
  < artifactId > slf4j-jdk14 </ artifactId >
  <版本> 2.0.0 </版本>
</依赖>
```

### 二进制兼容性

SLF4J 绑定指定诸如 *slf4j-jdk14.jar*或*slf4j-log4j12.jar 之类*的工件，用于 将 slf4j*绑定*到底层日志框架，例如 java.util.logging 和 log4j。

从客户端的角度来看，所有版本的 slf4j-api 都是兼容的。使用 slf4j-api-N.jar 编译的客户端代码可以在任何 N 和 M 的 slf4j-api-M.jar 下完美运行。您只需确保绑定的版本与 slf4j-api.jar 的版本匹配。您不必担心项目中给定依赖项使用的 slf4j-api.jar 版本。

混合不同版本的*slf4j-api.jar*和 SLF4J 绑定可能会导致问题。例如，如果您使用的是 slf4j-api-2.0.0.jar，那么您也应该使用 slf4j-simple-2.0.0.jar，使用 slf4j-simple-1.5.5.jar 将不起作用。

但是，从客户端的角度来看，所有版本的 slf4j-api 都是兼容的。*使用slf4j-api-N.jar*编译的客户端代码 可以在任何 N 和 M*的 slf4j-api-M.jar*下完美运行 。您只需确保绑定的版本与 slf4j-api.jar 的版本匹配。您不必担心项目中给定依赖项使用的 slf4j-api.jar 版本。您始终可以使用任何版本的*slf4j-api.jar*，只要 slf4j-api.jar 的版本*及其*绑定匹配，就可以了。

在初始化时，如果 SLF4J 怀疑可能存在 slf4j-api 与绑定版本不匹配的问题，它会发出疑似不匹配的警告。

### 通过 SLF4J 合并日志记录

很多时候，一个给定的项目将依赖于依赖于除 SLF4J 之外的日志 API 的各种组件。根据 JCL、java.util.logging、log4j 和 SLF4J 的组合来查找项目是很常见的。然后希望通过单个通道合并日志记录。SLF4J 通过为 JCL、java.util.logging 和 log4j 提供桥接模块来满足这个常见的用例。有关更多详细信息，请参阅[**桥接旧版 API**](https://www.slf4j.org/legacy.html)页面。

### 支持 JDK 平台日志记录 (JEP 264) SLF4J

**从 2.0.0-** alpha5 *开始 slf4j-jdk-platform-logging*模块增加了对[JDK Platform Logging](http://openjdk.java.net/jeps/264)的支持。

```
<依赖> 
  < groupId > org.slf4j </ groupId >
  < artifactId > slf4j-jdk-platform-logging </ artifactId >
  <版本> 2.0.0 </版本>
</依赖>
```

### 映射诊断上下文 (MDC) 支持

“映射诊断上下文”本质上是由日志框架维护的映射，其中应用程序代码提供键值对，然后可以由日志框架插入日志消息中。MDC 数据在过滤消息或触发某些操作方面也非常有用。

SLF4J 支持 MDC 或映射诊断上下文。如果底层日志框架提供 MDC 功能，那么 SLF4J 将委托给底层框架的 MDC。请注意，目前只有 log4j 和 logback 提供 MDC 功能。如果底层框架不提供 MDC，例如 java.util.logging，则 SLF4J 仍将存储 MDC 数据，但其中的信息需要通过自定义用户代码检索。

因此，作为 SLF4J 用户，您可以在存在 log4j 或 logback 的情况下利用 MDC 信息，但不会将这些日志框架作为依赖项强加给您的用户。

有关 MDC 的更多信息，请参阅 logback 手册中 [有关 MDC 的章节。](http://logback.qos.ch/manual/mdc.html)

### 执行摘要

| 优势                     | 描述                                                         |
| ------------------------ | ------------------------------------------------------------ |
| 在部署时选择您的日志框架 | 通过在类路径中插入适当的 jar 文件（绑定），可以在部署时插入所需的日志框架。 |
| 快速故障操作             | 由于 JVM 加载类的方式，框架绑定将在很早的时候自动验证。如果 SLF4J 在类路径上找不到绑定，它将发出一条警告消息并默认为无操作实现。 |
| 流行日志框架的绑定       | SLF4J 支持流行的日志框架，即 log4j、java.util.logging、Simple logging 和 NOP。[logback](http://logback.qos.ch/)项目原生支持 SLF4J。 |
| 桥接旧的日志记录 API     | JCL over SLF4J 的实现，即 *jcl-over-slf4j.jar*，将允许您的项目逐步迁移到 SLF4J，而不会破坏与使用 JCL 的现有软件的兼容性。同样，log4j-over-slf4j.jar 和 jul-to-slf4j 模块将允许您将 log4j 和 java.util.logging 调用分别重定向到 SLF4J。有关更多详细信息， 请参阅[桥接旧版 API页面。](https://www.slf4j.org/legacy.html) |
| 迁移您的源代码           | slf4j [-migrator](https://www.slf4j.org/migrator.html)实用程序可以帮助您迁移源代码以使用 SLF4J。 |
| 支持参数化日志消息       | 所有 SLF4J 绑定都支持参数化日志消息，[性能](https://www.slf4j.org/faq.html#logging_performance) 结果显着提高。 |