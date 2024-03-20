# Stage 1: Build the Maven project
FROM maven:3.8.3-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn install

# Copy the rest of the project and build it
COPY . .
RUN mvn package -DskipTests

# Stage 2: Create the final image
FROM openjdk:17.0.1-jdk-slim
WORKDIR /app
COPY --from=build /app/target/test-0.0.1-SNAPSHOT.jar test.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "test.jar"]
