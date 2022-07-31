# Banner 横幅





## 类层次结构

![Banner 的子类型](images\Banner的子类型.png)



### Banner

`org.springframework.boot.Banner`

用于以编程方式编写横幅的接口类。

![Banner 类结构](images\Banner类结构.png)

`Banner` 是 `@FunctionalInterface`，只定义了一个方法 `printBanner`，该方法用于将横幅打印到指定的打印流。

`Mode` 是枚举类，用于配置横幅的可能值的枚举。它有三个值，分别是：

* `OFF` ：禁用横幅的打印。
* `CONSOLE` ：将横幅打印到 `System.out`。
* `LOG` ：将横幅打印到日志文件。

### SpringBootBanner

默认横幅实现，写出 `Spring` 横幅。

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.7.2)

```

### PrintedBanner

> `org.springframework.boot.SpringApplicationBannerPrinter.PrintedBanner`

允许再次打印Banner而不需要指定源类的装饰器。

### Banners

> `org.springframework.boot.SpringApplicationBannerPrinter.Banners`

Banner 由其他 Banners 组成。

持有字段 `banners`

``` java
private final List<Banner> banners = new ArrayList<>();
```



### ResourceBanner

> `org.springframework.boot.ResourceBanner`

从源文本 Resource 打印的横幅实现。



### ImageBanner

> `org.springframework.boot.ImageBanner`

打印从图像资源Resource生成的 ASCII 艺术的横幅实现。



## 打印 Banner 流程

![打印 Banner 流程](images\Banner流程.png)

### 启动类

``` java
@SpringBootApplication
public class FirstBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(FirstBootApplication.class, args);
    }

}
```

下图的方法被调用。

![方法调用层次结构2](images\Banner-方法调用层次结构-02.png)

### SpringApplication 类

实例方法 `SpringApplication#run(String... args)` 中，第 304 行代码是**打印 Banner 的入口**。

``` java
Banner printedBanner = printBanner(environment);
```

私有方法 `SpringApplication#printBanner` 源码，如下：

``` java
private Banner printBanner(ConfigurableEnvironment environment) {
    // 禁用横幅打印
    if (this.bannerMode == Banner.Mode.OFF) {
        return null;
    }
    ResourceLoader resourceLoader = (this.resourceLoader != null) ? this.resourceLoader
        : new DefaultResourceLoader(null);
    SpringApplicationBannerPrinter bannerPrinter = new SpringApplicationBannerPrinter(resourceLoader, this.banner);
    // 将横幅打印到日志文件
    if (this.bannerMode == Mode.LOG) {
        return bannerPrinter.print(environment, this.mainApplicationClass, logger);
    }
    // 将横幅打印到 System.out （默认）
    return bannerPrinter.print(environment, this.mainApplicationClass, System.out);
}
```

> 在 `application.yml` 中**使用 `spring.main.banner-mode` 配置**。
>
> 启动过程中，在 `SpringApplication#run(String... args)` 方法中，第 304 行代码 `ConfigurableEnvironment environment = prepareEnvironment(listeners, bootstrapContext, applicationArguments);` 执行时，反射调用 `SpringApplication#setBannerMode(Banner.Mode bannerMode)` 方法设置。

### SpringApplicationBannerPrinter 类

> SpringApplication 用来打印应用程序横幅的类。

打印横幅的动作，由实例方法 `SpringApplicationBannerPrinter#print` 完成。

``` java
Banner print(Environment environment, Class<?> sourceClass, PrintStream out) {
    // 获取 Banner
    Banner banner = getBanner(environment);
    // 打印
    banner.printBanner(environment, sourceClass, out);
    // 包装，并返回
    return new PrintedBanner(banner, sourceClass);
}
```

`print` 方法执行三个操作：获取 Banner、打印 Banner、返回可再次打印的 Banner。

> `SpringApplicationBannerPrinter.PrintedBanner` 允许再次打印 Banner 而不需要指定源类的装饰器。

`getBanner` 方法源码，如下：

``` java
private Banner getBanner(Environment environment) {
    	// 自定义配置 banners
		Banners banners = new Banners();
		banners.addIfNotNull(getImageBanner(environment));
		banners.addIfNotNull(getTextBanner(environment));
		if (banners.hasAtLeastOneBanner()) {
			return banners;
		}
    	// SpringApplication#setBanner(Banner) 设置
		if (this.fallbackBanner != null) {
			return this.fallbackBanner;
		}
    	// 默认
		return DEFAULT_BANNER;
	}
```

`SpringApplicationBannerPrinter.Banners` 类持有一个 `List<Banner> banners` 字段，表示多个横幅。

* `ImageBanner` 使用 `spring.banner.image.location` 配置，或者默认的 `banner.gif`、`banner.jpg`、`banner.png` 中找到的第一个。
* `ResourceBanner` 使用 `spring.banner.location` 配置，或者默认的 `banner.txt`。

使用 `SpringApplication#setBanner(Banner)` 设置，如下：

``` java
public static void main(String[] args) {
    SpringApplication application = new SpringApplication();
    application.addPrimarySources(List.of(FirstBootApplication.class));

    String location = "classpath:static/banner.txt";
    ResourceLoader resourceLoader = application.getResourceLoader();
    if (resourceLoader == null) resourceLoader = new DefaultResourceLoader(null);
    Resource resource = resourceLoader.getResource(location);
    ResourceBanner resourceBanner = new ResourceBanner(resource);
    application.setBanner(resourceBanner);

    application.run(args);
}
```



默认是 `SpringBootBanner`，由 `SpringApplicationBannerPrinter` 类定义 `private static final Banner DEFAULT_BANNER = new SpringBootBanner();`。



## 示例

### 禁用 Banner

只需要在 `application.yml` 中添加一行配置：

``` yaml
spring:
  main:
    banner-mode: off
```

### 日志 Banner

只需要在 `application.yml` 中添加一行配置：

``` yaml
spring:
  main:
    banner-mode: log
```

### 自定义文本 Banner

> 可以在 http://patorjk.com/software/taag/ 网站生成艺术字 banner。

在 `src/main/resources/` 下，创建 `banner.txt` 文件，添加如下内容：

``` 
spring boot ${spring-boot.formatted-version}
${application.title} ${application.formatted-version}
```

运行 jar 包，将会打印 Banner

``` 
spring boot  (v2.7.2)
first-boot  (v0.0.1-SNAPSHOT)
```

### 自定义图片 Banner

在 `src/main/resources/` 下，添加一个 `banner.jpg` 图片即可。

### 自定义 Banner 位置

比如，将文件放在 `src/main/resources/static/` 目录下，只需要在 `application.yml` 中添加一行配置：

``` yaml
spring:
  banner:
    location: static/banner.txt
    image:
      location: classpath:static/banner.jpg
```

