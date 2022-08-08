### JSP 和 JSTL

Spring 框架有一个内置的集成，可以将 Spring MVC 与 JSP 和 JSTL 结合使用。

#### 视图解析器

使用 JSPs 进行开发时，通常会声明一个 `InternalResourceViewResolver` bean。

`InternalResourceViewResolver` 可用于分派到任何 Servlet 资源，尤其是 JSP。作为最佳实践，我们强烈建议将您的 JSP 文件放在 `'WEB-INF'` 目录下的一个目录中，这样客户端就不能直接访问 JSP 文件。

``` xml
<bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
    <property name="prefix" value="/WEB-INF/jsp/"/>
    <property name="suffix" value=".jsp"/>
</bean>
```

#### JSP 与 JSTL

使用 JSP 标准标记库 (JSTL) 时，您必须使用一个特殊的视图类 `JstlView` ， 因为 JSTL 需要在 I18N  等功能开始起作用之前做一些准备工作。

#### Spring 的 JSP 标签库

Spring 提供了**请求参数到命令对象的数据绑定**，如前几章所述。为了结合这些数据绑定特性促进 JSP 页面的开发，Spring 提供了一些标签，使事情变得更加容易。所有 Spring 标签都**具有 HTML 转义功能**，以启用或禁用字符转义。

`spring.tld` 标签库描述符 (TLD) 包含在 `spring-webmvc.jar` 中。要获得关于单个标签的全面参考资料，请浏览 [API 参考](https://docs.spring.io/spring-framework/docs/5.3.22/javadoc-api/org/springframework/web/servlet/tags/package-summary.html#package.description) 或查看标签库描述。

#### Spring 的表单标签

> https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-view-jsp-formtaglib

