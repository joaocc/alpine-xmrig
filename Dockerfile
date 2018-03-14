FROM  alpine:latest
RUN   adduser -S -D -H -h /xmrig miner
RUN   apk --no-cache upgrade && \
      apk --no-cache add \
        bash \
        git \
        cmake \
        libuv-dev \
        build-base && \
      git clone https://github.com/xmrig/xmrig && \
      cd xmrig && \
      sed -i 's/kDonateLevel = 5/kDonateLevel = 0/' src/donate.h && \
      mkdir build && \
      cd build && \
      cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_HTTPD=OFF && \
      make && \
      apk del \
        build-base \
        cmake \
        git
USER miner
ENTRYPOINT  ["/xmrig/build/xmrig"]
