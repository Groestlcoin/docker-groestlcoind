# Smallest base image, latests stable image
# Alpine would be nice, but it's linked again musl and breaks the groestlcoin core download binary
#FROM alpine:latest

FROM ubuntu:latest as builder

# Testing: gosu
#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
#    && apk add --update --no-cache gnupg gosu gcompat libgcc
RUN apt update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        wget \
        gnupg \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION=2.21.0
ARG ARCH=x86_64
ARG GROESTLCOIN_CORE_SIGNATURE=287AE4CA1187C68C08B49CB2D11BD4F33F1DB499

# Don't use base image's groestlcoin package for a few reasons:
# 1. Would need to use ppa/latest repo for the latest release.
# 2. Some package generates /etc/groestlcoin.conf on install and that's dangerous to bake in with Docker Hub.
# 3. Verifying pkg signature from main website should inspire confidence and reduce chance of surprises.
# Instead fetch, verify, and extract to Docker image
RUN cd /tmp \
    && wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${VERSION}/SHA256SUMS.asc \
    && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys ${GROESTLCOIN_CORE_SIGNATURE} \
    && gpg --verify SHA256SUMS.asc \
    && grep groestlcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz SHA256SUMS.asc > SHA25SUM \
    && wget https://github.com/Groestlcoin/groestlcoin/releases/download/v${VERSION}/groestlcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz \
    && sha256sum -c SHA25SUM \
    && tar -xzvf groestlcoin-${VERSION}-${ARCH}-linux-gnu.tar.gz -C /opt \
    && ln -sv groestlcoin-${VERSION} /opt/groestlcoin \
    && rm -v /opt/groestlcoin/bin/groestlcoin-qt

FROM ubuntu:latest
LABEL maintainer="Groestlcoin developers <groestlcoin@gmail.com>"

ENTRYPOINT ["docker-entrypoint.sh"]
ENV HOME /groestlcoin
EXPOSE 1441 1331
VOLUME ["/groestlcoin/.groestlcoin"]
WORKDIR /groestlcoin

ARG GROUP_ID=1000
ARG USER_ID=1000
RUN groupadd -g ${GROUP_ID} groestlcoin \
    && useradd -u ${USER_ID} -g groestlcoin -d /groestlcoin groestlcoin

COPY --from=builder /opt/ /opt/

RUN apt update \
    && apt install -y --no-install-recommends gosu \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -sv /opt/groestlcoin/bin/* /usr/local/bin

COPY ./bin ./docker-entrypoint.sh /usr/local/bin/

CMD ["grs_oneshot"]
