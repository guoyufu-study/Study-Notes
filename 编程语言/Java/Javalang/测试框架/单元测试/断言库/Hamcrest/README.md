# Java Hamcrest

> http://hamcrest.org/JavaHamcrest/
>
> 中文参考（已过时）[Hamcrest使用](http://www.manongjc.com/detail/6-xuhbaxbkorkosck.html)、[JUnit4---Hamcrest匹配器常用方法总结](https://blog.csdn.net/neven7/article/details/42489723)

Hamcrest 诞生于 Java，现在有多种语言的实现。

## 最新版本

``` xml
<dependency>
    <groupId>org.hamcrest</groupId>
    <artifactId>hamcrest</artifactId>
    <version>2.2</version>
    <scope>test</scope>
</dependency>
```



## 简介

**Hamcrest 是一个用于编写matcher对象的框架，允许以声明的方式定义“匹配”规则。**在许多情况下，匹配器非常有用，比如UI验证或数据过滤，但是在编写灵活测试的领域中，匹配器最常用。 本教程向你展示**如何使用 Hamcrest 进行单元测试**。

在编写测试时，有时很难**在过度指定测试和未足够指定测试之间取得平衡**。过度指定测试，会使其易受更改影响。未足够指定测试，会使测试的价值降低，因为即使在被测试的东西被破坏时，它仍然可以通过测试。如果有一个工具，可以让我们以受控的精确度精确地选择要测试的方面并描述其应具有的值，对于编写“恰到好处”的测试会有很大帮助。当被测方面的行为偏离预期的行为时，此类测试将失败，但是当对行为进行较小的，无关的更改时，此类测试将继续通过。

## 第一个Hamcrest测试

我们将从编写一个非常简单的JUnit 5测试开始，但是我们不使用JUnit的`assertEquals`方法，而是使用 Hamcrest 的`assertThat`构造和标准的匹配器集，这两者都是静态导入的：

``` java
import org.junit.jupiter.api.Test;
import static org.hamcrest.MatcherAssert.assertThat; 
import static org.hamcrest.Matchers.*;

public class BiscuitTest {
  @Test 
  public void testEquals() { 
    Biscuit theBiscuit = new Biscuit("Ginger"); 
    Biscuit myBiscuit = new Biscuit("Ginger"); 
    assertThat(theBiscuit, equalTo(myBiscuit)); 
  } 
} 
```

`assertThat`方法是用于进行测试断言的程式化语句。在本例中，断言的主题是对象`theBiscuit`，它是第一个方法参数。 第二个方法参数是`Biscuit`对象的匹配器，这里是使用`Object` `equals`方法检查一个对象与另一个对象是否相等的匹配器。 由于`Biscuit`类定义了`equals`方法，因此测试通过。

如果我们的测试中有多个断言，可以在断言中包含被测试值的标识符:

``` java
assertThat("chocolate chips", theBiscuit.getChocolateChipCount(), equalTo(10)); 

assertThat("hazelnuts", theBiscuit.getHazelnutCount(), equalTo(3))
```

## 其它测试框架

从一开始，Hamcrest就被设计成**能够与不同的单元测试框架集成**。 比如，Hamcrest可以与JUnit（所有版本）和TestNG一起使用。（有关详细信息，请查看完整的Hamcrest分发版附带的示例。）由于其他断言风格可以与Hamcrest的断言风格共存，因此在现有测试套件中迁移到使用Hamcrest风格的断言非常容易。

Hamcrest也可以**与模拟对象框架一起使用**，方法是使用适配器从模拟对象框架的匹配器概念过渡到Hamcrest匹配器。例如，JMock 1的约束是Hamcrest的匹配器。Hamcrest提供了一个JMock 1适配器，允许您在JMock 1测试中使用Hamcrest匹配器。JMock 2不需要这样的适配器层，因为它被设计为使用Hamcrest作为匹配库。Hamcrest还为EasyMock 2提供了适配器。再次，请参见Hamcrest示例了解更多细节。

## 匹配器

### 普通匹配器

Hamcrest附带一个有用的matchers库。这里是最重要的一些。

#### Core 核心

`anything` - 始终匹配，如果你不在乎被测对象是什么，则很有用

`describedAs` - 装饰器，用于添加自定义故障描述

`is` - 装饰器，用以提高可读性-参见下面的“Sugar”

#### Logical 逻辑

`allOf` - 只有所有的匹配器都匹配，才会匹配。短路(像Java `&&`)

`anyOf` - 只要有任何匹配器匹配，就会匹配。短路(像Java `||`)

`not` - 只有包装的匹配器不匹配，才会匹配，反之亦然

#### Object 对象

`equalTo` - 使用 `Object.equals` 测试对象是否相等

`hasToString` - 测试 `Object.toString`

`instanceOf`, `isCompatibleType` - 测试类型

`notNullValue`, `nullValue` - 测试空

`sameInstance` - 测试对象的标识

#### Beans

`hasProperty` - 测试JavaBeans属性

#### Collections 集合

`array` - 根据匹配器数组测试数组的元素

`hasEntry`, `hasKey`, `hasValue` - 测试map是否包含条目，键或值

`hasItem`, `hasItems` - 测试一个集合是否包含元素

`hasItemInArray` - 测试一个数组是否包含一个元素

#### Number 数字

`closeTo` - 测试浮点值是否接近给定值

`greaterThan`, `greaterThanOrEqualTo`, `lessThan`, `lessThanOrEqualTo` - 测试排序

#### Text

`equalToIgnoringCase` - 测试字符串相等性忽略大小写

`equalToIgnoringWhiteSpace` - 测试字符串是否相等，忽略空格中运行的差异

`containsString`, `endsWith`, `startsWith` - 测试字符串匹配

#### Sugar 语法糖

Hamcrest努力使我们的测试尽可能具有可读性。例如，`is` matcher是一个包装器，它不向底层matcher添加任何额外的行为。下列断言都是等价的:

``` java
assertThat(theBiscuit, equalTo(myBiscuit)); 
assertThat(theBiscuit, is(equalTo(myBiscuit))); 
assertThat(theBiscuit, is(myBiscuit));
```

允许使用最后一种形式，因为`is(T value)`被重载以返回`is(equalTo(value))`。

### 编写自定义匹配器

Hamcrest捆绑了许多有用的匹配器，但你可能会发现你需要不时创建自己的匹配器以适应测试需求。 当你发现一段代码反复测试同一组属性（在不同的测试中），并且你希望将这段代码段捆绑到一个断言中时，通常会发生这种情况。 通过编写自己的匹配器，你将消除代码重复，并使你的测试更具可读性！

让我们编写自己的匹配器，来测试一个double值是否具有`NaN`值（不是数字）。 这是我们要编写的测试：

``` java
@Test
public void testSquareRootOfMinusOneIsNotANumber() { 
  assertThat(Math.sqrt(-1), is(notANumber())); 
}
```

这是实现：

``` java
package org.hamcrest.examples.tutorial;

import org.hamcrest.Description; 
import org.hamcrest.Matcher; 
import org.hamcrest.TypeSafeMatcher;

public class IsNotANumber extends TypeSafeMatcher {

  @Override 
  public boolean matchesSafely(Double number) { 
    return number.isNaN(); 
  }

  public void describeTo(Description description) { 
    description.appendText("not a number"); 
  }

  public static Matcher notANumber() { 
    return new IsNotANumber(); 
  }

} 
```

`assertThat`方法是一个泛型方法，它采用断言主题的类型参数化的`Matcher`。我们正在声明有关`Double`值的信息，因此我们知道我们需要`Matcher<Double>`。 对于我们的`Matcher`实现，最方便的是将`TypeSafeMatcher`子类化，它可以为我们进行`Double`转换。 我们只需要实现`matchesSafely`方法和`describeTo`方法即可。`matchesSafely`方法仅检查`Double`是否为`NaN`。`describeTo`方法用于在测试失败时生成失败消息。以下是失败消息的外观示例：

``` java
assertThat(1.0, is(notANumber()));

// fails with the message

java.lang.AssertionError: Expected: is not a number got : <1.0>
```

我们的匹配器中的第三个方法是一个便捷的工厂方法。 要在测试中使用匹配器，需要静态导入此方法：

``` java
import org.junit.jupiter.api.Test;
import static org.hamcrest.MatcherAssert.assertThat; 
import static org.hamcrest.Matchers.*;
import static org.hamcrest.examples.tutorial.IsNotANumber.notANumber;

public class NumberTest {
  @Test
  public void testSquareRootOfMinusOneIsNotANumber() { 
    assertThat(Math.sqrt(-1), is(notANumber())); 
  } 
} 
```

即使`notANumber`方法每次被调用都创建一个新的匹配器，你也不应假定这是匹配器的唯一用法。 因此，你应该**确保你的匹配器是无状态的，以便可以在匹配之间重用单个实例**。

## 补充

如果你定义了很多自定义的匹配器，这会导致我们必须分别的单独导入它们，这让人很烦恼。最好是把它们组织到一个类中，这样它们就可以像导入Hamcrest 匹配器库一样，静态导入这一个类就可以了。Hamcrest提供了一种方式来完成这种情况，那就是使用一个generator。

首先，创建一个XML的配置文件来罗列出我们所有的匹配器类应该寻找的工厂方法（），如下面的例子：（官网上是空的）

第二步运行，在控制台运行org.hamcrest.generator.config.XmlConfigurator。这个工具将根据XML配置文件生成一个Java类,其包含了所有的XML文件中指定的工厂方法。不带参数的运行它，将会显示一个使用信息，这里有一个输出的例子：

``` java
// Generated source. package org.hamcrest.examples.tutorial;
public class Matchers{
    public static org.hamcrest.Matcher is(T param1){
        return org.hamcrest.core.Is.is(param1);
    }
    public static org.hamcrest.Matcher is(java.lang.Class param1)    {
        return org.hamcrest.core.Is.is(param1);
    }
    public static org.hamcrest.Matcher is(org.hamcrest.Matcher param1)    {
        return org.hamcrest.core.Is.is(param1);
    }
    public static org.hamcrest.Matcher notANumber(){
        return org.hamcrest.examples.tutorial.IsNotANumber.notANumber();
    }
}
```

最后，我们可以更新我们的测试用例，来使用新定义的匹配器类了。

``` java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.examples.tutorial.Matchers.*;
import junit.framework.TestCase;
public class CustomSugarNumberTest extends TestCase{
    public void testSquareRootOfMinusOneIsNotANumber(){
        assertThat(Math.sqrt(-1), is(notANumber()));
    }
} 
```

请注意我们现在使用Hamcrest库是我们自定义的匹配器类进口匹配器。

## 相关项目

下面是一些提供附加特性和匹配器的项目

- [Awaitility](https://github.com/jayway/awaitility) 一种DSL，允许你以简洁易读的方式表达对异步系统的期望
- [EZ Testing](https://github.com/EZGames/ez-testing) 包含用于定义与AssertJ风格相似的链式匹配器的基类
- [Hamcrest 1.3 Utility Matchers](https://github.com/NitorCreations/matchers) Java 匹配器，比如`CollectionMatchers`, `MapMatchers`, `FieldMatcher`, `SerializableMatcher` 等等
- [Hamcrest avro](https://github.com/Byhiras/avro-utils)
- [Hamcrest Composites](https://github.com/Cornutum/hamcrest-composites) 用于比较具有更好可测试性的复杂Java对象
- [Hamcrest Date](https://github.com/modularit/hamcrest-date) 用于比较日期
- [Hamcrest HAR](https://github.com/roydekleijn/har-assert) 用于HTTP存档文件
- [Hamcrest Java Extras](https://github.com/sf105/hamcrest-java-extras) 目前只有几个Json匹配器
- [Hamcrest JSON](https://github.com/hertzsprung/hamcrest-json) 用于比较整个JSON文档
- [Hamcrest Path](https://github.com/seinesoftware/hamcrest-path) 用于测试路径存在和权限
- [Hamcrest Querydsl](https://github.com/beloglazov/hamcrest-querydsl) 用于检查查询结果：`hasResultSize`, `hasColumnRange`, `hasColumnMax`, `hasColumnMin`, `hasColumnContainingAll`, `hasColumnContainingAny`
- [Hamcrest Text Patterns](http://code.google.com/p/hamcrest-text-patterns/)
- [hamcrest-pojo-matcher-generator](https://github.com/yandex-qatools/hamcrest-pojo-matcher-generator) 用于根据你的POJOs生成功能匹配器的注解处理器
- [http-matchers](https://github.com/valid4j/http-matchers) 用于通过RESTful服务的标准Java API（JAX-RS）测试Web服务的匹配器
- [json-path-matchers](https://github.com/jayway/JsonPath/tree/master/json-path-assert) 用于评估JSON路径表达式
- [JsonUnit](https://github.com/lukas-krecan/JsonUnit) 用于比较JSON结构 `jsonEquals`, `jsonPartEquals`
- [Proboscis](https://github.com/sf105/proboscis) 用于轮询结果的微型Java库，最初用于经过测试的异步系统
- [Shazamcrest](https://github.com/shazam/shazamcrest) 具有自定义字段匹配和错误消息的bean的匹配器
- [Spotify’s hamcrest matchers](https://github.com/spotify/java-hamcrest) POJO，JSON和Java 8中引入的某些类型的匹配器
- [valid4j](https://github.com/valid4j/valid4j) 断言和验证库，即支持design-by-contract按合同设计样式和/或可恢复的输入验证
