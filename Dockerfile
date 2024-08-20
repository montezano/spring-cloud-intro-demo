FROM amazoncorretto:17
LABEL authors="montezano"

ARG SERVICE
ENV SERVICE=${SERVICE}*.jar

RUN mkdir -p /opt/service

WORKDIR /opt/service

ENTRYPOINT java -jar ${SERVICE}