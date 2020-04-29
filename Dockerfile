FROM openjdk:8-jre-alpine
MAINTAINER Justin Menga <justin.menga@gmail.com> 
LABEL application=microtrader
LABEL mytest=true

# Install system dependencies
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --update --no-cache bash curl confd@testing

# Create vertx user
RUN mkdir -p /app/conf && \
    addgroup -g 1000 vertx && \
    adduser -u 1000 -G vertx -D vertx && \
    chown -R vertx:vertx /app && \
    chmod -R 777 /app

# Set default user
USER vertx
WORKDIR /app

# Set entrypoint and default command arguments
COPY etc/confd /etc/confd
COPY entrypoint.sh /app/entrypoint.sh
USER root
RUN chmod -R 777 /app
USER vertx
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["java", "-jar", "/app/app.jar", "-server", "-cluster", "-Dvertx.hazelcast.config=/app/conf/cluster.xml"]
