# Stage 1: Build with Gradle
FROM gradle:7.6-jdk17 AS builder

WORKDIR /app

# Copy Gradle build files and source code
COPY . .

# Build the application
RUN ./gradlew build --no-daemon

# Stage 2: Run with lightweight Java image
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy only the JAR from the build stage
COPY --from=builder /app/app/build/libs/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
