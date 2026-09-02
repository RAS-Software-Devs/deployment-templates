FROM eclipse-temurin:25-jdk-jammy as build
WORKDIR /src
COPY pom.xml ./
COPY src ./src
RUN apt-get update && apt-get install -y maven && mvn -DskipTests package

FROM eclipse-temurin:25-jdk-jammy
WORKDIR /app
COPY --from=build /src/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["/usr/bin/java","-jar","/app/app.jar"]
