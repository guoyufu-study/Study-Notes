# AssertJ

> 原官网地址 http://joel-costigliola.github.io/assertj/  , AssertJ 核心站点已迁移至https://assertj.github.io/doc/
> 这个站点仍然为AssertJ模块维护，直到它们的文档被迁移。

AssertJ 是一个 Java 库，它提供了一组丰富的断言和真正有用的错误消息，提高了测试代码的可读性，并且在您最喜欢的 IDE 中非常易于使用。

## 一分钟指南

### 1 - 获取AssertJ 核心断言

### Maven

```xml
<dependency>
  <groupId>org.assertj</groupId>
  <artifactId>assertj-core</artifactId>
  <!-- use 2.9.1 for Java 7 projects -->
  <version>3.22.0</version>
  <scope>test</scope>
</dependency>
```

### 2 - 添加 AssertJ 方法静态导入

一个静态导入解决所有问题...

```java
import static org.assertj.core.api.Assertions.*;
```

...或者选择多个

```java
import static org.assertj.core.api.Assertions.assertThat;  // main one
import static org.assertj.core.api.Assertions.atIndex; // for List assertions
import static org.assertj.core.api.Assertions.entry;  // for Map assertions
import static org.assertj.core.api.Assertions.tuple; // when extracting several properties at once
import static org.assertj.core.api.Assertions.fail; // use when writing exception tests
import static org.assertj.core.api.Assertions.failBecauseExceptionWasNotThrown; // idem
import static org.assertj.core.api.Assertions.filter; // for Iterable/Array assertions
import static org.assertj.core.api.Assertions.offset; // for floating number assertions
import static org.assertj.core.api.Assertions.anyOf; // use with Condition
import static org.assertj.core.api.Assertions.contentOf; // use with File assertions
```

### 3 - 使用代码补全功能

### 4 - 了解更多

查看AssertJ的一些值得注意的功能， 以充分利用它！ 

可以通过查看AssertJ核心javadoc了解更多信息。

扩展知识的另一种方法是assertj-examples测试项目。它涵盖了运行代码使用AssertJ断言可能实现的功能。你可以克隆存储库并运行其测试!(首先需要运行`mvn install`，因为该项目还展示了如何生成自定义断言。)