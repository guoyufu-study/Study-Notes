修改`pom.xml`

增加以下代码：

``` xml
<build>
	<finalName>App</finalName>
	<plugins>
		<plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-shade-plugin</artifactId>
			<version>3.2.1</version>
			<executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                    <configuration>
                        <transformers>
                            <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                <mainClass>App</mainClass>
                            </transformer>
                        </transformers>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

其中的

```xml
<mainClass>App</mainClass>
```

是主函数的类，并要求全路径，比如

```xml
<mainClass>com.project.App</mainClass>
```

然后再次使用maven命令clean、compile、package命令打包，并使用其中类似`App-1.0-SNAPSHOT.jar`的包。

作者：阳光的技术小栈

链接：https://www.jianshu.com/p/72f914a617ec

来源：简书

简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。