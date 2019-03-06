FROM alpine:latest AS build
WORKDIR /xmrig
RUN   apk --no-cache upgrade && \
      apk --no-cache add \
        bash \
        git \
        cmake \
        libuv-dev \
        build-base \
        && \
      git clone https://github.com/xmrig/xmrig && \
      cd xmrig && \
      sed -i 's/kMinimumDonateLevel = 1/kMinimumDonateLevel = 0/' src/donate.h && \
      sed -i 's/kDefaultDonateLevel = 5/kDefaultDonateLevel = 0/' src/donate.h && \
      cmake -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF -DWITH_TLS=OFF && \
      make

FROM  alpine:latest
RUN   adduser -S -D -H -h /xmrig miner
COPY --from=build /xmrig/xmrig/xmrig-notls /xmrig/xmrig
USER miner
WORKDIR /xmrig
ENTRYPOINT  ["./xmrig"]
