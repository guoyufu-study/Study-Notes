### 处理程序方法

`@RequestMapping` 处理程序方法**具有灵活的签名**，可以从一系列受支持的控制器方法参数和返回值中进行选择。

#### 方法参数

下表描述了**受支持的控制器方法参数**。任何参数都不支持响应式类型。

JDK 8 `java.util.Optional` 被支持作为方法参数，并与具有 `required` 属性的注解（例如 `@RequestParam`、`@RequestHeader`等）结合使用，它等价于 `required=false`。

| 控制器方法参数                                               | 描述                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| `WebRequest`、`NativeWebRequest`                             | 对请求参数以及请求和会话属性的通用访问，无需直接使用 Servlet API。 |
| `javax.servlet.ServletRequest`、`javax.servlet.ServletResponse` | 选择任何特定的请求或响应类型，例如 `ServletRequest`， `HttpServletRequest` 或 Spring 的 `MultipartRequest`， `MultipartHttpServletRequest`。 |
| `javax.servlet.http.HttpSession`                             | 强制会话的存在。因此，这样的参数永远不会为 `null`。请注意，会话访问不是线程安全的。如果允许多个请求同时访问会话，请考虑将 `RequestMappingHandlerAdapter` 实例的 `synchronizeOnSession` 标志设置为 `true`。 |
| `javax.servlet.http.PushBuilder`                             | Servlet 4.0 推送构建器 API，用于编程 HTTP/2 资源推送。注意，根据 Servlet 规范，如果客户端不支持 HTTP/2 特性，注入的 `PushBuilder` 实例可以为空。 |
| `java.security.Principal`                                    | 当前经过身份验证的用户——如果已知，可能是特定的 `Principal` 实现类。<br/>注意，这个参数不是主动解析的，如果它是为了允许自定义解析器在通过 `HttpServletRequest#getUserPrincipal` 返回到默认解析之前解析它的话。例如，Spring Security `Authentication` 实现了 `Principal` 并且将通过 `HttpServletRequest#getUserPrincipal` 注入，除非它还被 `@AuthenticationPrincipal` 注解，在这种情况下，它由自定义 Spring Security 解析器通过 `Authentication#getPrincipal` 解析。 |
| `HttpMethod`                                                 | 请求的 HTTP 方法。                                           |
| `java.util.Locale`                                           | 当前请求区域设置，由最具体的可用 `LocaleResolver`（实际上是配置的`LocaleResolver` 或 `LocaleContextResolver`）确定。 |
| `java.util.TimeZone`  +<br/> `java.time.ZoneId`              | 与当前请求关联的时区，由 `LocaleContextResolver` 确定。      |
| `java.io.InputStream`、<br/>`java.io.Reader`                 | 用于访问 Servlet API 公开的原始请求正文。                    |
| `java.io.OutputStream`、`java.io.Writer`                     | 用于访问 Servlet API 公开的原始响应主体。                    |
| `@PathVariable`                                              | 用于访问 URI 模板变量。请参阅 [URI 模式](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestmapping-uri-templates)。 |
| `@MatrixVariable`                                            | 用于访问 URI 路径段中的名-值对。请参阅[矩阵变量](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-matrix-variables)。 |
| `@RequestParam`                                              | 用于访问 Servlet 请求参数，包括多部分文件。参数值被转换为声明的方法参数类型。见[`@RequestParam`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestparam) 以及 [`Multipart`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart-forms) 。<br/>注意，对于简单的参数值，使用 `@RequestParam` 是可选的。请参阅本表末尾的“任何其他参数”。 |
| `@RequestHeader`                                             | 用于访问请求标头。标头值被转换为声明的方法参数类型。见[`@RequestHeader`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestheader)。 |
| `@CookieValue`                                               | 用于访问 cookie。Cookies 值被转换为声明的方法参数类型。见[`@CookieValue`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-cookievalue)。 |
| `@RequestBody`                                               | 用于访问 HTTP 请求正文。使用 `HttpMessageConverter` 实现将正文内容转换为声明的方法参数类型。见[`@RequestBody`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestbody)。 |
| `HttpEntity<B>`                                              | 用于访问请求标头和正文。正文用 `HttpMessageConverter` 进行转换。见 [`HttpEntity`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-httpentity)。 |
| `@RequestPart`                                               | 要访问 `multipart/form-data` 请求中的某个部分，请使用`HttpMessageConverter`进行转换。见 [多部分](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-multipart-forms)。 |
| `java.util.Map`, `org.springframework.ui.Model`, `org.springframework.ui.ModelMap` | 用于访问 HTML 控制器中使用的模型，并作为视图渲染的一部分暴露给模板。 |
| `RedirectAttributes`                                         | 指定重定向时要使用的属性（即附加到查询字符串中）和在重定向后临时存储到请求的 flash 属性。请参阅[重定向属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-redirecting-passing-data)和[Flash 属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes)。 |
| `@ModelAttribute`                                            | 用于访问模型中的现有属性（如果不存在则实例化）并应用数据绑定和验证。见 [`@ModelAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-modelattrib-method-args) 以及 [`Model`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-modelattrib-methods) 和 [`DataBinder`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-initbinder)。请注意，`@ModelAttribute` 的使用是可选的(例如，设置其属性)。请参阅本表末尾的“任何其他参数”。 |
| `Errors`, `BindingResult`                                    | 用于访问来自命令对象（即 `@ModelAttribute` 参数）的验证和数据绑定的错误或来自一个 `@RequestBody` 或多个 `@RequestPart` 参数的验证的错误。您必须在经过验证的方法参数之后立即声明一个 `Errors` 或 `BindingResult` 参数。 |
| `SessionStatus` + 类级别 `@SessionAttributes`                | 用于标记表单处理完成，这会触发对通过类级别`@SessionAttributes`注解声明的会话属性的清理。见 [`@SessionAttributes`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-sessionattributes)。 |
| `UriComponentsBuilder`                                       | 用于准备一个相对于当前请求的主机、端口、模式、上下文路径和 servlet 映射的文字部分的URL。见 [URI 链接](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-uri-building)。 |
| `@SessionAttribute`                                          | 用于访问任何会话属性，与存储在会话中的模型属性不同，它是类级别的`@SessionAttributes` 声明的结果。见 [`@SessionAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-sessionattribute)。 |
| `@RequestAttribute`                                          | 用于访问请求属性。见 [`@RequestAttribute`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-requestattrib)。 |
| 任何其他参数                                                 | 如果一个方法参数与该表中任何前面的值都不匹配，并且它是一个简单类型（由 [`BeanUtils#isSimpleProperty`](https://docs.spring.io/spring-framework/docs/5.3.22/javadoc-api/org/springframework/beans/BeanUtils.html#isSimpleProperty-java.lang.Class-)确定，则将其解析为 `@RequestParam`。否则，将其解析为 `@ModelAttribute`。 |



#### 返回值



#### 类型转换

一些带注解的控制器方法参数表示基于 `String` 的请求输入，比如 `@RequestParam`、 `@RequestHeader`、 `@PathVariable`、 `@MatrixVariable` 和 `@CookieValue`，如果参数声明为 `String` 以外的其他类型，则需要进行类型转换。

对于这种情况，根据配置的转换器**自动应用**类型转换。默认情况下，支持**简单类型**（`int`、`long`、`Date`等）。您可以通过 `WebDataBinder`（请参阅 [`DataBinder`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-initbinder)）或通过在 `FormattingConversionService` 中注册 `Formatters` 来**自定义**类型转换。请参阅 [Spring 字段格式化](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#format)。

类型转换的一个实际问题是**对空字符串源值的处理**。如果这种值在类型转换后变为 `null`，则将其视为缺失值。这可能是 `Long` 、`UUID` 和其他目标类型的情况。如果希望允许允许注入 `null` ，请在参数注解上使用 `required` 标志，或将参数声明为 `@Nullable`。

>从 5.3 开始，即使在类型转换之后，也将强制执行非空参数。如果你的处理方法也打算接受一个空值，要么声明你的参数为`@Nullable`，要么在相应的 `@RequestParam` 等注解中将其标记为 `required=false`。这是 5.3 升级中遇到的回归问题的最佳实践和推荐解决方案。
>
>或者，你可以专门处理，例如，在需要 `@PathVariable` 的情况下，产生的 `MissingPathVariableException`。转换后的空值将被视为空的原始值，因此相应的 `Missing…Exception` 变量将被抛出。

#### `@ModelAttribute`

您可以在方法参数上使用 `@ModelAttribute` 注解来**访问模型中的属性**，或者**如果不存在则将其实例化**。模型属性还覆盖了 HTTP Servlet 请求参数的值，这些参数的名称与字段名称相匹配。这被称为数据绑定，它使您不必解析和转换各个查询参数和表单字段。以下示例显示了如何执行此操作：

``` java
@PostMapping("/owners/{ownerId}/pets/{petId}/edit")
public String processSubmit(@ModelAttribute Pet pet) {
    // method logic...
}
```

上面的 `Pet` 实例来源于以下方式之一：

- 从模型中检索，模型可能由 `@ModelAttribute` 方法添加。
- 如果模型属性列在类级别 `@SessionAttributes` 注解中，则从 HTTP 会话中检索。
- 通过 `Converter` 获得，其中模型属性名称与请求值的名称，比如一个路径变量或者一个请求参数(参见下一个示例)，相匹配。
- 使用其默认构造函数实例化。
- 通过带参数的“主构造函数”实例化，其中参数与 Servlet 请求参数匹配。参数名称通过 `JavaBean`s `@ConstructorProperties` 或通过字节码中运行时保留的参数名称确定。 

使用 `@ModelAttribute` 方法来提供它或依赖框架来创建模型属性的一种替代方法是使用  `Converter<String, T>` 提供实例。当模型属性名称与请求值的名称，比如一个路径变量或者一个请求参数，相匹配，并且存在一个从 `String` 到模型属性类型的 `Converter` 时，这将被应用。在以下示例中，模型属性名称 `account` 与 URI 路径变量 `account` 匹配，并且有一个注册的 `Converter<String, Account>` 可以从数据存储中加载 `Account`：

``` java
@PutMapping("/accounts/{account}")
public String save(@ModelAttribute("account") Account account) {
    // ...
}
```



获取模型属性实例后，进行数据绑定。`WebDataBinder` 类将 Servlet 请求参数名称（查询参数和表单字段）与目标 `Object` 上的字段名称相匹配。在必要时应用类型转换后填充匹配字段。有关数据绑定（和验证）的更多信息，请参阅 [验证](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#validation)。有关自定义数据绑定的更多信息，请参阅 [`DataBinder`](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-initbinder)。

数据绑定可能会**导致错误**。默认情况下，会引发一个 `BindException`。但是，要检查控制器方法中的此类错误，您可以在 `@ModelAttribute` 旁边立即添加一个 `BindingResult` 参数，如以下示例所示：

``` java
@PostMapping("/owners/{ownerId}/pets/{petId}/edit")
public String processSubmit(@ModelAttribute("pet") Pet pet, BindingResult result) { 
    if (result.hasErrors()) {
        return "petForm";
    }
    // ...
}
```

在某些情况下，您可能希望**在没有数据绑定的情况下访问模型属性**。对于这种情况，您可以将 `Model` 注入控制器并直接访问它，或者，设置 `@ModelAttribute(binding=false)`，如以下示例所示：

``` java
@ModelAttribute
public AccountForm setUpForm() {
    return new AccountForm();
}

@ModelAttribute
public Account findAccount(@PathVariable String accountId) {
    return accountRepository.findOne(accountId);
}

@PostMapping("update")
public String update(@Valid AccountForm form, BindingResult result,
        @ModelAttribute(binding=false) Account account) { 
    // ...
}
```

您可以通过添加 `javax.validation.Valid` 注解或 Spring 的 `@Validated` 注解（[Bean Validation](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#validation-beanvalidation)和 [Spring 验证](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#validation)）**在数据绑定后自动应用验证** 。以下示例显示了如何执行此操作：

``` java
@PostMapping("/owners/{ownerId}/pets/{petId}/edit")
public String processSubmit(@Valid @ModelAttribute("pet") Pet pet, BindingResult result) { 
    if (result.hasErrors()) {
        return "petForm";
    }
    // ...
}
```

请注意，使用 `@ModelAttribute` 是可选的（例如，设置其属性）。默认情况下，任何不是简单值类型（由 `BeanUtils#isSimpleProperty` 确定）并且未被任何其他参数解析器解析的参数都被视为使用 `@ModelAttribute`注解的。


#### 重定向属性

默认情况下，所有**模型属性**都被认为是**作为重定向 URL 中的 URI 模板变量**公开的。在其余属性中，简单类型或简单类型的集合或简单类型的数组将**作为查询参数自动追加**。

如果模型实例是专门为重定向准备的，那么添加原始类型属性作为查询参数可能是期望的结果。但是，在带注解的控制器中，模型可以包含用于渲染目的的附加属性（例如，下拉字段值）。为避免在 URL 中出现这样的属性，`@RequestMapping` 方法可以**声明一个 `RedirectAttributes` 类型的参数，并使用它来指定可用于 `RedirectView` 的确切属性**。如果该方法进行了重定向，则使用 `RedirectAttributes` 的内容。否则，使用模型的内容。

`RequestMappingHandlerAdapter`提供了一个名为 `ignoreDefaultModelOnRedirect` 的标志 ，您可以使用它来指示如果控制器方法重定向，则不应使用默认 `Model` 内容。相反，控制器方法应该声明一个 `RedirectAttributes` 类型的属性，或者，如果它不这样做，则不应将任何属性传递给 `RedirectView`。MVC 命名空间和 MVC Java 配置都将此标志设置为 `false`，以保持向后兼容性。但是，对于新应用程序，我们**建议将其设置为 `true`**。

注意，**当展开重定向 URL 时，当前请求的 URI 模板变量是自动可用的**，您不需要通过 `Model` 或 `RedirectAttributes` 显式地添加它们。下面的例子展示了如何定义重定向：

``` java
@PostMapping("/files/{path}")
public String upload(...) {
    // ...
    return "redirect:files/{path}";
}
```

将数据传递到重定向目标的另一种方法是使用 flash 属性。与其他重定向属性不同，flash 属性保存在 HTTP 会话中（因此，不会出现在 URL 中）。有关详细信息，请参阅[Flash 属性](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-flash-attributes)。



#### Flash 属性

Flash 属性为**一个请求存储打算在另一个请求中使用的属性**提供了一种方法。这是重定向时最常需要的——例如，Post-Redirect-Get 模式。Flash 属性在重定向（通常在会话中）之前临时保存，以便在重定向后对请求可用，并立即被删除。

Spring MVC 有两个主要的抽象来支持 `flash` 属性。`FlashMap` 用于保存 `flash` 属性，而 `FlashMapManager` 用于存储、检索和管理  `FlashMap` 实例。

Flash 属性支持**始终处于“开启”状态**，不需要显式启用。但是，如果不使用它，它永远不会导致创建 HTTP 会话。在每个请求中，都有一个 “输入” `FlashMap` 和一个“输出” `FlashMap`，前者的属性来自于上一个请求(如果有的话)，后者的属性保存到下一个请求中。这两个`FlashMap` 实例都可以通过 `RequestContextUtils` 中的静态方法在 Spring MVC 的任何地方访问。

带注解的控制器通常不需要直接使用 `FlashMap`。相反， `@RequestMapping` 方法可以**接受 `RedirectAttributes` 类型参数**并使用它为重定向场景添加 flash 属性。通过 `RedirectAttributes` 添加的 flash 属性会自动传播到“输出” `FlashMap`。同样，在重定向之后，来自“输入” `FlashMap` 的属性会自动添加到服务于目标 URL 的控制器的 `Model` 中。

> 将请求与 `flash` 属性匹配
>
> flash 属性的概念存在于许多其他 Web 框架中，并且已被证明**有时会遇到并发问题**。这是因为，根据定义， `flash` 属性将被存储到下一个请求。然而，“下一个”请求可能不是预期的接收者，而是另一个异步请求（例如，轮询或资源请求），在这种情况下， `flash` 属性被删除得太早。
>
> 为了减少出现此类问题的可能性，`RedirectView` 会自动使用目标重定向 URL 的路径和查询参数“标记” `FlashMap` 实例。反过来，默认的 `FlashMapManager` 在查找“输入” `FlashMap` 时，会将该信息与传入的请求进行匹配。
>
> 这并不能完全消除并发问题的可能性，但可以通过重定向 URL 中已有的信息大大减少并发问题。因此，我们建议您将 flash 属性主要用于重定向场景。



