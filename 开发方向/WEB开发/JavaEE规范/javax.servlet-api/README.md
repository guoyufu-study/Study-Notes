# javax.servlet-api

## ServletContainerInitializer

> `javax.servlet.ServletContainerInitializer` Servlet 3.0 引入

接口，允许库/运行时收到 web 应用启动阶段的通知，并执行任何必要的 servlets、过滤器和监听器的编程注册来响应它。

这个接口的实现可以用 `HandlesTypes` 进行注解，以便(在它们的 `onStartup` 方法中)**接收一组应用程序类**，这些应用程序类使用注解指定的类类型实现、扩展或进行注解。

如果该接口的实现不使用 `HandlesTypes` 注解，或者没有一个应用程序类与该注解指定的类匹配，容器必须向 `onStartup` 传递一个空的类集。

当检查应用程序的类以确定它们是否符合 `ServletContainerInitializer` 的 `HandlesTypes` 注解指定的任何标准时，如果应用程序的任何可选 JAR 文件丢失，容器可能会遇到类加载问题。因为容器不能决定这些类型的类加载失败是否会阻止应用程序正确工作，所以它必须忽略它们，同时提供一个记录它们的配置选项。

该接口的实现必须由位于 `META-INF/services` 目录中的 JAR 文件资源声明，并以该接口的完全限定类名命名，并且将使用运行时的服务提供者查找机制或语义上与之等价的容器特定机制来发现。在任何一种情况下，从 web 片段 JAR 文件中排除的 `ServletContainerInitializer` 服务都必须被忽略，并且这些服务被发现的顺序必须遵循应用程序的类加载委托模型。

> 分四步：实现、注解、声明、发现。

### 结构

![onStartup 方法](images\ServletContainerInitializer-onStartup方法.png)

由给定的 `ServletContext` 表示的应用程序的启动，通知这个 `ServletContainerInitializer` 。

如果这个 `ServletContainerInitializer` 被捆绑在应用程序的 `WEB-INF/lib` 目录中的 JAR 文件中，那么它的 `onStartup` 方法在捆绑应用程序的启动期间只会被调用一次。如果这个 `ServletContainerInitializer` 被捆绑在任何 `WEB-INF/lib` 目录外的 JAR 文件中，但仍然可以像上面描述的那样被发现，则每次启动应用程序时都会调用其 `onStartup` 方法。

## HandlesTypes

> `javax.servlet.annotation.HandlesTypes`

此注解用于声明 `ServletContainerInitializer` 可以处理的类类型。



