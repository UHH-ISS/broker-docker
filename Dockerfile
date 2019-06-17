FROM alpine:3.9

ENV BROKER_VERSION v1.1.2

RUN echo "===> Installing dependencies..." \
    && apk add --no-cache bash ca-certificates python3 openssl \
    && apk add --no-cache -t .build-deps \
    make \
    cmake \
    clang \
    g++ \
    linux-headers \
    openssl-dev \
    python3-dev \
    git

RUN echo "===> Cloning broker..." \
    && git clone --single-branch --branch "$BROKER_VERSION" --recurse-submodules https://github.com/zeek/broker.git /tmp/broker

RUN echo "===> Building broker..." \
    && cd /tmp/broker \
    && CC=/usr/bin/clang CXX=/usr/bin/clang++ ./configure --enable-debug --enable-static --disable-docs \
    && make \
    && make install

RUN echo "===> Removing build-dependencies..." \
    && apk del .build-deps

CMD "bash"
