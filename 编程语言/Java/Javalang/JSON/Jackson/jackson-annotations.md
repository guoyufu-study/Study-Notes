# jackson-annotations

> https://github.com/FasterXML/jackson-annotations

## JacksonAnnotation

`com.fasterxml.jackson.annotation.JacksonAnnotation` 注解

``` java
/**
 * Meta-annotation (annotations used on other annotations)
 * used for marking all annotations that are
 * part of Jackson package. Can be used for recognizing all
 * Jackson annotations generically, and in future also for
 * passing other generic annotation configuration.
 */
@Target({ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface JacksonAnnotation
{
    // for now, a pure tag annotation, no parameters
}
```

元注解（用于其他注解的注解）用于标记属于 Jackson 包的所有注解。可用于通用识别所有 Jackson 注解，将来还可用于传递其他通用注解配置。

## JsonView

`com.fasterxml.jackson.annotation.JsonView` 注解

``` java
/**
 * Annotation used for indicating view(s) that the property
 * that is defined by method or field annotated is part of.
 *<p>
 * An example annotation would be:
 *<pre>
 *  &#064;JsonView(BasicView.class)
 *</pre>
 * which would specify that property annotated would be included
 * when processing (serializing, deserializing) View identified
 * by <code>BasicView.class</code> (or its sub-class).
 * If multiple View class identifiers are included, property will
 * be part of all of them.
 *<p>
 * Starting with 2.9, it is also possible to use this annotation on
 * POJO classes to indicate the default view(s) for properties of the
 * type, unless overridden by per-property annotation.
 */
@Target({ElementType.ANNOTATION_TYPE, ElementType.METHOD, ElementType.FIELD,
	    ElementType.PARAMETER, // since 2.5
	    ElementType.TYPE // since 2.9, to indicate "default view" for properties
})
@Retention(RetentionPolicy.RUNTIME)
@JacksonAnnotation
public @interface JsonView
```

注解用于**指示由注解方法或注解字段定义的属性所属的视图**。
一个示例注解是：

   ``` java
   @JsonView(BasicView.class)
   ```

这将指定在处理（序列化、反序列化）由 `BasicView.class` （或其子类）标识的 View 时将包含注解的属性。如果包含多个 View 类标识符，则属性将是所有这些标识符的一部分。
从 2.9 开始，也可以在 POJO 类上使用此注解来指示该类型属性的默认视图，除非被每个属性注解覆盖。