# Spring Data Elasticsearch

>https://spring.io/projects/spring-data-elasticsearch

Spring Data Elasticsearch 项目将核心 Spring 概念应用于使用 Elasticsearch 搜索引擎的解决方案的开发。它提供了：

* `Templates` 用于存储，搜索，排序文档和构建聚合的一个高级抽象。
* `Repositories` 通过定义具有自定义方法名称的接口，使用户能够表达查询。

***

Spring Data 存储库抽象的目标是显著减少为各种持久性存储实现数据访问层所需的样板代码量。



### 核心概念

Spring 数据存储库抽象中的中心接口是 `Repository`。它使用要管理的域类以及域类的 ID 类型作为类型参数。此接口主要充当一个标记接口，用于捕获要使用的类型，并帮助我们发现扩展此接口的接口。`Cruddrepository` 接口为正在管理的实体类提供复杂的 CRUD 功能。

> 我们还提供了特定于持久性技术的抽象，比如`JpaRepository`或`MongoRepository`。这些接口扩展了`CrudRepository`，并且公开了底层持久性技术的功能，以及与持久性技术无关的相当通用的接口(如`CrudRepository`)。

在 `CrudRepository` 之上，还有一个[`PagingAndSortingRepository`](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/PagingAndSortingRepository.html)抽象，它添加了额外的方法来简化对实体的分页访问。

要访问 `User` 的页面大小为 20 的第二页，可以执行以下操作：

``` java
PagingAndSortingRepository<User, Long> repository = // … get access to a bean
Page<User> users = repository.findAll(PageRequest.of(1, 20));
```

除了查询方法之外，还可以使用计数和删除查询的查询派生。

### 查询方法

标准 CRUD 功能存储库通常对底层数据存储进行查询。使用 Spring Data，声明这些查询变成了一个四步过程：

1. 声明一个扩展 Repository 或其子接口之一的接口，并将其键入应处理的域类和 ID 类型。

2. 在接口上声明查询方法。

   ``` java
   interface PersonRepository extends Repository<Person, Long> {
     List<Person> findByLastname(String lastname);
   }
   ```

3. 设置 Spring 以使用[JavaConfig](https://docs.spring.io/spring-data/elasticsearch/docs/current/reference/html/#repositories.create-instances.java-config)或[XML configuration](https://docs.spring.io/spring-data/elasticsearch/docs/current/reference/html/#repositories.create-instances)为这些接口创建代理实例。

   * 要使用 Java 配置，请创建一个类似于以下内容的类：

     ``` java
     import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
     
     @EnableJpaRepositories
     class Config { … }
     ```

   * 要使用 XML 配置，请定义一个类似于以下内容的 bean：

     ``` xml
     <?xml version="1.0" encoding="UTF-8"?>
     <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:jpa="http://www.springframework.org/schema/data/jpa"
        xsi:schemaLocation="http://www.springframework.org/schema/beans
          https://www.springframework.org/schema/beans/spring-beans.xsd
          http://www.springframework.org/schema/data/jpa
          https://www.springframework.org/schema/data/jpa/spring-jpa.xsd">
     
        <jpa:repositories base-package="com.acme.repositories"/>
     
     </beans>
     ```

     此示例中使用了 JPA 命名空间。如果您将存储库抽象用于任何其他存储，则需要将其更改为存储模块的适当命名空间声明。

   4. 注入存储库实例并使用它。

   

### 定义存储库接口

要定义存储库接口，您首先需要定义特定于域类的存储库接口。接口必须扩展`Repository`并输入到域类和 ID 类型。如果要公开该域类型的 CRUD 方法，请扩展`CrudRepository`而不是`Repository`.

通常，您的存储库接口会扩展`Repository`、`CrudRepository`或`PagingAndSortingRepository`。或者，如果您不想扩展 Spring Data 接口，也可以使用`@RepositoryDefinition`注解存储库接口。 扩展`CrudRepository`公开了一整套操作实体的方法。如果您希望对公开的方法有选择性，请将要从 `CrudRepository` 公开的方法复制到您的域存储库中。

> 这样做可以让您在提供的 Spring Data Repositories 功能之上定义自己的抽象。



   
