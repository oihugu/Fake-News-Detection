FROM neo4j:latest

RUN apt update -y

WORKDIR /
COPY . /

ENTRYPOINT [ "build/app/main" ]