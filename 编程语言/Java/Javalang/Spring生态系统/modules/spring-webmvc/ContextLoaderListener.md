# ContextLoaderListener

## JDK

> `java.util.EventListener`

标记接口，所有事件监听器接口都必须扩展它。

`javax.servlet`内的 `EventListener` 子类型

![javax.servlet内的EventListener子类型](images\javax.servlet内的EventListener子类型.png)

`org.springframework` 内的 `EventListener` 子类型

![org.springframework内的EventListener子类型](images\org.springframework内的EventListener子类型.png)

## servlet-api

> `javax.servlet.ServletContextListener`

接口，接收有关 `ServletContext` 生命周期更改的通知事件
为了接收这些通知事件，实现类必须在 Web 应用程序的部署描述符中声明，使用 `javax.servlet.annotation.WebListener` 进行注释，或者通过 `ServletContext` 上定义的 `addListener` 方法之一进行注册。
这个接口的实现在它们的 `contextInitialized` 方法中按照它们被声明的顺序被调用，并且在它们的 `contextDestroyed` 方法中以相反的顺序被调用。

### `contextInitialized`

接收 Web 应用程序初始化过程正在启动的通知。
在初始化 Web 应用程序中的任何 filters 或 servlets 之前，所有 `ServletContextListener` 都会收到context初始化通知。

### `contextDestroyed`

接收到 `ServletContext` 即将关闭的通知。
在通知任何 `ServletContextListener` context销毁之前，所有 servlets 和 filters 都将被销毁。

## spring-web

## `ContextLoaderListener` 执行流程

![ContextLoaderListener-执行流程](images\ContextLoaderListener-执行流程.png)

## `ContextLoaderListener`

> `org.springframework.web.context.ContextLoaderListener`

引导监听器来启动和关闭 Spring 的根 `WebApplicationContext` 。只需委托给 `ContextLoader` 以及 `ContextCleanupListener` 。
从 Spring 3.1 开始， `ContextLoaderListener` 支持通过 `ContextLoaderListener(WebApplicationContext)` 构造函数注入根 `WebApplicationContext`，从而允许在 Servlet 3.0+ 环境中进行编程配置。有关使用示例，请参阅 `org.springframework.web.WebApplicationInitializer` 。

### 无参构造

创建一个新的 `ContextLoaderListener` ，它将基于 servlet context参数 `contextClass` 和 `contextConfigLocation` 创建一个 `WebApplicationContext`。有关每个默认值的详细信息，请参阅 `ContextLoader` 超类文档。
这个构造函数通常在 `web.xml` 中将 `ContextLoaderListener` 声明为 `<listener>` 时使用，其中需要无参数构造函数。
创建的 `WebApplicationContext` 将注册到 ServletContext 中的属性名称 `WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE` 下，当在这个监听器上调用 `contextDestroyed` 生命周期方法时，将关闭 Spring `ApplicationContext`。



### 有参构造

使用给定的 `WebApplicationContext` 创建一个新的 `ContextLoaderListener` 。这个构造函数在 Servlet 3.0+ 环境中很有用，在这些环境中，可以通过 `javax.servlet.ServletContext.addListener` API 对监听器进行基于实例的注册。
context 可能已刷新，也可能尚未刷新。如果它 (a) 是 `ConfigurableWebApplicationContext` 的实现并且 (b)尚未刷新（推荐的方法），则将发生以下情况：

* 如果给定的 context 还没有被分配一个 `id` ，将给它分配一个。
* `ServletContext` 和 `ServletConfig` 对象将被委托给 `ApplicationContext`
* 将调用 `customizeContext`
* 将应用通过 `contextInitializerClasses` `init-param` 指定的任何 `ApplicationContextInitializer org.springframework.context.ApplicationContextInitializer ApplicationContextInitializers` 。
* `refresh()` 将被调用

如果 context 已被刷新或未实现 `ConfigurableWebApplicationContext` ，则假设用户已根据他或她的特定需要执行了这些操作（或未执行），则不会发生上述任何情况。
有关使用示例，请参阅 `org.springframework.web.WebApplicationInitializer` 。
在任何情况下，给定的 `ApplicationContext` 将注册到 `ServletContext` 中 `WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE` 属性名称下 ，并且当在此监听器上调用 `contextDestroyed` 生命周期方法时，Spring  `ApplicationContext` 将关闭。

### 实现 `ServletContextListener`

![ContextLoaderListener-实现](images\ContextLoaderListener-实现.png)



## `ContextLoader`

> `org.springframework.web.context.ContextLoader`

### `initWebApplicationContext`

为给定的 `ServletContext` 初始化 Spring 的 `WebApplicationContext`，可以使用在构建时提供的 `WebApplicationContext`，或者根据 `context-param`  `contextClass` 和 `contextConfigLocation` 创建一个新的。

