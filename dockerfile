# Use official Maven image with JDK 17
FROM maven:3.9.6-eclipse-temurin-17 as build

# Set working directory in the container
WORKDIR /app

# Copy source code to container
COPY . .

# Build the project and run tests (includes Sonar if configured in pom.xml)
RUN mvn clean verify

# ----- Optional: If you only need the final JAR to run in a slim image -----

# Use JDK-only image for runtime (smaller size)
FROM eclipse-temurin:17-jdk

# Create working directory
WORKDIR /app

# Copy built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
