# 动态架构

## 调用方

![ViewResolver-resolveViewName的调用方](images\ViewResolver-resolveViewName的调用方.png)

## 入口

`DispatcherServlet` 调用 `ViewResolver#resolveViewName`  的入口

![Dispatcher构造View入口](images\Dispatcher构造View入口.png)

## 执行流程

`InternalResourceViewResolver#resolveViewName` 执行流程

``` java
public static void main(String[] args) {
    InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
    viewResolver.setPrefix("WEB-INF/jsp");
    viewResolver.setSuffix(".jsp");
    try {
        viewResolver.resolveViewName("hello", Locale.CHINA);
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
}
```

![InternalResourceViewResolver#resolveViewName执行流程](images\InternalResourceViewResolver-resolveViewName执行流程.png)

