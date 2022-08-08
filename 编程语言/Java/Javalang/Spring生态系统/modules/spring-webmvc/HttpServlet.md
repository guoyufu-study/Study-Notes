# Spring Web MVC 内置 `HttpServlet` 实现类



![HttpServlet内置实现类](images\HttpServlet内置实现类.png)

## 核心控制器

### `HttpServletBean`

### `FrameworkServlet`

### `DispatcherServlet`



## 实时 bean 快照

### Java 风格配置 Servlet

``` java
public class AnnotationConfigDispatcherServletInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
    
    // ...

   @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        super.onStartup(servletContext);
        ServletRegistration.Dynamic registration = servletContext
            .addServlet("liveBeansViewServlet", new LiveBeansViewServlet());
        registration.addMapping("/live");
    }
}
```

然后访问 `http:/localhost:8080/live` 即可看到 JSON 快照。

### `LiveBeansViewServlet`

> `org.springframework.web.context.support.LiveBeansViewServlet`

`org.springframework.context.support.LiveBeansView` 的 MBean 公开的 Servlet 变体。

为当前 Web 应用程序中的所有 `ApplicationContext`s 中的当前 bean 及其依赖项生成 JSON 快照。

已弃用：从 5.3 开始，支持使用 Spring Boot 执行器来满足此类需求

### `LiveBeansView`

> `org.springframework.context.support.LiveBeansView`

用于实时 bean 视图公开的适配器，从本地 `ApplicationContext` （带有本地 `LiveBeansView` bean 定义）或所有注册的 `ApplicationContext`s（由 `spring.liveBeansView.mbeanDomain` 环境属性驱动）构建当前 bean 及其依赖项的快照。



## Http 请求处理

### `HttpRequestHandlerServlet`

简单的 `HttpServlet`，它委托给在 Spring 的根 web application context 中定义的一个 `HttpRequestHandler` bean。目标 bean 名称必须与`web.xml` 中定义的 `HttpRequestHandlerServlet` `servlet-name` 匹配。

例如，这可以用于为每个 `HttpRequestHandlerServlet` 定义公开一个 Spring 远程导出器，例如`org.springframework.remoting.httpinvoker.HttpInvokerServiceExporter` 或`org.springframework.remoting.caucho.HessianServiceExporter` 。这是在 `DispatcherServlet` 上下文中将远程导出器定义为 bean 的最小替代方案（那里提供高级映射和拦截工具）。

### `HttpRequestHandler`

用于处理 HTTP 请求的组件的普通处理程序接口，类似于 Servlet。仅声明 `ServletException` 和 `IOException` ，以允许在任何`javax.servlet.http.HttpServlet` 中使用。这个接口本质上是一个 `HttpServlet` 的直接等价物，被简化为一个中央句柄方法。