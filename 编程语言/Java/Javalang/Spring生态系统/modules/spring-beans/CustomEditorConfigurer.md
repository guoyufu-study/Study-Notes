# `CustomEditorConfigurer`

> `org.springframework.beans.factory.config.CustomEditorConfigurer`

## 概述

允许方便地注册自定义 `PropertyEditor`s 的 `BeanFactoryPostProcessor` 实现。
如果您想注册 `PropertyEditor`实例，从 Spring 2.0 开始推荐的用法是使用自定义 `PropertyEditorRegistrar` 实现，然后在给定的 `registry` 上注册任何所需的编辑器实例。每个 `PropertyEditorRegistrar` 可以注册任意数量的自定义编辑器。

``` xml
<bean id="customEditorConfigurer" class="org.springframework.beans.factory.config.CustomEditorConfigurer">
    <property name="propertyEditorRegistrars">
        <list>
            <bean class="mypackage.MyCustomDateEditorRegistrar"/>
            <bean class="mypackage.MyObjectEditorRegistrar"/>
        </list>
    </property>
</bean>
```

通过 `customEditors` 属性注册 `PropertyEditor` 类是非常好的。 Spring 将为每次编辑尝试创建它们的新实例，然后：

``` xml
<bean id="customEditorConfigurer" class="org.springframework.beans.factory.config.CustomEditorConfigurer">
    <property name="customEditors">
        <map>
            <entry key="java.util.Date" value="mypackage.MyCustomDateEditor"/>
            <entry key="mypackage.MyObject" value="mypackage.MyObjectEditor"/>
        </map>
    </property>
</bean>
```

请注意，您不应通过 `customEditors` 属性注册 `PropertyEditor` bean 实例，因为 `PropertyEditors` 是有状态的，并且每次编辑尝试都必须同步实例。如果您需要控制 `PropertyEditors` 的实例化过程，请使用 `PropertyEditorRegistrar` 来注册它们。
还支持 `java.lang.String[]` 风格的数组类名和原始类名（例如 `boolean`）。委托给 `ClassUtils` 以进行实际的类名解析。
注意：使用此配置器注册的自定义属性编辑器不适用于数据绑定。数据绑定的自定义编辑器需要在 `org.springframework.validation.DataBinder` 上注册：使用通用基类或委托给通用 `PropertyEditorRegistrar` 实现以重用编辑器注册。

### 类图

<img src="images\CustomEditorConfigurer-类图.png" alt="CustomEditorConfigurer-类图" style="zoom:50%;" />

### 类结构

![CustomEditorConfigurer-结构](images\CustomEditorConfigurer-结构.png)

### 后处理

![CustomEditorConfigurer-postProcessBeanFactory](images\CustomEditorConfigurer-postProcessBeanFactory.png)

在 `postProcessBeanFactory` 方法中，将 `propertyEditorRegistrars` 和 ` customEditors` 中的元素，设置到 `AbstractBeanFactory` 中。

![beans.factory.support.AbstractBeanFactory-editors](images\beans.factory.support.AbstractBeanFactory-editors.png)

#### 注册自定义编辑器

使用已在此 `BeanFactory` 中注册的自定义编辑器初始化给定的 `PropertyEditorRegistry`。
为将创建和填充 bean 实例的 `BeanWrappers` 以及用于构造函数参数和工厂方法类型转换的 `SimpleTypeConverter` 调用。

![beans.factory.support.AbstractBeanFactory-registerCustomEditors](images\beans.factory.support.AbstractBeanFactory-registerCustomEditors.png)