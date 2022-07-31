# View

> `org.springframework.web.servlet.View`

用于 Web 交互的 MVC 视图。实现负责呈现内容并曝露模型。单个视图曝露多个模型属性。
Rod Johnson（Wrox，2002）的 Expert One-On-One J2EE Design and Development  （Wrox，2002）的第 12 章讨论了这个类和与之相关的 MVC 方法。
视图实现可能大相径庭。一个明显的实现是基于 JSP 的。其他实现可能是基于 XSLT 的，或者使用 HTML 生成库。该接口旨在避免限制可能实现的范围。
视图应该是 bean。它们很可能被 `ViewResolver` 实例化为 bean。由于这个接口是**无状态**的，视图实现应该是线程安全的。

## 结构

![View 结构](images\View结构.png)

### render 方法

**渲染**给定模型的视图。
第一步是**准备请求**：在 JSP 案例中，这意味着将模型对象设置为请求属性。第二步将是视图的**实际呈现**，例如通过 `RequestDispatcher` 包含 JSP。

### HttpServletRequest 属性名

响应状态代码、带有路径变量的 Map、内容协商期间选择的`org.springframework.http.MediaType` 

## 子类型

![View 子类型](images\View子类型.png)

### AbstractView

`View` 实现的抽象基类。子类应该是 Java Beans，以方便配置为 Spring 管理的 bean 实例。
提供对**静态属性**的支持，可用于视图，并以多种方式指定它们。对于每个渲染操作，静态属性将与给定的**动态属性**（控制器返回的模型）**合并**。
扩展了 `WebApplicationObjectSupport` ，这将有助于某些视图。子类只需要实现实际的渲染

#### 模板方法 `render`

准备给定模型的视图，如有必要，将其与静态属性和 `RequestContext` 属性合并。委托 `renderMergedOutputModel` 进行实际渲染。

![view类-render方法](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-webmvc\images\view类-render方法.png)

##### 创建组合输出模型

创建包含动态值和静态属性的组合输出 `Map`（从不为 `null` ）。动态值优先于静态属性。

![view类-createMergedOutputModel方法](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-webmvc\images\view类-createMergedOutputModel方法.png)

顺序，前面的被后面的覆盖：

* 静态属性 `staticAttributes`
* 路径变量 `pathVars`
* 模型 `model`
* `requestContextAttribute`

##### 准备给定的响应

**准备给定的响应**以进行渲染。
当通过 HTTPS 发送下载内容时，默认实现适用于 IE 错误的解决方法。

![view类-prepareResponse方法](G:\文档工具\docsify\study-notes\编程语言\Java\Javalang\Spring生态系统\modules\spring-webmvc\images\view类-prepareResponse方法.png)

##### 渲染组合输出模型

**子类必须实现**此方法才能实际呈现视图。
第一步是准备请求：在 JSP 案例中，这意味着将模型对象设置为请求属性。第二步将是视图的实际呈现，例如通过 `RequestDispatcher` 包含 JSP。

``` java
protected abstract void renderMergedOutputModel(
			Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception;
```

