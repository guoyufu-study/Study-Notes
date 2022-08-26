

# Bean 定义中的表达式

您可以将 `SpEL` 表达式与基于 XML 或基于注解的配置元数据一起使用来定义 `BeanDefinition` 实例。在这两种情况下，**定义表达式的语法**都是 `#{ <expression string> }`。

## XML 配置

可以使用表达式设置属性或构造函数参数值，如以下示例所示：

``` xml
<bean id="numberGuess" class="org.spring.samples.NumberGuess">
    <property name="randomNumber" value="#{ T(java.lang.Math).random() * 100.0 }"/>

    <!-- other properties -->
</bean>
```

应用程序上下文中的所有 bean 都可以作为具有公共 bean 名称的**预定义变量**使用。这包括用于访问运行时环境的标准上下文 bean，例如 `environment` ( `org.springframework.core.env.Environment` 类型) 以及 `systemProperties` 和 `systemEnvironment`(`Map<String, Object>` 类型)。

以下示例显示了对 `systemProperties` 作为 `SpEL` 变量的 bean 的访问：

``` xml
<bean id="taxCalculator" class="org.spring.samples.TaxCalculator">
    <property name="defaultLocale" value="#{ systemProperties['user.region'] }"/>

    <!-- other properties -->
</bean>
```

请注意，您不必在此处使用 `#` 符号作为预定义变量的前缀。

您还可以按名称引用其他 bean 属性，如以下示例所示：

``` xml
<bean id="numberGuess" class="org.spring.samples.NumberGuess">
    <property name="randomNumber" value="#{ T(java.lang.Math).random() * 100.0 }"/>

    <!-- other properties -->
</bean>

<bean id="shapeGuess" class="org.spring.samples.ShapeGuess">
    <property name="initialShapeSeed" value="#{ numberGuess.randomNumber }"/>

    <!-- other properties -->
</bean>
```



## 注解配置

要指定默认值，您可以将 `@Value` 注解放在字段、方法以及方法参数或构造函数参数上。

以下示例设置字段的默认值：

``` java
public class FieldValueTestBean {

    @Value("#{ systemProperties['user.region'] }")
    private String defaultLocale;

    public void setDefaultLocale(String defaultLocale) {
        this.defaultLocale = defaultLocale;
    }

    public String getDefaultLocale() {
        return this.defaultLocale;
    }
}
```

以下示例显示了等效的但在属性设置器方法上：

``` java
public class PropertyValueTestBean {

    private String defaultLocale;

    @Value("#{ systemProperties['user.region'] }")
    public void setDefaultLocale(String defaultLocale) {
        this.defaultLocale = defaultLocale;
    }

    public String getDefaultLocale() {
        return this.defaultLocale;
    }
}
```

自动装配的方法也可以使用 `@Value` 注解，如以下示例所示：

``` java
public class SimpleMovieLister {

    private MovieFinder movieFinder;
    private String defaultLocale;

    @Autowired
    public void configure(MovieFinder movieFinder,
            @Value("#{ systemProperties['user.region'] }") String defaultLocale) {
        this.movieFinder = movieFinder;
        this.defaultLocale = defaultLocale;
    }

    // ...
}
```

自动装配构造函数也可以使用 `@Value` 注解，如以下示例所示：

``` java
public class MovieRecommender {

    private String defaultLocale;

    private CustomerPreferenceDao customerPreferenceDao;

    public MovieRecommender(CustomerPreferenceDao customerPreferenceDao,
            @Value("#{systemProperties['user.country']}") String defaultLocale) {
        this.customerPreferenceDao = customerPreferenceDao;
        this.defaultLocale = defaultLocale;
    }

    // ...
}
```



