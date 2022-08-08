### 日志

Spring MVC 中的 DEBUG 级日志被设计成紧凑、最小且人性化的。它关注的是反复使用的高价值信息，而不是只有在调试特定问题时才有用的信息。

TRACE 级别的日志通常遵循与 DEBUG 相同的原则（例如，也不应该是消防水带），但可用于调试任何问题。此外，某些日志消息可能会在 TRACE 和 DEBUG 中显示不同级别的详细信息。

好的日志记录来自于使用日志的经验。如果您发现任何不符合既定目标的地方，请告知我们。

#### 敏感数据

DEBUG 和 TRACE 日志记录可能会记录敏感信息。这就是为什么请求参数和标头在默认情况下会被屏蔽，并且必须通过 `DispatcherServlet` 上的 `enableLoggingRequestDetails` 属性显式启用它们的完整日志。

以下示例显示了如何使用 Java 配置来执行此操作：

```java
public class MyInitializer
        extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return ... ;
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return ... ;
    }

    @Override
    protected String[] getServletMappings() {
        return ... ;
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        registration.setInitParameter("enableLoggingRequestDetails", "true");
    }

}
```