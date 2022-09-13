# 文本块程序员指南

> https://docs.oracle.com/en/java/javase/18/text-blocks/index.html

**吉姆·拉斯基**

**斯图尔特马克斯**

**2020-09-15**

[JEP 378](http://openjdk.java.net/jeps/378) 将语言功能*文本块*添加 到 Java SE 15 及更高版本。虽然 JEP 非常详细地解释了该特性，但并不总是很清楚**如何使用该功能**以及**应该如何使用该功能**。本指南汇集了**文本块的实际使用建议**，以及**一些风格指南**。

## 介绍

文本块的*原则*是通过**最小化呈现跨越多行的字符串**所需的 Java 语法来提供清晰度。

在 JDK 的早期版本中，嵌入多行代码片段需要大量的显式行结束符、字符串连接和分隔符。文本块消除了大多数这些障碍，允许您或多或少地嵌入代码片段和文本序列。

文本块是 Java 字符串表示的另一种形式，可以在任何可以使用传统双引号字符串字面值的地方使用。例如：

```java
// Using a literal string
String dqName = "Pat Q. Smith";

// Using a text block
String tbName = """
                Pat Q. Smith""";
```

从文本块生成的对象是 `java.lang.String` ，其特征与传统的双引号字符串相同。这包括对象表示和内部处理。继续上面示例中的 `dqName` 和 `tbName`，

```java
// Both dqName and tbName are strings of equal value
dqName.equals(tbName)    // true

// Both dqName and tbName intern to the same string
dqName == tbName         // true
```

文本块可以在任何可以使用字符串字面值的地方使用。例如，在字符串连接表达式中，文本块可以与字符串字面值混合在一起:

```java
String str = "The old";
String tb = """
            the new""";
String together = str + " and " + tb + ".";
```

文本块可以用作方法参数：

```java
System.out.println("""
    This is the first line
    This is the second line
    This is the third line
    """);
```

`String` 方法可以应用于文本块：

```java
"""
John Q. Smith""".substring(8).equals("Smith")    // true
```

可以使用文本块代替字符串字面值，以提高代码的可读性和清晰度。这主要发生在使用字符串字面值表示多行字符串时。在这种情况下，引号、换行符转义和连接运算符会造成相当大的混乱：

```java
// ORIGINAL
String message = "'The time has come,' the Walrus said,\n" +
                 "'To talk of many things:\n" +
                 "Of shoes -- and ships -- and sealing-wax --\n" +
                 "Of cabbages -- and kings --\n" +
                 "And why the sea is boiling hot --\n" +
                 "And whether pigs have wings.'\n";
```

使用文本块消除了很多混乱：

```java
// BETTER
String message = """
    'The time has come,' the Walrus said,
    'To talk of many things:
    Of shoes -- and ships -- and sealing-wax --
    Of cabbages -- and kings --
    And why the sea is boiling hot --
    And whether pigs have wings.'
    """;
```

## 使用文本块

### 文本块语法

文本块**以三个双引号字符开头，后跟一个行结束符**。不能将文本块放在单行上，也不能在没有中间行结束符的情况下将文本块的内容放在三个开头的双引号后面。这样做的原因是，文本块主要是为支持多行字符串而设计的，需要初始行结束符简化了缩进处理规则（请参阅下面的部分，*附带空白*）。

```java
// ERROR
String name = """Pat Q. Smith""";

// ERROR
String name = """red
                 green
                 blue
                 """;

// OK
String name = """
    red
    green
    blue
    """;
```

最后一个示例等效于以下字符串字面值：

```java
String name = "red\n" +
              "green\n" +
              "blue\n";
```

下面是一个文本块中的 Java 代码片段示例：

```java
String source = """
    String message = "Hello, World!";
    System.out.println(message);
    """;
```

请注意，**无需转义嵌入的双引号**。等效的字符串字面值将是：

```java
String source = "String message = \"Hello, World!\";\n" +
                "System.out.println(message);\n";
```

### 最后的新行

注意上面的例子，

```java
String name = """
    red
    green
    blue
    """;
```

相当于`"red\ngreen\nblue\n"`。如果你想表示一个没有最后的 `\n` 的多行字符串怎么办？

```java
String name = """
    red
    green
    blue""";
```

这个文本块相当于 `"red\ngreen\nblue"`。因此，将结束分隔符放在最后一个可见行上会有效地删除最后一个`\n`。

### 附带的空白

理想情况下，文本块**应该缩进以匹配周围代码的缩进**。例如:

```java
void writeHTML() {
    String html = """
        <html>
            <body>
                <p>Hello World.</p>
            </body>
        </html>
        """;
    writeOutput(html);
}
```

但是，这提出了用于缩进的空格如何影响字符串内容的问题。天真的解释将包括文本块中的所有空白。这样做的结果是，重新缩进代码会影响文本块的内容。这很可能是一个错误。

为了避免这个问题，文本块将*附带*的空白与*必要*的空白区分开来。Java 编译器会**自动去除附带的空白**。`<html>` 和 `</html>` 左侧的缩进被认为是附带的，因为这些行的缩进最少。因此，它们有效地确定了文本块中文本的左边距。但是，`<body>` 相对于 `<html>` 的缩进*不*被认为是附带的空白。据推测，这种相对缩进是字符串内容的一部分。

下面的示例使用 “ `·`” 来可视化附带的空白，必要空白显示为实际空白。

```java
void writeHTML() {
    String html = """
········<html>
········    <body>
········        <p>Hello World.</p>
········    </body>
········</html>
········""";
    writeOutput(html);
}
```

去掉附带的空白后，得到的文本块内容如下：

```html
<html>
    <body>
        <p>Hello World.</p>
    </body>
</html>
```

JEP 378 中详细描述了用于**确定附带空白的算法**。然而，最终效果非常简单。文本块的全部内容向左移动，直到前导空白最少的行没有前导空白。

要**保留一些空白**而不将其视为附带空白，只需将文本块的内容行向右移动，同时将结束的三引号分隔符保留在适合周围代码的缩进处。例如：

```java
void writeHTML() {
    String html = """
········    <html>
········        <body>
········            <p>Hello World.</p>
········        </body>
········    </html>
········""";
    writeOutput(html);
}
```

结果如下：

```html
    <html>
        <body>
            <p>Hello World.</p>
        </body>
    </html>
```

文本块可以通过将结束分隔符定位在源行的第一个字符位置来*选择不*剥离附带的空白：

```java
void writeHTML() {
    String html = """
                  <html>
                      <body>
                          <p>Hello World.</p>
                      </body>
                  </html>
""";
    writeOutput(html);
}
```

结果是没有附带的空白被剥离，并且字符串在每行上都包含前导空白。

```html
                  <html>
                      <body>
                          <p>Hello World.</p>
                      </body>
                  </html>
```

这种用于**控制保留的缩进量**的技术仅在文本块的最后一行以行终止符结尾时才有效。如果最后一行没有*以*行终止符结尾，则需要使用`String::indent` 显式控制缩进。在以下示例中，

```java
String colors = """
    red
    green
    blue""";
```

所有缩进都被视为附带并被剥离：

```
red
green
blue
```

要在字符串内容中包含一些缩进，请在文本块上调用 `indent` 方法：

```java
String colors = """
    red
    green
    blue""".indent(4);
```

这导致：

```
    red
    green
    blue
```

### 尾随空格

**文本块中每一行的尾随空白也被认为是附带的**，并被 Java 编译器删除。这样做是为了使文本块的内容始终在视觉上可辨别。如果不这样做，自动去除尾随空格的文本编辑器可能会无形地更改文本块的内容。

如果您需要**在文本块中包含尾随空格**，则可以使用以下策略之一：

```java
// character substitution
String r = """
    trailing$$$
    white space
    """.replace('$', ' ');


// character fence
String s = """
    trailing   |
    white space|
    """.replace("|\n", "\n");


// octal escape sequence for space
String t = """
    trailing\040\040\040
    white space
    """;
```

**注意：**不能使用 `\u0020`，因为 Unicode 转义在源文件读取过程中，在词法分析之前被翻译。相比之下，诸如`\040` 在词法分析将源文件划分为标记并识别字符串字面量和文本块之后处理的字符和字符串转义。

### 检测空白区域的潜在问题

在前面的示例中，所有缩进都由空格字符组成。但是，有时人们会使用 TAB 字符 `\t` 。不幸的是，Java 编译器不可能知道制表符在不同的编辑器中是如何显示的。因此，规则是平等对待每个单独的空白字符。单个空格字符被视为与单个制表符相同，即使后者在某些特定系统上显示时可能导致最多 8 个空格的空白。

因此，混合空白字符可能会产生不一致和意想不到的效果。考虑下面的例子，其中一些行用空格缩进，一些用制表符缩进（用 `␉` 可视化）：

```java
    String colors = """
····················red
␉   ␉   ␉   ␉   ␉   green
····················blue""";
```

在这种情况下，由于第二行只有 5 个空白字符而其他行有 20 个空格，因此附带缩进的去除将是不均匀的。结果看起来像这样：

```
               red
green
               blue
```

通过使用 Java 编译器 `lint` 标志，`-Xlint:text-blocks`，打开文本块 `lint` 检测，可以检测与附带空白相关的问题. 如果启用 lint 检测，那么上面的例子将生成一个警告，“不一致的空白缩进”（`inconsistent white space indentation`）。

这个 lint 标志还启用另一个警告，“将删除尾随空格”（`trailing white space  will be removed`），如果文本块内的任何行上有尾随空格，则会发出该警告。如果您需要保留尾随空格，请使用上一节中描述的转义或替换技术之一。

### 行终止符的归一化

多行字符串字面值的复杂性之一是源文件中使用的行终止符（`\n`、`\r`或`\r\n`）因平台而异。不同平台的编辑器可能会无形地更改行终止符。或者，如果在不同平台上编辑源文件，则文本块可能包含不同行终止符的混合。这可能会产生令人困惑和不一致的结果。

为了避免这些问题，**Java 编译器将文本块中的所有行终止符规范化为`\n`**，而不管源文件中实际出现什么行终止符。以下文本块（其中`␊`和`␍`表示`\n`和`\r`）：

```java
String colors = """
    red␊
    green␍
    blue␍␊
    """;
```

相当于这个字符串字面值：

```java
String colors = "red\ngreen\nblue\n";
```

如果需要平台行终止符，则可以使用 `String::replaceAll("\n", System.lineSeparator())`。

### 转义序列的翻译

与字符串字面值一样，文本块**识别**转义序列 `\b`、`\f`、`\n`、`\t`、`\r`、`\"`、`\'`、`\\` 和八进制转义。与字符串字面值不同，**通常不需要**转义序列。在大多数情况下，可以使用实际字符来代替转义序列 `\n`、`\t`、`\"` 和 `\'`。以下文本块（其中 `␉` 和 `␊` 表示 `\t` 和 `\n`）：

```java
String s = """
    Color␉   Shape␊
    Red␉ ␉   Circle␊
    Green␉   Square␊
    Blue␉␉   Triangle␊
    """;
```

结果是：

```
Color␉  Shape␊
Red␉ ␉  Circle␊
Green␉  Square␊
Blue␉␉  Triangle␊
```

当三个或更多双引号连续出现时需要转义。

```java
String code = """
    String source = \"""
        String message = "Hello, World!";
        System.out.println(message);
        \""";
    """;
```

**转义翻译发生在 Java 编译器处理的最后一步**，因此您可以使用显式转义序列绕过行终止符规范化和空格剥离步骤。例如：

```java
String s = """
           red  \040
           green\040
           blue \040
           """;
```

将保证所有行的长度相同，因为直到去除尾随空格后才会转换 `\040` 为空格（“ `·`”用于显示尾随空格）。结果是：

```
red···
green·
blue··
```

**注意：**如前所述，Unicode 转义序列 `\u0020` *不能*用作 `\040`。

### 新转义序列

 `\<line-terminator>` 转义序列**显式禁止包含隐式换行符**。

例如，通常的做法是将非常长的字符串字面值拆分为较小子字符串的串联，然后将生成的字符串表达式硬包装到多行中。

```java
  String literal = "Lorem ipsum dolor sit amet, consectetur adipiscing " +
                   "elit, sed do eiusmod tempor incididunt ut labore " +
                   "et dolore magna aliqua.";
```

使用 `\<line-terminator>` 转义序列，这可以表示为；

```java
  String text = """
                Lorem ipsum dolor sit amet, consectetur adipiscing \
                elit, sed do eiusmod tempor incididunt ut labore \
                et dolore magna aliqua.\
                """;
```

`\s` 转义序列**简单地转换为空格**（`\040`, ASCII 字符 32，空格）。由于转义序列直到事件空间剥离后才会被转换，因此 `\s` 可以充当栅栏以防止尾随空格的剥离。在以下示例中的每行末尾使用`\s`，可确保每行正好是六个字符长。

```java
String colors = """
    red  \s
    green\s
    blue \s
    """;
```

## 文本块的风格指南

**G1. 当文本块可以提高代码的清晰度时，尤其是多行字符串时，应该使用它。**

```java
// ORIGINAL
String message = "'The time has come,' the Walrus said,\n" +
                 "'To talk of many things:\n" +
                 "Of shoes -- and ships -- and sealing-wax --\n" +
                 "Of cabbages -- and kings --\n" +
                 "And why the sea is boiling hot --\n" +
                 "And whether pigs have wings.'\n";

// BETTER
String message = """
    'The time has come,' the Walrus said,
    'To talk of many things:
    Of shoes -- and ships -- and sealing-wax --
    Of cabbages -- and kings --
    And why the sea is boiling hot --
    And whether pigs have wings.'
    """;
```

**G2. 如果一个字符串适合单行，没有连接和转义换行符，您可能应该继续使用字符串字面量。**

```java
// ORIGINAL - is a text block helpful here?
String name = """
              Pat Q. Smith""";

// BETTER - a string literal works fine
String name = "Pat Q. Smith";
```

**G3. 在保持可读性时使用嵌入式转义序列。**

```java
var data = """
    Name | Address | City
    Bob Smith | 123 Anytown St\nApt 100 | Vancouver
    Jon Brown | 1000 Golden Place\nSuite 5 | Santa Ana
    """;
```

**G4. 对于大多数多行字符串，将开始分隔符放置在前一行的右端，并将结束分隔符放置在其自己的行上，即文本块的左边距。**

```java
String string = """
    red
    green
    blue
    """;
```

**G5. 避免对齐开始和结束分隔符和文本块的左边距。如果变量名或修饰符被更改，这需要重新缩进文本块。**

```java
// ORIGINAL
String string = """
                red
                green
                blue
                """;

// ORIGINAL - after variable declaration changes
static String rgbNames = """
                         red
                         green
                         blue
                         """;

// BETTER
String string = """
    red
    green
    blue
    """;

// BETTER - after variable declaration changes
static String rgbNames = """
    red
    green
    blue
    """;
```

**G6. 避免复杂表达式中的内嵌文本块，因为这样做会扭曲可读性。考虑重构为局部变量或静态最终字段。**

```java
// ORIGINAL
String poem = new String(Files.readAllBytes(Paths.get("jabberwocky.txt")));
String middleVerses = Pattern.compile("\\n\\n")
                             .splitAsStream(poem)
                             .match(verse -> !"""
                                   ’Twas brillig, and the slithy toves
                                   Did gyre and gimble in the wabe;
                                   All mimsy were the borogoves,
                                   And the mome raths outgrabe.
                                   """.equals(verse))
                             .collect(Collectors.joining("\n\n"));

// BETTER
String firstLastVerse = """
    ’Twas brillig, and the slithy toves
    Did gyre and gimble in the wabe;
    All mimsy were the borogoves,
    And the mome raths outgrabe.
    """;
String poem = new String(Files.readAllBytes(Paths.get("jabberwocky.txt")));
String middleVerses = Pattern.compile("\\n\\n")
                             .splitAsStream(poem)
                             .match(verse -> !firstLastVerse.equals(verse))
                             .collect(Collectors.joining("\n\n"));
```

**G7. 仅使用空格或仅使用制表符来缩进文本块。混合空白将导致不规则缩进的结果。**

```java
// ORIGINAL
    String colors = """
········red
␉       green
········blue""";    // result: "·······red\ngreen\n·······blue"

// PROBABLY WHAT WAS INTENDED
    String colors = """
········red
········green
········blue""";    // result: "red\ngreen\nblue"
```

**G8. 当文本块包含三个或更多双引号的序列时，请转义每次运行三个双引号的第一个双引号。**

```java
// ORIGINAL
String code = """
    String source = \"\"\"
        String message = "Hello, World!";
        System.out.println(message);
        \"\"\";
    """;

// BETTER
String code = """
    String source = \"""
        String message = "Hello, World!";
        System.out.println(message);
        \""";
    """;
```

**G9. 大多数文本块应该缩进以与相邻的 Java 代码对齐。**

```java
    // ORIGINAL - odd indentation
    void printPoem() {
        String poem = """
’Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
All mimsy were the borogoves,
And the mome raths outgrabe.
""";
        System.out.print(poem);
    }

    // BETTER
    void printPoem() {
        String poem = """
            ’Twas brillig, and the slithy toves
            Did gyre and gimble in the wabe;
            All mimsy were the borogoves,
            And the mome raths outgrabe.
            """;
        System.out.print(poem);
    }
```

**G10. 建议将宽字符串完全左对齐以避免水平滚动或换行。**

```java
// ORIGINAL

class Outer {
    class Inner {
        void printPoetry() {
            String lilacs = """
                Over the breast of the spring, the land, amid cities,
                Amid lanes and through old woods, where lately the violets peep’d from the ground, spotting the gray debris,
                Amid the grass in the fields each side of the lanes, passing the endless grass,
                Passing the yellow-spear’d wheat, every grain from its shroud in the dark-brown fields uprisen,
                Passing the apple-tree blows of white and pink in the orchards,
                Carrying a corpse to where it shall rest in the grave,
                Night and day journeys a coffin.
                """;
            System.out.println(lilacs);
        }
    }
}

// BETTER

class Outer {
    class Inner {
        void printPoetry() {
            String lilacs = """
Over the breast of the spring, the land, amid cities,
Amid lanes and through old woods, where lately the violets peep’d from the ground, spotting the gray debris,
Amid the grass in the fields each side of the lanes, passing the endless grass,
Passing the yellow-spear’d wheat, every grain from its shroud in the dark-brown fields uprisen,
Passing the apple-tree blows of white and pink in the orchards,
Carrying a corpse to where it shall rest in the grave,
Night and day journeys a coffin.
""";
            System.out.println(lilacs);
        }
    }
}
```

**G11. 同样，当高行数导致关闭分隔符可能垂直滚动到视图之外时，将文本块完全左对齐也是合理的。这允许读者在关闭分隔符不在视线范围内时使用左边距跟踪缩进。**

```java
// ORIGINAL

String validWords = """
                    aa
                    aah
                    aahed
                    aahing
                    aahs
                    aal
                    aalii
                    aaliis
...
                    zythum
                    zythums
                    zyzzyva
                    zyzzyvas
                    zzz
                    zzzs
                    """;


// BETTER

String validWords = """
aa
aah
aahed
aahing
aahs
aal
aalii
aaliis
...
zythum
zythums
zyzzyva
zyzzyvas
zzz
zzzs
""";
```

**G12. 当 `\<line-terminator>` 需要排除文本块的最后一个新行时，应使用转义序列。这可以更好地框住文本块并允许关闭分隔符管理缩进。**

```java
// ORIGINAL

String name = """
    red
    green
    blue""".indent(4);


// BETTER

String name = """
        red
        green
        blue\
    """;
```

## 与文本块相关的字符串方法

`String` 类中包含了几个新方法，作为文本块特性的一部分。

### `String formatted(Object... args)`

这种方法相当于`String.format(this, args)`。优点是，作为实例方法，它可以链接到文本块的末尾：

```java
String output = """
    Name: %s
    Phone: %s
    Address: %s
    Salary: $%.2f
    """.formatted(name, phone, address, salary);
```

### `String stripIndent()`

`stripIndent` 方法使用 Java 编译器使用的相同算法从多行字符串中删除附带的空格。如果您有一个程序将文本作为输入数据读取，并且您希望以与文本块相同的方式去除缩进，这将非常有用。

### `String translateEscapes()`

`translateEscapes` 方法执行转义序列（`\b`、`\f`、`\n`、`\t`、`\r`、`\"`、`\'`、`\\` 和八进制转义）的翻译并被 Java 编译器用于处理文本块和字符串字面值。如果您有一个程序将文本作为输入数据读取并且您想要执行转义序列处理，这将非常有用。请注意，Unicode 转义 ( `\uNNNN`)*不会*被处理。