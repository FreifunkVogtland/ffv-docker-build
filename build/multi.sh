#!/bin/bash

# build
git clone https://github.com/FreifunkVogtland/gluon.git "${GLUONDIR}" -b v"${GLUON_VERSION}"
git clone https://github.com/FreifunkVogtland/site-ffv.git "${GLUONDIR}"/site -b "${SITE_TAG}"
make -C "${GLUONDIR}" update
for target in ${TARGETS}; do
    make -C "${GLUONDIR}" GLUON_TARGET="${target}" BROKEN=1 GLUON_BRANCH="${TARGET_BRANCH}" -j"$(nproc || echo 1)"
done

make -C "${GLUONDIR}" GLUON_BRANCH="${TARGET_BRANCH}" BROKEN=1 manifest
"${GLUONDIR}"/contrib/sign.sh "${SIGN_KEYDIR}/${MANIFEST_KEY}" "${GLUONDIR}"/output/images/sysupgrade/"${TARGET_BRANCH}".manifest
