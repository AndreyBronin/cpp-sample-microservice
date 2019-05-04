FROM alpine:latest as builder

LABEL maintainer="Andrey Bronin <jonnib@yandex.ru>"

RUN apk update && \
    apk upgrade && \
    apk --update add \
#        alpine-sdk \
        g++ \
        build-base \
        cmake \
#        bash \
        libstdc++ \
#        git \
        linux-headers \
#        cppcheck \
        py-pip && \
        pip install conan && \
    rm -rf /var/cache/apk/*

COPY . /project
WORKDIR /project
RUN cmake -DCMAKE_BUILD_TYPE=Release . && make

FROM alpine:latest
COPY --from=builder /project/bin/main /main

RUN apk update && \
    apk upgrade && \
    apk --update add libstdc++ \
    rm -rf /var/cache/apk/*

ENTRYPOINT [ "/main" ]