# Spring MVC 入口

## 配置示例

``` java
public class AnnotationConfigDispatcherServletInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] {RootConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[] {WebConfig.class};
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] {"/demo", "/"};
    }
}
```



## 原理

![springmvc启动入口](images\springmvc启动入口.png)



## `SpringServletContainerInitializer`

> `org.springframework.web.SpringServletContainerInitializer`

Servlet 3.0 `ServletContainerInitializer` 设计用于支持使用 Spring 的 `WebApplicationInitializer` SPI 的基于代码的 Servlet 容器配置，这与传统的基于 `web.xml` 的方法相反(或可能与之结合)。

### 运作机制

假设 `spring-web` 模块 JAR 存在于类路径中，则这个类将被加载和实例化，并在容器启动期间由任何符合 Servlet 3.0 的容器调用其`onStartup` 方法。这是通过检测 `spring-web` 模块的 `META-INF/services/javax.servlet.ServletContainerInitializer` 服务提供者配置文件的 JAR 服务 API `ServiceLoader.load(Class)` 方法发生的。有关完整的详细信息，请参阅 [JAR 服务 API 文档](https://docs.oracle.com/javase/6/docs/technotes/guides/jar/jar.html#Service%20Provider) 以及 Servlet 3.0 最终草案规范的第 8.2.4节。



### 结合 `web.xml`

Web 应用程序可以选择通过 `web.xml` 中的 `metadata-complete` 属性来限制 Servlet 容器在启动时扫描的类路径的数量，该属性控制对 Servlet 注解的扫描，或者通过 `web.xml` 中的 `<absolute-ordering>` 元素，它控制允许哪些 Web 片段（即 jars）执行`ServletContainerInitializer` 扫描。使用此功能时，可以通过将 `SpringServletContainerInitializer` 添加到 `web.xml` 中的命名 Web 片段列表中来启用 `SpringServletContainerInitializer`，如下所示：

``` xml
<absolute-ordering>
    <name>some_web_fragment</name>
    <name>spring_web</name>
</absolute-ordering>
```



### 与 Spring 的 `WebApplicationInitializer` 的关系

Spring 的 `WebApplicationInitializer` SPI 仅包含一种方法： `WebApplicationInitializer.onStartup(ServletContext)` 。签名有意与`ServletContainerInitializer.onStartup(Set, ServletContext)` 非常相似：简单地说， `SpringServletContainerInitializer` 负责实例化 `ServletContext` 并将其委托给任何用户定义的 `WebApplicationInitializer` 实现。然后每个 `WebApplicationInitializer` 负责执行初始化 `ServletContext` 的实际工作。委托的确切过程在下面的 `onStartup` 文档中有详细描述。



### 一般注意事项

通常，此类应被视为更重要且面向用户的 `WebApplicationInitializer` SPI 的支持基础架构。利用这个容器初始化器也是完全可选的：虽然这个初始化器确实会在所有 Servlet 3.0+ 运行时下加载和调用，但用户可以选择是否在类路径上提供任何 `WebApplicationInitializer` 实现。如果未检测到 `WebApplicationInitializer` 类型，则此容器初始化程序将无效。
请注意，这个容器初始化器和 `WebApplicationInitializer` 的使用与 Spring MVC 没有任何“关联”，除了这些类型在 `spring-web` 模块 JAR 中提供。相反，它们可以被认为是通用的，因为它们能够方便地对 `ServletContext` 进行基于代码的配置。换句话说，任何 servlet、监听器或过滤器都可以在 `WebApplicationInitializer` 中注册，而不仅仅是 Spring MVC 特定的组件。
这个类既不是为扩展而设计的，也不是为了扩展而设计的。它应该被认为是一种内部类型，其中 `WebApplicationInitializer` 是面向公众的 SPI。

### 也可以看看

有关示例和详细的使用建议，请参阅 `WebApplicationInitializer` Javadoc。



## `WebApplicationInitializer`

> `org.springframework.web.WebApplicationInitializer`

要在 Servlet 3.0+ 环境中实现的接口，以便以编程方式配置 `ServletContext` - 与传统的基于 `web.xml` 的方法相反（或可能结合使用）。
此 SPI 的实现将由 `SpringServletContainerInitializer` 自动检测，它本身由任何 Servlet 3.0 容器自动引导。有关此引导机制的详细信息，请参阅其 Javadoc 。

### 示例

#### 传统的基于 XML 的方法、

大多数构建 Web 应用程序的 Spring 用户都需要注册 Spring 的 `DispatcherServlet` 。作为参考，在 `WEB-INF/web.xml` 中，这通常会按如下方式完成：

``` xml
<servlet>
    <servlet-name>dispatcher</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/spring/dispatcher-config.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>dispatcher</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```



#### 使用 `WebApplicationInitializer` 的基于代码的方法

这是等效的 `DispatcherServlet` 注册逻辑， `WebApplicationInitializer` 风格：

``` java
public class MyWebAppInitializer implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext container) {
        XmlWebApplicationContext appContext = new XmlWebApplicationContext();
        appContext.setConfigLocation("/WEB-INF/spring/dispatcher-config.xml");

        ServletRegistration.Dynamic dispatcher =
            container.addServlet("dispatcher", new DispatcherServlet(appContext));
        dispatcher.setLoadOnStartup(1);
        dispatcher.addMapping("/");
    }
}
```

作为上述的替代方案，您还可以从 `org.springframework.web.servlet.support.AbstractDispatcherServletInitializer` 扩展。如您所见，由于 Servlet 3.0 的新 `ServletContext.addServlet` 方法，我们实际上是在注册 `DispatcherServlet` 的一个实例，这意味着`DispatcherServlet` 现在可以像任何其他对象一样被对待——接收其应用程序上下文的构造函数注入在这种情况下。

这种风格既简单又简洁。无需担心处理 `init-params` 等，只需处理普通的 JavaBean 样式属性和构造函数参数即可。在将 Spring 应用程序上下文注入 `DispatcherServlet` 之前，您可以根据需要自由创建和使用它们。

大多数主要的 Spring Web 组件都已更新以支持这种注册方式。您会发现 `DispatcherServlet`、 `FrameworkServlet` 、 `ContextLoaderListener` 和 `DelegatingFilterProxy` 现在都支持构造函数参数。即使组件（例如非 Spring，其他第三方）没有被专门更新以在 `WebApplicationInitializer`s 中使用，它们仍然可以在任何情况下使用。 Servlet 3.0 ServletContext API 允许以编程方式设置 `init-params`、`context-params` 等。

### 100% 基于代码的配置方法
在上面的示例中， `WEB-INF/web.xml` 已成功替换为 `WebApplicationInitializer` 形式的代码，但实际的 `dispatcher-config.xml` Spring 配置仍然基于 XML。 `WebApplicationInitializer` 非常适合与 Spring 的基于代码的 `@Configuration` 类一起使用。有关完整的详细信息，请参阅 `@Configuration` Javadoc，但以下示例演示了重构以使用 `XmlWebApplicationContext` 的 `AnnotationConfigWebApplicationContext` 代替 `Configuration`，以及用户定义的 `@Configuration` 类 `AppConfig` 和 `DispatcherConfig` 而不是 Spring XML 文件。此示例还比上面的示例更进一步，以演示“根”应用程序上下文的典型配置和 `ContextLoaderListener` 的注册：

``` java
public class MyWebAppInitializer implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext container) {
        // Create the 'root' Spring application context
        AnnotationConfigWebApplicationContext rootContext =
            new AnnotationConfigWebApplicationContext();
        rootContext.register(AppConfig.class);

        // Manage the lifecycle of the root application context
        container.addListener(new ContextLoaderListener(rootContext));

        // Create the dispatcher servlet's Spring application context
        AnnotationConfigWebApplicationContext dispatcherContext =
            new AnnotationConfigWebApplicationContext();
        dispatcherContext.register(DispatcherConfig.class);

        // Register and map the dispatcher servlet
        ServletRegistration.Dynamic dispatcher =
            container.addServlet("dispatcher", new DispatcherServlet(dispatcherContext));
        dispatcher.setLoadOnStartup(1);
        dispatcher.addMapping("/");
    }
}
```

作为上述的替代方案，您还可以从 `org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer` 扩展。请记住， `WebApplicationInitializer` 实现是自动检测的——因此您可以随意将它们打包到您的应用程序中。

### 排序 `WebApplicationInitializer` 执行

`WebApplicationInitializer` 实现可以选择在类级别使用 Spring 的 `Order` 注解进行注解，或者可以实现 Spring 的 `Ordered` 接口。如果是这样，初始化器将在调用之前排序。这为用户提供了一种机制来确保 servlet 容器初始化发生的顺序。预计很少使用此功能，因为典型应用程序可能会将所有容器初始化集中在单个 `WebApplicationInitializer` 中。

### 注意事项

#### `web.xml` 版本控制

`WEB-INF/web.xml` 和 `WebApplicationInitializer` 的使用不是互斥的；例如，`web.xml` 可以注册一个 servlet，而`WebApplicationInitializer` 可以注册另一个。初始化程序甚至可以通过 `ServletContext.getServletRegistration(String)` 等方法修改在 `web.xml` 中执行的注册。但是，如果应用程序中存在 `WEB-INF/web.xml`  ，则其 `version` 属性必须设置为 `3.0` 或更高版本，否则`ServletContainerInitializer` 引导将被 servlet 容器忽略。

#### Tomcat 下映射到 `/`

Apache Tomcat 将其内部 `DefaultServlet` 映射到 `/`，并且在 Tomcat 版本 `<= 7.0.14` 上，不能以编程方式覆盖此 servlet 映射。 7.0.15 修复了这个问题。覆盖 `/` servlet 映射也已在 GlassFish 3.1 下成功测试。



## `AbstractContextLoaderInitializer`

用于**在 servlet 上下文中注册 `ContextLoaderListener`** 的 `WebApplicationInitializer` 实现的方便基类。
子类需要实现的唯一方法是 `createRootApplicationContext()`  ，它从 `registerContextLoaderListener(ServletContext)` 调用。



![Abstract Context Loader Initializer 结构](images\AbstractContextLoaderInitializer结构.png)

### `registerContextLoaderListener`

针对给定的 servlet 上下文注册一个 `ContextLoaderListener` 。 `ContextLoaderListener`使用从 `createRootApplicationContext()` 模板方法返回的应用程序上下文进行初始化。



## `AbstractDispatcherServletInitializer`

> `org.springframework.web.servlet.support.AbstractDispatcherServletInitializer`

**在 servlet 上下文中注册 `DispatcherServlet`** 的 `org.springframework.web.WebApplicationInitializer` 实现的基类。
大多数应用程序应该考虑扩展 Spring Java 配置子类 `AbstractAnnotationConfigDispatcherServletInitializer` 。

![Abstract Dispatcher Servlet Initializer 结构](images\AbstractDispatcherServletInitializer.png)

### `registerDispatcherServlet`

针对给定的 servlet 上下文注册 `DispatcherServlet` 。
此方法将使用 `getServletName()` 返回的名称创建一个 `DispatcherServlet`，使用从 `createServletApplicationContext()` 返回的应用程序上下文对其进行初始化，并将其映射到从 `getServletMappings()` 返回的模式。
可以通过覆盖 `customizeRegistration(ServletRegistration.Dynamic)` 或 `createDispatcherServlet(WebApplicationContext)` 来实现进一步的定制。

![AbstractDispatcherServletInitializer-registerDispatcherServlet](images\AbstractDispatcherServletInitializer-registerDispatcherServlet.png)



## `AbstractAnnotationConfigDispatcherServletInitializer`

> `org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer`

`WebApplicationInitializer` 注册一个 `DispatcherServlet` 并使用基于 Java 的 Spring 配置。

实现需要实现：

* `getRootConfigClasses()` -- 用于“根”应用程序上下文（非 Web 基础设施）配置。
* `getServletConfigClasses()` -- 用于 `DispatcherServlet` 应用程序上下文（Spring MVC 基础设施）配置。

如果不需要应用程序上下文层次结构，应用程序可以通过 `getRootConfigClasses()` 返回所有配置，并从 `getServletConfigClasses()` 返回 `null` 。

![AbstractAnnotationConfigDispatcherServletInitializer结构](images\AbstractAnnotationConfigDispatcherServletInitializer结构.png)

### `createRootApplicationContext`

创建要提供给 `ContextLoaderListener` 的“根”应用程序上下文。
返回的上下文被委托给 `ContextLoaderListener.ContextLoaderListener(WebApplicationContext)` 并将被建立为任何 `DispatcherServlet` 应用程序上下文的父上下文。因此，它通常包含中间层服务、数据源等。
此实现创建一个 `AnnotationConfigWebApplicationContext` ，为它提供由 `getRootConfigClasses()` 返回的带注解的类。如果`getRootConfigClasses()` 返回 `null`，则返回 `null`。

### `createServletApplicationContext`

创建要提供给 `DispatcherServlet` 的 servlet 应用程序上下文。
返回的上下文被委托给 Spring 的 `DispatcherServlet.DispatcherServlet(WebApplicationContext)`。因此，它通常包含控制器、视图解析器、语言环境解析器和其他与 Web 相关的 bean。
此实现创建一个 `AnnotationConfigWebApplicationContext` ，为它提供由 `getServletConfigClasses()` 返回的带注解的类。



