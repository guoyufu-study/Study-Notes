## `ITemplateEngine`

> `org.thymeleaf.ITemplateEngine`

接口由 `Thymeleaf` 模板引擎实现。

这个接口只提供了一个开箱即用的实现：`TemplateEngine`。该接口旨在用于模拟或创建原型。



### 类结构

![ITemplateEngine](images\ITemplateEngine.png)



处理指定的模板（通常是模板名称）。一旦模板处理完成，输出将被写入一个 `String` ，调用此方法将返回该 `String`。
这实际上是一种便捷的方法，它将在内部创建一个 `TemplateSpec` 然后调用 `process(TemplateSpec, IContext)` 。

![ITemplateEngine-process-convenience](images\ITemplateEngine-process-convenience.png)



## `TemplateEngine`

> `org.thymeleaf.TemplateEngine`

### 类声明

用于执行模板的主类。
这是 `TemplateEngine` 提供的唯一一个现成的 `ITemplateEngine` 实现。

#### 创建 `TemplateEngine` 的实例

可以在任何时候通过调用这个类的构造函数来创建这个类的实例：
``` java
final TemplateEngine templateEngine = new TemplateEngine();
```

创建和配置 `TemplateEngine` 实例的开销很大，因此建议只创建该类的一个实例(或者每个方言/配置至少创建一个实例)，并使用它处理多个模板。

#### 配置 `TemplateEngine`

`TemplateEngine`的实例一旦创建，通常需要配置一种解析模板的机制（即获取和读取模板）：

* 一个或多个**模板解析器**（ `ITemplateResolver` 的实现），负责读取或获取模板，以便引擎能够处理它们。如果只设置了一个模板解析器（最常见的情况），则可以使用 `setTemplateResolver(ITemplateResolver)` 方法。如果要设置更多解析器，可以使用`setTemplateResolvers(Set)` 和 `addTemplateResolver(ITemplateResolver)` 方法。

* 如果没有配置模板解析器， `TemplateEngine` 实例将使用 `StringTemplateResolver` 实例，该实例将指定要处理的模板作为模板内容（而不仅仅是它们的名称）。当第一次调用 `setTemplateResolver(ITemplateResolver)` 、 `setTemplateResolvers(Set)` 或 `addTemplateResolver(ITemplateResolver)` 时，此配置将被覆盖。

将根据一组配置好的**方言**（ `IDialect` 的实现）处理模板，定义处理模板的方式：处理器、表达式对象等。如果没有显式设置方言，则将使用 `StandardDialect` （标准方言）的唯一实例。

* 方言定义了一个默认前缀，如果没有另外指定，将为它们使用该前缀。
* 设置/添加方言时，可以为每个方言指定一个非默认前缀。
* 几种方言可以使用相同的前缀，有效地充当聚合方言。

那些包含任何外部化消息（也包括国际化消息，i18n）的模板将需要 `TemplateEngine` 配置一个或多个**消息解析器**（ `IMessageResolver`的实现）。如果没有显式设置消息解析器， `TemplateEngine` 将默认为 `StandardMessageResolver` 的单个实例。
如果只设置一个消息解析器，则可以使用 `setMessageResolver(IMessageResolver)` 方法。如果要设置更多解析器，可以使用 `setMessageResolvers(Set)` 和 `addMessageResolver(IMessageResolver)` 方法。

此外，从模板构建链接 URL 将需要配置至少一个**链接构建器**（ `ILinkBuilder` 的实现），该链接构建器将负责为输出的 URL 提供形状。如果没有明确设置链接构建器，则 `StandardLinkBuilder` 将设置为默认实现，在特定类型的 URL 需要时使用 `java Servlet API`。

除此之外，还可以配置**缓存管理器**（ `ICacheManager` 的实现）。缓存管理器负责提供缓存对象（ `org.thymeleaf.cache.ICache` 的实例）用于缓存（至少）解析的模板和解析的表达式。默认情况下，使用 `StandardCacheManager` 实例。如果通过调用 `setCacheManager(ICacheManager)` 指定了空缓存管理器，则不会使用缓存。

#### 模板执行

##### 创建上下文

所有模板执行都需要一个 context 。context 是实现 `IContext` 接口的对象，并且至少包含以下数据：

* 用于消息外部化（国际化）的语言环境 `locale`。

* `context` 变量。可从执行模板中的表达式中使用的变量映射。

开箱即用地提供了两个 `IContext` 实现：

* `org.thymeleaf.context.Context` ，一个只包含所需数据的标准实现。

* `org.thymeleaf.context.WebContext` ，扩展 `org.thymeleaf.context.IWebContext` 子接口的特定于 Web 的实现，提供对特殊表达式对象中的 `request`、`session` 和 `servletcontext`（`application`）属性的访问。使用 `Thymeleaf` 在基于 `Servlet API` 的 Web 应用程序中生成 HTML 接口时，需要使用 `org.thymeleaf.context.IWebContext` 的实现。

创建 `org.thymeleaf.context.Context`实例非常简单：

``` java
final Context ctx = new Context();
ctx.setVariable("allItems", items);
```

如果需要，您还可以指定用于处理模板的语言环境 `locale`： 
``` java
final Context ctx = new Context(new Locale("gl","ES"));
ctx.setVariable("allItems", items);
```

`org.thymeleaf.context.WebContext` 还需要 `javax.servlet.http.HttpServletRequest` 、 `javax.servlet.http.HttpServletResponse` 和 `javax.servlet.ServletContext` 对象作为构造函数参数：

``` java
final WebContext ctx = new WebContext(request, response, servletContext);
ctx.setVariable("allItems", items);
```

有关更多详细信息，请参阅这些特定实现的文档。

##### 模板处理

为了执行模板，应该使用不同的 `process(...)` 方法。它们主要分为两个块：将模板处理结果作为 `String` 返回的块，以及接收 `Writer` 作为参数并将其用于写入结果的块。
如果没有 `writer`，处理结果将作为 `String` 返回：

``` java
final String result = templateEngine.process("mytemplate", ctx);
```

通过指定 `writer`，我们可以避免创建包含整个处理结果的字符串，方法是在从已处理的模板生成该结果后立即将该结果写入输出流。这在 Web 场景中特别有用（并且强烈推荐）：
``` java
templateEngine.process("mytemplate", ctx, httpServletResponse.getWriter());
```

`"mytemplate"` 字符串参数是模板名称，它将以模板解析器/s 中配置的方式与模板本身的物理/逻辑位置相关。

注意，自1.0 以来就有一个名为这个名字的类，但在 `Thymeleaf` 3.0 中它被完全重新实现了

### 类结构

![TemplateEngine](images\TemplateEngine.png)

#### 方法

##### `constructor`

`TemplateEngine` 对象的构造函数。
这是创建 `TemplateEngine` 实例的唯一方法（应在创建后配置）。

![TemplateEngine-Constructor](images\TemplateEngine-Constructor.png)

##### `process`



从 `TemplateSpec` 开始处理模板。。当处理模板生成输出时，输出将被写入指定的 `writer`。这对于 Web 环境特别有用（使用 `javax.servlet.http.HttpServletResponse.getWriter()` ）。
模板规范 `templateSpec` 将用作模板解析器的输入，在链中查询，直到其中一个解析模板，然后执行。
上下文 `context` 将包含可用于在模板内执行表达式的变量。

![ITemplateEngine-process](images\ITemplateEngine-process.png)

具体实现

![TemplateEngine-process](images\TemplateEngine-process.png)