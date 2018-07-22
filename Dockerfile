FROM debian:latest

RUN apt-get update \
    && apt-get install -y locales \
        git \
        subversion \
        python \
        build-essential \ 
        gawk \
        unzip \
        libncurses-dev \
        libz-dev \
        libssl-dev \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# gluon / site
ENV GLUON_VERSION "2018.1-2"
ENV SIGN_KEYDIR "/opt/freifunk/signkeys_ffv"
ENV MANIFEST_KEY "manifest_key"
ENV SITE_TAG b20180710-exp
ENV TARGET_BRANCH experimental
ENV GLUONDIR "gluon-ffv-${TARGET_BRANCH}"

ENV GLUON_OPKG_KEY "${SIGN_KEYDIR}/gluon-opkg-key"
ENV GLUON_RELEASE "${SITE_TAG}"

ENV GLUON_OUTPUTDIR "/output"

# multi targets
ENV TARGETS "ar71xx-generic ar71xx-tiny ar71xx-nand brcm2708-bcm2708 brcm2708-bcm2709 ipq806x mpc85xx-generic ramips-mt7620 ramips-mt7621 ramips-mt7628 ramips-rt305x sunxi x86-generic x86-geode x86-64 ar71xx-mikrotik brcm2708-bcm2710 mvebu"

# single target
ENV GLUON_SINGLE_TARGET "ar71xx-generic"
ENV GLUON_SINGLE_DEVICE "tp-link-tl-wr1043n-nd-v1"

# build dir
RUN mkdir /build

# output dir
RUN mkdir /output

# add build scripts
ADD build/*.sh /build/

RUN chmod +x /build/*.sh

WORKDIR /build

RUN useradd -ms /bin/bash ffv \
    && chown ffv /build -R \
    && chown ffv /output -R

USER ffv

VOLUME [ "/opt/freifunk", "/build", "/output" ]