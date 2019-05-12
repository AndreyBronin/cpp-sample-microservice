FROM alpine:latest as builder

LABEL maintainer="Andrey Bronin <jonnib@yandex.ru>"
# ENV CONAN_PASSWORD=bintray_api_key

RUN apk update && \
    apk upgrade && \
    apk --update add \
#        alpine-sdk \
        g++ \
        build-base \
        cmake \
#        bash \
        libstdc++ \
        git \
        linux-headers \
#        cppcheck \
        py-pip && \
        pip install conan && \
    rm -rf /var/cache/apk/*

RUN conan remote add andreybronin https://api.bintray.com/conan/andreybronin/conan
RUN conan user andreybronin -r andreybronin
COPY ./profile /root/.conan/profiles/default

COPY . /project
WORKDIR /project
RUN conan install . --build=missing

#RUN conan upload solidity/develop@andreybronin/testing -r andreybronin --all
#RUN conan upload jsoncpp/1.8.4@andreybronin/stable -r andreybronin --all
#RUN conan upload boost/1.70.0@andreybronin/stable -r andreybronin --all

RUN cmake -DCMAKE_BUILD_TYPE=Release . && make

FROM alpine:latest
COPY --from=builder /project/bin/main /main

RUN apk update && \
   apk upgrade && \
   apk --update add libstdc++ \
   rm -rf /var/cache/apk/*

ENTRYPOINT [ "/main" ]