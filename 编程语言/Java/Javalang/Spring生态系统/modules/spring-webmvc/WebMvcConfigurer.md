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

### 静态资源

添加处理器来提供静态资源，比如图片、js 和 css 文件，这些静态资源来自 web 应用根目录、类路径等特定位置。

![WebMvcConfigurer-addResourceHandlers](images\WebMvcConfigurer-addResourceHandlers.png)

#### `ResourceHandlerRegistry`

> `org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry`

存储资源处理程序的注册，以通过 Spring MVC 提供静态资源，例如图像、css 文件和其他资源，包括设置缓存标头以优化 Web 浏览器中的有效加载。资源可以从 Web 应用程序根目录下的位置、类路径和其他位置提供。
要创建资源处理程序，请使用 `addResourceHandler(String...)` 提供应调用处理程序以提供静态资源的 URL 路径模式（例如`/resources/**` ）。
然后在返回的 `ResourceHandlerRegistration` 上使用其他方法来添加一个或多个用于提供静态内容的位置（例如 `{ "/" 、 "classpath:/META-INF/public-web-resources/" }`）或指定缓存服务资源的期限。

### 配置简单的自动化控制器

![WebMvcConfigurer-addViewControllers](images\WebMvcConfigurer-addViewControllers.png)

配置简单的自动化控制器，预先配置响应状态代码和/或视图，以渲染响应主体。这在不需要自定义控制器逻辑的情况下很有用——例如，渲染一个主页，执行简单的站点 URL 重定向，返回一个带有 HTML 内容的 404 状态，返回一个没有内容的 204 状态，等等。

使用 `ViewControllerRegistry` 协助注册预先配置有状态代码和/或视图的简单自动化控制器。



### 配置视图解析器

![WebMvcConfigurer-configureViewResolvers](images\WebMvcConfigurer-configureViewResolvers.png)

配置视图解析器，将从控制器返回的基于字符串的视图名称转换为具体的 `org.springframework.web.servlet.View` 实现来执行渲染。