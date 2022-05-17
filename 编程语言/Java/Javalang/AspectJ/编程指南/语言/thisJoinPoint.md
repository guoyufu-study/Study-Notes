## `thisJoinPoint`

AspectJ 提供了一个特殊的引用变量 `thisJoinPoint`，它**包含有关当前连接点的反射信息**，以供通知使用。`thisJoinPoint` 变量只能在通知上下文中使用，就像 `this` 只能在非静态方法和变量初始化器的上下文中使用一样。在通知中，`thisJoinPoint` 是 [`org.aspectj.lang.JoinPoint`](https://www.eclipse.org/aspectj/doc/released/api/org/aspectj/lang/JoinPoint.html) 类型的对象。

使用它的一种方法是简单地将它打印出来。与所有 Java 对象一样， `thisJoinPoint` 有一个`toString()` 方法，可以轻松进行快速跟踪：

```java
  aspect TraceNonStaticMethods {
      before(Point p): target(p) && call(* *(..)) {
          System.out.println("Entering " + thisJoinPoint + " in " + p);
      }
  }
```

`thisJoinPoint` 的类型包括签名的丰富的反射类层次结构，可用于访问有关连接点的静态和动态信息，例如连接点的**参数**：

```java
  thisJoinPoint.getArgs()
```

此外，它还包含一个对象，该对象由有关连接点的所有**静态信息**组成，例如相应的行号和静态签名：

```java
  thisJoinPoint.getStaticPart()
```

如果只需要连接点的静态信息，可以直接使用特殊变量 `thisJoinPointStaticPart` 访问连接点的静态部分。使用 `thisJoinPointStaticPart` 将避免在直接使用 `thisJoinPoint` 时可能需要的连接点对象的运行时创建 。

总是这样

```java
   thisJoinPointStaticPart == thisJoinPoint.getStaticPart()

   thisJoinPoint.getKind() == thisJoinPointStaticPart.getKind()
   thisJoinPoint.getSignature() == thisJoinPointStaticPart.getSignature()
   thisJoinPoint.getSourceLocation() == thisJoinPointStaticPart.getSourceLocation()
```

还有一个反射变量可用： `thisEnclosureJoinPointStaticPart`。这与 `thisJoinPointStaticPart` 一样，仅包含连接点的静态部分，但它不是当前连接点而是**封闭连接点**。因此，例如，可以打印出调用源位置（如果可用）

```java
   before() : execution (* *(..)) {
     System.err.println(thisEnclosingJoinPointStaticPart.getSourceLocation())
   }
```
