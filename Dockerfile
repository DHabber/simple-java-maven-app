FROM maven:3.8.6-jdk-11 as test

WORKDIR /app
COPY ./src /app/src
COPY ./pom.xml /app/pom.xml

RUN mvn package
RUN mvn test

FROM maven:3.8.6-jdk-11 as build

WORKDIR /app
COPY ./src/main/java/com/mycompany/app/App.java /app/src/main/java/com/mycompany/app/App.java
COPY ./pom.xml /app/pom.xml

RUN mvn package

FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /app/target/my-app-1.0-SNAPSHOT.jar /app/my-app.jar

EXPOSE 80

ENTRYPOINT ["java", "-jar", "my-app.jar", "-Dserver.port=80"]
#ENTRYPOINT ["/bin/sh", "-c", "while true; do java -jar my-app.jar; sleep 3; done"]

