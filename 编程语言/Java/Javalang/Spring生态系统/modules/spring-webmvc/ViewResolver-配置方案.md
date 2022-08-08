# ViewResolver 配置方案

有三种配置 `ViewResolver` 的方案：

* 默认配置：什么都不做
* 显式声明 `ViewResolver` bean
* 使用 `@EnableWebMvc` 注解，并可选实现 `WebMvcConfigurer` 接口。

## 默认配置

不做任何视图解析器相关配置，默认使用**内部资源视图解析器** 。

### 原理

在 `org.springframework.web.servlet.DispatcherServlet` 类中。

#### `initStrategies`

初始化这个 servlet 使用的策略对象。
可以在子类中重写，以便初始化进一步的策略对象。

![DispatcherServlet-initStrategies](images\DispatcherServlet-initStrategies.png)



#### `initViewResolvers`

初始化此类使用的 `ViewResolvers`。
如果没有在 `BeanFactory` 中为此命名空间定义 `ViewResolver` bean，我们默认为 `InternalResourceViewResolver`。

![DispatcherServlet-initViewResolvers](images\DispatcherServlet-initViewResolvers.png)

三个分支

* 检测所有视图解析器，并排序：查找 `ApplicationContext` 中的所有 `ViewResolver`，包括祖先上下文。
* 只使用 bean 名称为 `viewResolver` 的视图解析器
* 使用默认的视图解析器：如果没有找到其他解析器，请通过注册默认 `ViewResolver` 来确保我们至少有一个 `ViewResolver`。

#### `getDefaultStrategies`

为给定的策略接口创建一个默认策略对象列表。
默认实现使用 `DispatcherServlet.properties` 文件（与 `DispatcherServlet` 类位于同一包中）来确定类名。它通过上下文的 `BeanFactory` 实例化策略对象。

![DispatcherServlet-getDefaultStrategies](images\DispatcherServlet-getDefaultStrategies.png)

分四步

* 从属性文件中加载默认策略实现。目前这是严格的内部操作，并意味着应用程序开发人员不可以自定义。
* 获取默认策略实现类。多个实现类，用逗号分隔。
* 加载实现类，并创建相应 bean。
* 收集策略 bean，并返回。

#### `createDefaultStrategy`

![DispatcherServlet-createDefaultStrategy](images\DispatcherServlet-createDefaultStrategy.png)

## 声明 `ViewResolver` bean

显式声明 `ViewResolver` Bean。

### Java 配置

![WebConfig-ViewResolver](images\WebConfig-ViewResolver.png)

在执行 `DispatcherServlet#initViewResolvers` 时，会检测到此处定义的视图解析器，并将其注册到 `DispatcherServlet#viewResolvers` 列表。

### 原理

见 `initViewResolvers`。

## `@EnableWebMvc`

> `org.springframework.web.servlet.config.annotation.EnableWebMvc`

### Java 配置

![WebConfig-WebMvcConfigurer](images\WebConfig-WebMvcConfigurer.png)

分三步

* 在 `@Configuration` 类上使用 `@EnableWebMvc` 注解
* 实现 `WebMvcConfigurer` 接口（可选）
* 自定义方法（可选）

#### `ViewResolverRegistry` 

`org.springframework.web.servlet.config.annotation.ViewResolverRegistry` 协助配置 `ViewResolver` 实例链。此类预计将通过 `WebMvcConfigurer.configureViewResolvers` 使用。

`UrlBasedViewResolverRegistration` 协助配置 `UrlBasedViewResolver` 。

### 原理

将此注解添加到 `@Configuration` 类会**从 `WebMvcConfigurationSupport` 导入 Spring MVC 配置**，例如：

``` java
@Configuration
@EnableWebMvc
@ComponentScan(basePackageClasses = MyConfiguration.class)
public class MyConfiguration {
}
```

要**自定义**导入的配置，请实现接口 `WebMvcConfigurer` 并覆盖各个方法，例如：

``` java
@Configuration
@EnableWebMvc
@ComponentScan(basePackageClasses = MyConfiguration.class)
public class MyConfiguration implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry formatterRegistry) {
        formatterRegistry.addConverter(new MyConverter());
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        converters.add(new MyHttpMessageConverter());
    }

}
```

注意：只有一个 `@Configuration` 类可以有 `@EnableWebMvc` 注解来导入 Spring Web MVC 配置。然而，可以有多个 `@Configuration` 类实现 `WebMvcConfigurer` 以自定义提供的配置。
如果 `WebMvcConfigurer` 没有公开一些需要配置的更高级设置，请考虑删除 `@EnableWebMvc` 注解并直接从 `WebMvcConfigurationSupport` 或 `DelegatingWebMvcConfiguration` 扩展，例如：

``` java
@Configuration
@ComponentScan(basePackageClasses = { MyConfiguration.class })
public class MyConfiguration extends WebMvcConfigurationSupport {

    @Override
    public void addFormatters(FormatterRegistry formatterRegistry) {
        formatterRegistry.addConverter(new MyConverter());
    }

    @Bean
    public RequestMappingHandlerAdapter requestMappingHandlerAdapter() {
        // Create or delegate to "super" to create and
        // customize properties of RequestMappingHandlerAdapter
    }

}
```

#### 源码

``` java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
@Import(DelegatingWebMvcConfiguration.class)
public @interface EnableWebMvc {
}
```

可以看到 `@EnableWebMvc` 除了导入一个 `DelegatingWebMvcConfiguration` 类，什么都没做。

#### `DelegatingWebMvcConfiguration`

> `org.springframework.web.servlet.config.annotation.DelegatingWebMvcConfiguration`

`WebMvcConfigurationSupport` 的子类，它检测并委托给所有类型为 `WebMvcConfigurer` 的 bean，允许它们自定义`WebMvcConfigurationSupport` 提供的配置。这是 `@EnableWebMvc` 实际导入的类。

![DelegatingWebMvcConfiguration-结构](images\DelegatingWebMvcConfiguration-结构.png)

#### `WebMvcConfigurationSupport`

> `org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport`

这是提供 MVC Java 配置背后配置的主类。它通常是通过将 `@EnableWebMvc` 添加到应用程序的 `@Configuration` 类来导入的。另一种更高级的选择是从这个类直接扩展并根据需要重写方法，记住要将 `@Configuration` 添加到子类中，将 `@Bean` 添加到重写的 `@Bean` 方法中。更多细节请参见 `@EnableWebMvc` 的 java 文档。
