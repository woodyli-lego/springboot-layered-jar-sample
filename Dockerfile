FROM eclipse-temurin:21.0.5_11-jdk as JAR_EXTRACT
WORKDIR /workspace
COPY ./target/*.jar /workspace/app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --launcher

FROM eclipse-temurin:21.0.5_11-jdk as FINAL
WORKDIR /application
COPY --from=JAR_EXTRACT /workspace/app/dependencies ./
COPY --from=JAR_EXTRACT /workspace/app/spring-boot-loader ./
COPY --from=JAR_EXTRACT /workspace/app/snapshot-dependencies ./
COPY --from=JAR_EXTRACT /workspace/app/application ./

ENV APP_JVM_OPTS=""
ENV APP_MAIN_ARGS=""
ENTRYPOINT ["sh", "-c", "java -Duser.timezone=UTC $APP_JVM_OPTS org.springframework.boot.loader.launch.JarLauncher $APP_MAIN_ARGS"]