# 手写 spring-beans 过程

## 准备工作

使用 IDAE 新建项目。

引入 `org.springframework:spring-core:5.3.22` JAR 包。

在 `src/main/java` 目录下，创建 `cn.jasper.spring.beans` 包。

### 具体流程

创建 `package-info.java`

``` java
/**
 * 这个包包含用于操作 Java beans 的接口和类。大多数其他 Spring 包都使用它。
 * {@link BeanWrapper} 对象可用于单独或批量设置和获取 bean 属性。
 */
@NonNullApi
@NonNullFields
package cn.jasper.spring.beans;

import org.springframework.lang.NonNullApi;
import org.springframework.lang.NonNullFields;
```

#### 异常系统

异常系统：创建 `BeansException` 抽象超类，

beans 包和子包中抛出的所有异常都实现这个抽象类。请注意，这是一个运行时（未经检查的）异常。 Beans 异常通常是致命的；没有理由对它们进行检查。

``` java
package cn.jasper.spring.beans;

public abstract class BeansException extends NestedRuntimeException {

    public BeansException(String msg) {
        super(msg);
    }

    public BeansException(String msg, Throwable cause) {
        super(msg, cause);
    }
}
```

#### beans

`org.springframework.beans.factory.DisposableBean`

`org.springframework.beans.factory.InitializingBean`



***

bean 定义

`org.springframework.beans.BeanMetadataElement`

`org.springframework.beans.BeanMetadataAttributeAccessor`



`org.springframework.beans.Mergeable`

`org.springframework.beans.factory.config.ConstructorArgumentValues`



`org.springframework.beans.factory.config.BeanDefinition`

`org.springframework.beans.factory.support.AbstractBeanDefinition`



`org.springframework.beans.factory.support.ChildBeanDefinition`



***

属性值

`org.springframework.beans.BeanMetadataElement`

`org.springframework.beans.BeanMetadataAttributeAccessor`

`org.springframework.beans.PropertyValue`

`org.springframework.beans.PropertyValues`

`org.springframework.beans.MutablePropertyValues`

***