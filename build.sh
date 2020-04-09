#!/bin/bash

__push__="$1"

# Pull alpine to get newest security updates
docker pull alpine:3.10

# Build all tags
for TAG in $(cat tags.txt); do
    docker build --build-arg "BROKER_VERSION=v$TAG" -t "uhhiss/broker-docker:$TAG" .
    if [ "$__push__" == "push" ]; then
        docker push "uhhiss/broker-docker:$TAG"
    fi
done

# Also tag latest
docker build --build-arg "BROKER_VERSION=v$TAG" -t "uhhiss/broker-docker:latest" .
if [ "$__push__" == "push" ]; then
    docker push uhhiss/broker-docker:latest
fi
