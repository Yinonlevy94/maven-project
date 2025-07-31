########## 1️⃣ BUILD STAGE ##########
FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests            # compile inside the container

########## 2️⃣ RUNTIME STAGE ##########
FROM eclipse-temurin:17-jre-alpine              # ~55 MB slim JRE image :contentReference[oaicite:1]{index=1}
RUN apk add --no-cache tini                     # tini = proper PID 1 & signal handling :contentReference[oaicite:2]{index=2}
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar
ENTRYPOINT ["/sbin/tini","--","java","-jar","/app/app.jar"]

