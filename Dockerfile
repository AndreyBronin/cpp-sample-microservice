FROM ubuntu:19.04 as builder

LABEL maintainer="Andrey Bronin <jonnib@yandex.ru>"
# ENV CONAN_PASSWORD=bintray_api_key

RUN apt-get update && \
    apt-get install -y git build-essential cmake python3-pip && \
    pip3 install conan

RUN conan remote add andreybronin https://api.bintray.com/conan/andreybronin/conan
RUN conan user andreybronin -r andreybronin
COPY ./profile /root/.conan/profiles/default

COPY . /project
WORKDIR /project
RUN conan install . --build=missing

#RUN conan upload solidity/develop@andreybronin/testing -r andreybronin --all
#RUN conan upload jsoncpp/1.8.4@andreybronin/stable -r andreybronin --all
#RUN conan upload boost/1.70.0@andreybronin/stable -r andreybronin --all

RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/ .
RUN VERBOSE=1 make

FROM ubuntu:19.04
COPY --from=builder /project/bin/main /main
COPY --from=builder /usr/local/lib /usr/local/lib
#COPY --from=builder /root/.conan/data /root/.conan/data

#
#RUN apk update && \
#   apk upgrade && \
#   apk --update add libstdc++ \
#   rm -rf /var/cache/apk/*
#
ENTRYPOINT [ "/main" ]

# /root/.conan/data/solidity/develop/andreybronin/testing/package/21d1b1434e0d571dbf2719e58dbfbab177f2ab51/lib:/root/.conan/data/boost/1.70.0/conan/stable/package/2e1777b52bec46a45440dc252927f1c4bdda05d8/lib:/root/.conan/data/jsoncpp/1.8.4/theirix/stable/package/1f28336000774cc28c0e2936e7383df8120945c0/lib:/root/.conan/data/zlib/1.2.11/conan/stable/package/1d877a3df840030e6a8abb74c5ffb9088d08b47a/lib:/root/.conan/data/bzip2/1.0.6/conan/stable/package/a5875aed3fc7ae8dd0488f7e5e99acbc480d721d/lib