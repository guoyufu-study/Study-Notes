## `DispatcherServlet`

Spring MVC 与许多其他 Web 框架一样，是**围绕前端控制器模式设计**的，其中一个**中央控制器 `Servlet`， `DispatcherServlet`， 为请求处理提供共享算法，而实际工作由可配置的委托组件执行**。该模型非常灵活，支持多种工作流程。

 `DispatcherServlet` 和所有 `Servlet` 一样，需要通过使用 Java 配置或通过在`web.xml` 中根据 Servlet 规范声明和映射。反过来，`DispatcherServlet`使用 Spring 配置来发现请求映射、视图解析、异常处理[等](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-servlet-special-bean-types)所需的委托组件。

以下 **Java 配置**示例**注册并初始化 `DispatcherServlet`** ，它由 Servlet 容器自动检测到 （请参阅[Servlet 配置](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-container-config)）：

``` java
public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) {

        // Load Spring web application configuration
        AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
        context.register(AppConfig.class);

        // Create and register the DispatcherServlet
        DispatcherServlet servlet = new DispatcherServlet(context);
        ServletRegistration.Dynamic registration = servletContext.addServlet("app", servlet);
        registration.setLoadOnStartup(1);
        registration.addMapping("/app/*");
    }
}
```

> 除了直接使用 ServletContext API，您还可以扩展 `AbstractAnnotationConfigDispatcherServletInitializer` 并覆盖特定方法（参见 [Context Hierarchy](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-servlet-context-hierarchy) 下的示例）。

> 对于编程用例， `GenericWebApplicationContext` 可以用作 `AnnotationConfigWebApplicationContext` 的替代品。有关详细信息，请参阅 [`GenericWebApplicationContext`](https://docs.spring.io/spring-framework/docs/5.3.21/javadoc-api/org/springframework/web/context/support/GenericWebApplicationContext.html) javadoc。

以下 **`web.xml` 配置**示例**注册并初始化 `DispatcherServlet`**：

``` xml
<web-app>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/app-context.xml</param-value>
    </context-param>

    <servlet>
        <servlet-name>app</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value></param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app</servlet-name>
        <url-pattern>/app/*</url-pattern>
    </servlet-mapping>

</web-app>
```

> Spring Boot 遵循不同的初始化顺序。Spring Boot 不是挂钩到 Servlet 容器的生命周期，而是使用 Spring 配置来引导自身和嵌入式 Servlet 容器。`Filter`和`Servlet`声明在 Spring 配置中被检测到并注册到 Servlet 容器中。有关更多详细信息，请参阅 [Spring Boot 文档](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-embedded-container)。

### 上下文层次结构

`DispatcherServlet` 需要一个 `WebApplicationContext` ( 普通 `ApplicationContext` 的一个扩展) 用于它自己的配置。`WebApplicationContext` 与 `ServletContext` 及其相关联的 `Servlet` 有一个链接。它还绑定到 `ServletContext`，这样应用在需要访问 `WebApplicationContext` 时，可以在 `RequestContextUtils` 上使用静态方法来查找 `WebApplicationContext`。

对于许多应用，拥有一个 `WebApplicationContext` 简单且足够。也可以有一个上下文层次结构，其中一个根 `WebApplicationContext` 在多个 `DispatcherServlet`（或其他 `Servlet`）实例之间共享，每个实例都有自己的子 `WebApplicationContext` 配置。 有关上下文层次结构功能的更多信息，请参阅[`ApplicationContext`附加功能](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#context-introduction)。

根 `WebApplicationContext` 通常包含基础设施 bean，例如需要跨多个 `Servlet` 实例共享的数据存储库和业务服务。这些 bean 被有效地继承，并且可以在特定于 Servlet 的子 `WebApplicationContext` 中被重写（即重新声明），该子 `WebApplicationContext` 通常包含给定 `Servlet` 的本地 beans。下图显示了这种关系：

<img src="https://docs.spring.io/spring-framework/docs/current/reference/html/images/mvc-context-hierarchy.png" alt="DispatcherServlet" style="zoom: 80%;" />

以下示例配置 `WebApplicationContext` 层次结构：

``` java
public class MyWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        // 指定要提供给 root application context 的@Configuration和/或@Component类。
        return new Class<?>[] { RootConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        // 指定要提供给 dispatcher servlet application context 的@Configuration和/或@Component类。
        return new Class<?>[] { App1Config.class };
    }

    @Override
    protected String[] getServletMappings() {
        //为 DispatcherServlet 指定 servlet 映射——例如"/" 、 "/app"等。
        return new String[] { "/app1/*" };
    }
}
```

> **`org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer`**
>
> `org.springframework.web.WebApplicationInitializer` 实现的基类，它注册一个带有注解的类配置的 `DispatcherServlet`，例如 Spring 的 `@Configuration` 类。
> 实现 `getRootConfigClasses()` 和 `getServletConfigClasses()` 以及 `getServletMappings()` 需要具体的实现。 `AbstractDispatcherServletInitializer` 提供了更多的模板和自定义方法

> 如果不需要应用上下文层次结构，应用可以通过 `getRootConfigClasses()` 返回所有配置，并从 `getServletConfigClasses()` 返回 `null`。

以下示例显示了 `web.xml` 等效项：

``` xml
<web-app>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/root-context.xml</param-value>
    </context-param>

    <servlet>
        <servlet-name>app1</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/app1-context.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>app1</servlet-name>
        <url-pattern>/app1/*</url-pattern>
    </servlet-mapping>

</web-app>
```

> 如果不需要应用上下文层次结构，应用可以只配置 `root` 上下文并将 Servlet 参数 `contextConfigLocation` 留空。

### 特殊 Bean 类型

`DispatcherServlet` 委托给特殊 bean  来处理请求并渲染适当的响应。我们所说的“特殊 bean”是指实现了框架契约的 Spring 管理的 `Object` 实例。它们通常**带有内置契约**，但您可以**自定义**它们的属性并**扩展**或**替换**它们。

下表列出了由 `DispatcherServlet` 检测到的特殊 bean ：

| bean 类型                                                    | 解释                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `HandlerMapping`                                             | 将请求与用于预处理和后处理的[拦截器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-handlermapping-interceptor)列表一起映射到处理程序 。映射基于一些标准，其细节因`HandlerMapping` 实施而异。两个主要`HandlerMapping`实现是`RequestMappingHandlerMapping` （支持带`@RequestMapping`注释的方法）和`SimpleUrlHandlerMapping` （维护向处理程序的 URI 路径模式的显式注册）。 |
| `HandlerAdapter`                                             | 帮助`DispatcherServlet`调用映射到请求的处理程序，而不管实际调用处理程序的方式。例如，调用带注释的控制器需要解析注释。a 的主要目的`HandlerAdapter`是屏蔽`DispatcherServlet`这些细节。 |
| [`HandlerExceptionResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-exceptionhandlers) | 解决异常的策略，可能将它们映射到处理程序、HTML 错误视图或其他目标。请参阅[例外](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-exceptionhandlers)。 |
| [`ViewResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-viewresolver) | `String`将从处理程序返回的基于逻辑的视图名称解析`View` 为用于呈现响应的实际视图名称。请参阅[查看分辨率](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-viewresolver)和[查看技术](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-view)。 |
| [`LocaleResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver), [LocaleContextResolver](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-timezone) | 解析`Locale`客户正在使用的可能以及他们的时区，以便能够提供国际化视图。请参阅[区域设置](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-localeresolver)。 |
| [`ThemeResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-themeresolver) | 解决您的 Web 应用程序可以使用的主题——例如，提供个性化的布局。请参阅[主题](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-themeresolver)。 |
| [`MultipartResolver`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart) | 在一些多部分解析库的帮助下解析多部分请求（例如，浏览器表单文件上传）的抽象。请参阅[多部分解析器](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart)。 |
| [`FlashMapManager`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes) | `FlashMap`存储和检索可用于将属性从一个请求传递到另一个请求的“输入”和“输出” ，通常通过重定向。请参阅[Flash 属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes)。 |

### Web MVC Config

应用可以声明 处理请求所需的[特殊 Bean 类型](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-servlet-special-bean-types)中列出的基础设施 bean。`DispatcherServlet`检查 每个特殊 bean 的 `WebApplicationContext`。如果没有匹配的 bean 类型，它将回退到 [`DispatcherServlet.properties`](https://github.com/spring-projects/spring-framework/tree/main/spring-webmvc/src/main/resources/org/springframework/web/servlet/DispatcherServlet.properties)中列出的默认类型。

在大多数情况下，[MVC Config](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-config) 是最好的起点。它以 Java 或 XML 声明所需的 bean，并提供更高级别的配置回调 API 来定制它。

> Spring Boot 依赖于 MVC Java 配置来配置 Spring MVC，并提供了许多额外的便捷选项。

### Servlet Config

在 Servlet 3.0+ 环境中，您可以选择以编程方式配置 Servlet 容器作为替代方案，或与`web.xml`文件结合使用。以下示例注册了一个 `DispatcherServlet`： 

``` java
import org.springframework.web.WebApplicationInitializer;

public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext container) {
        XmlWebApplicationContext appContext = new XmlWebApplicationContext();
        appContext.setConfigLocation("/WEB-INF/spring/dispatcher-config.xml");

        ServletRegistration.Dynamic registration = container.addServlet("dispatcher", new DispatcherServlet(appContext));
        registration.setLoadOnStartup(1);
        registration.addMapping("/");
    }
}
```

`WebApplicationInitializer` 是 Spring MVC 提供的一个接口，可确保检测到您的实现并自动用于初始化任何 Servlet 3 容器。

>**`org.springframework.web.WebApplicationInitializer`**
>
>在 Servlet 3.0+ 环境中，要以编程方式配置 `ServletContext` 需要实现的接口。以编程方式配置 `ServletContext`，与传统的基于 `web.xml` 的方法相反（或可能结合使用）。
>
>此 SPI 的实现将由 `SpringServletContainerInitializer` 自动检测。 `SpringServletContainerInitializer` 本身由任何 Servlet 3.0 容器自动引导。有关此引导机制的详细信息，请参阅其 Javadoc 

`WebApplicationInitializer` 的抽象基类实现 `AbstractDispatcherServletInitializer` 通过重写方法来指定 `DispatcherServlet` 配置的 servlet 映射和位置，从而更容易注册 `DispatcherServlet`。

>**`org.springframework.web.servlet.support.AbstractDispatcherServletInitializer`**
>
>`org.springframework.web.WebApplicationInitializer` 接口实现的基类。该类在 servlet context 中注册 `DispatcherServlet` 。
>要实现 `createServletApplicationContext()` 和 `getServletMappings()` 需要具体的实现，这两者都是从`registerDispatcherServlet(ServletContext)` 调用的。可以通过重写 `customizeRegistration(ServletRegistration.Dynamic)` 来实现进一步的定制。
>由于此类从 `AbstractContextLoaderInitializer` 扩展而来，因此还需要具体实现来实现 `createRootApplicationContext()` 以设置父“根”应用程序上下文。如果不需要根上下文，实现可以简单地在 `createRootApplicationContext()` 实现中返回 `null`

建议使用基于 Java 的 Spring 配置的应用，如以下示例所示：

``` java
public class MyWebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return null;
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[] { MyWebConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }
}
```

如果使用基于 XML 的 Spring 配置，则应直接从 `AbstractDispatcherServletInitializer` 扩展，如以下示例所示：

``` java
public class MyWebAppInitializer extends AbstractDispatcherServletInitializer {

    @Override
    protected WebApplicationContext createRootApplicationContext() {
        return null;
    }

    @Override
    protected WebApplicationContext createServletApplicationContext() {
        XmlWebApplicationContext cxt = new XmlWebApplicationContext();
        cxt.setConfigLocation("/WEB-INF/spring/dispatcher-config.xml");
        return cxt;
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }
}
```

`AbstractDispatcherServletInitializer`还提供了一种便捷的方法来添加 `Filter`  实例并将它们自动映射到 `DispatcherServlet`，如以下示例所示：

``` java
public class MyWebAppInitializer extends AbstractDispatcherServletInitializer {

    // ...

    @Override
    protected Filter[] getServletFilters() { // 指定要添加并映射到 DispatcherServlet 的过滤器。
        return new Filter[] {
            new HiddenHttpMethodFilter(), new CharacterEncodingFilter() };
    }
}
```

每个过滤器都根据其具体类型添加了一个默认名称，并自动映射到`DispatcherServlet`.

`AbstractDispatcherServletInitializer` 的 `isAsyncSupported` protected 方法提供了一个单独的位置来在 `DispatcherServlet` 和映射到它的所有过滤器上启用异步支持。默认情况下，此标志设置为`true`。

最后，如果需要进一步自定义`DispatcherServlet`自身，可以重写 `createDispatcherServlet` 方法。

