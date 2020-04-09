#!/bin/sh

# Pull alpine to get newest security updates
docker pull alpine:3.10

# Build all tags
for TAG in $(cat tags.txt); do
    docker build --build-arg "BROKER_VERSION=v$TAG" -t "uhhiss/broker-docker:$TAG" .
done

# Also tag latest
docker build --build-arg "BROKER_VERSION=v$TAG" -t "uhhiss/broker-docker:latest" .
