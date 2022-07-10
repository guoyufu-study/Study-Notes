

## SpringBootApplication

`org.springframework.boot.autoconfigure.SpringBootApplication` 注解

``` java
/**
 * Indicates a {@link Configuration configuration} class that declares one or more
 * {@link Bean @Bean} methods and also triggers {@link EnableAutoConfiguration
 * auto-configuration} and {@link ComponentScan component scanning}. This is a convenience
 * annotation that is equivalent to declaring {@code @Configuration},
 * {@code @EnableAutoConfiguration} and {@code @ComponentScan}.
 *
 * @author Phillip Webb
 * @author Stephane Nicoll
 * @since 1.2.0
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan(excludeFilters = {
		@Filter(type = FilterType.CUSTOM, classes = TypeExcludeFilter.class),
		@Filter(type = FilterType.CUSTOM, classes = AutoConfigurationExcludeFilter.class) })
public @interface SpringBootApplication
```

表示一个 `configuration` 类，声明一个或多个 `@Bean` 方法，同时触发 `auto-configuration` 和 `component scanning` 。这是一个便捷的注解，相当于声明 `@Configuration` 、 `@EnableAutoConfiguration` 和 `@ComponentScan` 。

### 排除特定的自动配置类

``` java
	/**
	 * Exclude specific auto-configuration classes such that they will never be applied.
	 * @return the classes to exclude
	 */
	@AliasFor(annotation = EnableAutoConfiguration.class)
	Class<?[] exclude() default {};

	/**
	 * Exclude specific auto-configuration class names such that they will never be
	 * applied.
	 * @return the class names to exclude
	 * @since 1.3.0
	 */
	@AliasFor(annotation = EnableAutoConfiguration.class)
	String[] excludeName() default {};
```

排除特定的自动配置类，使它们永远不会被应用。排除特定的自动配置类名称，使其永远不会被应用。

### 扫描带注解组件的基础包

``` java
	/**
	 * Base packages to scan for annotated components. Use {@link #scanBasePackageClasses}
	 * for a type-safe alternative to String-based package names.
	 * @return base packages to scan
	 * @since 1.3.0
	 */
	@AliasFor(annotation = ComponentScan.class, attribute = "basePackages")
	String[] scanBasePackages() default {};

	/**
	 * Type-safe alternative to {@link #scanBasePackages} for specifying the packages to
	 * scan for annotated components. The package of each class specified will be scanned.
	 * <p
	 * Consider creating a special no-op marker class or interface in each package that
	 * serves no purpose other than being referenced by this attribute.
	 * @return base packages to scan
	 * @since 1.3.0
	 */
	@AliasFor(annotation = ComponentScan.class, attribute = "basePackageClasses")
	Class<?[] scanBasePackageClasses() default {};
```

用于扫描带注解组件的基础包。使用 `scanBasePackageClasses` 作为基于字符串的包名称的类型安全替代方案。

`scanBasePackages` 的类型安全替代方案，用于指定要扫描带注解组件的包。将扫描指定的每个类的包。
考虑在每个包中创建一个特殊的无操作标记类或接口，除了被此属性引用之外没有其他用途。



## SpringBootConfiguration

`org.springframework.boot.SpringBootConfiguration` 注解

``` java
/**
 * Indicates that a class provides Spring Boot application
 * {@link Configuration @Configuration}. Can be used as an alternative to the Spring's
 * standard {@code @Configuration} annotation so that configuration can be found
 * automatically (for example in tests).
 * <p
 * Application should only ever include <emone</em{@code @SpringBootConfiguration} and
 * most idiomatic Spring Boot applications will inherit it from
 * {@code @SpringBootApplication}.
 *
 * @author Phillip Webb
 * @since 1.4.0
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Configuration
public @interface SpringBootConfiguration {

}
```

表示一个类提供 Spring Boot 应用 `@Configuration` 。可以用作 Spring 标准 `@Configuration` 注解的替代品，以便可以自动找到配置（例如在测试中）。
应用程序应该只包含一个 `@SpringBootConfiguration` 并且大多数惯用的 Spring Boot 应用程序将从 `@SpringBootApplication` 继承它。

## EnableAutoConfiguration

`org.springframework.boot.autoconfigure.EnableAutoConfiguration` 注解

``` java
/**
 * Enable auto-configuration of the Spring Application Context, attempting to guess and
 * configure beans that you are likely to need. Auto-configuration classes are usually
 * applied based on your classpath and what beans you have defined. For example, if you
 * have {@code tomcat-embedded.jar} on your classpath you are likely to want a
 * {@link TomcatServletWebServerFactory} (unless you have defined your own
 * {@link ServletWebServerFactory} bean).
 * <p
 * When using {@link SpringBootApplication}, the auto-configuration of the context is
 * automatically enabled and adding this annotation has therefore no additional effect.
 * <p
 * Auto-configuration tries to be as intelligent as possible and will back-away as you
 * define more of your own configuration. You can always manually {@link #exclude()} any
 * configuration that you never want to apply (use {@link #excludeName()} if you don't
 * have access to them). You can also exclude them via the
 * {@code spring.autoconfigure.exclude} property. Auto-configuration is always applied
 * after user-defined beans have been registered.
 * <p
 * The package of the class that is annotated with {@code @EnableAutoConfiguration},
 * usually via {@code @SpringBootApplication}, has specific significance and is often used
 * as a 'default'. For example, it will be used when scanning for {@code @Entity} classes.
 * It is generally recommended that you place {@code @EnableAutoConfiguration} (if you're
 * not using {@code @SpringBootApplication}) in a root package so that all sub-packages
 * and classes can be searched.
 * <p
 * Auto-configuration classes are regular Spring {@link Configuration} beans. They are
 * located using the {@link SpringFactoriesLoader} mechanism (keyed against this class).
 * Generally auto-configuration beans are {@link Conditional @Conditional} beans (most
 * often using {@link ConditionalOnClass @ConditionalOnClass} and
 * {@link ConditionalOnMissingBean @ConditionalOnMissingBean} annotations).
 *
 * @author Phillip Webb
 * @author Stephane Nicoll
 * @see ConditionalOnBean
 * @see ConditionalOnMissingBean
 * @see ConditionalOnClass
 * @see AutoConfigureAfter
 * @see SpringBootApplication
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage
@Import(AutoConfigurationImportSelector.class)
public @interface EnableAutoConfiguration 
```

启用 Spring Application Context 的自动配置，尝试猜测和配置您可能需要的 bean。**自动配置类通常根据您的类路径和您定义的 bean 应用**。例如，如果您的类路径中有 `tomcat-embedded.jar` ，您可能需要一个`TomcatServletWebServerFactory` （除非您已经定义了自己的 `ServletWebServerFactory` bean）。
使用 `SpringBootApplication` 时，上下文的自动配置会自动启用，因此添加此注解不会产生额外的影响。
自动配置尝试尽可能智能，并且会随着您定义更多自己的配置而后退。您始终可以手动 `exclude()` 任何您不想应用的配置（如果您无权访问它们，请使用 `excludeName()` ）。您还可以通过 `spring.autoconfigure.exclude` 属性排除它们。自动配置总是在用户定义的 bean 注册后应用。
使用 `@EnableAutoConfiguration` 注解的类的包，通常通过 `@SpringBootApplication`，具有特定的意义，通常用作“默认值”。例如，它将在扫描 `@Entity` 类时使用。通常建议您将 `@EnableAutoConfiguration` （如果您不使用 `@SpringBootApplication` ）放在根包中，以便可以搜索所有子包和类。
自动配置类是常规的 Spring Configuration bean。它们使用 `SpringFactoriesLoader` 机制定位（针对这个类设置键）。通常自动配置 bean 是 `@Conditional` bean（最常使用 `@ConditionalOnClass` 和 `@ConditionalOnMissingBean` 注解）。



## ComponentScan

`org.springframework.context.annotation.ComponentScan` 注解：**组件扫描指令**

``` java
/**
 * Configures component scanning directives for use with @{@link Configuration} classes.
 * Provides support parallel with Spring XML's {@code <context:component-scan} element.
 *
 * <pEither {@link #basePackageClasses} or {@link #basePackages} (or its alias
 * {@link #value}) may be specified to define specific packages to scan. If specific
 * packages are not defined, scanning will occur from the package of the
 * class that declares this annotation.
 *
 * <pNote that the {@code <context:component-scan} element has an
 * {@code annotation-config} attribute; however, this annotation does not. This is because
 * in almost all cases when using {@code @ComponentScan}, default annotation config
 * processing (e.g. processing {@code @Autowired} and friends) is assumed. Furthermore,
 * when using {@link AnnotationConfigApplicationContext}, annotation config processors are
 * always registered, meaning that any attempt to disable them at the
 * {@code @ComponentScan} level would be ignored.
 *
 * <pSee {@link Configuration @Configuration}'s Javadoc for usage examples.
 *
 * @author Chris Beams
 * @author Juergen Hoeller
 * @author Sam Brannen
 * @since 3.1
 * @see Configuration
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
@Repeatable(ComponentScans.class)
public @interface ComponentScan {
```

配置组件扫描指令与 `@Configuration` 类**一起使用**。提供与 Spring XML 的 `<context:component-scan` 元素**并行的支持**。
可以指定 `basePackageClasses` 或 `basePackages` （或其别名 `value` ）来**定义要扫描的特定包**。如果未定义特定的包，则会从声明此注解的类的包中进行扫描。
注意 `<context:component-scan` 元素有一个 `annotation-config` 属性；但是，此注解没有。这是因为在几乎所有使用`@ComponentScan` 的情况下，都**假定默认注解配置处理**（例如，处理 `@Autowired` 和朋友）。此外，当使用`AnnotationConfigApplicationContext` 时，注解配置处理器总是被注册，这意味着任何在 `@ComponentScan` 级别**禁用它们的尝试都将被忽略**。
有关使用示例，请参阅 `@Configuration` 的 Javadoc。

### 定义要扫描的特定包

``` java
	/**
	 * Alias for {@link #basePackages}.
	 * <pAllows for more concise annotation declarations if no other attributes
	 * are needed &mdash; for example, {@code @ComponentScan("org.my.pkg")}
	 * instead of {@code @ComponentScan(basePackages = "org.my.pkg")}.
	 */
	@AliasFor("basePackages")
	String[] value() default {};

	/**
	 * Base packages to scan for annotated components.
	 * <p{@link #value} is an alias for (and mutually exclusive with) this
	 * attribute.
	 * <pUse {@link #basePackageClasses} for a type-safe alternative to
	 * String-based package names.
	 */
	@AliasFor("value")
	String[] basePackages() default {};

	/**
	 * Type-safe alternative to {@link #basePackages} for specifying the packages
	 * to scan for annotated components. The package of each class specified will be scanned.
	 * <pConsider creating a special no-op marker class or interface in each package
	 * that serves no purpose other than being referenced by this attribute.
	 */
	Class<?[] basePackageClasses() default {};
```

定义要扫描的特定包

### Bean 名称生成器

``` java
	/**
	 * The {@link BeanNameGenerator} class to be used for naming detected components
	 * within the Spring container.
	 * <pThe default value of the {@link BeanNameGenerator} interface itself indicates
	 * that the scanner used to process this {@code @ComponentScan} annotation should
	 * use its inherited bean name generator, e.g. the default
	 * {@link AnnotationBeanNameGenerator} or any custom instance supplied to the
	 * application context at bootstrap time.
	 * @see AnnotationConfigApplicationContext#setBeanNameGenerator(BeanNameGenerator)
	 */
	Class<? extends BeanNameGeneratornameGenerator() default BeanNameGenerator.class;
```

 `BeanNameGenerator` 类，用于命名 Spring 容器中检测到的组件。
`BeanNameGenerator` 接口本身的默认值表示用于处理此 `@ComponentScan` 注解的扫描器应使用其继承的 bean 名称生成器，例如默认 `AnnotationBeanNameGenerator` 或在引导时提供给应用程序上下文的任何自定义实例。

### 作用域解析器

``` java
	/**
	 * The {@link ScopeMetadataResolver} to be used for resolving the scope of detected components.
	 */
	Class<? extends ScopeMetadataResolverscopeResolver() default AnnotationScopeMetadataResolver.class;

	/**
	 * Indicates whether proxies should be generated for detected components, which may be
	 * necessary when using scopes in a proxy-style fashion.
	 * <pThe default is defer to the default behavior of the component scanner used to
	 * execute the actual scan.
	 * <pNote that setting this attribute overrides any value set for {@link #scopeResolver}.
	 * @see ClassPathBeanDefinitionScanner#setScopedProxyMode(ScopedProxyMode)
	 */
	ScopedProxyMode scopedProxy() default ScopedProxyMode.DEFAULT;
```

`ScopeMetadataResolver` 用于解析检测到的组件的作用域。

指示是否应为检测到的组件生成代理，这在以代理样式方式使用作用域时可能是必需的。
默认值遵循用于执行实际扫描的组件扫描器的默认行为。
请注意，设置此属性会覆盖为 `scopeResolver` 设置的任何值。

### 过滤器

``` java
	/**
	 * Controls the class files eligible for component detection.
	 * <pConsider use of {@link #includeFilters} and {@link #excludeFilters}
	 * for a more flexible approach.
	 */
	String resourcePattern() default ClassPathScanningCandidateComponentProvider.DEFAULT_RESOURCE_PATTERN;

	/**
	 * Indicates whether automatic detection of classes annotated with {@code @Component}
	 * {@code @Repository}, {@code @Service}, or {@code @Controller} should be enabled.
	 */
	boolean useDefaultFilters() default true;

	/**
	 * Specifies which types are eligible for component scanning.
	 * <pFurther narrows the set of candidate components from everything in {@link #basePackages}
	 * to everything in the base packages that matches the given filter or filters.
	 * <pNote that these filters will be applied in addition to the default filters, if specified.
	 * Any type under the specified base packages which matches a given filter will be included,
	 * even if it does not match the default filters (i.e. is not annotated with {@code @Component}).
	 * @see #resourcePattern()
	 * @see #useDefaultFilters()
	 */
	Filter[] includeFilters() default {};

	/**
	 * Specifies which types are not eligible for component scanning.
	 * @see #resourcePattern
	 */
	Filter[] excludeFilters() default {};
```

控制符合组件检测条件的类文件。
考虑使用 `includeFilters` 和 `excludeFilters` 以获得更灵活的方法。

指示是否应启用自动检测，来自动检测使用 `@Component`、`@Repository` 、 `@Service` 或 `@Controller` 注解的类。

指定哪些类型适合组件扫描。
进一步将候选组件集从 `basePackages` 中的所有内容缩小到与给定过滤器或过滤器匹配的基本包中的所有内容。
请注意，除了默认过滤器（如果指定）之外，还将应用这些过滤器。将包含指定基本包下与给定过滤器匹配的任何类型，即使它与默认过滤器不匹配（即未使用 `@Component` 注解）。

指定哪些类型不适合组件扫描。

### 延迟初始化

``` java
	/**
	 * Specify whether scanned beans should be registered for lazy initialization.
	 * <pDefault is {@code false}; switch this to {@code true} when desired.
	 * @since 4.1
	 */
	boolean lazyInit() default false;
```

指定是否应为延迟初始化注册扫描的 bean。
默认为 `false` ；需要时将其切换为 `true` 。



## Controller

`org.springframework.stereotype.Controller` 注解

``` java
/**
 * Indicates that an annotated class is a "Controller" (e.g. a web controller).
 *
 * <pThis annotation serves as a specialization of {@link Component @Component},
 * allowing for implementation classes to be autodetected through classpath scanning.
 * It is typically used in combination with annotated handler methods based on the
 * {@link org.springframework.web.bind.annotation.RequestMapping} annotation.
 *
 * @author Arjen Poutsma
 * @author Juergen Hoeller
 * @since 2.5
 * @see Component
 * @see org.springframework.web.bind.annotation.RequestMapping
 * @see org.springframework.context.annotation.ClassPathBeanDefinitionScanner
 */
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface Controller
```

表示一个带注解的类是一个“控制器”（例如一个 web 控制器）。
这个注解作为 `@Component` 的一个特化，允许通过类路径扫描自动检测实现类。它通常与基于 `org.springframework.web.bind.annotation.RequestMapping` 注解的注解处理程序方法结合使用。

``` java
	/**
	 * The value may indicate a suggestion for a logical component name,
	 * to be turned into a Spring bean in case of an autodetected component.
	 * @return the suggested component name, if any (or empty String otherwise)
	 */
	@AliasFor(annotation = Component.class)
	String value() default "";
```

该值可能表示对逻辑组件名称的建议，在自动检测到组件的情况下将其转换为 Spring bean。

## Component

`org.springframework.stereotype.Component` 注解

``` java
/**
 * Indicates that an annotated class is a "component".
 * Such classes are considered as candidates for auto-detection
 * when using annotation-based configuration and classpath scanning.
 *
 * <pOther class-level annotations may be considered as identifying
 * a component as well, typically a special kind of component:
 * e.g. the {@link Repository @Repository} annotation or AspectJ's
 * {@link org.aspectj.lang.annotation.Aspect @Aspect} annotation.
 *
 * @author Mark Fisher
 * @since 2.5
 * @see Repository
 * @see Service
 * @see Controller
 * @see org.springframework.context.annotation.ClassPathBeanDefinitionScanner
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Indexed
public @interface Component
```

表示带注解的类是“组件”。在使用基于注解的配置和类路径扫描时，此类类被视为自动检测的候选对象。
其他类级别的注解也可以被认为是标识一个组件，通常是一种特殊的组件：例如 `@Repository` 注解或 AspectJ 的 `@Aspect`注解。

``` java
	/**
	 * The value may indicate a suggestion for a logical component name,
	 * to be turned into a Spring bean in case of an autodetected component.
	 * @return the suggested component name, if any (or empty String otherwise)
	 */
	String value() default "";
```

## Indexed

`org.springframework.stereotype.Indexed` 注解

``` java
/**
 * Indicate that the annotated element represents a stereotype for the index.
 *
 * <pThe {@code CandidateComponentsIndex} is an alternative to classpath
 * scanning that uses a metadata file generated at compilation time. The
 * index allows retrieving the candidate components (i.e. fully qualified
 * name) based on a stereotype. This annotation instructs the generator to
 * index the element on which the annotated element is present or if it
 * implements or extends from the annotated element. The stereotype is the
 * fully qualified name of the annotated element.
 *
 * <pConsider the default {@link Component} annotation that is meta-annotated
 * with this annotation. If a component is annotated with {@link Component},
 * an entry for that component will be added to the index using the
 * {@code org.springframework.stereotype.Component} stereotype.
 *
 * <pThis annotation is also honored on meta-annotations. Consider this
 * custom annotation:
 * <pre class="code"
 * package com.example;
 *
 * &#064;Target(ElementType.TYPE)
 * &#064;Retention(RetentionPolicy.RUNTIME)
 * &#064;Documented
 * &#064;Indexed
 * &#064;Service
 * public @interface PrivilegedService { ... }
 * </pre
 *
 * If the above annotation is present on a type, it will be indexed with two
 * stereotypes: {@code org.springframework.stereotype.Component} and
 * {@code com.example.PrivilegedService}. While {@link Service} isn't directly
 * annotated with {@code Indexed}, it is meta-annotated with {@link Component}.
 *
 * <pIt is also possible to index all implementations of a certain interface or
 * all the subclasses of a given class by adding {@code @Indexed} on it.
 *
 * Consider this base interface:
 * <pre class="code"
 * package com.example;
 *
 * &#064;Indexed
 * public interface AdminService { ... }
 * </pre
 *
 * Now, consider an implementation of this {@code AdminService} somewhere:
 * <pre class="code"
 * package com.example.foo;
 *
 * import com.example.AdminService;
 *
 * public class ConfigurationAdminService implements AdminService { ... }
 * </pre
 *
 * Because this class implements an interface that is indexed, it will be
 * automatically included with the {@code com.example.AdminService} stereotype.
 * If there are more {@code @Indexed} interfaces and/or superclasses in the
 * hierarchy, the class will map to all their stereotypes.
 *
 * @author Stephane Nicoll
 * @since 5.0
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Indexed {
}
```

指示带注解的元素表示索引的构造型。
`CandidateComponentsIndex` 是类路径扫描的替代方法，它使用编译时生成的元数据文件。该索引允许基于原型检索候选组件（即完全限定名称）。此注解指示生成器对存在注解元素的元素进行索引，或者它是否实现或从注解元素扩展。构造型是带注解元素的完全限定名称。
考虑使用此注解进行元注解的默认 `Component` 注解。如果一个组件用 `Component` 注解，则该组件的条目将使用 `org.springframework.stereotype.Component` 原型添加到索引中。
此注解也适用于元注解。考虑这个自定义注解：

``` java
  package com.example;

  @Target(ElementType.TYPE)
  @Retention(RetentionPolicy.RUNTIME)
  @Documented
  @Indexed
  @Service
  public @interface PrivilegedService { ... }
```

如果上面的注解出现在一个类型上，它将被两个原型索引： `org.springframework.stereotype.Component` 和 `com.example.PrivilegedService` 。虽然 `Service` 没有直接用 `Indexed` 注解，但它是用 `Component` 元注解的。
也可以通过在其上添加 `@Indexed` 来索引某个接口的所有实现或给定类的所有子类。考虑这个基本接口：

``` java
  package com.example;

  @Indexed
  public interface AdminService { ... }
```

现在，在某处考虑这个 `AdminService` 的实现：

``` java
  package com.example.foo;

  import com.example.AdminService;

  public class ConfigurationAdminService implements AdminService { ... }
```

因为这个类实现了一个被索引的接口，它将自动包含在 `com.example.AdminService` 原型中。如果层次结构中有更多 `@Indexed` 接口和/或超类，则该类将映射到它们的所有构造型。

## GetMapping

`org.springframework.web.bind.annotation.GetMapping` 注解

``` java
/**
 * Annotation for mapping HTTP {@code GET} requests onto specific handler
 * methods.
 *
 * <pSpecifically, {@code @GetMapping} is a <emcomposed annotation</emthat
 * acts as a shortcut for {@code @RequestMapping(method = RequestMethod.GET)}.
 *
 *
 * @author Sam Brannen
 * @since 4.3
 * @see PostMapping
 * @see PutMapping
 * @see DeleteMapping
 * @see PatchMapping
 * @see RequestMapping
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@RequestMapping(method = RequestMethod.GET)
public @interface GetMapping
```

用于**将 HTTP GET 请求映射到特定处理程序方法**的注解。
具体来说， `@GetMapping` 是一个组合注解，它充当 `@RequestMapping(method = RequestMethod.GET)` 的快捷方式。

## RequestMapping



``` java
/**
 * Annotation for mapping web requests onto methods in request-handling classes
 * with flexible method signatures.
 *
 * <pBoth Spring MVC and Spring WebFlux support this annotation through a
 * {@code RequestMappingHandlerMapping} and {@code RequestMappingHandlerAdapter}
 * in their respective modules and package structure. For the exact list of
 * supported handler method arguments and return types in each, please use the
 * reference documentation links below:
 * <ul
 * <liSpring MVC
 * <a href="https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-ann-arguments"Method Arguments</a
 * and
 * <a href="https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-ann-return-types"Return Values</a
 * </li
 * <liSpring WebFlux
 * <a href="https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-ann-arguments"Method Arguments</a
 * and
 * <a href="https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-ann-return-types"Return Values</a
 * </li
 * </ul
 *
 * <p<strongNote:</strongThis annotation can be used both at the class and
 * at the method level. In most cases, at the method level applications will
 * prefer to use one of the HTTP method specific variants
 * {@link GetMapping @GetMapping}, {@link PostMapping @PostMapping},
 * {@link PutMapping @PutMapping}, {@link DeleteMapping @DeleteMapping}, or
 * {@link PatchMapping @PatchMapping}.</p
 *
 * <p<bNOTE:</bWhen using controller interfaces (e.g. for AOP proxying),
 * make sure to consistently put <iall</iyour mapping annotations - such as
 * {@code @RequestMapping} and {@code @SessionAttributes} - on
 * the controller <iinterface</irather than on the implementation class.
 *
 * @author Juergen Hoeller
 * @author Arjen Poutsma
 * @author Sam Brannen
 * @since 2.5
 * @see GetMapping
 * @see PostMapping
 * @see PutMapping
 * @see DeleteMapping
 * @see PatchMapping
 * @see org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter
 * @see org.springframework.web.reactive.result.method.annotation.RequestMappingHandlerAdapter
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Mapping
public @interface RequestMapping
```

用于**将 Web 请求映射到具有灵活方法签名的请求处理类中的方法**的注解。
Spring MVC 和 Spring WebFlux 都通过各自模块和包结构中的 `RequestMappingHandlerMapping` 和 `RequestMappingHandlerAdapter` 支持此注解。有关每个支持的处理程序方法参数和返回类型的确切列表，请使用下面的参考文档链接：
Spring MVC [方法参数](https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-ann-arguments) 和 [返回值](https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-ann-return-types)
Spring WebFlux [方法参数](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-ann-arguments) 和 [返回值](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-ann-return-types)
注意：这个注解可以在类和方法级别使用。在大多数情况下，在方法级别应用程序会更喜欢使用 HTTP 方法特定的变体 `@GetMapping` 、 `@PostMapping` 、 `@PutMapping` 、 `@DeleteMapping` 或 `@PatchMapping` 。
注意：当使用控制器接口（例如，用于 AOP 代理）时，请确保始终将所有映射注解 - 例如 `@RequestMapping` 和 `@SessionAttributes` - 放在控制器接口上而不是实现类上。

## ResponseBody

`org.springframework.web.bind.annotation.ResponseBody` 注解

``` java
/**
 * Annotation that indicates a method return value should be bound to the web
 * response body. Supported for annotated handler methods in Servlet environments.
 *
 * <pAs of version 4.0 this annotation can also be added on the type level in
 * which case it is inherited and does not need to be added on the method level.
 *
 * @author Arjen Poutsma
 * @since 3.0
 * @see RequestBody
 * @see RestController
 */
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ResponseBody {

}
```

注解指示**方法返回值应绑定到 Web 响应正文**。支持 Servlet 环境中的带注解的处理程序方法。
从 4.0 版开始，这个注解也可以添加到类型级别，在这种情况下，它是继承的，不需要添加到方法级别。

## RestController

``` java
/**
 * A convenience annotation that is itself annotated with
 * {@link Controller @Controller} and {@link ResponseBody @ResponseBody}.
 * <p
 * Types that carry this annotation are treated as controllers where
 * {@link RequestMapping @RequestMapping} methods assume
 * {@link ResponseBody @ResponseBody} semantics by default.
 *
 * <p<bNOTE:</b{@code @RestController} is processed if an appropriate
 * {@code HandlerMapping}-{@code HandlerAdapter} pair is configured such as the
 * {@code RequestMappingHandlerMapping}-{@code RequestMappingHandlerAdapter}
 * pair which are the default in the MVC Java config and the MVC namespace.
 *
 * @author Rossen Stoyanchev
 * @author Sam Brannen
 * @since 4.0
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
public @interface RestController 
```

一个便利的注解，它本身用 `@Controller` 和 `@ResponseBody` 注解。
带有此注解的类型被视为控制器，其中 `@RequestMapping` 方法默认采用 `@ResponseBody` 语义。
注意：如果配置了适当的 `HandlerMapping-HandlerAdapter` 对，例如 MVC Java 配置和 MVC 命名空间中默认的`RequestMappingHandlerMapping-RequestMappingHandlerAdapter` 对，则处理 `@RestController` 。

## SpringBootTest

`org.springframework.boot.test.context.SpringBootTest`

``` java
/**
 * Annotation that can be specified on a test class that runs Spring Boot based tests.
 * Provides the following features over and above the regular <em>Spring TestContext
 * Framework</em>:
 * <ul>
 * <li>Uses {@link SpringBootContextLoader} as the default {@link ContextLoader} when no
 * specific {@link ContextConfiguration#loader() @ContextConfiguration(loader=...)} is
 * defined.</li>
 * <li>Automatically searches for a
 * {@link SpringBootConfiguration @SpringBootConfiguration} when nested
 * {@code @Configuration} is not used, and no explicit {@link #classes() classes} are
 * specified.</li>
 * <li>Allows custom {@link Environment} properties to be defined using the
 * {@link #properties() properties attribute}.</li>
 * <li>Provides support for different {@link #webEnvironment() webEnvironment} modes,
 * including the ability to start a fully running web server listening on a
 * {@link WebEnvironment#DEFINED_PORT defined} or {@link WebEnvironment#RANDOM_PORT
 * random} port.</li>
 * <li>Registers a {@link org.springframework.boot.test.web.client.TestRestTemplate
 * TestRestTemplate} and/or
 * {@link org.springframework.test.web.reactive.server.WebTestClient WebTestClient} bean
 * for use in web tests that are using a fully running web server.</li>
 * </ul>
 *
 * @author Phillip Webb
 * @author Andy Wilkinson
 * @since 1.4.0
 * @see ContextConfiguration
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@BootstrapWith(SpringBootTestContextBootstrapper.class)
public @interface SpringBootTest 
```

可以在运行基于 Spring Boot 的测试的测试类上指定的注解。在常规 Spring TestContext Framework 之外提供以下功能：

* 当没有定义特定的 `@ContextConfiguration(loader=...)` 时，使用 `SpringBootContextLoader` 作为默认的 `ContextLoader` 。
* 不使用嵌套 `@Configuration` ，并且未指定显式 `classes`时，自动搜索 `@SpringBootConfiguration`  。
* 允许使用 `properties` `attribute` 定义自定义 `Environment` 属性。
* 提供对不同 `webEnvironment` 模式的支持，包括启动在 defined 或 random 端口上侦听的完全运行的 Web 服务器的能力。
* 注册一个 `TestRestTemplate` 和/或 `WebTestClient` bean，以便在使用完全运行的 Web 服务器的 Web 测试中使用。

### 自定义 `Environment` 属性

``` java
	/**
	 * Alias for {@link #properties()}.
	 * @return the properties to apply
	 */
	@AliasFor("properties")
	String[] value() default {};

	/**
	 * Properties in form {@literal key=value} that should be added to the Spring
	 * {@link Environment} before the test runs.
	 * @return the properties to add
	 */
	@AliasFor("value")
	String[] properties() default {};
```

应在测试运行之前添加到 Spring `Environment` 中的 `key=value` 形式的属性。

### 用于加载 `ApplicationContext` 的带注解的类

``` java
	/**
	 * The <em>annotated classes</em> to use for loading an
	 * {@link org.springframework.context.ApplicationContext ApplicationContext}. Can also
	 * be specified using
	 * {@link ContextConfiguration#classes() @ContextConfiguration(classes=...)}. If no
	 * explicit classes are defined the test will look for nested
	 * {@link Configuration @Configuration} classes, before falling back to a
	 * {@link SpringBootConfiguration} search.
	 * @see ContextConfiguration#classes()
	 * @return the annotated classes used to load the application context
	 */
	Class<?>[] classes() default {};
```

用于加载 `ApplicationContext` 的带注解的类。也可以使用 `@ContextConfiguration(classes=...)` 指定。如果未定义显式类，则测试将在返回到 `SpringBootConfiguration` 搜索之前查找嵌套的 `@Configuration` 类。

### 不同 `webEnvironment` 模式

``` java
	/**
	 * The type of web environment to create when applicable. Defaults to
	 * {@link WebEnvironment#MOCK}.
	 * @return the type of web environment
	 */
	WebEnvironment webEnvironment() default WebEnvironment.MOCK;

	/**
	 * An enumeration web environment modes.
	 */
	enum WebEnvironment {

		/**
		 * Creates a {@link WebApplicationContext} with a mock servlet environment if
		 * servlet APIs are on the classpath, a {@link ReactiveWebApplicationContext} if
		 * Spring WebFlux is on the classpath or a regular {@link ApplicationContext}
		 * otherwise.
		 */
		MOCK(false),

		/**
		 * Creates a web application context (reactive or servlet based) and sets a
		 * {@code server.port=0} {@link Environment} property (which usually triggers
		 * listening on a random port). Often used in conjunction with a
		 * {@link LocalServerPort} injected field on the test.
		 */
		RANDOM_PORT(true),

		/**
		 * Creates a (reactive) web application context without defining any
		 * {@code server.port=0} {@link Environment} property.
		 */
		DEFINED_PORT(true),

		/**
		 * Creates an {@link ApplicationContext} and sets
		 * {@link SpringApplication#setWebApplicationType(WebApplicationType)} to
		 * {@link WebApplicationType#NONE}.
		 */
		NONE(false);

		private final boolean embedded;

		WebEnvironment(boolean embedded) {
			this.embedded = embedded;
		}

		/**
		 * Return if the environment uses an {@link ServletWebServerApplicationContext}.
		 * @return if an {@link ServletWebServerApplicationContext} is used.
		 */
		public boolean isEmbedded() {
			return this.embedded;
		}

	}
```

适用时要创建的 Web 环境的类型。默认为 `SpringBootTest.WebEnvironment.MOCK` 。

枚举 web 环境模式。

## BootstrapWith

``` java
/**
 * {@code @BootstrapWith} defines class-level metadata that is used to determine
 * how to bootstrap the <em>Spring TestContext Framework</em>.
 *
 * <p>This annotation may also be used as a <em>meta-annotation</em> to create
 * custom <em>composed annotations</em>.
 *
 * @author Sam Brannen
 * @since 4.1
 * @see BootstrapContext
 * @see TestContextBootstrapper
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
public @interface BootstrapWith
```

`@BootstrapWith` 定义了类级元数据，这个类级元数据用于确定如何引导 Spring TestContext Framework 。
此注解也可以用作元注解来创建自定义组合注解。

``` java
	/**
	 * The {@link TestContextBootstrapper} to use to bootstrap the <em>Spring
	 * TestContext Framework</em>.
	 */
	Class<? extends TestContextBootstrapper> value() default TestContextBootstrapper.class;
```

## TestContextBootstrapper

``` java
/**
 * {@code TestContextBootstrapper} defines the SPI for bootstrapping the
 * <em>Spring TestContext Framework</em>.
 *
 * <p>A {@code TestContextBootstrapper} is used by the {@link TestContextManager} to
 * {@linkplain #getTestExecutionListeners get the TestExecutionListeners} for the
 * current test and to {@linkplain #buildTestContext build the TestContext} that
 * it manages.
 *
 * <h3>Configuration</h3>
 *
 * <p>A custom bootstrapping strategy can be configured for a test class (or
 * test class hierarchy) via {@link BootstrapWith @BootstrapWith}, either
 * directly or as a meta-annotation.
 *
 * <p>If a bootstrapper is not explicitly configured via {@code @BootstrapWith},
 * either the {@link org.springframework.test.context.support.DefaultTestContextBootstrapper
 * DefaultTestContextBootstrapper} or the
 * {@link org.springframework.test.context.web.WebTestContextBootstrapper
 * WebTestContextBootstrapper} will be used, depending on the presence of
 * {@link org.springframework.test.context.web.WebAppConfiguration @WebAppConfiguration}.
 *
 * <h3>Implementation Notes</h3>
 *
 * <p>Concrete implementations must provide a {@code public} no-args constructor.
 *
 * <p><strong>WARNING</strong>: this SPI will likely change in the future in
 * order to accommodate new requirements. Implementers are therefore strongly encouraged
 * <strong>not</strong> to implement this interface directly but rather to <em>extend</em>
 * {@link org.springframework.test.context.support.AbstractTestContextBootstrapper
 * AbstractTestContextBootstrapper} or one of its concrete subclasses instead.
 *
 * @author Sam Brannen
 * @since 4.1
 * @see BootstrapWith
 * @see BootstrapContext
 */
public interface TestContextBootstrapper
```

`TestContextBootstrapper` 定义了用于引导 Spring TestContext Framework 的 SPI。
`TestContextBootstrapper` 使用 `TestContextManager` 来获取当前测试的 `TestExecutionListeners` 并构建它管理的 `TestContext` 。
配置
可以通过 `@BootstrapWith` 直接或作为元注解为测试类（或测试类层次结构）配置自定义引导策略。
如果引导程序未通过 `@BootstrapWith` 显式配置，则将使用 `DefaultTestContextBootstrapper` 或 `WebTestContextBootstrapper` ，具体取决于 `@WebAppConfiguration` 的存在。
实施说明
具体实现必须提供一个公共的无参数构造函数。
警告：此 SPI 将来可能会更改以适应新要求。因此，强烈建议实现者不要直接实现此接口，而是扩展 `AbstractTestContextBootstrapper` 或其具体子类之一。

## SpringBootTestContextBootstrapper



## TestRestTemplate

``` java
/**
 * Convenient alternative of {@link RestTemplate} that is suitable for integration tests.
 * They are fault tolerant, and optionally can carry Basic authentication headers. If
 * Apache Http Client 4.3.2 or better is available (recommended) it will be used as the
 * client, and by default configured to ignore cookies and redirects.
 * <p>
 * Note: To prevent injection problems this class intentionally does not extend
 * {@link RestTemplate}. If you need access to the underlying {@link RestTemplate} use
 * {@link #getRestTemplate()}.
 * <p>
 * If you are using the
 * {@link org.springframework.boot.test.context.SpringBootTest @SpringBootTest}
 * annotation, a {@link TestRestTemplate} is automatically available and can be
 * {@code @Autowired} into your test. If you need customizations (for example to adding
 * additional message converters) use a {@link RestTemplateBuilder} {@code @Bean}.
 *
 * @author Dave Syer
 * @author Phillip Webb
 * @author Andy Wilkinson
 * @author Kristine Jetzke
 * @since 1.4.0
 */
public class TestRestTemplate
```

`RestTemplate` 的便捷替代品，适用于集成测试。它们是容错的，并且可以选择携带基本身份验证标头。如果 Apache Http Client 4.3.2 或更高版本可用（推荐），它将用作客户端，并且默认配置为忽略 cookie 和重定向。
注意：为了防止注入问题，此类故意不扩展 `RestTemplate` 。如果您需要访问底层 `RestTemplate` 使用 `getRestTemplate()` 。
如果您使用 `@SpringBootTest` 注解，则 `TestRestTemplate` 自动可用，并且可以 `@Autowired` 到您的测试中。如果您需要自定义（例如添加其他消息转换器），请使用 `RestTemplateBuilder` `@Bean` 。

### RestOperations

`org.springframework.web.client.RestOperations`

``` java
/**
 * Interface specifying a basic set of RESTful operations.
 * Implemented by {@link RestTemplate}. Not often used directly, but a useful
 * option to enhance testability, as it can easily be mocked or stubbed.
 *
 * @author Arjen Poutsma
 * @author Juergen Hoeller
 * @since 3.0
 * @see RestTemplate
 * @see AsyncRestOperations
 */
public interface RestOperations
```

指定一组基本 RESTful 操作的接口。由 `RestTemplate` 实现。不经常直接使用，但它是增强可测试性的有用选项，因为它很容易被模拟或存根

### RestTemplate

``` java
/**
 * <strong>Spring's central class for synchronous client-side HTTP access.</strong>
 * It simplifies communication with HTTP servers, and enforces RESTful principles.
 * It handles HTTP connections, leaving application code to provide URLs
 * (with possible template variables) and extract results.
 *
 * <p><strong>Note:</strong> by default the RestTemplate relies on standard JDK
 * facilities to establish HTTP connections. You can switch to use a different
 * HTTP library such as Apache HttpComponents, Netty, and OkHttp through the
 * {@link #setRequestFactory} property.
 *
 * <p>The main entry points of this template are the methods named after the six main HTTP methods:
 * <table>
 * <tr><th>HTTP method</th><th>RestTemplate methods</th></tr>
 * <tr><td>DELETE</td><td>{@link #delete}</td></tr>
 * <tr><td>GET</td><td>{@link #getForObject}</td></tr>
 * <tr><td></td><td>{@link #getForEntity}</td></tr>
 * <tr><td>HEAD</td><td>{@link #headForHeaders}</td></tr>
 * <tr><td>OPTIONS</td><td>{@link #optionsForAllow}</td></tr>
 * <tr><td>POST</td><td>{@link #postForLocation}</td></tr>
 * <tr><td></td><td>{@link #postForObject}</td></tr>
 * <tr><td>PUT</td><td>{@link #put}</td></tr>
 * <tr><td>any</td><td>{@link #exchange}</td></tr>
 * <tr><td></td><td>{@link #execute}</td></tr> </table>
 *
 * <p>In addition the {@code exchange} and {@code execute} methods are generalized versions of
 * the above methods and can be used to support additional, less frequent combinations (e.g.
 * HTTP PATCH, HTTP PUT with response body, etc.). Note however that the underlying HTTP
 * library used must also support the desired combination.
 *
 * <p><strong>Note:</strong> For URI templates it is assumed encoding is necessary, e.g.
 * {@code restTemplate.getForObject("http://example.com/hotel list")} becomes
 * {@code "http://example.com/hotel%20list"}. This also means if the URI template
 * or URI variables are already encoded, double encoding will occur, e.g.
 * {@code http://example.com/hotel%20list} becomes
 * {@code http://example.com/hotel%2520list}). To avoid that use a {@code URI} method
 * variant to provide (or re-use) a previously encoded URI. To prepare such an URI
 * with full control over encoding, consider using
 * {@link org.springframework.web.util.UriComponentsBuilder}.
 *
 * <p>Internally the template uses {@link HttpMessageConverter} instances to
 * convert HTTP messages to and from POJOs. Converters for the main mime types
 * are registered by default but you can also register additional converters
 * via {@link #setMessageConverters}.
 *
 * <p>This template uses a
 * {@link org.springframework.http.client.SimpleClientHttpRequestFactory} and a
 * {@link DefaultResponseErrorHandler} as default strategies for creating HTTP
 * connections or handling HTTP errors, respectively. These defaults can be overridden
 * through {@link #setRequestFactory} and {@link #setErrorHandler} respectively.
 *
 * @author Arjen Poutsma
 * @author Brian Clozel
 * @author Roy Clarkson
 * @author Juergen Hoeller
 * @since 3.0
 * @see HttpMessageConverter
 * @see RequestCallback
 * @see ResponseExtractor
 * @see ResponseErrorHandler
 * @see AsyncRestTemplate
 */
public class RestTemplate extends InterceptingHttpAccessor implements RestOperations
```

**Spring 用于同步客户端 HTTP 访问的核心类**。它简化了与 HTTP 服务器的通信，并强制执行 RESTful 原则。它处理 HTTP 连接，让应用程序代码提供 URL（带有可能的模板变量）并提取结果。
注意：默认情况下，`RestTemplate` 依赖于标准 JDK 工具来建立 HTTP 连接。您可以通过 `setRequestFactory` 属性切换到使用不同的 HTTP 库，例如 Apache HttpComponents、Netty 和 OkHttp。
该模板的主要入口点是以六个主要 HTTP 方法命名的方法：

HTTP方法         RestTemplate 方法
DELETE                   delete
GET                   		getForObject		getForEntity
HEAD                      headForHeaders
OPTIONS                  optionsForAllow
POST                 postForLocation 	postForObject
PUT                      put
any                 exchange  			execute

此外， `exchange` 和 `execute` 方法是上述方法的通用版本，可用于支持其他不太常见的组合（例如 HTTP PATCH、HTTP PUT 与响应正文等）。但是请注意，使用的底层 HTTP 库也必须支持所需的组合
