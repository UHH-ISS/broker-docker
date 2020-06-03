#!/bin/bash

__push__="$1"

# Pull alpine to get newest security updates
docker pull alpine:3.10
docker pull alpine:3.11

# Build tags for version 1.2.x
for TAG in $(cat tags-1.2.txt); do
    docker build --build-arg "BROKER_VERSION=v$TAG" -t "uhhiss/broker-docker:$TAG" -f Dockerfile-1.2 .
    if [ "$__push__" == "push" ]; then
        docker push "uhhiss/broker-docker:$TAG"
    fi
done

# Build tags for version 1.2.x
for TAG in $(cat tags-1.3.txt); do
    docker build --build-arg "BROKER_VERSION=v$TAG" -t "uhhiss/broker-docker:$TAG" -f Dockerfile-1.3 .
    if [ "$__push__" == "push" ]; then
        docker push "uhhiss/broker-docker:$TAG"
    fi
done

# Also tag latest
docker tag "uhhiss/broker-docker:$TAG" "uhhiss/broker-docker:latest"
if [ "$__push__" == "push" ]; then
    docker push uhhiss/broker-docker:latest
fi
