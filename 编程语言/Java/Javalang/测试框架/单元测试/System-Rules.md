# System Rules

> https://stefanbirkner.github.io/system-rules/index.html

用于测试使用`java.lang.System`的代码的JUnit 规则集合。

System Rules 适用于 Java 6 或 Java 7，且只适用于 Junit 4。

如果使用 Java 8 及以上版本，**建议使用 System Lamda 替代**。

## 最新版本

``` xml
<dependency>
  <groupId>com.github.stefanbirkner</groupId>
  <artifactId>system-rules</artifactId>
  <version>1.19.0</version>
  <scope>test</scope>
</dependency>
```



## 涉及功能
System Rules的范围分为五个部分。

### 1. System.out, System.err and System.in
Command-line应用从command-line读取并写入command-line。 使用<a href="#SystemErrRule">`SystemErrRule`</a>，<a href="#SystemOutRule">`SystemOutRule`</a>和<a href="#System.in">`TextFromStandardInputStream`</a>提供输入文本并验证输出。

应用有时会无意间写入`System.out`或`System.err`。 通过使用`DisallowWriteToSystemOut`和`DisallowWriteToSystemErr`确保不会发生这种情况。

### 2. System.exit
使用`ExpectedSystemExit`规则来测试调用`System.exit(…)`的代码。验证调用了`System.exit(…)`，验证此调用的状态码或检查断言应用程序已终止。

### 3. System Properties
如果你的测试处理系统属性，要求你必须设置它们并在测试之后恢复它们。为此，请使用`ClearSystemProperties`、`ProvideSystemProperty`和`RestoreSystemProperties`规则。

### 4. Environment Variables
如果你的测试需要设置一个环境变量，那么使用`EnvironmentVariables`规则。

### 5. Security Managers
使用`ProvideSecurityManager`规则为测试提供特定的安全管理器。 测试后将还原系统的安全管理器。

## 用法

建议：系统规则至少需要JUnit 4.9。

以下所有示例都使用`@Rule`注解，但是规则也可以与`@ClassRule`注解一起使用。

### 系统属性

#### ClearSystemProperties
`ClearSystemProperties`规则在测试之前删除属性，并在测试完成时恢复属性的原始值。

``` java
public class MyTest {
	@Rule
	public final ClearSystemProperties myPropertyIsCleared
	 = new ClearSystemProperties("MyProperty");

	@Test
	public void overrideProperty() {
		assertNull(System.getProperty("MyProperty"));
	}
}
```

#### ProvideSystemProperty
`ProvideSystemProperty`规则为要测试的系统属性提供一个任意值。测试后恢复原始值。

##### 多实例
``` java
public class MyTest {
	@Rule
	public final ProvideSystemProperty myPropertyHasMyValue
	 = new ProvideSystemProperty("MyProperty", "MyValue");

	@Rule
	public final ProvideSystemProperty otherPropertyIsMissing
	 = new ProvideSystemProperty("OtherProperty", null);

	@Test
	public void overrideProperty() {
		assertEquals("MyValue", System.getProperty("MyProperty"));
		assertNull(System.getProperty("OtherProperty"));
	}
}
```

##### 单一实例

你也可以使用规则的单一实例来达到同样的效果:

``` java
public class MyTest {
	@Rule
	public final ProvideSystemProperty properties
	 = new ProvideSystemProperty("MyProperty", "MyValue").and("OtherProperty", null);

	@Test
	public void overrideProperty() {
		assertEquals("MyValue", System.getProperty("MyProperty"));
		assertNull(System.getProperty("OtherProperty"));
	}
}
```
##### 属性文件

可以使用属性文件为`ProvideSystemProperty`规则提供属性。文件可以来自文件系统或类路径。
在第一种情况下使用

``` java
@Rule
public final ProvideSystemProperty properties
 = ProvideSystemProperty.fromFile("/home/myself/example.properties");
```

在第二种情况下使用

``` java
@Rule
public final ProvideSystemProperty properties
 = ProvideSystemProperty.fromResource("example.properties");
```

#### RestoreSystemProperties
当测试完成时，`RestoreSystemProperties`规则取消所有系统属性的更改(无论它是否通过)。

``` java
public class MyTest {
	@Rule
	public final RestoreSystemProperties restoreSystemProperties
	 = new RestoreSystemProperties();

	@Test
	public void overrideProperty() {
		//after the test the original value of "MyProperty" will be restored.
		System.setProperty("MyProperty", "other value");
		...
	}
}
```

### System.err 和 System.out

`SystemErrRule`和`SystemOutRule`帮助你为写入`System.err`或`System.out`的类创建测试。 他们可以记录所有写入`System.err`或`System.out`的内容。 可以通过调用`getLog()`获得文本。

#### SystemErrRule

``` java
public class MyTest {
	@Rule
	public final SystemErrRule systemErrRule = new SystemErrRule().enableLog();

	@Test
	public void writesTextToSystemErr() {
		System.err.print("hello world");
		assertEquals("hello world", systemErrRule.getLog());
	}
}
```
#### SystemOutRule

``` java
public class MyTest {
	@Rule
	public final SystemOutRule systemOutRule = new SystemOutRule().enableLog();

	@Test
	public void writesTextToSystemOut() {
		System.out.print("hello world");
		assertEquals("hello world", systemOutRule.getLog());
	}
}
```
#### 行分隔符
如果验证包含行分隔符的日志与包含行分隔符的日志不同(例如，Linux: `\n`, Windows: `\r\n`)。对于始终使用行分隔符`\n`的日志，使用`getLogWithNormalizedLineSeparator()`。

``` java
public class MyTest {
	@Rule
	public final SystemErrRule systemErrRule = new SystemErrRule().enableLog();

	@Test
	public void writesTextToSystemErr() {
		System.err.print(String.format("hello world%n)");
		assertEquals("hello world\n", systemErrRule.getLog());
	}
}
```

``` java
public class MyTest {
	@Rule
	public final SystemOutRule systemOutRule = new SystemOutRule().enableLog();

	@Test
	public void writesTextToSystemOut() {
		System.out.print(String.format("hello world%n)");
		assertEquals("hello world\n", systemOutRule.getLog());
	}
}
```

#### 读二进制数据

如果你的测试代码将原始二进制数据写入`System.err`或`System.out`，则可以通过`getLogAsBytes()`读取它。

``` java
public class MyTest {
	@Rule
	public final SystemErrRule systemErrRule = new SystemErrRule().enableLog();

	@Test
	public void writesBytesToSystemErr() {
		byte[] data = { 1, 2, 3, 4, 5 };
		System.err.write(data, 0, data.length);
		assertEquals(data, systemErrRule.getLogAsBytes());
	}
}
```

``` java
public class MyTest {
	@Rule
	public final SystemOutRule systemOutRule = new SystemOutRule().enableLog();

	@Test
	public void writesBytesToSystemOut() {
		byte[] data = { 1, 2, 3, 4, 5 };
		System.out.write(data, 0, data.length);
		assertEquals(data, systemOutRule.getLogAsBytes());
	}
}
```
#### 清空日志

如果您想要丢弃某些已写入日志的文本，可以清除日志。

``` java
public class MyTest {
	@Rule
	public final SystemErrRule systemErrRule = new SystemErrRule().enableLog();

	@Test
	public void writesTextToSystemErr() {
		System.err.print("hello world");
		systemErrRule.clear().
		System.err.print("foo");
		assertEquals("foo", systemErrRule.getLog());
	}
}
```

``` java
public class MyTest {
	@Rule
	public final SystemOutRule systemOutRule = new SystemOutRule().enableLog();

	@Test
	public void writesTextToSystemOut() {
		System.out.print("hello world");
		systemOutRule.clear().
		System.out.print("foo");
		assertEquals("foo", systemOutRule.getLog());
	}
}
```

#### 静默输出mute

输出仍将写入`System.err`和`System.out`。 通常，这不是必需的。 避免输出可能会加快测试速度并减少命令行上的混乱情况。你可以通过调用`mute()`禁用输出。

``` java
@Rule
public final SystemErrRule systemErrRule = new SystemErrRule().mute();
```

``` java
@Rule
public final SystemOutRule systemOutRule = new SystemOutRule().mute();
```

#### 结合mute和log

可以将静音和日志记录结合在一起。

``` java
@Rule
public final SystemErrRule systemErrRule = new SystemErrRule().enableLog().mute();
```

``` java
@Rule
public final SystemOutRule systemOutRule = new SystemOutRule().enableLog().mute();
```

#### 只静音成功测试

如果测试失败，有时查看输出是有帮助的。这时`muteForSuccessfulTests()`方法就开始起作用了。

``` java
@Rule
public final SystemErrRule systemErrRule = new SystemErrRule().muteForSuccessfulTests();
```

``` java
@Rule
public final SystemOutRule systemOutRule = new SystemOutRule().muteForSuccessfulTests();
```

#### 禁止写入System.out和System.err
`DisallowWriteToSystemErr`和`DisallowWriteToSystemOut`规则使测试在尝试写入`System.err`或`System.out`时失败。 这些规则很好地替代了静态代码分析，因为它们也涵盖了外部库。

``` java
public class MyTest {
  @Rule
  public final DisallowWriteToSystemErr disallowWriteToSystemErr
    = new DisallowWriteToSystemErr();

  @Test
  public void this_test_fails() {
    System.err.println("some text");
  }
}
```

``` java
public class MyTest {
  @Rule
  public final DisallowWriteToSystemOut disallowWriteToSystemOut
    = new DisallowWriteToSystemOut();

  @Test
  public void this_test_fails() {
    System.out.println("some text");
  }
}
```

### System.in
`TextFromStandardInputStream`规则可帮助你为从`System.in`读取数据的类创建测试。 你可以通过调用`provideLines(String ...)`来指定由`System.in`提供的行。 该示例的被测类从`System.in`中读取两个数字，并计算这些数字的总和。

#### 被测试覆盖的类

``` java
import java.util.Scanner;

public class Summarize {
  public static int sumOfNumbersFromSystemIn() {
    Scanner scanner = new Scanner(System.in);
    int firstSummand = scanner.nextInt();
    int secondSummand = scanner.nextInt();
    return firstSummand + secondSummand;
  }
}
```

#### TextFromStandardInputStream


``` java
import static org.junit.Assert.*;
import static org.junit.contrib.java.lang.system.TextFromStandardInputStream.*;

import org.junit.Rule;
import org.junit.Test;
import org.junit.contrib.java.lang.system.TextFromStandardInputStream;

public class SummarizeTest {
  @Rule
  public final TextFromStandardInputStream systemInMock
    = emptyStandardInputStream();

  @Test
  public void summarizesTwoNumbers() {
    systemInMock.provideLines("1", "2");
    assertEquals(3, Summarize.sumOfNumbersFromSystemIn());
  }
}
```

#### 正确处理异常
如果要测试被测类是否正确处理了异常，则可以告诉`TextFromStandardInputStream`在读取所有字符之后引发异常。

``` java
systemInMock.throwExceptionOnInputEnd(new IOException());
```

``` java
systemInMock.throwExceptionOnInputEnd(new RuntimeException());
```

### System.exit()

如果你的代码调用`System.exit()`，则你的测试将停止并且不会完成。 `ExpectedSystemExit`规则允许在测试中指定预期的`System.exit()`调用。 此外，由于代码的异常终止，您不能使用JUnit的`assert`方法。 作为替代，您可以为`ExpectedSystemExit`规则提供一个`Assertion`对象。

如果你的被测系统创建了一个新线程，并且该线程调用`System.exit()`，则必须格外小心。 在这种情况下，必须确保在调用`System.exit()`之前测试未完成。

测试要覆盖的类

``` java
public class AppWithExit {
  public static String message;

  public static void doSomethingAndExit() {
    message = "exit ...";
    System.exit(1);
  }

  public static void doNothing() {
  }
}
```

测试

``` java
public class AppWithExitTest {
  @Rule
  public final ExpectedSystemExit exit = ExpectedSystemExit.none();

  @Test
  public void exits() {
    exit.expectSystemExit();
    AppWithExit.doSomethingAndExit();
  }

  @Test
  public void exitsWithStatusCode1() {
    exit.expectSystemExitWithStatus(1);
    AppWithExit.doSomethingAndExit();
  }

  @Test
  public void writesMessage() {
    exit.expectSystemExitWithStatus(1);
    exit.checkAssertionAfterwards(new Assertion() {
      public void checkAssertion() {
        assertEquals("exit ...", AppWithExit.message);
      }
    });
    AppWithExit.doSomethingAndExit();
  }

  @Test
  public void systemExitWithStatusCode1() {
    exit.expectSystemExitWithStatus(1);
    AppWithExit.doSomethingAndExit();
  }

  @Test
  public void noSystemExit() {
    AppWithExit.doNothing();
    //passes
  }
}
```

### 环境变量

如果需要设置环境变量，那么使用`EnvironmentVariables`规则。它完成了设置环境变量的所有繁琐工作，并在测试后恢复你的更改。

``` java
public class EnvironmentVariablesTest {
  @Rule
  public final EnvironmentVariables environmentVariables
    = new EnvironmentVariables();

  @Test
  public void setEnvironmentVariable() {
    environmentVariables.set("name", "value");
    assertEquals("value", System.getenv("name"));
  }
}
```

如果你的测试需要一些环境变量不存在，那么你可以清除它。

``` java
public class EnvironmentVariablesTest {
	@Rule
	public final EnvironmentVariables environmentVariables
		= new EnvironmentVariables();
	
	@Test
	public void setEnvironmentVariable() {
		environmentVariables.clear("first variable", "second variable");
		assertNull(System.getenv("first variable"));
		assertNull(System.getenv("second variable"));
	}
}
```

### 安全管理器

如果你需要一个特殊的安全管理器来测试您的代码，你可以使用`ProvideSecurityManager`规则来提供它。此规则在整个测试期间将系统的安全管理器替换为你的安全管理器

``` java
public class MyTest {
	private final MySecurityManager securityManager
	 = new MySecurityManager();

	@Rule
	public final ProvideSecurityManager provideSecurityManager
	 = new ProvideSecurityManager(securityManager);

	@Test
	public void overrideProperty() {
		assertEquals(securityManager, System.getSecurityManager());
	}
}
```