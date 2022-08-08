### 默认 Servlet

Spring MVC 允许映射 `DispatcherServlet` 到 `/`（从而覆盖容器的默认 Servlet 的映射），同时仍然允许由容器的默认 Servlet 处理静态资源请求。它使用一个 URL 映射 `/**` 和相对于其他 URL 映射的最低优先级配置了 `DefaultServletHttpRequestHandler` 。

这个处理器将所有请求转发到默认 Servlet。因此，它必须在所有其他 URL `HandlerMappings` 的顺序中保持在最后。如果您使用 `<mvc:annotation-driven>`。或者，如果您设置自己的自定义 `HandlerMapping` 实例，请确保将其 `order` 属性设置为低于 `DefaultServletHttpRequestHandler` 的值，即低于 `Integer.MAX_VALUE`。

以下示例显示如何使用默认设置启用该功能：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

``` xml
<mvc:default-servlet-handler/>
```

覆盖 `/` Servlet 映射需要注意的是，默认 Servlet 的 `RequestDispatcher` 必须按名称检索，而不是按路径检索。`DefaultServletHttpRequestHandler` 尝试在启动时，使用大多数主要 Servlet 容器（包括 Tomcat、Jetty、GlassFish、JBoss、Resin、WebLogic 和 WebSphere）的已知名称列表，自动检测容器的默认 Servlet。 如果默认 Servlet 已使用不同的名称进行自定义配置，或者如果使用了不同的 Servlet 容器而默认 Servlet 名称未知，则必须**显式提供默认 Servlet 的名称**，如以下示例所示：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable("myCustomDefaultServlet");
    }
}
```

以下示例显示了如何在 XML 中实现相同的配置：

``` xml
<mvc:default-servlet-handler default-servlet-name="myCustomDefaultServlet"/>
```

