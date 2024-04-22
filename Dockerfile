FROM openjdk:8u151-jdk-alpine3.7
WORKDIR $APP_HOME
ENV APP_HOME /usr/src/app
COPY target/shopping-cart-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar
EXPOSE 8070
ENTRYPOINT exec java -jar app.jar
