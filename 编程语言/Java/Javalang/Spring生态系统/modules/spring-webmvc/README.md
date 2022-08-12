# spring-webmvc

[创建WEB应用的流程](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/创建WEB应用流程.md)

[SpringServletContainerInitializer](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/SpringServletContainerInitializer.md)：启动 Spring Web MVC 应用的入口点。

[HttpServlet](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/HttpServlet.md)：Spring Web MVC 内置的 `HttpServlet` 实现类。

[DipatcherServlet](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/DispatcherServlet.md)：核心控制器。梳理初始化过程，请求处理过程。



## 配置

[ContextLoaderListener](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/ContextLoaderListener.md)：创建和初始化 root `WebApplicationContext`。

### XML 风格

[NamespaceHandler](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/NamespaceHandler.md)：名称空间处理器。

### Java 风格

[WebMvcConfigurer](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/WebMvcConfigurer.md)：配置说明，以及简单示例。

## 组件

### [格式化功能](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/格式化功能.md)

### 视图解析器

* [配置方式](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/ViewResolver-配置方案.md)
* [接口定义及实现类](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/ViewResolver.md)
* [执行流程](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/ViewResolver-resolveViewName.md)

### 视图

* [视图](编程语言/Java/Javalang/Spring生态系统/modules/spring-webmvc/View.md)

### 处理器

* 处理器映射
* 处理器适配器
* 处理器异常解析器
