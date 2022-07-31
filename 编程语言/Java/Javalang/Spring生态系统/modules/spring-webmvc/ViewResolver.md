# ViewResolver

> `org.springframework.web.servlet.ViewResolver`

由可以**按名称解析视图**的对象实现的接口。
视图状态在应用程序运行期间不会改变，因此实现**可以自由地缓存视图**。
**鼓励实现支持国际化**，即本地化视图解决

## 结构

![类结构](images\ViewResolver结构.png)

### `resolveViewName`

按名称解析给定的视图。
注意：为了允许 `ViewResolver` 链接，如果 `ViewResolver` 中未定义具有给定名称的视图，则应返回 `null` 。但是，这不是必需的：某些 `ViewResolver` 将始终尝试使用给定名称构建 `View` 对象，无法返回 `null` （而是在 `View` 创建失败时抛出异常）。

## 子类型

![ViewResolver子类型](images\ViewResolver子类型.png)

### 缓存视图功能

>`org.springframework.web.servlet.view.AbstractCachingViewResolver`

`ViewResolver` 实现的方便基类。一旦解析 `View` 对象，就**缓存**它：这意味着**视图解析不会成为性能问题**，无论初始视图检索的成本有多大。
子类需要实现 `loadView` 模板方法，为特定的视图名称和语言环境构建 `View` 对象。

![AbstractCachingViewResolver结构](images\AbstractCachingViewResolver结构.png)

使用 `private final Map<Object, View> viewAccessCache = new ConcurrentHashMap<>(DEFAULT_CACHE_LIMIT);` 缓存视图。



#### `resolveViewName`

此处使用了模板方法模式。

如果不允许缓存，直接创建；如果允许缓存，先从缓存中查找。代码如下：

![Abstract Caching View Resolver - resolve View Name 极简](images\AbstractCachingViewResolver-resolveViewName-极简.png)

如果在缓存中没找到，直接创建。具体代码如下，

![AbstractCachingViewResolver-resolveViewName](images\AbstractCachingViewResolver-resolveViewName.png)

#### `createView`

创建实际的 `View` 对象。
默认实现委托给 `loadView` 。在委托给子类提供的实际 `loadView` 实现之前，**可以覆盖它**以以特殊方式解析某些视图名称。

![AbstractCachingViewResolver-createView](images\AbstractCachingViewResolver-createView.png)

#### `loadView`（抽象）

子类必须实现这个方法，为指定的视图构建一个 `View` 对象。返回的 `View` 对象将被这个 `ViewResolver` 基类缓存。
不强制子类支持国际化：不支持国际化的子类可以简单地忽略 `locale` 参数

``` java
@Nullable
protected abstract View loadView(String viewName, Locale locale) throws Exception;
```



### 基于 URL 的视图解析器

> `org.springframework.web.servlet.view.UrlBasedViewResolver`

`org.springframework.web.servlet.ViewResolver` 接口的简单实现，允许将符号视图名称直接解析为 URL，而无需显式映射定义。如果您的符号名称以直接的方式与视图资源的名称匹配（即符号名称是资源文件名的唯一部分），则这很有用，而无需为每个视图定义专用映射。
支持 `AbstractUrlBasedView` 子类，如 `InternalResourceView` 和 `org.springframework.web.servlet.view.freemarker.FreeMarkerView` 。此解析器生成的所有视图的视图类可以通过 `viewClass` 属性指定。
视图名称可以是资源 URL 本身，也可以通过指定的前缀和/或后缀进行扩充。明确支持将包含 `RequestContext` 的属性导出到所有视图。
示例：`prefix="/WEB-INF/jsp/"`, `suffix=".jsp"`, `viewname="test"` → `"/WEB-INF/jsp/test.jsp"`
作为一项特殊功能，可以通过 `redirect:` 前缀指定重定向 URL。例如：`redirect:myAction` 将触发到给定 URL 的重定向，而不是作为标准视图名称的解析。这通常用于在完成表单工作流程后重定向到控制器 URL。
此外，可以通过 `forward:` 前缀指定转发 URL。例如：`forward:myAction` 将触发对给定 URL 的转发，而不是作为标准视图名称解析。这通常用于控制器 URL；它不应该用于 JSP URL - 在那里使用逻辑视图名称。
注意：此类不支持本地化解析，即根据当前语言环境将符号视图名称解析为不同的资源。
注意：链接 `ViewResolver` 时，`UrlBasedViewResolver` 将检查指定资源是否实际存在。但是，使用 `InternalResourceView` ，通常不可能预先确定目标资源的存在。在这种情况下，`UrlBasedViewResolver` 将始终为任何给定的视图名称返回一个视图；因此，它应该被配置为链中的最后一个 `ViewResolver`。

![UrlBasedViewResolver结构](images\UrlBasedViewResolver结构.png)



#### `createView`

重写以实现对 `redirect:` 前缀的检查。

在 `loadView` 中是不可能的，因为重写的 `loadView` 版本在子类中可能依赖于父类，总是创建所需视图类的实例。

![UrlBasedViewResolver-createView](images\UrlBasedViewResolver-createView.png)

处理流程如下：

* 如果此解析器不应该处理给定的视图，则返回 `null` 以传递给链中的下一个解析器。
* 检查特殊的 `redirect:` 前缀。
* 检查特殊的 `forward:` 前缀。
* 否则回退到超类实现：调用 `loadView`。

#### `loadView`

委托 `buildView` 创建指定视图类的新实例。应用以下 Spring 生命周期方法（由通用 Spring bean 工厂支持）：

* `ApplicationContextAware` 的 `setApplicationContext`
* `InitializingBean` 的 `afterPropertiesSet`

![UrlBasedViewResolver-loadView](images\UrlBasedViewResolver-loadView.png)

分三步：

* 创建视图
* 应用 Spring 生命周期方法
* 检查资源

#### `buildView`

创建指定视图类的新视图实例并对其进行配置。不对预定义的 `View` 实例执行任何查找。
bean 容器定义的 Spring 生命周期方法不必在这里调用；这些将在此方法返回后由 `loadView` 方法应用。
子类通常会先调用 `super.buildView(viewName)` ，然后再自行设置更多属性。 `loadView` 将在此过程结束时应用 Spring 生命周期方法。

![UrlBasedViewResolver-buildView](images\UrlBasedViewResolver-buildView.png)

创建视图并设置。

#### `instantiateView`

实例化指定的视图类。
默认实现**使用反射来实例化类**。

![UrlBasedViewResolver-instantiateView](images\UrlBasedViewResolver-instantiateView.png)

### 内部资源视图解析器（默认）

> `org.springframework.web.servlet.view.InternalResourceViewResolver`

`UrlBasedViewResolver` 的子类，支持 `InternalResourceView` （即 Servlet 和 JSP）和 `JstlView` 等子类。
这个解析器生成的所有视图的视图类都可以通过 `setViewClass` 指定。有关详细信息，请参阅 `UrlBasedViewResolver` 的 javadoc。默认值为`InternalResourceView` ，如果有JSTL API，则为 `JstlView`。
顺便说一句，将 JSP 文件作为视图放在 `WEB-INF` 下是一个很好的实践，以隐藏它们，使它们不被直接访问(例如通过手动输入URL)。只有控制器才能访问它们。
注意：链接 `ViewResolver`s 时，`InternalResourceViewResolver` 总是需要**放在最后**，因为无论底层资源是否实际存在，它都会尝试解析任何视图名称。

使用 XML 风格配置时，可选属性

![Internal Resource View Resolver 属性](images\InternalResourceViewResolver属性.png)



该类的内部结构

![Internal Resource View Resolver 结构](images\InternalResourceViewResolver结构.png)

#### 构造

这个解析器生成的所有视图的视图类都可以通过 `setViewClass` 指定。

默认值为 `InternalResourceView` ，如果有 JSTL API，则为 `JstlView`。

![InternalResourceViewResolver构造](images\InternalResourceViewResolver构造.png)



#### `buildView`

![InternalResourceViewResolver-buildView](images\InternalResourceViewResolver-buildView.png)

调用父类方法，创建和设置视图对象，然后个性化设置。

#### `instantiateView`

![InternalResourceViewResolver-instantiateView](images\InternalResourceViewResolver-instantiateView.png)

`InternalResourceView` 或 `JstlView`，否则执行父类方法反射创建。

## 动态架构

### `resolveViewName` 的调用方

![ViewResolver-resolveViewName的调用方](images\ViewResolver-resolveViewName的调用方.png)

### `resolveViewName` 入口

`DispatcherServlet` 调用 `ViewResolver#resolveViewName`  的入口

![Dispatcher构造View入口](images\Dispatcher构造View入口.png)

### `resolveViewName` 执行流程

`InternalResourceViewResolver#resolveViewName` 执行流程

``` java
public static void main(String[] args) {
    InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
    viewResolver.setPrefix("WEB-INF/jsp");
    viewResolver.setSuffix(".jsp");
    try {
        viewResolver.resolveViewName("hello", Locale.CHINA);
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
}
```

![InternalResourceViewResolver#resolveViewName执行流程](images\InternalResourceViewResolver#resolveViewName执行流程.png)
