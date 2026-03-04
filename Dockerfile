# ============================================
# DOCKERFILE - Multi-stage Build
# ============================================
# Stage 1: Build the application
# Stage 2: Run the application
# This reduces final image size significantly
# ============================================

# ============================================
# STAGE 1: BUILD
# ============================================
FROM eclipse-temurin:17-jdk-alpine AS builder

# Set working directory
WORKDIR /app

# Copy Maven wrapper and pom.xml first (for caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (cached layer)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests -B

# ============================================
# STAGE 2: RUNTIME
# ============================================
FROM eclipse-temurin:17-jre-alpine

# Add metadata labels
LABEL maintainer="Gunaseelan Chandrasekaran"
LABEL application="spring-petclinic"
LABEL version="4.0.0-SNAPSHOT"

# Create non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Set working directory
WORKDIR /app

# Copy JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Set environment variable to override application.properties
ENV SERVER_PORT=8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

# Optional: JVM options for container
# Uncomment below for production tuning
# ENTRYPOINT ["java", \
#   "-XX:+UseContainerSupport", \
#   "-XX:MaxRAMPercentage=75.0", \
#   "-Djava.security.egd=file:/dev/./urandom", \
#   "-jar", "app.jar"]
