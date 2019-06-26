FROM alpine:3.9

LABEL Maintainer="{haas,wilkens}@informatik.uni-hamburg.de"

ENV BROKER_VERSION v1.1.2

RUN echo "===> Installing dependencies..." \
    && apk add --no-cache bash ca-certificates libstdc++ python3 openssl \
    && apk add --no-cache -t .build-deps \
    make \
    cmake \
    g++ \
    linux-headers \
    openssl-dev \
    python3-dev \
    git

RUN echo "===> Cloning broker..." \
    && git clone --single-branch --branch "$BROKER_VERSION" --recurse-submodules https://github.com/zeek/broker.git /tmp/broker

RUN echo "===> Building & installing broker..." \
    && cd /tmp/broker \
    && ./configure --disable-docs \
    && make \
    && make test \
    && make install

RUN echo "===> Removing broker sources..." \
    && rm -rf /tmp/broker

RUN echo "===> Removing build-dependencies..." \
    && apk del --purge .build-deps

CMD "bash"
