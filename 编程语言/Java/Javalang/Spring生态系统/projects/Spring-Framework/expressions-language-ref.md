### 语言参考

本节介绍 Spring 表达式语言的工作原理。它涵盖以下主题：

- [字面量表达式](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-ref-literal)
- [属性、数组、列表、映射和索引器](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-properties-arrays)
- [内联列表](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-inline-lists)
- [内联地图](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-inline-maps)
- [数组构造](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-array-construction)
- [方法](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-methods)
- [运营商](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-operators)
- [类型](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-types)
- [构造函数](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-constructors)
- [变量](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-ref-variables)
- [功能](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-ref-functions)
- [Bean 引用](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-bean-references)
- [三元运算符（If-Then-Else）](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-operator-ternary)
- [猫王接线员](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-operator-elvis)
- [安全导航操作员](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-operator-safe-navigation)

#### 字面量表达式

字面量表达式支持的类型是字符串、数值（int、real、hex）、`boolean` 和 `null`。字符串由单引号分隔。要将单引号本身放在字符串中，请使用两个单引号字符。

以下清单显示了字面量的简单用法。通常，它们不会像这样单独使用，而是作为更复杂表达式的一部分使用——例如，在逻辑比较运算符的一侧使用字面量。

``` java
ExpressionParser parser = new SpelExpressionParser();

// evals to "Hello World"
String helloWorld = (String) parser.parseExpression("'Hello World'").getValue();

double avogadrosNumber = (Double) parser.parseExpression("6.0221415E+23").getValue();

// evals to 2147483647
int maxValue = (Integer) parser.parseExpression("0x7FFFFFFF").getValue();

boolean trueValue = (Boolean) parser.parseExpression("true").getValue();

Object nullValue = parser.parseExpression("null").getValue();
```

数字支持使用负号、指数表示法和小数点。默认情况下，实数使用 `Double.parseDouble()`。

#### 属性、数组、列表、映射和索引器

使用属性引用导航很容易。为此，请**使用句点来指示嵌套属性值**。`Inventor` 类的实例 `pupin` 和 `tesla` 使用示例部分中使用的类中列出的数据进行填充。 为了在对象图中 “向下” 导航并获取 `Tesla` 的出生年份和 `Pupin` 的出生城市，我们使用以下表达式：

``` java
// evals to 1856
int year = (Integer) parser.parseExpression("birthdate.year + 1900").getValue(context);

String city = (String) parser.parseExpression("placeOfBirth.city").getValue(context);
```

