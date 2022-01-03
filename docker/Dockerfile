FROM debian

RUN apt-get update \
    && apt-get install -y \
        locales \
        git \
        subversion \
        python3 \
        build-essential \ 
        gawk \
        unzip \
        libncurses-dev \
        libz-dev \
        libssl-dev \
        wget \
        rsync \
        file \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
ENV BUILD_USER "ffv-build-user"

RUN mkdir -p /build /output
ADD build.sh /build/
RUN chmod +x /build/*.sh
WORKDIR /build

RUN useradd -ms /bin/bash ${BUILD_USER:=build} \
    && chown ${BUILD_USER:=build} /build -R \
    && chown ${BUILD_USER:=build} /output -R
USER ${BUILD_USER}

VOLUME [ "/opt/freifunk", "/output" ]