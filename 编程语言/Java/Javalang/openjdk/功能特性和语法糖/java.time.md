# 时期时间库

> `java.time` 

为什么引入新的时期时间库？

原来的时期时间组件：

* 设计混乱，职责不统一
* 易用性糟糕
* 线程安全无保证



## 基本概念

ISO-8601 日历系统是当今世界大部分地区使用的现代民用日历系统。它相当于预测的公历系统，在该系统中，今天的闰年规则适用于所有时间。对于当今编写的大多数应用程序，ISO-8601 规则完全适用。但是，任何使用历史日期并要求它们准确的应用程序都会发现 ISO-8601 方法不适合。

### 年表

`java.time.chrono.Chronology`

表示一个日历系统，用于组织和识别日期。

主要的日期和时间 API 建立在 ISO 日历系统之上。**年表在幕后运作，代表日历系统的一般概念**。比如日本人、伪民国人、泰国佛教徒等。

大多数其他**日历系统也在年、月和日的共享概念上运行**，与地球围绕太阳的周期和月球围绕地球的周期相关联。这些共享概念由`ChronoField` 定义，可供任何 `Chronology` 实现使用：

``` java
LocalDate isoDate = ...
ThaiBuddhistDate thaiDate = ...
int isoYear = isoDate.get(ChronoField.YEAR);
int thaiYear = thaiDate.get(ChronoField.YEAR);
```

如图所示，尽管日期对象位于不同的日历系统中，由不同的 `Chronology` 实例表示，但两者都可以使用 `ChronoField` 上的相同常量进行查询。有关此含义的完整讨论，请参阅 `ChronoLocalDate` 。一般来说，建议是使用已知的基于 ISO 的 `LocalDate` ，而不是 `ChronoLocalDate` 。
虽然 `Chronology` 对象通常使用 `ChronoField` 并基于日期的 `era`、`year-of-era`、`month-of-year`、`day-of-month`模型，但这不是必需的。一个 `Chronology` 实例可能代表一种完全不同的日历系统，例如玛雅。
实际上， `Chronology` 实例也**充当工厂**。 `of(String)` 方法允许通过标识符查找实例，而 `ofLocale(Locale)` 方法允许通过区域设置查找。
`Chronology` 实例提供了一组方法来创建 `ChronoLocalDate` 实例。日期类用于操作特定日期。

#### 添加新日历

可用年表的集合可以由应用程序扩展。添加新的日历系统需要编写 `Chronology` 、 `ChronoLocalDate` 和 `Era` 的实现。大多数特定于日历系统的逻辑将在 `ChronoLocalDate` 实现中。 `Chronology` 实现就像一个工厂。
为了允许发现其他年表，使用了 `ServiceLoader` 。必须在 `META-INF/services` 目录中添加一个名为 `java.time.chrono.Chronology` 的文件，其中列出了实现类。有关服务加载的更多详细信息，请参阅 `ServiceLoader`。对于按 `id` 或 `calendarType` 查找，首先找到系统提供的日历，然后是应用程序提供的日历。
每个年表必须定义一个在系统内唯一的年表 ID。如果年表表示由 CLDR 规范定义的日历系统，则日历类型是 CLDR 类型和（如果适用）CLDR 变体的串联。

#### 内置实现类图

<img src="images\Chronology-子级类图.png" alt="Chronology-子级类图" style="zoom: 43%;" />

### 时代

> `java.time.chrono.Era`

表示时间线的一个时代。
大多数日历系统都有一个单独的纪元，将时间线分为两个时代。然而，一些历法系统有多个时代，例如每个领导人在位的时代。在所有情况下，时代在概念上都是时间线的最大划分。每个年表定义了已知时代的时代和一个 `Chronology.eras` 以获得有效时代。
例如，泰国佛教历法系统将时间分为两个时代，一个日期之前和之后。相比之下，日本的历法系统对每一位天皇的统治都有一个时代。

<img src="images\Era-类图.png" alt="Era-类图" style="zoom:50%;" />



### 框架级接口

#### `TemporalAccessor`

> `java.time.temporal.TemporalAccessor`

框架级接口，**定义对时间对象的只读访问**，例如日期、时间、偏移量或这些的某种组合。
这是日期、时间和偏移对象的**基本接口类型**。它由那些可以提供信息作为字段或查询的类来实现。
大多数日期和时间信息都可以表示为数字。这些是使用 `TemporalField` 建模的，使用 `long` 保存的数字来处理大值。`Year`、`month`  和 `day-of-month` 是字段的简单示例，但它们也包括 `instant` 和 `offsets`。有关标准字段集，请参阅 `ChronoField` 。
两条日期/时间信息不能用数字表示，年表和时区。这些可以通过使用 `TemporalQuery` 上定义的静态方法的查询来访问。
子接口 `Temporal` 将此定义扩展到还支持对更完整的时间对象进行调整和操作的接口。
该接口是框架级接口，**不应在应用程序代码中广泛使用**。相反，应用程序应该创建和传递具体类型的实例，例如 `LocalDate` 。造成这种情况的原因有很多，其中一部分是该接口的实现可能在 ISO 以外的日历系统中。有关这些问题的更全面讨论，请参阅`java.time.chrono.ChronoLocalDate` 。

##### `isSupported`

``` java
boolean isSupported(TemporalField field);
```

**检查是否支持指定的字段**。
这将检查是否可以查询指定字段的日期时间。如果为 `false`，则调用 `range` 和 `get` 方法将引发异常。

实现要求：
实现必须检查和处理 `ChronoField` 中定义的所有字段。如果支持该字段，则必须返回 `true`，否则必须返回 `false`。
如果该字段不是 `ChronoField` ，则通过调用 `TemporalField.isSupportedBy(TemporalAccessor)` 将 `this` 作为参数传递来获得此方法的结果。
实现必须确保在调用此只读方法时不会更改可观察到的状态。

##### `range`

``` java
default ValueRange range(TemporalField field) {
    if (field instanceof ChronoField) {
        if (isSupported(field)) {
            return field.range();
        }
        throw new UnsupportedTemporalTypeException("Unsupported field: " + field);
    }
    Objects.requireNonNull(field, "field");
    return field.rangeRefinedBy(this);
}
```

**获取指定字段的有效值范围**。
所有字段都可以表示为一个 `long` 整数。此方法返回一个对象，该对象描述该值的有效范围。此时间对象的值用于增强返回范围的准确性。如果日期时间无法返回范围，因为该字段不受支持或其他原因，将引发异常。
请注意，结果仅描述了最小和最大有效值，重要的是不要过多地阅读它们。例如，范围内可能存在对该字段无效的值。

实现要求：
实现必须检查和处理 `ChronoField` 中定义的所有字段。如果支持该字段，则必须返回该字段的范围。如果不受支持，则必须抛出`UnsupportedTemporalTypeException` 。
如果该字段不是 `ChronoField` ，则通过调用 `TemporalField.rangeRefinedBy(TemporalAccessorl)` 将 `this` 作为参数传递来获得此方法的结果。
实现必须确保在调用此只读方法时不会更改可观察到的状态。

##### `get`

``` java
default int get(TemporalField field) {
    ValueRange range = range(field);
    if (range.isIntValue() == false) {
        throw new UnsupportedTemporalTypeException("Invalid field " + field + " for get() method, use getLong() instead");
    }
    long value = getLong(field);
    if (range.isValidValue(value) == false) {
        throw new DateTimeException("Invalid value for " + field + " (valid values " + range + "): " + value);
    }
    return (int) value;
}
```

以 `int` 形式获取指定字段的值。
这会查询指定字段的值的日期时间。返回的值将始终在该字段的有效值范围内。如果日期时间不能返回值，因为该字段不受支持或其他原因，将抛出异常。

实现要求：
实现必须检查和处理 `ChronoField` 中定义的所有字段。如果该字段受支持并且具有 `int` 范围，则必须返回该字段的值。如果不受支持，则必须抛出 `UnsupportedTemporalTypeException` 。
如果该字段不是 `ChronoField` ，则通过调用 `TemporalField.getFrom(TemporalAccessor)` 将 `this` 作为参数传递来获得此方法的结果。
实现必须确保在调用此只读方法时不会更改可观察到的状态。

##### `getLong`

以 `long` 形式获取指定字段的值。
这会查询指定字段的值的日期时间。返回的值可能超出该字段的有效值范围。如果日期时间不能返回值，因为该字段不受支持或其他原因，将抛出异常。

实现要求：
实现必须检查和处理 `ChronoField` 中定义的所有字段。如果支持该字段，则必须返回该字段的值。如果不受支持，则必须抛出`UnsupportedTemporalTypeException` 。
如果该字段不是 `ChronoField` ，则通过调用 `TemporalField.getFrom(TemporalAccessor)` 将 `this` 作为参数传递来获得此方法的结果。
实现必须确保在调用此只读方法时不会更改可观察到的状态。

##### `query`

``` java
default <R> R query(TemporalQuery<R> query) {
    if (query == TemporalQueries.zoneId()
        || query == TemporalQueries.chronology()
        || query == TemporalQueries.precision()) {
        return null;
    }
    return query.queryFrom(this);
}
```

查询此日期时间。
这将**使用指定的查询策略对象查询此日期时间**。
查询是从日期时间中提取信息的关键工具。根据策略设计模式，它们的存在是为了**将查询过程外部化**，允许不同的方法。示例可能是检查日期是否是闰年 2 月 29 日之前的一天的查询，或者计算距您下一个生日的天数。
最常见的查询实现是方法引用，例如 `LocalDate::from` 和 `ZoneId::from` 。附加实现作为 `TemporalQuery` 上的静态方法提供。

实现要求：

未来版本允许向 `if` 语句添加更多查询。
所有实现此接口并覆盖此方法的类都必须调用 `TemporalAccessor.super.query(query)` 。如果 JDK 类提供与默认行为等效的行为，则它们可能会避免调用 `super` ，但是非 JDK 类可能不会使用此优化并且必须调用 `super`。
如果实现可以为默认实现的 `if` 语句中列出的查询之一提供值，那么它必须这样做。例如，存储小时和分钟的应用程序定义的 `HourMin` 类必须重写此方法，如下所示：

``` java
if (query == TemporalQueries.precision()) {
    return MINUTES;
}
return TemporalAccessor.super.query(query);
```

实现必须确保在调用此只读方法时不会更改可观察到的状态。

#### `Temporal`

框架级接口，**定义对时间对象的读写访问**，例如日期、时间、偏移量或这些的某种组合。
这是日期、时间和偏移量对象的**基本接口类型**，它们足够完整，可以使用 `plus` 和 `minus` 进行操作。它由那些可以提供和操作信息作为字段或查询的类来实现。有关此接口的只读版本，请参阅 `TemporalAccessor` 。
大多数日期和时间信息都可以表示为数字。这些是使用 `TemporalField` 建模的，使用 `long` 保存的数字来处理大值。`Year`、`month`  和 `day-of-month` 是字段的简单示例，但它们也包括 `instant` 和 `offsets`。有关标准字段集，请参阅 `ChronoField` 。
两条 `date/time` 信息不能用数字表示，年表和时区。这些可以通过使用 `TemporalQuery` 上定义的静态方法的 `queries` 来访问。
该接口是框架级接口，**不应在应用程序代码中广泛使用**。相反，应用程序应该创建和传递具体类型的实例，例如 `LocalDate` 。造成这种情况的原因有很多，其中一部分是该接口的实现可能在 ISO 以外的日历系统中。有关这些问题的更全面讨论，请参阅`java.time.chrono.ChronoLocalDate` 。

##### 何时实施

如果一个类满足三个条件，就应该实现这个接口：

* 根据 `TemporalAccessor` ，它提供对日期/时间/偏移信息的访问
* 字段集从最大到最小是连续的
* 字段集是完整的，因此不需要其他字段来定义所表示字段的有效值范围

四个例子说明了这一点：

* `LocalDate` 实现此接口，因为它表示一组从天数到永远连续的字段，并且不需要外部信息来确定每个日期的有效性。因此，它能够正确实现加/减。
* `LocalTime` 实现了这个接口，因为它代表了一组从纳秒到几天内连续的字段，并且不需要外部信息来确定有效性。通过环绕一天，它能够正确地实现加/减。
* `MonthDay` 是 `month-of-year` 和 `day-of-month` 的组合，不实现此接口。虽然组合是连续的(从年中的天数到月)，但该组合没有足够的信息来定义每月的天数的有效值范围。因此，它无法正确实现加/减。
* `day-of-week` 和 `day-of-month` 的组合（"Friday the 13th"）不应实现此接口。它不代表一组连续的字段，因为 `days to weeks` 与 `days to months` 重叠。

实现要求：
此接口对实现的可变性没有任何限制，但强烈建议使用不变性。所有实现必须是 `Comparable` 。

##### `isSupported`

``` java
boolean isSupported(TemporalUnit unit);
```

**检查是否支持指定的单位**。
这将检查指定的单位是否可以添加到此日期时间或从中减去。如果为 `false`，则调用 `plus(long, TemporalUnit)` 和 `minus` 方法将引发异常。

实现要求：
实现必须检查和处理 `ChronoUnit` 中定义的所有单位。如果支持单位，则必须返回 `true`，否则必须返回 `false`。
如果该字段不是 `ChronoUnit` ，则通过调用 `TemporalUnit.isSupportedBy(Temporal)` 将 `this` 作为参数传递来获得此方法的结果。
实现必须确保在调用此只读方法时不会更改可观察到的状态。

##### `with-TemporalAdjuster`

``` java
default Temporal with(TemporalAdjuster adjuster) {
    return adjuster.adjustInto(this);
}
```

返回与此对象具有相同类型的**已调整对象**，并进行了调整。
这将根据指定调整器的规则调整此日期时间。一个简单的调整器可能会简单地设置其中一个字段，例如年份字段。更复杂的调整器可能会将日期设置为该月的最后一天。 `TemporalAdjuster`s 中提供了一系列常用调整。其中包括查找“本月的最后一天”和“下周三”。调节器负责处理特殊情况，例如不同的月份长度和闰年。
一些示例代码说明了如何以及为什么使用此方法：

``` java
date = date.with(Month.JULY);        // most key classes implement TemporalAdjuster
date = date.with(lastDayOfMonth());  // static import from Adjusters
date = date.with(next(WEDNESDAY));   // static import from Adjusters and DayOfWeek
```

实现要求：

实现不得更改此对象或指定的时间对象。相反，必须返回原件的调整副本。这为不可变和可变实现提供了等效的安全行为。

##### `with-TemporalField`

``` java
Temporal with(TemporalField field, long newValue);
```

##### `plus-TemporalAmount`

``` java
default Temporal plus(TemporalAmount amount) {
    return amount.addTo(this);
}
```



##### `plus-TemporalUnit`

``` java
Temporal plus(long amountToAdd, TemporalUnit unit);
```

##### `minus-TemporalAmount`

``` java
default Temporal minus(TemporalAmount amount) {
    return amount.subtractFrom(this);
}
```

##### `minus-TemporalUnit`

``` java
default Temporal minus(long amountToSubtract, TemporalUnit unit) {
    return (amountToSubtract == Long.MIN_VALUE ? plus(Long.MAX_VALUE, unit).plus(1, unit) : plus(-amountToSubtract, unit));
}
```

##### `until`

``` java
long until(Temporal endExclusive, TemporalUnit unit);
```

**根据指定的单位计算直到另一个时间的时间量。**
这会根据单个 `TemporalUnit` 计算两个时间对象之间的时间量。起点和终点是 `this` 和指定的时间。如果不同，终点将转换为与起点相同的类型。如果结束在开始之前，结果将为负数。例如，可以使用 `startTime.until(endTime, HOURS)` 计算两个时间对象之间的小时数。
计算返回一个整数，表示**两个时间之间的完整单元数**。例如，时间 `11:30`  和 `13:29` 之间的小时数将只有一小时，因为它比两小时短一分钟。
有两种等效的方法可以使用此方法。第一种是直接调用这个方法。第二种是使用 `TemporalUnit.between(Temporal, Temporal)` ：

``` java
// these two lines are equivalent
temporal = start.until(end, unit);
temporal = unit.between(start, end);
```

应该根据使代码更具可读性来做出选择。
例如，此方法允许计算两个日期之间的天数：

``` java
long daysBetween = start.until(end, DAYS);
// or alternatively
long daysBetween = DAYS.between(start, end);
```

实现要求：
实现必须首先检查以确保输入时间对象与实现具有相同的可观察类型。然后，他们必须对 `ChronoUnit` 的所有实例执行计算。对于 `UnsupportedTemporalTypeException` 的 `ChronoUnit` 实例，必须抛出 `UnsupportedTemporalTypeException`。
如果单位不是 `ChronoUnit` ，则通过调用 `TemporalUnit.between(Temporal, Temporal)` 将this作为第一个参数传递，将转换后的输入时间作为第二个参数传递来获得此方法的结果。
总之，实现必须以与此伪代码等效的方式运行：

``` java
// convert the end temporal to the same type as this class
if (unit instanceof ChronoUnit) {
    // if unit is supported, then calculate and return result
    // else throw UnsupportedTemporalTypeException for unsupported units
}
return unit.between(this, convertedEndTemporal);
```

请注意，只有当两个时间对象具有由 `getClass()` 评估的完全相同的类型时，才必须调用单元的 `between` 方法。
实现必须确保在调用此只读方法时不会更改可观察到的状态。

#### `TemporalAdjuster`

调整时间对象的策略。
调整器是修改时间对象的关键工具。它们的存在是为了将调整过程外部化，根据策略设计模式允许不同的方法。示例可能是将日期设置为避免周末的调整器，或者将日期设置为该月的最后一天的调整器。
有两种使用 `TemporalAdjuster` 的等效方法。第一种是直接调用这个接口上的方法。第二种是使用 `Temporal.with(TemporalAdjuster)` ：

``` java
// these two lines are equivalent, but the second approach is recommended
temporal = thisAdjuster.adjustInto(temporal);
temporal = temporal.with(thisAdjuster);
```

建议使用第二种方法 `with(TemporalAdjuster)` ，因为它在代码中阅读起来更清晰。
`TemporalAdjuster`s 类包含一组标准的调整器，可作为静态方法使用。

##### `adjustInto`

``` java
Temporal adjustInto(Temporal temporal);
```

## 用户接口

`ChronoField`

`ChronoUnit`

`IsoFields`

