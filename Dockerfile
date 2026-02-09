# syntax=docker/dockerfile:1

FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /src

COPY pom.xml ./
COPY manifest.mf ./
COPY src ./src
COPY WebContent ./WebContent

RUN mvn -q -DskipTests package

FROM tomcat:9.0-jre11-temurin
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy under /fairness-assessment (matches OntoPortal UI default).
COPY --from=build /src/target/fairness-assessment.war /usr/local/tomcat/webapps/fairness-assessment.war

EXPOSE 8080
