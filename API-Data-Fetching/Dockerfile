# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

COPY . .

# Copy the current directory contents into the container at /app
COPY build/libs/API-Data-Fetching-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8082
EXPOSE 8083

# Run the jar file
ENTRYPOINT ["java","-jar","/app/app.jar"]
