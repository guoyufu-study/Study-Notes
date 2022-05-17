## AspectJ 简介 :id=starting-aspectj

本节简要介绍本章稍后将使用的 AspectJ 的特性。这些特性是语言的核心，但这绝不是 AspectJ 的完整概述。

使用简单的图形编辑器系统呈现这些功能。一个图形 `Figure` 由许多图形元素 `FigureElement`s 组成，它们可以是点 `Point`s 或线 `Line`s。图形 `Figure`类提供工厂服务。还有一个显示器 `Display`。本章后面的大多数示例程序也是基于这个系统的。

![图形编辑器系统](https://www.eclipse.org/aspectj/doc/released/progguide/figureUML.gif)

AspectJ（以及面向切面编程）的动机是认识到**存在传统编程方法不能很好地捕捉到的问题或关注点**。考虑在某些应用程序中强制执行安全策略的问题。就其本质而言，安全性跨越了应用程序的许多自然模块化单元。此外，随着应用程序的发展，必须统一地将安全策略应用于任何新增的内容。并且正在应用的安全策略本身也可能会不断演变。在传统编程语言中，以规范的方式捕获安全策略之类的关注点非常困难，而且容易出错。

诸如安全性等问题跨越了自然模块化单元。对于面向对象的编程语言，自然模块化单元是类。但是在面向对象的编程语言中，横切关注点不容易转换为类，正是因为它们跨越类，所以它们不能重用，不能被提炼或继承，它们会散布在整个程序中。简而言之，它们很难使用。

OOP 是一种**模块化常见关注点**的方法，AOP 是一种**模块化横切关注点**的方法，非常相似。。**AspectJ 是面向切面编程的 Java 实现**。

AspectJ 只向 Java 中添加了**一个新概念**，即连接点。而连接点实际上只是一个现有 Java 概念的名称。它只向 Java 添加了**一些新结构**：切点、通知、类间声明和切面。切点和通知动态地影响程序流程，类间声明静态地影响程序的类层次结构，而切面封装了这些新结构。

**连接点**是程序流中定义明确的点。**切点**挑选出某些连接点和这些连接点上的值。 **通知**是在到达连接点时执行的代码。这些是 AspectJ 的动态部分。

> 良定义（well defined）就是指**无歧义的、不会导致矛盾的、符合其应满足的所有要求**的定义。

AspectJ 还有不同种类的**类间声明**，允许程序员修改程序的静态结构，即类的成员和类之间的关系。

AspectJ 的**切面**是横切关注点的模块化单元。它们的行为有点像 Java 类，但也可能包括切点、通知和类间声明。

在接下来的小节中，我们将首先研究**连接点**以及它们**如何构成切点**。然后我们将研究**通知**，即在到达切点时运行的代码。我们将看到**如何将切点和通知组合成切面**，这是 AspectJ 的可重用、可继承的模块化单元。最后，我们将看看**如何使用类间声明来处理程序类结构的横切关注点**。

### 动态连接点模型

任何面向切面的语言设计中的一个关键元素是连接点模型。**连接点模型**提供了通用的参考框架，使定义横切关注点的动态结构成为可能。本章描述了 AspectJ 的动态连接点，其中连接点是程序执行中某些定义明确的点。

AspectJ 提供了**多种**连接点，但本章只讨论其中一种：方法调用连接点。**方法调用连接点**包含接收方法调用的对象的动作。它包括构成方法调用的所有动作，在所有参数被评估并包括返回（通常或通过抛出异常）之后开始。

运行时的每个方法调用都是不同的连接点，即使它来自程序中的同一个调用表达式。当方法调用连接点执行时，许多其他连接点可能会运行——所有在执行方法体时发生的连接点，以及从方法体中调用的那些方法中的连接点。我们说这些连接点在原始调用连接点 的*动态上下文中执行。*

### Pointcuts切点

在 AspectJ 中，切点**挑选**出程序流中的某些连接点。例如，切点

```java
call(void Point.setX(int))
```

挑选出每个连接点，该连接点是对具有 `void Point.setX(int)` 签名的方法的调用。即 `Point` 的 具有单个 `int` 参数 的 `void setX` 方法。

切点可以由**其他**切点构建，使用 `and`、`or` 和 `not`（拼写为`&&`、`||`和`!`）。例如：

```java
call(void Point.setX(int)) ||
call(void Point.setY(int))
```

挑选出调用 `setX` 或调用 `setY` 的每个连接点。

切点可以识别许多**不同类型**的连接点——换句话说，它们可以横切类型。例如，

```java
call(void FigureElement.setXY(int,int)) ||
call(void Point.setX(int))              ||
call(void Point.setY(int))              ||
call(void Line.setP1(Point))            ||
call(void Line.setP2(Point));
```

挑选出每个调用五个方法之一的连接点（顺便说一下，第一个是接口方法）。

在我们的示例系统中，当 `FigureElement` 移动时，此切点捕获所有连接点。虽然这是指定此横切关注点的有用方法，但它有点拗口。所以 AspectJ 允许程序员用 `pointcut` 形式定义自己**命名**的切点。所以下面声明了一个新的、命名的切点：

```java
pointcut move():
    call(void FigureElement.setXY(int,int)) ||
    call(void Point.setX(int))              ||
    call(void Point.setY(int))              ||
    call(void Line.setP1(Point))            ||
    call(void Line.setP2(Point));
```

并且只要这个定义可见，程序员就可以简单地使用 `move()` 来捕获这个复杂的切点。

前面的切点都是基于一组方法签名的显式枚举。我们有时称之为**基于名称的横切**。AspectJ 还提供了能够根据方法的属性而不是它们的确切名称来指定切点的机制。我们称之为**基于属性的横切**。其中最简单的涉及在方法签名的某些字段中使用**通配符**。例如，切点

```java
call(void Figure.make*(..))
```

选择每个连接点，该连接点是对 `Figure` 上定义的名称以 `make` 开头的 `void` 方法的调用，并且与方法的参数无关。在我们的系统中，这会挑选出对工厂方法 `makePoint` 和`makeLine` 的调用。切点

```java
call(public * Figure.* (..))
```

挑选出对 `Figure` 的公共方法的每个调用。

但是通配符并不是 AspectJ 支持的唯一属性。另一个切点 `cflow` 根据它们是否出现在其他连接点的动态上下文中来识别连接点。所以

```java
cflow(move())
```

挑选出由 `move()` 挑选的连接点的动态上下文中出现的每个连接点，`move()` 是我们在上面定义的命名切点。因此，这会挑选出在调用 `move` 方法和它返回（通过正常方式或抛出异常）之间发生的每个连接点。

### Advice通知

因此，切点挑选出连接点。但是它们除了挑选连接点外，什么也不做。为了实际实现横切行为，我们使用通知。**通知将切点**，用于挑选连接点，**和代码体**，在每个连接点上运行，**结合在一起。**

AspectJ 有几种不同类型的通知。**前置通知**，会在到达连接点时，程序继续使用连接点之前运行。例如，方法调用连接点上的前置通知的运行机时是：实际方法开始运行之前，方法调用的参数被计算之后。

```java
before(): move() {
    System.out.println("about to move");
}
```

对特定连接点的**后置通知**，会在程序继续使用该连接点之后运行。例如，方法调用连接点上的后置通知的运行时机是：方法体运行之后，控制返回给调用者之前。因为Java程序可以“正常地”或通过抛出异常离开连接点，所以有三种后置通知：返回后置 `after returning`，异常后置 `after throwing`，和普通后置 `after` (在返回后置或异常后置发生时运行，如同 Java 的 `finally`)。

```java
after() returning: move() {
    System.out.println("just successfully moved");
}
```

**环绕通知**，会在到达连接点时运行，并且对程序是否继续使用连接点具有显式控制。本节不会讨论环绕通知。

#### 在切点中公开上下文

切点不仅挑选出连接点，它们还可以在其连接点处**公开部分执行上下文**。切点暴露的值可以在通知声明的主体中使用。

一个通知声明有一个**参数列表**（就像方法一样），为它使用的所有上下文片段**提供名称**。例如，后置通知

```java
after(FigureElement fe, int x, int y) returning:
        ...SomePointcut... {
    ...SomeBody...
}
```

使用了三个公开的上下文，一个名为 `fe` 的 `FigureElement` ，以及两个名为 `x` 和 `y` 的 `int` 。

**通知体使用名称**，就像方法使用方法参数一样，所以

```java
after(FigureElement fe, int x, int y) returning:
        ...SomePointcut... {
    System.out.println(fe + " moved to (" + x + ", " + y + ")");
}
```

**通知的切点发布通知的参数的值**。三个原始切点 `this`、`target` 和 `args` 用于发布这些值。现在我们可以写出完整的通知：

```java
after(FigureElement fe, int x, int y) returning:
        call(void FigureElement.setXY(int, int))
        && target(fe)
        && args(x, y) {
    System.out.println(fe + " moved to (" + x + ", " + y + ")");
}
```

切点从对 `setXY` 的调用中公开了三个值 ：目标 `FigureElement` ，它作为 `fe` 发布，因此它成为后置通知的第一个参数； 两个 `int` 参数，它作为 `x` 和 `y` 发布，所以它们成为后置通知的第二个和第三个参数。

因此，在每次调用 `setXY` 方法后，通知会打印被移动的图形元素 `fe` 及其新的 `x` 和 `y` 坐标 。

像通知一样，**命名切点可能有一些参数**。当使用命名切点时（通过通知，或在另一个命名切点中），它按名称发布其上下文，就像 `this`、`target` 和 `args` 切点。所以上述通知的另一种写法是

```java
pointcut setXY(FigureElement fe, int x, int y):
    call(void FigureElement.setXY(int, int))
    && target(fe)
    && args(x, y);

after(FigureElement fe, int x, int y) returning: setXY(fe, x, y) {
    System.out.println(fe + " moved to (" + x + ", " + y + ").");
}
```

### 类间声明

AspectJ 中的类间声明是**跨类及其层次结构**的声明。它们可以声明跨多个类的成员，或者更改类之间的继承关系。与主要动态操作 advice 不同，**引入（introduction）在编译时是静态操作**。

考虑这样一个问题：现有类已经是类层次结构一部分，即现有类已经扩展了一个类，表达一些现有类的共享的功能。在 Java 中，创建一个捕获此新功能的接口，然后向每个受影响的类添加一个实现此接口的方法。

通过使用类间声明，AspectJ 可以在一个地方表示关注点。切面声明了实现新功能所必需的方法和字段，并将方法和字段关联到现有的类。

假设我们想让 `Screen` 对象观察 `Point` 对象的变化，其中 `Point` 是一个已存在的类。我们可以通过编写一个切面来实现这一点，声明类 `Point` 有一个实例字段 `observers`，它跟踪正在观察 `Point`s 的 `Screen` 对象。

```java
aspect PointObserving {
    private Vector Point.observers = new Vector();
    ...
}
```

`observers` 字段是私有的，所以只有 `PointObserving` 可以看到它。因此，可以通过切面的静态方法 `addObserver` 和 `removeObserver` 添加或删除观察者。

```java
aspect PointObserving {
    private Vector Point.observers = new Vector();

    public static void addObserver(Point p, Screen s) {
        p.observers.add(s);
    }
    public static void removeObserver(Point p, Screen s) {
        p.observers.remove(s);
    }
    ...
}
```

除此之外，我们可以定义一个切点 `changes` 来定义我们想要观察的内容，而后置通知定义我们在观察到变更时想要做什么。

```java
aspect PointObserving {
    private Vector Point.observers = new Vector();

    public static void addObserver(Point p, Screen s) {
        p.observers.add(s);
    }
    public static void removeObserver(Point p, Screen s) {
        p.observers.remove(s);
    }

    pointcut changes(Point p): target(p) && call(void Point.set*(int));

    after(Point p): changes(p) {
        Iterator iter = p.observers.iterator();
        while ( iter.hasNext() ) {
            updateObserver(p, (Screen)iter.next());
        }
    }

    static void updateObserver(Point p, Screen s) {
        s.display(p);
    }
}
```

请注意，`Screen` 和 `Point` 的代码都不必修改，并且支持这一新功能所需的所有更改 are local to this aspect.

### Aspects切面

**切面将切点、通知和类间声明封装在横切实现的模块化单元中**。它的定义非常像一个类，除了横切成员之外，它还可以有方法、字段和初始化程序。因为只有切面可能包括这些横切成员，所以这些声明影响是本地化的。

与类一样，切面可能会被实例化，但 AspectJ 控制该实例化的发生方式——因此您不能使用 Java 的 `new` 形式来构建新的切面实例。默认情况下，每个切面都是一个**单例**，因此只会创建一个切面实例。这意味着如果需要保持状态，通知可以使用切面的非静态字段

```java
aspect Logging {
    OutputStream logStream = System.err;

    before(): move() {
        logStream.println("about to move");
    }
}
```

切面也可能有更复杂的实例化规则，但这些将在后面的章节中描述。
