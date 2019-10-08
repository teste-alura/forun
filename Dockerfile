FROM java:8

ARG BUILD_DIR

WORKDIR /usr/app
COPY $BUILD_DIR/target/forum-0.0.1-SNAPSHOT.jar .

EXPOSE 8080

CMD ["/usr/lib/jvm/java-8-openjdk-amd64/bin/java", "-jar", "forum-0.0.1-SNAPSHOT.jar"]