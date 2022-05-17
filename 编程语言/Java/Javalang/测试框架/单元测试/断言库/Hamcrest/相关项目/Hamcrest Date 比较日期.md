# 比较日期

https://github.com/eXparity/hamcrest-date

## Hamcrest Date 是什么

Hamcrest Date是Java Hamcrest匹配器库的扩展库，它为Java日期类型（包括`LocalDate`，`LocalTime，LocalDateTime`，`ZonedDateTime`和`Date`）提供Matcher实现。

## 引入到项目中

Java8及更新版本

``` xml
<dependency>
    <groupId>org.exparity</groupId>
    <artifactId>hamcrest-date</artifactId>
    <version>2.0.7</version>
</dependency>
```

Java8之前版本

``` xml
<dependency>
    <groupId>org.exparity</groupId>
    <artifactId>hamcrest-date</artifactId>
    <version>1.1.0</version>
</dependency>
```

## 用法

这些匹配器在`LocalDateMatchers`、`LocalTimeMatchers`、`LocalDateTimeMatchers`、`ZonedDateTimeMatchers`、`OffsetDateTimeMatchers`、`SqlDateMatchers`和`DateMatchers`类上作为静态方法公开。例如

``` java
LocalDate today = LocalDate.now();
myBirthday = LocalDate.of(2015, AUGUST, 9);

MatcherAssert.assertThat(today, LocalDateMatchers.sameDay(myBirthday));
```

或者是测试你是否离你的生日越来越近了

``` java
LocalDate today = LocalDate.now();
myBirthday = LocalDate.of(2015, AUGUST, 9);
MatcherAssert.assertThat(today, LocalDateMatchers.within(1, ChronoUnit.DAY, myBirthday));
```

或者在静态导入之后

``` java
LocalDate today = LocalDate.now();
myBirthday = LocalDate.of(2015, AUGUST, 9);
assertThat(today, within(1, DAY, myBirthday));
```

所有日期类型都可以使用相同的匹配器，以便匹配`LocalDateTime`值:

``` java
LocalDateTime myAppointment = LocalDateTime.of(2015, AUGUST, 9, 10, 30, 0);
assertThat(LocalDateTime.now(), within(15, MINUTES, myAppointment));
```

或匹配`ZonedDateTime`的值:

``` java
ZonedDateTime myAppointment = ZonedDateTime
    .of(LocalDateTime.of(2015, AUGUST, 9, 10, 30, 0), ZoneId.of("UTC"));
assertThat(ZonedDateTime.now(), within(15, MINUTES, myAppointment));
```

或匹配`OffsetDateTime`的值:

``` java
OffsetDateTime myAppointment = OffsetDateTime
    .of(LocalDateTime.of(2015, AUGUST, 9, 10, 30, 0), ZoneOffset.UTC);
assertThat(OffsetDateTime.now(), within(15, MINUTES, myAppointment));
```

或匹配`LocalTime`的值:

``` java
LocalTime myAppointment = LocalTime.NOON;
assertThat(LocalTime.now(), within(15, MINUTES, myAppointment));
```

或匹配`java.sql.Date`的值:

``` java
java.sql.Date myAppointment = java.sql.Date.valueOf(LocalDate.of(2015, AUGUST, 9);
assertThat(new java.sql.Date(), within(15, MINUTES, myAppointment));
```

该库包括以下日期匹配器：

- **after** - Test if the actual date is after the reference date
- **before** - Test if the actual date is before the reference date
- **within** - Test if the actual date is within a given period (before or after) of the reference date
- **sameDay** - Test if the actual date is on the same day as the reference date
- **sameHourOfDay** - Test if the actual date is on the same hour of the day as the reference date
- **sameInstant** - Test if the actual date at the same instance as the reference date
- **sameOrBefore** - Test if the actual date is the same or before the reference date
- **sameOrAfter** - Test if the actual date is the same or after the reference date
- **sameMinuteOfHour** - Test if the actual date is on the same minute of the hour as the reference date
- **sameMonthOfYear** - Test if the actual date is on the same month of the year as the reference date
- **sameSecondOfMinute** - Test if the actual date is on the same second of the minute as the reference date
- **sameDayOfWeek** - Test if the actual date is on the same week day as the reference date
- **sameYear** - Test if the actual date is on the same year as the reference date
- **isInstance** - Test if the actual date is at the exact instant
- **isSecond** - Test if the actual date is on the given second
- **isMinute** - Test if the actual date is on the given minute
- **isHour** - Test if the actual date is on the given hour
- **isDayOfWeek** - Test if the actual date is on the given day of the week
- **isDayOfMonth** - Test if the actual date is on the given day of the month
- **isMonth** - Test if the actual date is on the given month
- **isYear** - Test if the actual date is on the given year
- **isYesterday** - Test if the actual date is yesterday
- **isToday** - Test if the actual date is today
- **isTomorrow** - Test if the actual date is tomorrow
- **isMonday** - Test if the actual date is on a monday
- **isTuesday** - Test if the actual date is on a tuesday
- **isWednesday** - Test if the actual date is on a wednesday
- **isThursday** - Test if the actual date is on a thursday
- **isFriday** - Test if the actual date is on a friday
- **isSaturday** - Test if the actual date is on a saturday
- **isSunday** - Test if the actual date is on a sunday
- **isWeekday** - Test if the actual date is on a weekday
- **isWeekend** - Test if the actual date is on a weekend
- **isJanuary** - Test if the actual date is in january
- **isFebruary** - Test if the actual date is in february
- **isMarch** - Test if the actual date is in march
- **isApril** - Test if the actual date is in april
- **isMay** - Test if the actual date is in may
- **isJune** - Test if the actual date is in june
- **isJuly** - Test if the actual date is in july
- **isAugust** - Test if the actual date is in august
- **isSeptember** - Test if the actual date is in september
- **isOctober** - Test if the actual date is in october
- **isNovember** - Test if the actual date is in november
- **isDecember** - Test if the actual date is in december
- **isLeapYear** - Test if the actual date is on a leap year

Javadocs包含所有方法的示例，因此你可以在此处查找特定方法的示例