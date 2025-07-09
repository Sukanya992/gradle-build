# Stage 1: Build the application
FROM gradle:7.6-jdk17 AS builder
WORKDIR /app
COPY . .

# Move into the actual Gradle project directory
WORKDIR /app/mygradle/app
RUN gradle build --no-daemon

# Stage 2: Run the application using a smaller image
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/mygradle/app/build/libs/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]


