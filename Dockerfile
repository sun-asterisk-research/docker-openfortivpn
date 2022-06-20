FROM debian:bullseye

ARG OPENFORTIVPN_VERSION=v1.17.3

ENV BUILD_DEPS \
    git \
    gcc \
    automake \
    autoconf \
    libssl-dev \
    make \
    pkg-config

ENV EXTRA_DEPS \
    iproute2 \
    ppp

RUN apt-get update \
    && apt-get install -y ${BUILD_DEPS} ${EXTRA_DEPS} \
    && git clone -b ${OPENFORTIVPN_VERSION} --single-branch --depth 1 https://github.com/adrienverge/openfortivpn \
    && cd openfortivpn \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local --sysconfdir=/etc \
    && make \
    && make install \
    && apt-get purge -y --autoremove ${BUILD_DEPS} \
    && rm -rf /var/lib/apt/list/* \
    && rm -r /openfortivpn

ENTRYPOINT [ "openfortivpn" ]

CMD [ "-c", "/etc/openfortivpn/config" ]
