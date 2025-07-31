########## builder ##########
FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests

########## runtime ##########
FROM eclipse-temurin:17-jre-alpine                  # 1 token only → OK
RUN apk add --no-cache tini
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar
ENTRYPOINT ["/sbin/tini","--","java","-jar","/app/app.jar"]

