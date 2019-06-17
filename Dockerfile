FROM alpine:3.9

RUN apk add --no-cache bash python3 openssl
RUN apk add --no-cache -t .build-deps \
    make \
    cmake \
    clang \
    g++ \
    linux-headers \
    openssl-dev \
    python3-dev \
    git


ENV BROKER_VERSION v1.1.2

RUN echo "===> Cloning zeek/broker..." \
    && cd /tmp \
    && git clone --single-branch --branch "$BROKER_VERSION" --recurse-submodules https://github.com/zeek/broker.git \
    && cd /tmp/broker \
    && CC=/usr/bin/clang CXX=/usr/bin/clang++ ./configure --enable-debug --enable-static --disable-docs \
    && make -j2 \
    && make install

CMD "bash"
