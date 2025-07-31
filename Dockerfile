########## 1️⃣ BUILD STAGE ##########
FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests            # compile inside the container

########## 2️⃣ RUNTIME STAGE ##########
FROM eclipse-temurin:17-jre-alpine
# slim JRE (≈55 MB)
RUN apk add --no-cache tini          # tini = proper PID 1
WORKDIR /app
COPY --from=builder /app/target/myapp.jar /app/app.jar
ENTRYPOINT ["tini","--"]
CMD ["java","-jar","/app/app.jar"]


