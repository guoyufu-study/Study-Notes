## `SpringApplicationBuilder`

> `org.springframework.boot.builder.SpringApplicationBuilder`

### 分析

#### 声明

![SpringApplicationBuilder-声明](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-声明.png)

`SpringApplication` 实例和 `ApplicationContext` 实例的构建器，具有便捷的流式 API 和 `context` 层次结构支持。

`context` 层次结构的简单示例：

``` java
new SpringApplicationBuilder(ParentConfig.class).child(ChildConfig.class).run(args);
```

另一个常见用例是设置活动 `profiles` 和默认 `properties` 以设置应用程序的环境：

``` java
new SpringApplicationBuilder(Application.class).profiles("server")
  		.properties("transport=local").run(args);
```

如果您的需求更简单，请考虑使用 `SpringApplication` 中的静态便捷方法。

#### 构造器

![SpringApplicationBuilder-构造](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-构造.png)

#### 访问器

![SpringApplicationBuilder-访问器](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-访问器.png)



#### 构建

返回一个准备好运行的完整配置的 `SpringApplication`。

![SpringApplicationBuilder-构建](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-构建.png)

#### properties

##### `String`

环境的默认属性，格式为 `key=value` 或 `key:value` 。多次调用此方法是累积的，不会清除任何先前设置的属性。

![SpringApplicationBuilder-properties](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-properties.png)

##### `Properties`

![SpringApplicationBuilder-properties-Properties](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-properties-Properties.png)

##### `Map`

![SpringApplicationBuilder-properties-map](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplicationBuilder-properties-map.png)

#### 初始化器

向应用程序添加一些初始化程序（在加载任何 bean 定义之前应用于 `ApplicationContext` ）。

#### 监听器

向应用程序添加一些侦听器（在上下文运行时侦听 `SpringApplication` 事件以及常规 Spring 事件）。同时也是`ApplicationContextInitializer` 的任何侦听器都将自动添加到 `initializers` 中。

#### `ApplicationStartup`

将 `ApplicationContext` 配置为与 `ApplicationStartup` 一起使用以收集启动指标。



使用提供的命令行参数创建应用程序上下文(如果指定了父上下文，也创建其父上下文)。如果父进程还没有启动，则会使用相同的参数先运行它。



## `SpringApplication`



### 分析

#### 类声明

#### 构造器

#### 源

向主源添加额外的项，当 `run(String…)` 被调用时将主源添加到 `ApplicationContext`。

这里的源被添加到构造函数中设置的源中。大多数用户应该考虑使用 `getSources()/setSources(Set)` 而不是调用这个方法。

![SpringApplication-sources](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplication-sources.png)

#### 运行

##### 静态方法

![SpringApplication-run-static](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplication-run-static.png)

`main`：可用于启动应用程序的基本 main。当通过 `--spring.main.sources` 命令行参数定义应用程序源时，此方法很有用。
大多数开发人员都希望定义自己的 `main` 方法并调用 `run` 方法。

`run`：静态助手，可用于使用默认设置和用户提供的参数从指定的源运行 `SpringApplication` 。



##### 核心方法

运行 Spring 应用程序，创建并刷新一个新的 `ApplicationContext` 。

![SpringApplication-run](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-boot\images\SpringApplication-run.png)



