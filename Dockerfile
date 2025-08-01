FROM maven:3.9.8-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src


RUN mvn -B -Denforcer.skip=true package

FROM eclipse-temurin:17-jre-alpine        
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=builder /workspace/target/my-app-1.0-SNAPSHOT.jar /app/app.jar
ENTRYPOINT ["tini","--"]
CMD ["java","-jar","/app/app.jar"]
