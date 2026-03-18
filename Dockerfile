# Stage 1 - Build
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app
COPY app/pom.xml .
RUN mvn dependency:go-offline
COPY app/src ./src
RUN mvn clean package -DskipTests

# Stage 2 - Run
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/studentapp-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
