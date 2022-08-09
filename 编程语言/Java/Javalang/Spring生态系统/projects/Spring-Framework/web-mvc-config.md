## MVC 配置

MVC Java 配置和 MVC XML 命名空间提供了适用于大多数应用程序的默认配置，以及用于定制它的配置 API。

有关配置 API 中不可用的更高级定制，请参阅[高级 Java 配置](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-config-advanced-java)和[高级 XML 配置](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-config-advanced-xml)。

您不需要理解由 MVC Java 配置和 MVC 名称空间创建的底层 bean。如果您想了解更多，请参阅[特殊 Bean 类型](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-servlet-special-bean-types)和 [Web MVC 配置](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-servlet-config)。

### 启用 MVC 配置

在 Java 配置中，你可以使用 `@EnableWebMvc` 注解来启用 MVC 配置，如下所示：

``` java
@Configuration
@EnableWebMvc
public class WebConfig {
}
```

在 XML 配置中，你可以使用 `<mvc:annotation-driven>` 元素来启用 MVC 配置，如下所示：

``` xml


<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
                           http://www.springframework.org/schema/beans
                           https://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/mvc
                           https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <mvc:annotation-driven/>

</beans>
```

前面的示例注册了许多 Spring MVC [基础结构 beans](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-servlet-special-bean-types)，并适应类路径上可用的依赖项(例如，JSON、XML和其他负载转换器)。



### MVC 配置 API

在 Java 配置中，你可以实现 `WebMvcConfigurer` 接口，如下所示：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    // Implement configuration methods...
}
```

在 XML 中，您可以检查 `<mvc:annotation-driven/>` 的属性和子元素。您可以查看 Spring MVC XML 模式或使用 IDE 的代码补全特性来发现可用的属性和子元素。

### 视图控制器

这是定义一个 `ParameterizableViewController` 的快捷方式，`ParameterizableViewController` 在被调用时立即转发到视图。当**在视图生成响应之前没有 Java 控制器逻辑要运行**时，可以在静态情况下使用它。

以下 Java 配置示例将请求 `/` 转发到名为 `home` 的视图：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("home");
    }
}
```

以下示例通过使用 `<mvc:view-controller>` 元素实现与前面示例相同的功能，但使用 XML ：

``` xml
<mvc:view-controller path="/" view-name="home"/>
```

如果一个 `@RequestMapping` 方法映射到任何 HTTP 方法的 URL，则视图控制器不能用于处理相同的 URL。这是因为通过 URL 匹配到带注解的控制器被认为是端点所有权的足够强的指示，因此可以向客户端发送 405 (`METHOD_NOT_ALLOWED`)、415 (`UNSUPPORTED_MEDIA_TYPE`) 或类似响应来帮助调试。出于这个原因，建议避免在带注解的控制器和视图控制器之间拆分 URL 处理。

### 类型转换

默认情况下，会安装各种数字和日期类型的格式化器，并支持通过 `@NumberFormat` 和 `@DateTimeFormat` **对字段进行定制**。

要在 Java 配置中**注册自定义格式化器和转换器**，请使用以下代码：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        // ...
    }
}
```

要在 XML 配置中做同样的事情，使用下面的方法：

``` xml


<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
                           http://www.springframework.org/schema/beans
                           https://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/mvc
                           https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <mvc:annotation-driven conversion-service="conversionService"/>

    <bean id="conversionService"
          class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
        <property name="converters">
            <set>
                <bean class="org.example.MyConverter"/>
            </set>
        </property>
        <property name="formatters">
            <set>
                <bean class="org.example.MyFormatter"/>
                <bean class="org.example.MyAnnotationFormatterFactory"/>
            </set>
        </property>
        <property name="formatterRegistrars">
            <set>
                <bean class="org.example.MyFormatterRegistrar"/>
            </set>
        </property>
    </bean>

</beans>
```

默认情况下，Spring MVC 在解析和格式化日期值时会考虑请求区域设置。这适用于日期表示为带有“输入”表单字段的字符串的表单。然而，对于“日期”和“时间”表单字段，浏览器使用 HTML 规范中定义的固定格式。在这种情况下，日期和时间格式可以自定义如下：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        DateTimeFormatterRegistrar registrar = new DateTimeFormatterRegistrar();
        registrar.setUseIsoFormat(true);
        registrar.registerFormatters(registry);
    }
}
```

> 有关何时使用 `FormatterRegistrar` 实现的更多信息，请参阅 [`FormatterRegistrar` SPI](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#format-FormatterRegistrar-SPI) 和 `FormattingConversionServiceFactoryBean`。



### 视图解析器

MVC 配置简化了视图解析器的注册。

下面的 Java 配置示例通过使用 JSP 和 Jackson 作为 JSON 渲染的默认 `View` 来配置内容协商视图解析：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.enableContentNegotiation(new MappingJackson2JsonView());
        registry.jsp();
    }
}
```

下面的示例显示了如何在 XML 中实现相同的配置：

``` xml
<mvc:view-resolvers>
    <mvc:content-negotiation>
        <mvc:default-views>
            <bean class="org.springframework.web.servlet.view.json.MappingJackson2JsonView"/>
        </mvc:default-views>
    </mvc:content-negotiation>
    <mvc:jsp/>
</mvc:view-resolvers>
```

但是请注意，FreeMarker、Tiles、Groovy 标记和脚本模板也需要配置底层视图技术。

MVC 命名空间提供专用元素。下面的示例适用于 FreeMarker：

``` xml
<mvc:view-resolvers>
    <mvc:content-negotiation>
        <mvc:default-views>
            <bean class="org.springframework.web.servlet.view.json.MappingJackson2JsonView"/>
        </mvc:default-views>
    </mvc:content-negotiation>
    <mvc:freemarker cache="false"/>
</mvc:view-resolvers>

<mvc:freemarker-configurer>
    <mvc:template-loader-path location="/freemarker"/>
</mvc:freemarker-configurer>
```

在 Java 配置中，您可以添加相应的 `Configurer` bean，如下面的示例所示：

``` java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.enableContentNegotiation(new MappingJackson2JsonView());
        registry.freeMarker().cache(false);
    }

    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPath("/freemarker");
        return configurer;
    }
}
```

### 静态资源



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

