# WebMvcConfigurer

> `org.springframework.web.servlet.config.annotation.WebMvcConfigurer`

定义回调方法，为通过 `@EnableWebMvc` 启用的 Spring MVC 定制基于 Java 的配置。
`@EnableWebMvc` 注解的配置类可以实现这个接口回调，并有机会自定义默认配置。

> 5.0 之前，使用 `WebMvcConfigurerAdapter` 。

## 分析

### 结构

![WebMvcConfigurer-结构](images\WebMvcConfigurer-结构.png)

### 子类

![WebMvcConfigurer-层次结构](images\WebMvcConfigurer-层次结构.png)

#### `WebMvcConfigurerComposite`

委托给一个或多个其他 `WebMvcConfigurer`。

#### `WebMvcConfigurerAdapter` （已弃用）

带有空方法的 `WebMvcConfigurer` 的实现，允许子类只重写它们感兴趣的方法。

在 5.0 版本中，`WebMvcConfigurer` 有默认的方法(由 Java 8 基线实现)，并且可以直接实现，因此不再需要这个适配器。

## 功能

### 配置简单的自动化控制器

![WebMvcConfigurer-addViewControllers](images\WebMvcConfigurer-addViewControllers.png)

配置简单的自动化控制器，预先配置响应状态代码和/或视图，以渲染响应主体。这在不需要自定义控制器逻辑的情况下很有用——例如，渲染一个主页，执行简单的站点 URL 重定向，返回一个带有 HTML 内容的 404 状态，返回一个没有内容的 204 状态，等等。

使用 `ViewControllerRegistry` 协助注册预先配置有状态代码和/或视图的简单自动化控制器。



### 配置视图解析器

![WebMvcConfigurer-configureViewResolvers](images\WebMvcConfigurer-configureViewResolvers.png)

配置视图解析器，将从控制器返回的基于字符串的视图名称转换为具体的 `org.springframework.web.servlet.View` 实现来执行渲染。