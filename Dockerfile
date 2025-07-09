# Stage 1: Build using Gradle image
FROM gradle:7.6-jdk17 AS builder
WORKDIR /app

# Copy source code
COPY . .

# Run build
RUN gradle build --no-daemon

# Stage 2: Create lightweight image with only the JAR
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built JAR with fixed name
COPY --from=builder /app/build/libs/app.jar app.jar

# Expose port (optional, depending on your app)
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

