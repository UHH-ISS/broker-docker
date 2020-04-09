FROM alpine:3.10 AS builder

RUN echo "===> Installing build dependencies..." \
    && apk add --no-cache ca-certificates libstdc++ python3 openssl \
    make cmake g++ \
    linux-headers openssl-dev python3-dev \
    git

ARG BROKER_VERSION=v1.3.1

RUN echo "===> Cloning broker..." \
    && git clone --single-branch --branch "$BROKER_VERSION" --recurse-submodules https://github.com/zeek/broker.git /tmp/broker

RUN echo "===> Building & installing broker..." \
    && cd /tmp/broker \
    && ./configure --disable-docs \
    && make -j2 \
    && make test \
    && make install


FROM alpine:3.10

LABEL Maintainer="{haas,wilkens}@informatik.uni-hamburg.de"

RUN echo "===> Installing runtime dependencies..." \
    && apk add --no-cache bash ca-certificates libstdc++ python3 openssl

# Copy libraries from builder
COPY --from=builder /usr/local/lib64/* /usr/local/lib64/
# Copy headers from builder
COPY --from=builder /usr/local/include/* /usr/local/include/
# Copy python bindings from builder
COPY --from=builder /usr/lib/python3.7/site-packages/broker /usr/lib/python3.7/site-packages/broker

CMD "bash"
