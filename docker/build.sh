#!/bin/bash

# COMMON
TARGET_BRANCH=${TARGET_BRANCH:="experimental"} #experimenal|stable
SITE_TAG=${SITE_TAG:="b20210911-exp"}
GLUON_VERSION=${GLUON_VERSION:="2021.1.x-hwtest"}
#AUTOUPDATER_ENABLED=${AUTOUPDATER_ENABLED:="true"}
AUTOUPDATER_ENABLED=${AUTOUPDATER_ENABLED:="false"}

#TARGETS=${TARGETS:="ar71xx-generic ar71xx-tiny ar71xx-nand brcm2708-bcm2708 brcm2708-bcm2709 ipq806x mpc85xx-generic ramips-mt7620 ramips-mt7621 ramips-mt7628 ramips-rt305x sunxi x86-generic x86-geode x86-64 ar71xx-mikrotik brcm2708-bcm2710 mvebu"}
TARGETS=${TARGETS:="rockchip-armv8"}

DEVICES=${DEVICES:=}

# SITE
FF_SITE_REPO=${FF_SITE_REPO:="https://github.com/FreifunkVogtland/site-ffv.git"}

# SIGN?
SIGN_KEYDIR=${SIGN_KEYDIR:="/opt/freifunk/signkeys_ffv"}
MANIFEST_KEY=${MANIFEST_KEY:="manifest_key"}

# GLUON
#GLUON_REPO=${GLUON_REPO:="https://github.com/FreifunkVogtland/gluon.git"}
#GLUON_TAG=${GLUON_TAG:="v${GLUON_VERSION}"}
GLUON_REPO=${GLUON_REPO:="https://github.com/freifunk-gluon/gluon.git"}
GLUON_TAG=${GLUON_TAG:="fastd-l2tp"}
GLUON_DIR=${GLUON_DIR:="gluon-ffv-${TARGET_BRANCH}"}
GLUON_OPKG_KEY=${GLUON_OPKG_KEY:="${SIGN_KEYDIR}/gluon-opkg-key"}7
GLUON_RELEASE=${GLUON_RELEASE:="${SITE_TAG}"}
GLUON_OUTPUTDIR=${GLUON_OUTPUTDIR:="${GLUON_DIR}/output"}
#GLUON_DEPRECATED=${GLUON_DEPRECATED:="upgrade"}
GLUON_DEPRECATED=${GLUON_DEPRECATED:="full"}

# CHECKOUT
git clone ${GLUON_REPO} "${GLUON_DIR}" -b "${GLUON_TAG}"
git clone ${FF_SITE_REPO} "${GLUON_DIR}"/site -b "${SITE_TAG}"
make -C "${GLUON_DIR}" update

# BUILD
if [ -n "${DEVICES}" ]; then
    make -C "${GLUON_DIR}" GLUON_TARGET=${TARGETS} DEVICES="${DEVICES}" GLUON_AUTOUPDATER_BRANCH="${TARGET_BRANCH}" GLUON_AUTOUPDATER_ENABLED="${AUTOUPDATER_ENABLED}" -j"$(nproc || echo 1)"
else
    make -C "${GLUON_DIR}" GLUON_TARGET=${TARGETS} GLUON_AUTOUPDATER_BRANCH="${TARGET_BRANCH}" GLUON_AUTOUPDATER_ENABLED="${AUTOUPDATER_ENABLED}" -j"$(nproc || echo 1)"    
fi
make -C "${GLUON_DIR}" GLUON_AUTOUPDATER_BRANCH="${TARGET_BRANCH}" BROKEN=1 manifest
if [ -e "${SIGN_KEYDIR}/${MANIFEST_KEY}" ]; then
    "${GLUON_DIR}"/contrib/sign.sh "${SIGN_KEYDIR}/${MANIFEST_KEY}" "${GLUON_DIR}"/output/images/sysupgrade/"${TARGET_BRANCH}".manifest
fi
