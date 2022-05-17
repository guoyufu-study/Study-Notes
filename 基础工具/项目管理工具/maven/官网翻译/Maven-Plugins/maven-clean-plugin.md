# Maven 清理插件

>https://maven.apache.org/plugins/maven-clean-plugin/

清理 Maven 在构建期间生成的文件和目录。虽然存在生成其他文件的插件，但是清理插件假定这些生成的文件在`target`目录中。

## 最新版本

``` xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-clean-plugin</artifactId>
    <version>3.1.0</version>
</plugin>
```

## 常见工作流

### 构建时自动运行清理插件

比如，将其绑定到 `initialize` 阶段：

``` xml
<project>
    [...]
    <build>
        <plugins>
            <plugin>
                <artifactId>maven-clean-plugin</artifactId>
                <version>3.1.0</version>
                <executions>
                    <execution>
                        <id>auto-clean</id>
                        <phase>initialize</phase>
                        <goals>
                            <goal>clean</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
    [...]
</project>
```



### 删除未暴露给Maven的其他文件

默认情况下，清理插件发现并删除配置在 `project.build.directory`、`project.build.outputDirectory`、`project.build.testOutputDirectory`，和 `project.reporting.outputDirectory` 中的目录。

除了默认目录外，要删除的文件集列表。比如：

``` xml
<build>
    [...]
    <plugin>
        <artifactId>maven-clean-plugin</artifactId>
        <version>3.1.0</version>
        <configuration>
            <filesets>
                <fileset>
                    <directory>some/relative/path</directory>
                    <includes>
                        <include>**/*.tmp</include>
                        <include>**/*.log</include>
                    </includes>
                    <excludes>
                        <exclude>**/important.log</exclude>
                        <exclude>**/another-important.log</exclude>
                    </excludes>
                    <followSymlinks>false</followSymlinks>
                </fileset>
            </filesets>
        </configuration>
    </plugin>
    [...]
</build>
```

