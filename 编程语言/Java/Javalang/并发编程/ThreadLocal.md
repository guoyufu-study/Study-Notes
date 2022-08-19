# `ThreadLocal`

> `java.lang.ThreadLocal`

目标：提供线程局部变量，实现类状态线程间隔离。

`ThreadLocal` 类提供线程局部变量。线程通过 `ThreadLocal` 的 `get` 或 `set` 方法来访问变量。这些变量与普通变量的不同之处在于，**每个访问变量的线程都有它自己的、独立初始化的变量副本**。`ThreadLocal` 实例通常是**类中的私有静态字段**，希望通过使用这个`ThreadLocal` 实例将类状态与线程关联（比如，用户 ID 或事务 ID）。
例如，下面的类生成每个线程本地的唯一标识符。线程的 id 在第一次调用 `ThreadId.get()` 时被分配，并且在后续调用中保持不变。

```java
import java.util.concurrent.atomic.AtomicInteger;

public class ThreadId {
    // Atomic integer containing the next thread ID to be assigned
    private static final AtomicInteger nextId = new AtomicInteger(0);
    // Thread local variable containing each thread's ID
    private static final ThreadLocal<Integer> threadId =
        new ThreadLocal<Integer>() {
        @Override protected Integer initialValue() {
            return nextId.getAndIncrement();
        }
    };

    // Returns the current thread's unique ID, assigning it if necessary
    public static int get() {
        return threadId.get();
    }
}
```
只要线程处于活动状态并且 `ThreadLocal` 实例是可访问的，每个线程都持有对其线程局部变量副本的隐式引用；在线程消失后，除非存在对这些副本的其他引用，否则这个线程的所有 `ThreadLocal` 实例副本都将被垃圾回收。

## 具体应用

### 源码框架

Spring 采用 `Threadlocal`，来保证单个线程中的数据库操作使用的是同一个数据库连接，同时，采用这种方式可以使业务层使用事务时不需要感知并管理 `connection` 对象，通过传播级别，巧妙地管理多个事务配置之间的切换，挂起和恢复。

### 自用代码

`SimpleDataFormat` 不是线程安全的，JDK 8 之前，多线程场景下，调用 `parse()` 方法解析日期，会出现问题。解决方案：每个线程都一个自己的 `SimpleDataFormat` 实现。

``` java
private static final ThreadLocal<SimpleDateFormat> sdf =
                ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyy-MM-dd"));
```

具体来说：线程池结合 `ThreadLocal`。`ThreadLocal` 解决线程安全问题，线程池解决性能问题。

过度传参的场景，也可以使用。

## 底层原理

暴露了四个接口：创建、存值、取值、删值。

![ThreadLocal-暴露的接口](images\ThreadLocal-暴露的接口.png)

### 使用



### 存值

* 获取当前线程
* 获取 `ThreadLocalMap` 对象
* 校验对象是否存在
* 不存在，先创建一个 `ThreadLocalMap`  对象，存值，并让当前线程中的 `threadLocals` 字段引用它。
* 存在，直接存值。

`ThreadLocal` 调用 `get`/`set`/`remove` 时，会委托当前线程持有的 `ThreadLocalMap` 处理。**每个线程都有自己 `ThreadLocalMap` 对象 `threadLocals`，它以 `ThreadLocal` 为键来存取删值**。

### `ThreadLocalMap`

持有一个 `tab` 数组用来存值，数组元素是 `java.lang.ThreadLocal.ThreadLocalMap.Entry` 类型。

`Entry` 类是其内部类，扩展了 `WeakReference` 类型。类中有两个字段，一个 `key`，一个 `value`。 `key` 作为弱引用，引用 `ThreadLocal` 对象。 `value` 作为强引用，引用存储的值。

`ThreadLocalMap` 存取删值时，使用传过来的 `ThreadLocal` 对象持有的 `threadLocalHashCode` 值，来定位索引。每个 `ThreadLocal` 对象都持有一个 `threadLocalHashCode` 值，这个值在创建 `ThreadLocal` 对象时自动生成。

解决哈希通常有四种方案：开放定址、rehash、拉链、提供公共溢出区。

如果在这里发生冲突，使用开放定址法中的线性探测法来解决。

> 开放定址法：在遇到哈希冲突时，找一个新的空闲的哈希地址来替代。
>
> 线性探测法：找新的空闲哈希地址时，向后找，每次加 `1` 并取模。
>
> 平方探测法：又称二次探测法。找新的空闲哈希地址时，向同时向后前两个方法找，每次加减 x 的平方并取模，其中 `x` 是自然数列。

### `InheritableThreadLocal`

子线程能共享父线程存储的数据。



内存泄漏问题，`remove` 一下就好。**由于 `ThreadLocalMap` 的生命周期跟 `Thread` 一样长，对于重复利用的线程来说，如果没有手动删除（`remove()`方法）对应 `key` ，就会导致 `Entry(null，value)` 的对象越来越多，从而导致内存泄漏．**

