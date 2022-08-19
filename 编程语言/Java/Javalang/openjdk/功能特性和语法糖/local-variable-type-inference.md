# 局部变量类型推断

> JDK 10、JDK11

## JEPs

* [JEP 286: Local-Variable Type Inference](https://openjdk.java.net/jeps/286)
* [JEP 323: Local-Variable Syntax for Lambda Parameters](https://openjdk.java.net/jeps/323)

## 官方文档

> https://docs.oracle.com/en/java/javase/18/language/local-variable-type-inference.html

在 JDK 10 及更高版本中，我们可以**使用带有 `var` 标识符的非空初始化器来声明局部变量**，这可以帮助我们编写更易于阅读的代码。

考虑以下示例，这似乎是多余的并且难以阅读：

``` java
URL url = new URL("http://www.oracle.com/"); 
URLConnection conn = url.openConnection(); 
Reader reader = new BufferedReader(
    new InputStreamReader(conn.getInputStream()));
```

我们可以通过使用 `var` 标识符声明局部变量来重写此示例。变量的类型是从上下文中推断出来的：

``` java
var url = new URL("http://www.oracle.com/"); 
var conn = url.openConnection(); 
var reader = new BufferedReader(
    new InputStreamReader(conn.getInputStream()));
```

**`var` 是保留的类型名称，而不是关键字**，这意味着 `var` 用作变量、方法名或包名的现有代码不受影响。但是，`var`用作类名或接口名的代码会受到影响，需要重命名类或接口。

`var` 可用于以下类型的变量：

- 带有初始化器的局部变量声明：

  ``` java
  var list = new ArrayList<String>();    // 推断 ArrayList<String>
  var stream = list.stream();            // 推断 Stream<String>
  var path = Paths.get(fileName);        // 推断 Path
  var bytes = Files.readAllBytes(path);  // 推断 bytes[]
  ```

- 增强`for`的循环索引：

  ``` java
  List<String> myList = Arrays.asList("a", "b", "c");
  for (var element : myList) {...}  // 推断 String
  ```

- 在传统 `for` 循环中声明的索引变量：

  ``` java
  for (var counter = 0; counter < 10; counter++)  {...}   // 推断 int
  ```

- `try`-with-resources 变量：

  ``` java
  try (var input = 
       new FileInputStream("validation.txt")) {...}   // 推断 FileInputStream
  ```

- 隐式类型 lambda 表达式的形参声明：其形参具有推断类型的 lambda 表达式是*隐式类型*的：

  ``` java
  BiFunction<Integer, Integer, Integer> = (a, b) -> a + b;
  ```

  在 JDK 11 及更高版本中，您可以使用 `var` 标识符声明隐式类型 lambda 表达式的每个形参：

  ``` java
  (var a, var b) -> a + b;
  ```

  因此，隐式类型 lambda 表达式中形参声明的语法与局部变量声明的语法一致；将 `var` 标识符应用于隐式类型 lambda 表达式中的每个形参与根本不使用 `var` 具有相同的效果。

  您不能在隐式类型的 lambda 表达式中混合使用推断形参和 `var` 声明的形参，也不能在显式类型的 lambda 表达式中混合使用 `var` 声明的形参和清单类型。不允许使用以下示例：

  ``` java
  (var x, y) -> x.process(y)      // Cannot mix var and inferred formal parameters
                                  // in implicitly typed lambda expressions
  (var x, int y) -> x.process(y)  // Cannot mix var and manifest types
  // in explicitly typed lambda expressions
  ```



## 风格指南

> https://openjdk.org/projects/amber/guides/lvti-style-guide

局部变量声明可以**通过消除冗余信息使代码更具可读性**。但是，它也会**通过省略有用的信息来降低代码的可读性**。因此，请谨慎使用此功能；**没有关于何时应该使用和不应该使用它的严格规则**。

### 介绍

Java SE 10 [为局部变量引入了类型推断](https://openjdk.java.net/jeps/286)。以前，所有局部变量声明都需要**在左侧有一个显式（清单）类型**。使用类型推断，对于具有初始化器的局部变量声明，显式类型可以用保留类型名 `var` 替换。变量的类型是从初始化器的类型推断出来的。

这个功能存在一定的争议。一些人欢迎它带来的简洁；其他人担心它会剥夺读者的重要类型信息，从而降低可读性。两组人都是对的。它可以通过消除冗余信息使代码更具可读性，也可以通过省略有用信息来降低代码可读性。另一组担心它会被过度使用，从而导致编写更多糟糕的 Java 代码。这也是正确的，但它也可能导致编写*更多优秀的* Java 代码。像所有功能一样，**使用它必须有判断力**。对于什么时候该用什么时候不该用，并没有统一的规则。

局部变量声明不是孤立存在的； 本文档的目的是检查周围代码对 `var` 声明的影响，解释一些权衡，并提供有效使用 `var` 的指导方针。

### [原则](https://openjdk.org/projects/amber/guides/lvti-style-guide#principles)

#### P1. 读代码比写代码更重要

读代码的频率远高于写代码的频率。此外，在写代码时，我们通常会在脑海中记住整个上下文，然后慢慢来写；在读代码时，我们经常会进行上下文切换，可能会比较匆忙。是否以及如何使用特定的语言特性应该取决于它们对程序*未来读者*的影响，而不应该取决于它们对程序原作者的影响。较短的程序可能比较长的程序更可取，但是过多地缩短程序会遗漏对理解程序有用的信息。这里的核心问题是为程序找到合适的大小，以便最大限度地提高可理解性。

这里我们特别不关心输入或编辑程序所需的键盘输入量。虽然简洁对作者来说可能是一个不错的好处，但专注于简洁会错过主要目标，即提高结果程序的可理解性。

#### P2. 代码应该从局部推理中清晰可见

读者应该能够查看`var`声明以及声明变量的用法，并应该能够几乎立即了解发生了什么。理想情况下，代码应该仅使用片段或补丁中的上下文即可理解。如果理解一个 `var` 声明需要读者查看代码周围的几个位置，那么使用 `var` 可能不是一个好的情况。同样，这可能表明代码本身存在问题。

#### P3. 代码可读性不应该依赖于 IDE

代码经常在 IDE 中编写和阅读，因此很容易严重依赖 IDE 的代码分析功能。对于类型声明，因为总是可以指向一个变量来确定它的类型，为什么不到处使用 `var`？

有两个原因。首先是**经常会在 IDE 之外阅读**代码。代码会出现在许多 IDE 工具不可用的地方，例如文档中的代码片段、在互联网上浏览存储库或补丁文件。仅仅为了理解代码的作用，就必须将代码导入 IDE，这是适得其反的。

第二个原因是，即使在 IDE 中阅读代码，通常也需要显式操作来查询 IDE 中有关变量的更多信息。例如，要查询使用  `var` 声明的变量的类型，可能必须将指针悬停在变量上并等待弹出窗口。这可能只需要花一点时间，但它**扰乱了阅读的流程**。

代码应该是自我揭示的。它表面上应该是可以理解的，不需要工具的帮助。

#### P4.显式类型是一种折衷

Java 历来要求局部变量声明显式地包含类型。虽然显式类型非常有用，但它们有时并不是很重要，有时只是碍事。要求显式类型**可能会使有用的信息变得杂乱**。

**省略显式类型可以减少混乱，但前提是省略不影响可理解性**。类型并不是向读者传达信息的唯一方式。其他方式包括变量名和初始化表达式。在确定是否可以将其中一个通道静音时，我们应该考虑所有可用的通道。

### 指导方针

#### G1. 选择提供有用信息的变量名

一般来说，选择提供有用信息的变量名是一种很好的做法，但在 `var` 的上下文中它更重要。在`var`声明中，可以使用变量名来传达有关变量含义和用途的信息。用  `var` 替换显式类型通常应该伴随着改进变量名。例如：

```java
// ORIGINAL
List<Customer> x = dbconn.executeQuery(query);

// GOOD
var custList = dbconn.executeQuery(query);
```

在这种情况下，一个无用的变量名已被替换为一个能唤起变量类型的名称，这个名称现在隐含在`var`声明中。

将变量的类型编码到其名称中，根据其逻辑结论得出“[匈牙利表示法](https://en.wikipedia.org/wiki/Hungarian_notation)”。就像显式类型一样，这有时很有帮助，有时只是混乱。在本例中，名称 `custList` 暗示正在返回一个 `List`。这可能并不重要。有时用变量名来表达变量的角色或性质比使用确切的类型更好，例如 `customers`：

```java
// ORIGINAL
try (Stream<Customer> result = dbconn.executeQuery(query)) {
    return result.map(...)
                 .filter(...)
                 .findAny();
}

// GOOD
try (var customers = dbconn.executeQuery(query)) {
    return customers.map(...)
                    .filter(...)
                    .findAny();
}
```

#### G2. 最小化局部变量的作用域

限制局部变量的作用域通常是一种很好的做法。这种做法在 [*Effective Java (3rd Edition)*](https://www.pearson.com/us/higher-education/program/Bloch-Effective-Java-3rd-Edition/PGM1763855.html) 的第 57 项中进行了描述。如果正在使用 `var`，它会以额外的力量应用。

在下面的示例中，`add` 方法清楚地将特殊项添加为最后一个列表元素，因此按预期将其最后处理。

```java
var items = new ArrayList<Item>(...);
items.add(MUST_BE_PROCESSED_LAST);
for (var item : items) ...
```

现在假设为了删除重复项，程序员将修改此代码以使用一个 `HashSet` 而不是一个 `ArrayList`：

```java
var items = new HashSet<Item>(...);
items.add(MUST_BE_PROCESSED_LAST);
for (var item : items) ...
```

此代码现在有一个错误，因为集合没有定义的迭代顺序。但是，程序员可能会立即修复此错误，因为`items`变量的使用与其声明相邻。

现在假设这段代码是一个大方法的一部分，`items` 变量的作用域也相应很大：

```java
var items = new HashSet<Item>(...);

// ... 100 lines of code ...

items.add(MUST_BE_PROCESSED_LAST);
for (var item : items) ...
```

从 `ArrayList` 更改为 `HashSet` 的影响不再明显，因为 `items` 的使用距离其声明太远了。看起来这个 bug 可能会存活更长时间。

如果 `items` 已显式声明为 `List<String>`，则更改初始化程序还需要将类型更改为 `Set<String>`。这可能会提示程序员检查该方法的其余部分是否有可能受此类更改影响的代码。（再说一遍，它可能不会。）使用 `var` 将删除此提示，可能会增加在此类代码中引入错误的风险。

这似乎是反对使用 `var` 的论据，但实际上并非如此。使用 `var` 的初始示例非常好。仅当变量的作用域很大时才会出现此问题。在这些情况下，，不应该简单地避免 `var`，而是应该更改代码以减少局部变量的作用域，然后才使用 `var` 声明它们。

#### G3. 当初始化器向读者提供足够的信息时，考虑 `var`



#### G4. 使用 `var` 来分解带有局部变量的链式或嵌套表达式



#### G5. 不要太担心使用局部变量的 “面向接口编程”。



#### G6.  结合菱形或通用方法使用 `var` 时要小心



#### G7. `var`与字面量一起使用时要小心



### 示例



### 结论