# DispatcherServlet

## 继承结构

![DispatcherServlet-继承结构](images\DispatcherServlet-继承结构.png)

继承结构可以分成两部分 `javax.servlet-api` 和 `springframework`。

其中 `Servlet` 、`ServletConfig` 两个接口和 `GenericServlet` 、`HttpServlet` 两个类来自 `javax.servlet:javax.servlet-api:4.0.1`。

其它包都来自 springframework。

其中 `Aware` 接口来自 `spring-beans`包。`ApplicationContextAware` 和 `EnvironmentAware` 两个接口来自 `spring-context` 包。spring 中的 `xxxAware` 接口表示可以感知到 `xxx`。如果某个 Bean 想要使用 spring 中的某个东西 `xxx`，我们可以通过让这个 Bean 的类实现 `xxxAware` 接口来告诉 spring，spring 会在实例化这个 Bean 的时候，把这个东西带过来。

`EnvironmentCapable` 来自 `spring-core` 包。通过让 Bean 的类实现这个接口，来告诉 spring，当前 Bean 能提供 `Environment` 功能。



## 入口

### 初始化过程

`onRefresh` 是 `DispatcherServlet` 初始化时的入口方法。

![DispatcherServlet初始化入口](images\DispatcherServlet初始化入口.png)



![DispatcherServlet-initStrategies-调用层次结构](images\DispatcherServlet-initStrategies-调用层次结构.png)

#### `Servlet` 接口

##### 有参初始化

`javax.servlet.Servlet#init`

由 servlet 容器调用以向 servlet 指示 servlet 正在投入使用。
servlet 容器在实例化 servlet 后恰好调用一次 `init` 方法。 `init` 方法必须成功完成，servlet 才能接收任何请求。
如果 `init`方法出现下面的情况，则 servlet 容器无法将 servlet 投入服务

1. 抛出 `ServletException`
2. 在 Web 服务器定义的时间段内不返回

#### `GenericServlet` 抽象方法

##### 有参初始化

`javax.servlet.GenericServlet#init(javax.servlet.ServletConfig)`

> 子类不应该重写这个方法。

由 servlet 容器调用以向 servlet 指示 servlet 正在投入使用。请参阅 `Servlet.init` 。
此实现存储它从 servlet 容器接收到的 `ServletConfig` 对象以供以后使用。当覆盖这种形式的方法时，调用 `super.init(config)` 。

##### 无参初始化（模板）

`javax.servlet.GenericServlet#init()`

> 模板方法，提供了空实现。

一种可以被覆盖的便捷方法，因此无需调用 `super.init(config)` 。
只需覆盖此方法，而不是覆盖 `init(ServletConfig)` ，它将由 `GenericServlet.init(ServletConfig config)` 调用。仍然可以通过`getServletConfig` 检索 `ServletConfig` 对象。

#### `HttpServletBean`

##### 无参初始化

`org.springframework.web.servlet.HttpServletBean#init`

将配置参数映射到此 servlet 的 bean 属性，并调用子类初始化。

![HttpServletBean-init](images\HttpServletBean-init.png)

##### 初始化 `BeanWrapper`（模板）

`org.springframework.web.servlet.HttpServletBean#initBeanWrapper`

> 模板方法，提供了空实现

初始化此 `HttpServletBean` 的 `BeanWrapper`，可能使用自定义编辑器。
此默认实现为空。



##### 初始化 `ServletBean`（模板）

`org.springframework.web.servlet.HttpServletBean#initServletBean`

> 模板方法，提供了空实现

子类可以覆盖它以执行自定义初始化。这个 servlet 的所有 bean 属性将在调用此方法之前设置。
此默认实现为空。

#### `FrameworkServlet`

##### 初始化 `ServletBean`

`org.springframework.web.servlet.FrameworkServlet#initServletBean`

`HttpServletBean` 的重写方法，在设置任何 bean 属性后调用。创建这个 servlet 的 `WebApplicationContext`。

![FrameworkServlet-initServletBean](images\FrameworkServlet-initServletBean.png)

##### 初始化并发布 `WebApplicationContext`

`org.springframework.web.servlet.FrameworkServlet#initWebApplicationContext`

初始化并发布这个 servlet 的 `WebApplicationContext`。
委托 `createWebApplicationContext` 实际创建上下文。可以在子类中覆盖。

![FrameworkServlet-initWebApplicationContext](images\FrameworkServlet-initWebApplicationContext.png)

##### 刷新容器（模板）

`org.springframework.web.servlet.FrameworkServlet#onRefresh`

> 模板方法，提供了空实现

可以被覆盖以添加特定于 servlet 的刷新工作的模板方法。在成功刷新上下文后调用。
这个实现是空的。

##### 初始化 `FrameworkServlet`（模板）

`org.springframework.web.servlet.FrameworkServlet#initFrameworkServlet`

> 模板方法，提供了空实现

在设置任何 bean 属性并加载 `WebApplicationContext` 后，将调用此方法。默认实现为空；子类可以重写此方法以执行它们所需的任何初始化。

#### DispatcherServlet

##### 刷新容器

`org.springframework.web.servlet.DispatcherServlet#onRefresh`

##### 初始化策略组件

`org.springframework.web.servlet.DispatcherServlet#initStrategies`

初始化这个 servlet 使用的策略对象。
可以在子类中被覆盖以初始化更多的策略对象。

![DispatcherServlet-onRefresh](images\DispatcherServlet-onRefresh.png)

### 处理请求过程

#### 从 Servlet 容器到 DispatcherServlet

`DispatcherServlet` 处理请求的入口是 `doService(HttpServletRequest, HttpServletResponse)` 方法。

![springmvc调用流程](images\springmvc调用流程.png)

`HttpServletBean` 只参与了创建工作，没有参与请求处理工作。

`FrameworkServlet` 增加了对 `PATCH` 类型请求的处理。所有类型的请求又都合并到了 `processRequest()` 方法。`processRequest()` 方法，是处理请求过程中最核心的方法。这个方法主要做三件事：对 `LocaleContext` 和 `RequestAttribute` 设置和恢复；将主要的处理逻辑交给 `doService()` 模板方法；处理完成后发布 `ServletRequestHandledEvent` 消息。



#### `doService`

![DispatcherServlet-doService](images\DispatcherServlet-doService.png)

主要工作：

* 如果是 `include` 请求，对 request 的当前属性做快照备份，处理结束后做快照恢复。
* 对 request 做一些设置
* 请求交给 `doDispatch` 方法处理。

在 `include` 的情况下保留请求属性的快照，以便能够在 `include` 后恢复原始属性。

![DispatcherServlet-doService-快照备份](images\DispatcherServlet-doService-快照备份.png)

使框架对象可用于处理程序和视图对象。

![DispatcherServlet-doService-设置请求](images\DispatcherServlet-doService-设置请求.png)

请求交给 `doDispatch` 方法处理，并在处理结束后做快照恢复。

![DispatcherServlet-doService-快照恢复](images\DispatcherServlet-doService-快照恢复.png)

#### `doDispatch`

处理对处理程序的实际调度。
将通过依次应用 servlet 的 `HandlerMapping`s 来获取处理程序。 通过查询 servlet 已安装的 `HandlerAdapter`s 来找到第一个支持该处理程序类的 `HandlerAdapter`。
所有 HTTP 方法都由这个方法处理。由 `HandlerAdapter`s 或处理程序自己决定哪些方法是可接受的。

四步：

* 根据请求找到处理器。
* 根据处理器找到处理器适配器。
* 实际调用处理器：处理器适配器使用处理器处理请求
* 处理调度结果



![DispatcherServlet-doDispatch](images\DispatcherServlet-doDispatch.png)

1-3 处理请求：找到处理器；找到处理器适配器；实际调用处理器。

![DispatcherServlet-doDispatch-前三步](images\DispatcherServlet-doDispatch-前三步.png)

4 渲染页面：处理调度结果

![DispatcherServlet-doDispatch-第四步](images\DispatcherServlet-doDispatch-第四步.png)
