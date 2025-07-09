# Use official Gradle image with JDK 17
FROM gradle:7.6-jdk17 as builder

# Set working directory inside the container
WORKDIR /app

# Copy only Gradle wrapper and build files first for better caching
COPY mygradle/gradlew mygradle/gradlew
COPY mygradle/gradle mygradle/gradle
COPY mygradle/build.gradle mygradle/settings.gradle /app/mygradle/

# Download dependencies (this improves layer caching)
WORKDIR /app/mygradle
RUN ./gradlew dependencies --no-daemon

# Now copy the rest of the project
COPY mygradle /app/mygradle

# Build the application
RUN ./gradlew build --no-daemon

# --------------------------------------------------
# Now create a lightweight image with only the JAR
# --------------------------------------------------

FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=builder /app/mygradle/app/build/libs/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
