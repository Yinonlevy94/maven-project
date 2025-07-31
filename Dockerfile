########## 1️⃣ BUILD STAGE ##########
FROM maven:3.9.8-eclipse-temurin-17-alpine AS builder   # <-- stage *name*
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B package

########## 2️⃣ RUNTIME STAGE ##########
FROM eclipse-temurin:17-jre-alpine                      # slim JRE
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=builder /app/target/myapp.jar /app/app.jar  # now resolves ✓
ENTRYPOINT ["tini","--"]
CMD ["java","-jar","/app/app.jar"]
