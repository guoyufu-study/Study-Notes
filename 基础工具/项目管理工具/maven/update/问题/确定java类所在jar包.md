# 确定Java类所在jar包



## ClassLocationUtils类

``` java
ublic class ClassLocationUtils {

    public static String where(final Class clazz) {
        checkClazzIsNull(clazz);

        URL result = null;
        final String clazzAsResource = clazz.getName().replace('.', '/').concat(".class");
        final ProtectionDomain protectionDomain = clazz.getProtectionDomain();
        
        if (protectionDomain != null) {
            
            final CodeSource codeSource = protectionDomain.getCodeSource();
            
            if (codeSource != null) result = codeSource.getLocation();
            
            if (result != null) {
                result = completeClazzName(result, clazzAsResource);
            }
        }
        if (result == null) {
            final ClassLoader clsLoader = clazz.getClassLoader();
            result = clsLoader != null ?
                    clsLoader.getResource(clazzAsResource) :
                    ClassLoader.getSystemResource(clazzAsResource);
        }
        return result.toString();
    }

    private static void checkClazzIsNull(Class clazz) {
        if (clazz == null) {
            throw new IllegalArgumentException("null input: cls");
        }
    }
    
    private static URL completeClazzName(URL result, String clazzAsResource) {
        if ("file".equals(result.getProtocol())) {
            try {
                if (result.toExternalForm().endsWith(".jar") || 
                    result.toExternalForm().endsWith(".zip")) {
                    result = new URL("jar:".concat(result.toExternalForm())
                                     .concat("!/")
                                     .concat(clazzAsResource));
                } else if (new File(result.getFile()).isDirectory()) {
                    result = new URL(result, clazzAsResource);
                }
            } catch (MalformedURLException ignore) {
            }
        }
        return result;
    }
}
```



## ClassLocationUtilsTests 测试类

``` java
public class ClassLocationUtilsTests {

    @Test
    public void testWhereisUserService() { //自定义类
        System.out.println(ClassLocationUtils.where(UserService.class));
        System.out.println(UserService.class
                           .getProtectionDomain()
                           .getCodeSource()
                           .getLocation()
                           .toString());
    }

    @Test
    public void testWhereisBean() {//org.springframework:spring-context.jar包中的类
        System.out.println(ClassLocationUtils.where(Bean.class));
        System.out.println(Bean.class
                           .getProtectionDomain()
                           .getCodeSource()
                           .getLocation()
                           .toString());
    }
}
```



## 测试结果

``` 
file:/F:/java/dubbo/dubbo/enjoy-mvc/target/classes/com/jasper/dubbo/mvc/service/UserService.class
file:/F:/java/dubbo/dubbo/enjoy-mvc/target/classes/


jar:file:/F:/.m2/repository/org/springframework/spring-context/4.0.2.RELEASE/spring-context-4.0.2.RELEASE.jar!/org/springframework/context/annotation/Bean.class
file:/F:/.m2/repository/org/springframework/spring-context/4.0.2.RELEASE/spring-context-4.0.2.RELEASE.jar
```

