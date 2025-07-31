########## 1. BUILD STAGE ##########
FROM maven:3.9.8-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B package

########## 2. RUNTIME STAGE ##########
FROM eclipse-temurin:17-jre-alpine
RUN apk add --no-cache tini         
WORKDIR /app
COPY --from=builder /app/target/myapp.jar /app/app.jar
ENTRYPOINT ["tini","--"]
CMD ["java","-jar","/app/app.jar"]
