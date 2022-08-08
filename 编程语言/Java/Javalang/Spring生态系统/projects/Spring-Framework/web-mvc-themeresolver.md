### 主题

您可以应用 Spring Web MVC 框架主题来**设置应用程序的整体外观**，从而**增强用户体验**。**主题是静态资源的集合，通常是样式表和图像，它们会影响应用程序的视觉样式。**

#### 定义主题

要在 Web 应用程序中使用主题，您必须设置 `org.springframework.ui.context.ThemeSource` 接口的实现。`WebApplicationContext` 接口扩展`ThemeSource`但将其职责委托给专用实现。**默认**情况下，委托是 `org.springframework.ui.context.support.ResourceBundleThemeSource` 实现，它从类路径的根目录加载属性文件。要使用**自定义** `ThemeSource` 实现或配置 `ResourceBundleThemeSource` 的基本名称前缀，您可以在应用程序上下文中使用保留名称 `themeSource` 注册一个 bean。 Web 应用程序上下文自动检测具有该名称的 bean 并使用它。

当您使用 `ResourceBundleThemeSource` 时，主题是在一个简单的属性文件中定义的。属性文件列出了构成主题的资源，如以下示例所示：

```properties
styleSheet=/themes/cool/style.css
background=/themes/cool/img/coolBg.jpg
```

属性的键是视图代码中引用主题化元素的名称。对于 JSP，您通常使用 `spring:theme` 自定义标记来完成此操作，这与 `spring:message` 标记非常相似。以下 JSP 片段使用前面示例中定义的主题来自定义外观：

```html
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
    <head>
        <link rel="stylesheet" href="<spring:theme code='styleSheet'/>" type="text/css"/>
    </head>
    <body style="background=<spring:theme code='background'/>">
        ...
    </body>
</html>
```

默认情况下，`ResourceBundleThemeSource` 使用空的基本名称前缀。因此，属性文件是从类路径的根目录加载的。因此，您可以将 `cool.properties` 主题定义放在类路径根目录的目录中（例如，放在 `/WEB-INF/classes` 中）。`ResourceBundleThemeSource` 使用标准的 Java 资源包加载机制，允许主题的完全国际化。例如，我们可以有一个 `/WEB-INF/classes/cool_nl.properties` 引用带有荷兰语文本的特殊背景图像。

#### 解析主题

定义主题后，如前一节所述，您决定要使用哪个主题。`DispatcherServlet`查找一个名为 `themeResolver` 的 bean 以找出要使用的 `ThemeResolver` 实现。主题解析器的工作方式与 `LocaleResolver` 非常相似。它**检测用于特定请求的主题**，还可以**更改请求的主题**。下表描述了 Spring 提供的主题解析器：

| 类                     | 描述                                                         |
| :--------------------- | :----------------------------------------------------------- |
| `FixedThemeResolver`   | 选择固定主题，使用 `defaultThemeName` 属性设置。             |
| `SessionThemeResolver` | 主题在用户的 HTTP 会话中维护。每个会话只需要设置一次，但不会在会话之间保留。 |
| `CookieThemeResolver`  | 选定的主题存储在客户端的 cookie 中。                         |

Spring 还提供了一个 `ThemeChangeInterceptor` ，它允许在每个请求中使用一个简单的请求参数更改主题。

