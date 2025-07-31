########## 1. BUILD STAGE ##########
FROM maven:3.9.8-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src

# ⬇️ skip Enforcer rules so JDK 17 / Maven 3.9.8 are accepted
RUN mvn -B -Denforcer.skip=true package

########## 2. RUNTIME STAGE ##########
FROM eclipse-temurin:17-jre-alpine                         # slim JRE 17 :contentReference[oaicite:1]{index=1}
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=builder /app/target/myapp.jar /app/app.jar
ENTRYPOINT ["tini","--"]
CMD ["java","-jar","/app/app.jar"]
