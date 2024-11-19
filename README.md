# springboot layered jar sample

## 参考

- https://jskim1991.medium.com/spring-boot-3-ways-of-dockerizing-spring-boot-application-29a905dd5a5a
- https://medium.com/viascom/spring-boot-3-2-x-jarlauncher-path-a3656f8e69b4

## 操作顺序

1. 构建 jar

执行 `mvn clean package`，在 `target` 目录下生成 `layered-jar-1.0-SNAPSHOT.jar`。

2. 观察 jar 的分层结构

执行以下命令，观察 jar 的结构:

```shell
java -Djarmode=tools -jar ./target/layered-jar-1.0-SNAPSHOT.jar list-layers
```

输出为：

```
dependencies
spring-boot-loader
snapshot-dependencies
application
```

3. 把 jar 的分层解压出来

执行以下命令

```shell
cd target
java -Djarmode=tools -jar layered-jar-1.0-SNAPSHOT.jar extract --layers --launcher
```

随后可以看到， jar 文件的内容解压到了 `target/layered-jar-1.0-SNAPSHOT`，
并且分成了 `dependencies`、`spring-boot-loader`、`snapshot-dependencies`、`application` 四个目录。

4. 构建 docker 镜像

git

```shell
docker build -t sample/layered-jar .
```

5. 通过 docker 启动应用

```shell
docker run -p 8080:8080 sample/layered-jar
```

## 小结

和之前在 mvn package 的时候就分层不一样，springboot 推荐的操作方式，是 build fat-jar，然后在构建 docker image 时，再从 fat-jar
中解压出分层结构。

这样可以达到 build thin-jar 的目的，同时在开发时又避免了由于分层导致的一系列问题
（例如需要手动指定 main class，例如 swagger generator plugin 无法工作等）。