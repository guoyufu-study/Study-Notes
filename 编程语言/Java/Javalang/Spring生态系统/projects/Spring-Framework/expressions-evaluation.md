# 求值

> https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-evaluation

本节介绍 `SpEL` 接口及其表达语言的简单使用。完整的语言参考可以在 [语言参考](编程语言/Java/Javalang/Spring生态系统/projects/Spring-Framework/expressions-language-ref.md) 中找到。

## 入门

### 字符串字面量

以下代码介绍了用于计算字符串字面量表达式 `Hello World` 的 `SpEL`  API

``` java
ExpressionParser parser = new SpelExpressionParser();
Expression exp = parser.parseExpression("'Hello World'"); 
String message = (String) exp.getValue();
```

> `message` 变量的值是 `'Hello World'`。

您最可能使用的 `SpEL` 类和接口位于 `org.springframework.expression` 包及其子包中，例如 `spel.support`。

`ExpressionParser` 接口负责解析表达式字符串。在前面的示例中，表达式字符串是**用单引号括起来的字符串字面量**。`Expression` 接口负责计算先前定义的表达式字符串。当调用 `parser.parseExpression` 和 `exp.getValue` 时，可以分别抛出的两个异常，`ParseException` 和 `EvaluationException`。

`SpEL` 支持多种的功能，例如**调用方法**、**访问属性**和**调用构造函数**。

### 调用方法

在下面的方法调用示例中，我们在字符串字面量上调用 `concat` 方法：

``` java
ExpressionParser parser = new SpelExpressionParser();
Expression exp = parser.parseExpression("'Hello World'.concat('!')"); 
String message = (String) exp.getValue();
```

> 现在， `message` 变量的值是 `'Hello World!'`。

### 访问属性

以下**调用 `JavaBean` 属性**的示例调用了 `String` 属性 `Bytes`：

``` java
ExpressionParser parser = new SpelExpressionParser();

// invokes 'getBytes()'
Expression exp = parser.parseExpression("'Hello World'.bytes"); 
byte[] bytes = (byte[]) exp.getValue();
```

> 此行将字面量转换为字节数组。

`SpEL` 还通过使用标准点表示法（例如 `prop1.prop2.prop3`）以及相应的属性值设置来**支持嵌套属性**。访问**公共字段**也可以被访问。

以下示例显示了如何使用点表示法来获取一个字面量的长度：

``` java
ExpressionParser parser = new SpelExpressionParser();

// invokes 'getBytes().length'
Expression exp = parser.parseExpression("'Hello World'.bytes.length"); 
int length = (Integer) exp.getValue();
```

> `'Hello World'.bytes.length`给出一个字面量的长度。

### 调用构造函数

可以调用 `String` 的构造函数，而不是使用字符串字面量，如以下示例所示：

``` java
ExpressionParser parser = new SpelExpressionParser();
Expression exp = parser.parseExpression("new String('hello world').toUpperCase()"); 
String message = exp.getValue(String.class);
```

> 从字面量构造一个新 `String` 的并转换成大写。

注意泛型方法的使用：`public <T> T getValue(Class<T> desiredResultType)`。使用此方法无需将表达式的值转换为所需的结果类型。如果无法将值强制转换为 `T` 类型或无法使用注册的类型转换器进行转换，则会引发 `EvaluationException` 。

### 根对象

`SpEL` 更常见的用法是**提供针对特定对象实例（称为根对象）进行评估的表达式字符串**。以下示例显示如何从 `Inventor` 类的实例中检索 `name` 属性或创建布尔条件：

``` java
// Create and set a calendar
GregorianCalendar c = new GregorianCalendar();
c.set(1856, 7, 9);

// The constructor arguments are name, birthday, and nationality.
Inventor tesla = new Inventor("Nikola Tesla", c.getTime(), "Serbian");

ExpressionParser parser = new SpelExpressionParser();

Expression exp = parser.parseExpression("name"); // Parse name as an expression
String name = (String) exp.getValue(tesla);
// name == "Nikola Tesla"

exp = parser.parseExpression("name == 'Nikola Tesla'");
boolean result = exp.getValue(tesla, Boolean.class);
// result == true
```

## 了解 `EvaluationContext`

在求值表达式以解析属性、方法或字段并帮助执行类型转换时，使用 `EvaluationContext` 接口。Spring 提供了两种实现。

- `SimpleEvaluationContext`：公开了基本 `SpEL` 语言特性和配置选项的子集，用于不需要完整的 `SpEL` 语言语法且应受到有意义限制的表达式类别。示例包括但不限于数据绑定表达式和基于属性的过滤器。
- `StandardEvaluationContext`：公开了全套 `SpEL` 语言特性和配置选项。可以使用它来指定默认根对象，并配置每个可用的评估相关策略。

`SimpleEvaluationContext` 被设计为只支持 `SpEL` 语言语法的一个子集。它不包括 Java 类型引用、构造函数和 bean 引用。它还**要求您明确选择对表达式中的属性和方法的支持级别**。默认情况下，`create()`静态工厂方法只允许对属性进行读取访问。您还**可以获得构建器来配置所需的确切支持级别**，目标是以下一种或几种组合：

- 仅自定义 `PropertyAccessor`（无反射）
- 只读访问的数据绑定属性
- 用于读取和写入的数据绑定属性

### 类型转换

默认情况下，`SpEL` 使用 Spring 核心 ( `org.springframework.core.convert.ConversionService`) 中可用的转换服务。这个转换服务附带了许多**用于常见转换的内置转换器**，但它也是**完全可扩展**的，因此您可以添加类型之间的自定义转换。此外，它是**泛型感知**的。这意味着，当您在表达式中使用泛型类型时，`SpEL` 会尝试转换，以维护它遇到的任何对象的类型正确性。

这在实践中意味着什么？假设使用 `setValue()` 赋值来设置 `List` 属性。属性的类型实际上是`List<Boolean>`。`SpEL` 认识到，在将列表中的元素放入其中之前，需要将其转换为 `Boolean`。以下示例显示了如何执行此操作：

``` java
class Simple {
    public List<Boolean> booleanList = new ArrayList<Boolean>();
}

Simple simple = new Simple();
simple.booleanList.add(true);

EvaluationContext context = SimpleEvaluationContext.forReadOnlyDataBinding().build();

// "false" is passed in here as a String. SpEL and the conversion service
// will recognize that it needs to be a Boolean and convert it accordingly.
parser.parseExpression("booleanList[0]").setValue(context, simple, "false");

// b is false
Boolean b = simple.booleanList.get(0);
```

### 解析器配置

可以使用解析器配置对象 ( `org.springframework.expression.spel.SpelParserConfiguration`) 来**配置 `SpEL` 表达式解析器**。配置对象**控制一些表达式组件的行为**。例如，如果您对数组或集合进行索引，并且指定索引处的元素是 `null`，`SpEL` 可以自动创建元素。这在使用由属性引用链组成的表达式时很有用。如果您对数组或列表进行索引并指定超出数组或列表当前大小末尾的索引，`SpEL` 可以自动增长数组或列表以适应该索引。为了在指定索引处添加元素，`SpEL` 将在设置指定值之前尝试使用元素类型的默认构造函数创建元素。如果元素类型没有默认构造函数，`null` 将被添加到数组或列表中。如果没有知道如何设置值的内置或自定义转换器，则将 `null` 保留在数组或列表中指定索引处。以下示例演示了如何自动增长列表：

``` java
class Demo {
    public List<String> list;
}

// Turn on:
// - auto null reference initialization
// - auto collection growing
SpelParserConfiguration config = new SpelParserConfiguration(true, true);

ExpressionParser parser = new SpelExpressionParser(config);

Expression expression = parser.parseExpression("list[3]");

Demo demo = new Demo();

Object o = expression.getValue(demo);

// demo.list will now be a real collection of 4 entries
// Each entry is a new empty String
```

### SpEL 编译

Spring Framework 4.1 包含一个基本的表达式编译器。通常会解释表达式，这在评估期间提供了很大的动态灵活性，但不能提供最佳性能。对于偶尔的表达式使用，这很好，但是，当被其他组件（例如 Spring Integration）使用时，性能可能非常重要，并且不需要动态。

SpEL 编译器旨在满足这一需求。在评估期间，编译器生成一个体现表达式运行时行为的 Java 类，并使用该类来实现更快的表达式评估。由于没有围绕表达式键入，编译器在执行编译时使用在表达式的解释评估期间收集的信息。例如，它不能仅从表达式中知道属性引用的类型，但在第一次解释评估期间，它会找出它是什么。当然，如果各种表达式元素的类型随着时间的推移而变化，那么基于这些派生信息进行编译可能会在以后造成麻烦。出于这个原因，编译最适合那些类型信息不会在重复计算中改变的表达式。

考虑以下基本表达式：

``` java
someArray[0].someProperty.someOtherProperty < 0.1
```

因为前面的表达式涉及数组访问、一些属性取消引用和数值运算，所以性能提升可能非常明显。在 50000 次迭代的示例微基准测试中，使用解释器评估需要 75 毫秒，而使用表达式的编译版本只需要 3 毫秒。

#### 编译器配置

编译器默认不打开，但您可以通过两种不同的方式之一打开它。您可以通过使用解析器配置过程（[前面讨论过](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/core.html#expressions-parser-configuration)）或在 SpEL 使用嵌入到另一个组件中时使用 Spring 属性来打开它。本节讨论这两个选项。

编译器可以在 `org.springframework.expression.spel.SpelCompilerMode`枚举中捕获的三种模式之一中运行。模式如下：

- `OFF`（默认）：编译器关闭。
- `IMMEDIATE`: 在立即模式下，表达式会尽快编译。这通常是在第一次解释评估之后。如果编译表达式失败（通常是由于类型更改，如前所述），则表达式求值的调用者会收到异常。
- `MIXED`：在混合模式下，表达式会随着时间在解释模式和编译模式之间静默切换。在经过一定次数的解释运行后，它们会切换到编译形式，如果编译形式出现问题（例如类型更改，如前所述），表达式会自动再次切换回解释形式。一段时间后，它可能会生成另一个已编译的表单并切换到它。基本上，用户进入`IMMEDIATE`模式的异常是在内部处理的。

`IMMEDIATE`mode 存在是因为`MIXED`mode 可能会导致具有副作用的表达式出现问题。如果编译的表达式在部分成功后崩溃，它可能已经做了一些影响系统状态的事情。如果发生这种情况，调用者可能不希望它在解释模式下静默重新运行，因为部分表达式可能会运行两次。

选择模式后，使用`SpelParserConfiguration`配置解析器。以下示例显示了如何执行此操作：

``` java
SpelParserConfiguration config = new SpelParserConfiguration(SpelCompilerMode.IMMEDIATE,
        this.getClass().getClassLoader());

SpelExpressionParser parser = new SpelExpressionParser(config);

Expression expr = parser.parseExpression("payload");

MyMessage message = new MyMessage();

Object payload = expr.getValue(message);
```

当你指定编译模式时，你也可以指定一个类加载器（允许传递null）。已编译的表达式在任何提供的子类加载器下创建的子类加载器中定义。重要的是要确保，如果指定了类加载器，它可以看到表达式评估过程中涉及的所有类型。如果您不指定类加载器，则使用默认类加载器（通常是在表达式评估期间运行的线程的上下文类加载器）。

配置编译器的第二种方法是在 SpEL 嵌入到某个其他组件中时使用，并且可能无法通过配置对象对其进行配置。在这些情况下，可以`spring.expression.compiler.mode` 通过 JVM 系统属性（或通过 [`SpringProperties`](https://docs.spring.io/spring-framework/docs/6.0.0-M5/reference/html/appendix.html#appendix-spring-properties)机制）将属性设置为 `SpelCompilerMode`枚举值之一（`off`、`immediate`或`mixed`）。



#### 编译器限制

从 Spring Framework 4.1 开始，基本的编译框架就到位了。但是，该框架还不支持编译所有类型的表达式。最初的重点是可能在性能关键的上下文中使用的常用表达式。目前无法编译以下类型的表达式：

- 涉及赋值的表达式
- 依赖于转换服务的表达式
- 使用自定义解析器或访问器的表达式
- 使用选择或投影的表达式

将来会编译更多类型的表达式。


