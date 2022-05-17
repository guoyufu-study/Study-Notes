# SDKMAN!

## 安装SDKMAN! 软件开发包管理器

官方网站：https://sdkman.io/

### 安装并校验

> 需要提前安装 `zip` 和 `unzip` 工具

``` bash
export SDKMAN_DIR="/usr/local/sdkman" && curl -s "https://get.sdkman.io" | bash
source "/root/.sdkman/bin/sdkman-init.sh"
sdk help
```



## 安装 JAVA

``` bash
sdk ls java
sdk install java 17.0.2-tem
sdk install java 11.0.14-tem
```

> JBake (2.6.7)                                                  http://jbake.org/
>
> JBake是一个面向开发者和设计师的基于Java的开源静态网站/博客生成器。
> 
>***
> 
>JBang (0.87.0)                              http://github.com/maxandersen/jbang/
> 
>JBang使得使用Java编写脚本变得很容易。它允许您使用单个文件进行代码和依赖关系管理，并允许您直接运行它。
> 
> ***
> 
> JDK Mission Control (8.1.1.51-zulu)https://www.oracle.com/java/technologies/jdk-mission-control.html
> 
> Java Flight Recorder和JDK Mission Control共同创建了一个完整的工具链，用于持续收集底层和详细的运行时信息，使事后事件分析成为可能。JDK任务控制是一套先进的工具，能够对Java飞行记录器收集的大量数据进行高效和详细的分析。该工具链使开发人员和管理员能够从本地运行或部署在生产环境中的Java应用程序中收集和分析数据。
> 
>

## 安装 Groovy

``` bash
sdk ls groovy
sdk install groovy 3.0.9
```

> **GroovyServ**
>
> `GroovyServ`大大减少了运行Groovy的JVM的启动时间。 这取决于您的环境，但在大多数情况下，它比常规Groovy快10到20倍。  

## 安装 MAVEN

``` bash
sdk ls maven
sdk install maven 3.8.4
```

> **Maven Daemon**
>
> mvnd项目旨在为基于maven的构建提供守护进程基础设施。 它借鉴了Gradle和Takari的技术，提供了一个简单高效的系统。  



## 安装 Tomcat


``` bash
sdk ls tomcat
sdk install tomcat 9.0.40
```



## 安装 Apache ActiveMQ



## 安装 Ant



## 安装 AsciidoctorJ



## 安装 

